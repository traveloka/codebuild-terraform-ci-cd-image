FROM ubuntu:xenial
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    jq \
    python \
    python-pip \
    unzip \
    wget \
    zip \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*
RUN git clone -b v2.0.0 https://github.com/tfutils/tfenv.git ~/.tfenv && \
    ln -s ~/.tfenv/bin/* /usr/local/bin
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install --upgrade awscli
RUN pip install boto3
RUN pip install cryptography
RUN pip install PyJWT
RUN pip install requests
RUN pip install Jinja2
COPY scripts/ /usr/local/bin/
