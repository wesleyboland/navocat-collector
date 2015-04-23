FROM jruby:1.7.19

# ==========REDIS CONFIGURATIONS============

RUN apt-get update \
	&& apt-get install -y git \
	&& apt-get install -y curl \
	&& rm -rf /var/lib/apt/lists/*

ENV REDIS_VERSION 3.0.0
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-3.0.0.tar.gz
ENV REDIS_DOWNLOAD_SHA1 c75fd32900187a7c9f9d07c412ea3b3315691c65

# for redis-sentinel see: http://redis.io/topics/sentinel
RUN buildDeps='gcc libc6-dev make'; \
	set -x \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/src/redis \
	&& curl -sSL "$REDIS_DOWNLOAD_URL" -o redis.tar.gz \
	&& echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c - \
	&& tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
	&& rm redis.tar.gz \
	&& make -C /usr/src/redis \
	&& make -C /usr/src/redis install \
	&& rm -r /usr/src/redis \
	&& apt-get purge -y --auto-remove $buildDeps

RUN mkdir /data

VOLUME /data

# ============REDIS CONFIG==============

# ============COLLECTOR CONFIGS=========
ENV MEDA_LOCATION /usr/src/app/external_configs/meda.yml
ENV DATASET_LOCATION /usr/src/app/external_configs/datasets.yml

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY . /usr/src/app

VOLUME /usr/src/app/meda_data
VOLUME /usr/src/app/log
VOLUME /usr/src/app/external_configs

RUN bundle install && gem install puma

EXPOSE 8000

RUN chmod +x entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
