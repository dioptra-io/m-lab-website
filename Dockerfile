FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies (cached unless this line or the base image changes)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git ruby-dev gcc g++ make libgmp-dev build-essential \
        patch zlib1g-dev liblzma-dev openssl libssl-dev \
        curl locales jupyter jupyter-nbconvert && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /home/website

# Copy dependency files first to take advantage of Docker layer caching
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN gem install bundler:2.4.22 && \
    bundle install && \
    gem cleanup

# Set UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LC_ALL=en_US.UTF-8