#!/bin/bash
# Quick Stripe Environment Variable Setup Script (guarded)
# Safeguards:
#   - set -euo pipefail for predictable exits
#   - verifies .env file exists and is writable
#   - validates non-empty inputs
#   - records exact backup path for traceability

set -euo pipefail

ENV_FILE="${ENV_FILE:-/home/kyler/.env}"
BACKUP_PATH="${ENV_FILE}.backup.$(date +%Y%m%d_%H%M%S)"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "❌ Missing required command: $1" >&2
    exit 1
  fi
}

ensure_file() {
  if [[ ! -f "$1" ]]; then
    echo "❌ Expected environment file not found: $1" >&2
    exit 1
  fi
  if [[ ! -w "$1" ]]; then
    echo "❌ Environment file is not writable: $1" >&2
    exit 1
  fi
}

prompt_for_value() {
  local prompt="$1"
  local var
  read -r -p "$prompt" var
  if [[ -z "$var" ]]; then
    echo "❌ Value required for $prompt" >&2
    exit 1
  fi
  printf '%s' "$var"
}

echo "🔐 Stripe Environment Variable Setup"
echo "====================================="
echo ""
echo "Enter your Stripe credentials (paste and press Enter):"
echo ""

require_cmd sed
ensure_file "$ENV_FILE"

STRIPE_SECRET_KEY=$(prompt_for_value "STRIPE_SECRET_KEY (sk_test_...): ")
STRIPE_PUBLISHABLE_KEY=$(prompt_for_value "STRIPE_PUBLISHABLE_KEY (pk_test_...): ")
STRIPE_WEBHOOK_SECRET=$(prompt_for_value "STRIPE_WEBHOOK_SECRET (whsec_...): ")
STRIPE_PRICE_BASIC=$(prompt_for_value "NEXT_PUBLIC_STRIPE_PRICE_BASIC (price_...): ")

echo ""
echo "📝 Updating $ENV_FILE ..."

cp "$ENV_FILE" "$BACKUP_PATH"

sed -i "s|^STRIPE_SECRET_KEY=.*|STRIPE_SECRET_KEY=$STRIPE_SECRET_KEY|" "$ENV_FILE"
sed -i "s|^STRIPE_PUBLISHABLE_KEY=.*|STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY|" "$ENV_FILE"
sed -i "s|^STRIPE_WEBHOOK_SECRET=.*|STRIPE_WEBHOOK_SECRET=$STRIPE_WEBHOOK_SECRET|" "$ENV_FILE"
sed -i "s|^NEXT_PUBLIC_STRIPE_PRICE_BASIC=.*|NEXT_PUBLIC_STRIPE_PRICE_BASIC=$STRIPE_PRICE_BASIC|" "$ENV_FILE"

echo "✅ $ENV_FILE updated!"
echo ""
echo "📋 Your Stripe configuration (partial):"
echo "STRIPE_SECRET_KEY=${STRIPE_SECRET_KEY:0:20}..."
echo "STRIPE_PUBLISHABLE_KEY=${STRIPE_PUBLISHABLE_KEY:0:20}..."
echo "STRIPE_WEBHOOK_SECRET=${STRIPE_WEBHOOK_SECRET:0:20}..."
echo "NEXT_PUBLIC_STRIPE_PRICE_BASIC=$STRIPE_PRICE_BASIC"
echo ""
echo "💾 Backup saved to: $BACKUP_PATH"
echo ""
echo "🚀 Ready to deploy! Run: vercel --prod"
