FROM python:3.10.7
ARG PIPENV_PARAMS=""
ENV PYTHONUNBUFFERED 1

WORKDIR /backend/
ADD backend /backend/
COPY Pipfile* /backend/

RUN apt-get update -y

RUN pip install --upgrade pip
RUN pip install pipenv
RUN pipenv install --system --ignore-pipfile
ENV LC_TIME ru_RU.UTF-8
CMD python manage.py migrate && gunicorn config.wsgi --bind 0.0.0.0:8000 --reload -w 3 --timeout 300
