FROM tiangolo/uvicorn-gunicorn-fastapi:python3.9-slim AS builder

WORKDIR /app

COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

COPY ./app ./app

FROM builder as dev-envs

RUN apt-get update
RUN apt-get install -y --no-install-recommends git

RUN useradd -s /bin/bash -m vscode
RUN groupadd docker
RUN usermod -aG docker vscode
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /

CMD ["uvicorn", "main:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "8080"]
