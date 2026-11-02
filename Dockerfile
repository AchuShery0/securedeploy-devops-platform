FROM python:3.14-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY requirements.txt .

RUN python -m pip install --no-cache-dir -r requirements.txt \
    && rm -rf \
       /usr/local/lib/python3.14/site-packages/pip \
       /usr/local/lib/python3.14/site-packages/pip-*.dist-info \
       /usr/local/bin/pip \
       /usr/local/bin/pip3 \
       /usr/local/bin/pip3.14 \
    && useradd --create-home --uid 10001 appuser

COPY app/ ./app/

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--access-logfile", "-", "--error-logfile", "-", "app:create_app()"]
