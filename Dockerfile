FROM jruby:1.7.19

ENV APP_PORT 8000

ENV LOCATION development

RUN apt-get update && apt-get install -y git

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY . /usr/src/app

VOLUME /usr/src/app/meda_data

RUN bundle install && gem install puma

EXPOSE ${APP_PORT}

CMD puma --environment ${LOCATION} --port ${APP_PORT} --threads 0:4