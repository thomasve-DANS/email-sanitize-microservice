FROM python:3.9-slim

ENV PYTHONDONTWRITEBYTECODE 1

ENV PYTHONUNBUFFERED 1

WORKDIR src

RUN pip install poetry

COPY pyproject.toml .

COPY pyproject.toml ./stub.toml

RUN poetry config virtualenvs.create false

RUN poetry install

EXPOSE 7070

RUN pip install uvicorn
