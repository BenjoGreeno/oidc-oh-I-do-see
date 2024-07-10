# pull the image from docker hub
FROM python:3.9.19-slim-bullseye

LABEL description="A Docker container to serve a simple Python Flask API"

# Set WORKDIR - the working directory for any RUN, CMD, ENTRYPOINT, COPY and ADD instructions that follow it in the Dockerfile
WORKDIR /home/app

# COPY - copies files or directories from <src> and adds them to the filesystem of the container at the path <dest>.
COPY files/* /home/app/

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies:
RUN pip install -r requirements.txt && chmod +x serve.sh \
 && apt update \
 && apt install -y curl
# EXPOSE - informs Docker that the container listens on the specified network ports at runtime
EXPOSE 8000
HEALTHCHECK CMD curl --fail http://localhost:8000/ || exit 1
RUN apt purge curl -y && apt-get clean -y
ENTRYPOINT ["bash", "-C", "./serve.sh"]
