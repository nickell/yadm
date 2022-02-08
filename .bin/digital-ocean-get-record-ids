#!/usr/bin/env bash

# ACCESS_TOKEN=fillthisin
# DOMAIN=fillthisin

[[ -f ~/.digital-ocean-secrets ]] && source ~/.digital-ocean-secrets

response=$(curl \
  --silent \
  -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://api.digitalocean.com/v2/domains/$DOMAIN/records")

echo $response
