from flask_wtf import FlaskForm
from wtforms import StringField, TextAreaField, SubmitField, SelectField, DecimalField
from wtforms.validators import InputRequired, DataRequired, Length

class NewItemForm(FlaskForm):
    title = StringField("Title", validators=[InputRequired("Input is required!"),
                                             DataRequired("Data is required!"),
                                             Length(min=2, max=20,
                                                    message="Input must be between 5 and 20 characters long!")])
    price = DecimalField("Price")
    description = TextAreaField("Description", validators=[InputRequired("Input is required!"),
                                                           DataRequired("Data is required!"),
                                                           Length(min=2, max=50,
                                                                  message=
                                                                  "Input must be between 2 and 50 characters long!")])
    category = SelectField("Category")
    subcategory = SelectField("Subcategory")
    submit = SubmitField("Submit")


class DeleteMealForm(FlaskForm):
    submit = SubmitField("Delete meal")


class ModifyMealForm(FlaskForm):
    submit = SubmitField("Modify meal")


class FilterForm(FlaskForm):
    title = StringField("Title", validators=[Length(max=20)])
    price = SelectField("Price", coerce=int, choices=[(0, "---"), (1, "Max to Min"), (2, "Min to Max")])
    category = SelectField("Category")
    subcategory = SelectField("Subcategory")
    submit = SubmitField("Filter")


class Meal:
    def __init__(self, name, protein, fat, kcal, carbs):
        self._name = name
        self._protein = protein
        self._fat = fat
        self._kcal = kcal
        self.carbs = carbs


class FastFood(Meal):
    def __init__(self):
        pass


class Vegetables:
    def __init__(self):
        pass


class Drinks:
    def __init__(self):
        pass




