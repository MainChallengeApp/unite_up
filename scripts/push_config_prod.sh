#!/bin/bash

cp .env .env.temp
cp .env.prod .env
supabase config push
cp .env.temp .env
rm .env.temp