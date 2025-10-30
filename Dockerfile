FROM python:3.9-slim

# pip más estable y sin caché
ENV PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=120 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Proxy (opcional, solo si pasas build-args)
ARG http_proxy
ARG https_proxy
ENV http_proxy=${http_proxy} \
    https_proxy=${https_proxy} \
    HTTP_PROXY=${http_proxy} \
    HTTPS_PROXY=${https_proxy}

# Herramientas base
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates build-essential \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Requisitos primero (mejor cacheo)
COPY requirements.txt .

# Instalar desde Internet (sin wheels locales)
RUN python -m pip install --upgrade pip setuptools wheel \
 && pip install -r requirements.txt

# Copiamos el resto del proyecto
COPY . .

EXPOSE 5000
CMD ["mlflow", "ui", "--host", "0.0.0.0"]