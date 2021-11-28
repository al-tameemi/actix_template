FROM rust:1.56 as build
ENV PKG_CONFIG_ALLOW_CROSS=1

WORKDIR /usr/src/${PROJECT_NAME}
COPY . .

RUN cargo install --path .

FROM gcr.io/distroless/cc-debian11

COPY --from=build /usr/local/cargo/bin/${PROJECT_NAME} /usr/local/bin/${PROJECT_NAME}

CMD ["${PROJECT_NAME}"]