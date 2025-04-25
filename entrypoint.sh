#!/bin/sh

set -e

CONFIG_DIR="/app/config"
mkdir -p "$CONFIG_DIR"

# Download config files from GIST_ID or CONFIG_FILES
if [ -n "$GIST_ID" ]; then
  echo "Using GIST_ID: $GIST_ID"
  API_URL="https://api.github.com/gists/$GIST_ID"
  FILES=$(curl -s "$API_URL" | jq -r '.files | to_entries[] | .value.raw_url')
else
  echo "Using CONFIG_FILES"
  FILES=$(echo "$CONFIG_FILES" | tr "," " ")
fi

for FILE_URL in $FILES; do
  if [ -n "$FILE_URL" ]; then
    FILE_NAME=$(basename "$FILE_URL")
    DEST_PATH="$CONFIG_DIR/$FILE_NAME"
    echo "Downloading $FILE_NAME..."
    wget -q -O "$DEST_PATH" "$FILE_URL"
    echo "$FILE_NAME has been downloaded."
  fi
done

# Download assets (CUSTOM_CSS, FAVICON, LOGO)
for VAR in CUSTOM_CSS FAVICON LOGO; do
  URL=$(eval echo \$$VAR)
  if [ -n "$URL" ]; then
    FILE_NAME=$(basename "$URL")
    DEST_PATH="$CONFIG_DIR/$FILE_NAME"
    echo "Downloading $FILE_NAME..."
    wget -q -O "$DEST_PATH" "$URL"
    echo "$FILE_NAME has been downloaded."
  fi
done

echo "Starting Glance..."
exec ./glance --config "$CONFIG_DIR/glance.yml"
