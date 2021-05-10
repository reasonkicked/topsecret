from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from sqlalchemy.sql import select
from sqlalchemy import create_engine
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
import logging as logger
# logger.basicConfig(level="DEBUG")
from flask_restful import Api
from secrets_manager import get_secret
import os
from flask_wtf import CSRFProtect
from topsecret import *

app = Flask(__name__)
SECRET_KEY = os.urandom(32)
app.config['SECRET_KEY'] = SECRET_KEY
csrf = CSRFProtect(app)
csrf.init_app(app)


# db_username = "postgres"
# db_password = "CluLnxPaSS"
# db_url = "tsrdsdb01.cveqos66v3sg.us-west-2.rds.amazonaws.com"
# db_db = "tsrdsdb01"
#
#
#
# app.config['SQLALCHEMY_DATABASE_URI'] = (
#     f'postgresql+psycopg2://{db_username}:' +
#     f'{db_password}@' +
#     f'{db_url}/' +
#     f'{db_db}'
# )
#
#
# app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False


db_config = get_secret()
app.config['SQLALCHEMY_DATABASE_URI'] = (
    f'postgresql+psycopg2://{db_config["username"]}:' +
    f'{db_config["password"]}@' +
    f'{db_config["host"]}/' +
    f'{db_config["db_name"]}'
)

app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SESSION_COOKIE_SECURE'] = False
#app.config['SERVER_NAME'] = 'topsecret.pgssandbox.com'
app.config['WTF_CSRF_CHECK_DEFAULT'] = False



db = SQLAlchemy(app)
migrate = Migrate(app, db)


class Transaction(db.Model):
    __tablename__ = 'transactions'

    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String())
    last_name = db.Column(db.String())
    amount = db.Column(db.Float)

    def __init__(self, first_name: str, last_name: str, amount: float):
        self.first_name = first_name
        self.last_name = last_name
        self.amount = amount

    def __repr__(self):
        return f'{self.first_name} {self.last_name} spent {self.amount}'


class Subcategory(db.Model):
    __tablename__ = 'subcategories'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String())
    category_id = db.Column(db.Integer())

    def __init__(self, name, category_id):
        self.name = name
        self.category_id = category_id

    def __repr__(self):
        return self.name


class MealsModel(db.Model):
    __tablename__ = 'meals'

    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String())
    description = db.Column(db.String())
    price = db.Column(db.Float())
    category = db.Column(db.String())
    subcategory = db.Column(db.String())

    def __init__(self, title, description, price, category, subcategory):
        self.title = title
        self.description = description
        self.price = price
        self.category = category
        self.subcategory = subcategory

    def __repr__(self):
        return '{:2d} : {:s}'.format(self.id, self.title)


class Category(db.Model):
    __tablename__ = 'categories'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String())

    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return self.name



@app.route('/list_db')
def list_db():
    transactions = Transaction.query.all()
    return '\n'.join([str(transaction) for transaction in transactions])


@app.route('/new_meal', methods=['POST', 'GET'])
def handle_meals():
    form = NewItemForm()
    categories = Category.query.all()
    subcategories = Subcategory.query.all()
    form.category.choices = categories
    form.subcategory.choices = subcategories

    if form.validate_on_submit():
        if request.method == 'POST':
            title = request.form.get("title")
            description = request.form.get("description")
            price = request.form.get("price")
            category = request.form.get("category")
            subcategory = request.form.get("subcategory")
            new_meal = MealsModel(title=title, description=description, price=price, category=category,
                                  subcategory=subcategory)
            db.session.add(new_meal)
            db.session.commit()

            flash("Meal {} has been successfully submitted".format(request.form.get("title")), "success")
            return redirect((url_for("home")))

    if form.errors:
        flash("{}".format(form.errors), "danger")
    return render_template("new_meal.html", form=form)


@app.route('/meals/<meal_id>', methods=['POST', 'GET', 'PUT', 'DELETE'])
def handle_meal(meal_id):
    meal = MealsModel.query.get_or_404(meal_id)
    form = NewItemForm()
    categories = Category.query.all()
    subcategories = Subcategory.query.all()
    form.category.choices = categories
    form.subcategory.choices = subcategories

    if request.method == 'GET':
        form.title.data = meal.title
        form.price.data = meal.price
        form.description.data = meal.description
        form.category.data = meal.category
        form.subcategory.data = meal.subcategory

        return render_template("modify_meal.html", meal_id=meal.id, form=form)

    elif request.method == 'POST':
        if form.validate_on_submit():
            meal.title = request.form.get("title")
            meal.description = request.form.get("description")
            meal.price = request.form.get("price")
            meal.category = request.form.get("category")
            meal.subcategory = request.form.get("subcategory")
            db.session.commit()
            flash("Item {} has been successfully updated".format(form.title.data), "success")
        if form.errors:
            flash("{}".format(form.errors), "danger")

            return redirect(url_for("view_meal", meal_id=meal.id))

    return redirect(url_for("home"))


@app.route('/meal/<meal_id>', methods=['GET'])
def view_meal(meal_id):
    meal = MealsModel.query.get_or_404(meal_id)
    if request.method == 'GET':
        delete_meal_form = DeleteMealForm()
        modify_meal_form = ModifyMealForm()
        return render_template("meal.html", meal=meal,
                               modify_meal_form=modify_meal_form,
                               delete_meal_form=delete_meal_form)


@app.route('/meal<int:meal_id>/delete', methods=["POST", "GET"])
def delete_meal(meal_id):
    meal = MealsModel.query.get_or_404(meal_id)

    delete_meal_form = DeleteMealForm()

    db.session.delete(meal)
    db.session.commit()
    return redirect(url_for("home"))


@app.route("/")
def home():
    form = FilterForm(request.args, meta={"csrf": False})
    categories = Category.query.all()
    subcategories = Subcategory.query.all() #
    categories.insert(0, "---")
    form.category.choices = categories
    subcategories.insert(0, "---")
    form.subcategory.choices = subcategories
    items_from_db = []
    meals = MealsModel.query.all()
    sorted_meals = sorted(meals, key=lambda x: x.title)
    cest = db.session.query(MealsModel).filter(MealsModel.title == 'cest').count()
    print(cest)

    for meal in sorted_meals[:10]:
        items_from_db.append(meal)

    return render_template("home.html", meals=items_from_db, form=form)


if __name__ == '__main__':
    app.run(host='0.0.0.0')
