FROM google/dart:1.13.0

MAINTAINER LitGroup Team <developers@litgroup.ru>

WORKDIR /app

COPY pubspec.* /app/

RUN pub get

COPY . /app

RUN pub get --offline \
    && pub build

EXPOSE 9931

CMD []

ENTRYPOINT ["/usr/bin/dart", "bin/server.dart"]