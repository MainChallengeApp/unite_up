#!/bin/bash
echo "######################"
echo start push config test
echo "######################"
cp .env.local .env.temp
cp .env.test .env.local
supabase config push
cp .env.temp .env.local
rm .env.temp
echo "######################"
echo end push config test
echo "######################"