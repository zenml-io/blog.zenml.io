FROM docker:18.06.1-ce

ENV JEKYLL_VERSION 3.7.2

RUN apk add --update --no-cache \
    python \
    python-dev \
    py-pip \
    build-base \
    curl \
    bash \
    jq \
    git \
    openssl-dev \
    libffi-dev \
    ruby \
    ruby-rdoc \
    ruby-bundler \
    ruby-dev \
    gcc \
    nodejs \
    npm \
  && rm -rf /var/cache/apk/*

RUN pip install awscli
RUN gem update
RUN gem uninstall psych
RUN gem install jekyll -v $JEKYLL_VERSION
RUN npm install html-minifier -g

ENTRYPOINT /bin/bash