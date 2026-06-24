#!/usr/bin/env bash
# Build the release APK inside Docker and drop it in ./output/
set -e

IMAGE="jewellery-erp-apk"
OUTPUT_DIR="$(pwd)/output"

echo "Building Docker image..."
docker build -t "$IMAGE" .

echo "Extracting APK to $OUTPUT_DIR ..."
mkdir -p "$OUTPUT_DIR"
docker run --rm -v "$OUTPUT_DIR:/output" "$IMAGE"

echo ""
echo "Done. APK is at: $OUTPUT_DIR/jewellery_erp.apk"
