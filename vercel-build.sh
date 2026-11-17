
#!/bin/bash
set -e

echo "Installing Flutter SDK..."

git clone https://github.com/flutter/flutter.git \
  --depth 1 -b stable "$HOME/flutter"

export PATH="$HOME/flutter/bin:$PATH"

echo "Checking Flutter version..."
flutter --version

echo "Getting Flutter dependencies..."
flutter pub get

echo "Creating environment file..."
if [ -n "$OPENWEATHER_API_KEY" ]; then
  printf 'OPENWEATHER_API_KEY=%s\n' "$OPENWEATHER_API_KEY" > .env
else
  echo "ERROR: OPENWEATHER_API_KEY is not configured in Vercel."
  exit 1
fi

echo "Building Flutter Web..."
flutter build web --release

echo "Flutter Web build completed successfully!"
