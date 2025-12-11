#!/bin/bash

cp .env.example .env
echo SUPABASE_URL=$SUPABASE_URL >> .env
echo SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY >> .env
git clone https://github.com/flutter/flutter.git --depth 1 -b 3.38.2 _flutter
_flutter/bin/flutter config --enable-web
_flutter/bin/flutter build web  --dart-define=SUPABASE_URL=$SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY