
# Dockerfile for COBRApy-based metabolic model pipeline
FROM python:3.9-slim

RUN apt-get update && apt-get install -y     build-essential     git     && rm -rf /var/lib/apt/lists/*

RUN pip install carveme cobra pandas

WORKDIR /app
COPY . /app

ENTRYPOINT ["nextflow"]
