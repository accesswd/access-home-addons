#!/usr/bin/with-contenv bashio
# ====================================================================
# Access Home Connect - Home Assistant Add-on
# run.sh - main entrypoint
# ====================================================================

set -e

# Config values from add-on config.json (subdomain, etc.)
SUBDOMAIN=$(bashio::config 'subdomain')

# API endpoint
API_URL="https://workflows.accesswd.ca/webhook/access-home-connect-api"

bashio::log.info "Requesting tunnel for subdomain: ${SUBDOMAIN}"

# Call your n8n API with the subdomain payload
RESPONSE=$(curl -s -X POST "${API_URL}" \
  -H "Content-Type: application/json" \
  -d "{\"subdomain\": \"${SUBDOMAIN}\"}")

bashio::log.info "API response: ${RESPONSE}"

# Extract tunnel credentials (assuming JSON response includes 'credentials')
CREDENTIALS=$(echo "${RESPONSE}" | jq -r '.credentials')

if [ -z "$CREDENTIALS" ] || [ "$CREDENTIALS" = "null" ]; then
  bashio::log.error "Failed to obtain tunnel credentials"
  exit 1
fi

# Save credentials to file
echo "${CREDENTIALS}" > /data/cert.json
bashio::log.info "Saved tunnel credentials to /data/cert.json"

# Start cloudflared with the credentials
bashio::log.info "Starting cloudflared tunnel..."
cloudflared tunnel --credentials-file /data/cert.json run "${SUBDOMAIN}"