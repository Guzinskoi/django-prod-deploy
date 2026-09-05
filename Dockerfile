FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_NO_INTERACTION=1

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libjpeg-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir poetry==2.4.3

COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root --only main

COPY mysite ./mysite

WORKDIR /app/mysite

EXPOSE 8000

CMD ["sh", "-c", "mkdir -p data && python manage.py migrate --noinput && python manage.py runserver 0.0.0.0:8000"]
