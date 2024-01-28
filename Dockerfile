# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim
EXPOSE 7755

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1


# Install pip requirements
COPY requirements.txt .
RUN python -m pip install -r requirements.txt && apt-get update && apt-get install -y curl

WORKDIR /app
COPY . /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
ENV FLASK_APP=core/server.py
# CMD ["flask", "run", "--host", "0.0.0.0", "--port", "7755"]
CMD ["gunicorn", "-b", "0.0.0.0:7755", "--config", "gunicorn_config.py", "core.server:app"]