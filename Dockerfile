FROM alpine:edge AS build
WORKDIR /app

# Build from  https://tdlib.github.io/telegram-bot-api/build.html?os=Linux
RUN apk update && apk upgrade && \
    apk add --update alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake

RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git && \
    cd telegram-bot-api && \
    rm -rf build && \
    mkdir build && \
    cd build  && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .. && \
    cmake --build . --target install && \
    cd ../.. && \
    ls -l /usr/local/bin/telegram-bot-api*


# Release
FROM alpine:edge
COPY --from=build /usr/local/bin/telegram-bot-api /usr/local/bin/telegram-bot-api
RUN apk add --no-cache --update openssl libstdc++

EXPOSE 8081/tcp
CMD ["sh"]