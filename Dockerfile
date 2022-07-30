FROM alpine:edge AS latest
WORKDIR /app

# Build from  https://tdlib.github.io/telegram-bot-api/build.html?os=Linux
RUN apk update && apk upgrade && \
    apk add --update alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake

RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git && \
    cd telegram-bot-api && \
    git submodule update --init && \
    rm -rf build && \
    mkdir build && \
    cd build  && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .. && \
    cmake --build . --target install -j $(nproc) && \
    cd ../.. && \
    ls -l /usr/local/bin/telegram-bot-api*


# # Release
FROM alpine:latest
COPY --from=build /usr/local/bin/telegram-bot-api /usr/local/bin/telegram-bot-api
RUN apk add --no-cache --update openssl libstdc++ bash
EXPOSE 8081-8082
