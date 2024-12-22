###########
# BUILDER #
###########

# pull official base image
# Use Python 3.11 to be able to use Debian packages as it is the version included with Debian Bookworm
FROM python:3.11-bookworm AS builder
ARG TARGETARCH

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends libsnmp-dev

RUN if [ $TARGETARCH = "arm" ]; then \
        apt-get install -y --no-install-recommends python3-cryptography python3-poetry rsync && \
        rsync -av /usr/lib/python3/dist-packages/ /usr/local/lib/python3.11/site-packages/ && \
        pip install --upgrade pip poetry-plugin-export; \
    else pip install --upgrade pip poetry poetry-plugin-export \
    ; fi

RUN git clone https://github.com/datagutten/switchinfo
RUN sed -i 's/python.*/python = ">=3.11"/' switchinfo/pyproject.toml
RUN sed -i 's/Django.*/Django = "^5"/' switchinfo/pyproject.toml
RUN git clone https://github.com/datagutten/django-switch-config-backup.git

RUN poetry -C switchinfo export -f requirements.txt --output requirements.txt --without-hashes --with postgres --with mysql --with aoscx --with easysnmp
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels -r requirements.txt
# RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels -r django-switch-config-backup/requirements.txt
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels paramiko scp netmiko

RUN pip wheel --no-cache-dir --no-deps --wheel-dir /usr/src/app/wheels gunicorn

#########
# FINAL #
#########

FROM python:3.11-bookworm
ARG TARGETARCH

# create directory for the app user
RUN mkdir -p /home/app

# create the app user
RUN addgroup --system app && adduser --system --group app

# create the appropriate directories
ENV HOME=/home/app
ENV APP_HOME=/home/app/web
ENV SNMP_LIBRARY=easysnmp

RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/staticfiles
RUN mkdir $APP_HOME/mediafiles
WORKDIR $APP_HOME

# install dependencies
RUN if [ $TARGETARCH = "arm" ]; then \
        apt-get update && apt-get install -y --no-install-recommends python3-paramiko rsync && \
        rsync -av /usr/lib/python3/dist-packages/ /usr/local/lib/python3.11/site-packages/ \
    ; fi

COPY --from=builder /usr/src/app/wheels /wheels
RUN pip install --upgrade pip
RUN pip install --no-cache /wheels/*

# install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends libsnmp-dev git

# copy project
COPY . $APP_HOME
COPY --from=builder /usr/src/app/switchinfo/switchinfo ./switchinfo
COPY --from=builder /usr/src/app/django-switch-config-backup/config_backup ./config_backup

# chown all the files to the app user
# RUN chown -R app:app $APP_HOME

# change to the app user
# USER app

# Set up git repository
RUN mkdir /home/config_backup
RUN git --git-dir /home/config_backup/.git init
RUN git --git-dir /home/config_backup/.git config user.email "config@backup.local"
RUN git --git-dir /home/config_backup/.git config user.name "Config backup"

EXPOSE 8000

# Collect static and start gunicorn
RUN chmod +x launcher.sh
CMD ["./launcher.sh"]
