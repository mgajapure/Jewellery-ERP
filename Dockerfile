# Flutter Android APK builder
# Usage: docker build -t jewellery-erp-apk .
#        docker run --rm -v "$(pwd)/output:/output" jewellery-erp-apk

FROM ghcr.io/cirruslabs/flutter:stable

WORKDIR /app

# Copy dependency manifests first for layer caching
COPY pubspec.yaml pubspec.lock ./

RUN flutter pub get

# Copy rest of the project
COPY . .

# Disable Flutter analytics in CI
RUN flutter config --no-analytics

# Build release APK (signed with debug key — replace with keystore for prod)
RUN flutter build apk --release

# Copy APK to /output so it can be extracted via volume mount
RUN mkdir -p /output && \
    cp build/app/outputs/flutter-apk/app-release.apk /output/jewellery_erp.apk

CMD ["sh", "-c", "echo 'APK ready at /output/jewellery_erp.apk'"]
