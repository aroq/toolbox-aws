FROM aroq/toolbox-cicd-build:0.1.13

ENV AWSCLI_VERSION=1.17.9

COPY Dockerfile.packages.txt /etc/apk/packages.txt
RUN apk add --no-cache --update $(grep -v '^#' /etc/apk/packages.txt)

# Install Python, pip & aws-cli
RUN apk --update add --virtual .build-deps \
      python3-dev \
      libffi-dev \
      openssl-dev \
      build-base && \
    python3 -m ensurepip && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip \
      setuptools \
      wheel \
      awscli==${AWSCLI_VERSION} && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/*

ENTRYPOINT [ "aws" ]
