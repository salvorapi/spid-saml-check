FROM debian:buster
LABEL mantainer="Michele D'Amico, michele.damico@agid.gov.it"

# Update and install utilities
RUN apt-get update \
    && apt-get install -y \
        wget \
        curl \
        unzip \
        gcc \
        libxml2-utils \
        openssl \
        python3 \
        python3-pip \
        xmlsec1

# Install spid-sp-test
RUN apt-get install -y \
        libxml2-dev \
        libxmlsec1-dev \
        libxmlsec1-openssl \
        xmlsec1 \
        python3-pip

RUN pip3 install spid-sp-test --upgrade --no-cache

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y \
        nodejs \
        build-essential

# Set the working directory
WORKDIR /spid-saml-check

# Copy the current directory to /spid-validator
ADD . /spid-saml-check

# Create directory for tests data
RUN mkdir /spid-saml-check/data

ENV TZ=Europe/Rome

# Build validator
RUN cd /spid-saml-check/spid-validator && \
    cd client && npm install --silent && cd .. && \
    cd server && npm install --silent && cd .. && \
    npm run build

# Ports exposed
EXPOSE 8080


ENTRYPOINT cd spid-validator && npm run start-prod
