How to run (mac):

virtualenv env
source env/bin/activate

export AWS_ACCESS_KEY_ID=#
export AWS_SECRET_ACCESS_KEY=#
export AWS_DEFAULT_REGION=us-west-2
export FLASK_SECRET_KEY=#

docker-compose up --build

#RDS
pip install flask
pip install gunicorn
pip install flask-sqlalchemy
pip install flask-migrate
pip install psycopg2-binary
pip install boto3

export POSTGRES_USER=#
export POSTGRES_PW=#
export POSTGRES_URL=#
export POSTGRES_DB=#

flask db init
flask db migrate
flask db upgrade

docker-compose up --build