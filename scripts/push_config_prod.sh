#!/bin/bash
echo "######################"
echo start push config prod
echo "######################"
cp .env.local .env.temp
cp .env.prod .env.local
supabase config push
cp .env.temp .env.local
rm .env.temp
echo "######################"
echo end push config prod
echo "######################"