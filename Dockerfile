# syntax=docker/dockerfile:1
ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim

ENV PATH="/home/openaiuser/.local/bin:${PATH}"

# Create an unprivileged user.
RUN useradd --create-home --user-group openaiuser
USER openaiuser
WORKDIR /home/openaiuser

RUN pip install --no-cache-dir --user openai

CMD ["openai", "--help"]
