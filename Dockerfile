# Leveraging the pre-built Docker images with
# cargo-chef and the Rust toolchain
FROM lukemathwalker/cargo-chef:latest-rust-1.56 AS chef
WORKDIR /usr/src/

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
COPY --from=planner /usr/src/recipe.json recipe.json
# Build dependencies - this is the caching Docker layer!
RUN cargo chef cook --release --recipe-path recipe.json
# Build application
COPY . .
RUN cargo build --release

# We do not need the Rust toolchain to run the binary!
FROM gcr.io/distroless/cc-debian11 AS runtime
WORKDIR /usr/src/
COPY --from=builder /usr/src/target/release/api_service /usr/bin

EXPOSE 8080

ENTRYPOINT ["api_service"]