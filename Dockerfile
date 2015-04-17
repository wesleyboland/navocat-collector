FROM jruby:1.7.19

ENV APP_PORT 8000
ENV LOCATION development
ENV THREAD_LOWER_BOUND 0
ENV THREAD_UPPER_BOUND 4

RUN apt-get update && apt-get install -y git
RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY . /usr/src/app

VOLUME /usr/src/app/meda_data
VOLUME /usr/src/app/log

RUN bundle install && gem install puma

EXPOSE ${APP_PORT}

CMD puma --environment ${LOCATION} --port ${APP_PORT} --threads ${THREAD_LOWER_BOUND}:${THREAD_UPPER_BOUND}