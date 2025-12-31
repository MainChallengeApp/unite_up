#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./build.sh <prod|test>"
  exit 1
fi

ENV=$1

if [ "$ENV" = "prod" ]; then
  echo "Building for PROD"
  cp .env.prod .env
elif [ "$ENV" = "test" ]; then
  echo "Building for TEST"
  cp .env.test .env
else
  echo "Invalid environment: $ENV"
  echo "Usage: ./build.sh <prod|test>"
  exit 1
fi

echo SUPABASE_URL=$SUPABASE_URL >> .env
echo SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY >> .env
git clone https://github.com/flutter/flutter.git --depth 1 -b 3.38.2 _flutter
_flutter/bin/flutter config --enable-web
_flutter/bin/flutter build web  --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY