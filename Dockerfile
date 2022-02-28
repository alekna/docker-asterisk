FROM alpine:3.15 as build
RUN apk add gcc musl-dev sqlite-dev autoconf automake make git asterisk-dev
RUN git clone https://github.com/wdoekes/asterisk-chan-dongle.git /build
WORKDIR /build
RUN ./bootstrap; \
    ./configure --with-astversion=18.2.2; \
    make

FROM alpine:3.15
RUN apk add asterisk
COPY --from=build /build/chan_dongle.so /usr/lib/asterisk/modules
CMD ["asterisk", "-f"]
