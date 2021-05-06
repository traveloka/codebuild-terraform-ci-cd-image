FROM ubuntu:bionic
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    jq \
    python \
    python-pip \
    unzip \
    wget \
    zip \
    openssh-client && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/* && \
    apt-get clean && \
    apt-get autoremove --purge
RUN git clone -b v2.2.0 https://github.com/tfutils/tfenv.git ~/.tfenv && \
    ln -s ~/.tfenv/bin/* /usr/local/bin
RUN python -m pip install --upgrade pip && \
    python -m pip install --no-cache-dir --upgrade setuptools && \
    python -m pip install --no-cache-dir --upgrade awscli && \
    python -m pip install --no-cache-dir boto3 && \
    python -m pip install --no-cache-dir cryptography && \
    python -m pip install --no-cache-dir PyJWT && \
    python -m pip install --no-cache-dir requests && \
    python -m pip install --no-cache-dir Jinja2 && \
    python -m pip cache purge
RUN tfenv install 0.11.15 &&\
    tfenv install 0.12.31 &&\
    tfenv install 0.13.7 &&\
    tfenv use 0.11.15
COPY scripts/ /usr/local/bin/