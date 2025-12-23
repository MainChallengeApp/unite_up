#!/bin/bash

cp .env .env_temp
cp .env.test .env
supabase config push
cp .env_temp .env
rm .env_temp