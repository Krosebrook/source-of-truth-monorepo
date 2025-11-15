#!/bin/bash
# Stripe Environment Variable Update Script (guarded)
# Safeguards:
#   - set -euo pipefail for predictable exits
#   - verifies .env exists/writable before mutating
#   - blocks execution if placeholder values are still present
#   - confirms Vercel CLI is installed + authenticated before pushing remote vars

set -euo pipefail

ENV_FILE="${ENV_FILE:-/home/kyler/.env}"
PROJECT_DIR="${PROJECT_DIR:-/home/kyler/source-of-truth-monorepo/projects/local/flashfusion-consolidated/packages/ai-core}"
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

require_value() {
  local value="$1"
  local name="$2"
  local placeholder="$3"

  if [[ -z "$value" ]]; then
    echo "❌ $name cannot be empty." >&2
    exit 1
  fi

  if [[ "$value" == "$placeholder" ]]; then
    echo "❌ $name still uses placeholder value ($placeholder). Update the script before running." >&2
    exit 1
  fi
}

ensure_vercel_auth() {
  require_cmd vercel
  if ! vercel whoami >/dev/null 2>&1; then
    echo "❌ Vercel CLI not authenticated. Run 'vercel login' before executing this script." >&2
    exit 1
  fi
}

echo "🔐 Updating Stripe Environment Variables..."

# REPLACE THESE WITH YOUR ACTUAL VALUES FROM STRIPE
STRIPE_SECRET_KEY="${STRIPE_SECRET_KEY:-sk_test_YOUR_KEY_HERE}"
STRIPE_PUBLISHABLE_KEY="${STRIPE_PUBLISHABLE_KEY:-pk_test_YOUR_KEY_HERE}"
STRIPE_WEBHOOK_SECRET="${STRIPE_WEBHOOK_SECRET:-whsec_YOUR_SECRET_HERE}"
STRIPE_PRICE_BASIC="${STRIPE_PRICE_BASIC:-price_YOUR_PRICE_ID_HERE}"

require_cmd sed
ensure_file "$ENV_FILE"
require_value "$STRIPE_SECRET_KEY" "STRIPE_SECRET_KEY" "sk_test_YOUR_KEY_HERE"
require_value "$STRIPE_PUBLISHABLE_KEY" "STRIPE_PUBLISHABLE_KEY" "pk_test_YOUR_KEY_HERE"
require_value "$STRIPE_WEBHOOK_SECRET" "STRIPE_WEBHOOK_SECRET" "whsec_YOUR_SECRET_HERE"
require_value "$STRIPE_PRICE_BASIC" "NEXT_PUBLIC_STRIPE_PRICE_BASIC" "price_YOUR_PRICE_ID_HERE"

cp "$ENV_FILE" "$BACKUP_PATH"

sed -i "s|^STRIPE_SECRET_KEY=.*|STRIPE_SECRET_KEY=$STRIPE_SECRET_KEY|" "$ENV_FILE"
sed -i "s|^STRIPE_PUBLISHABLE_KEY=.*|STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY|" "$ENV_FILE"
sed -i "s|^STRIPE_WEBHOOK_SECRET=.*|STRIPE_WEBHOOK_SECRET=$STRIPE_WEBHOOK_SECRET|" "$ENV_FILE"
sed -i "s|^NEXT_PUBLIC_STRIPE_PRICE_BASIC=.*|NEXT_PUBLIC_STRIPE_PRICE_BASIC=$STRIPE_PRICE_BASIC|" "$ENV_FILE"

echo "✅ Stripe credentials updated in $ENV_FILE"
echo "📋 Backup saved to $BACKUP_PATH"

if [[ "${SYNC_VERCEL:-true}" == "true" ]]; then
  echo ""
  echo "📤 Updating Vercel environment variables..."
  ensure_vercel_auth
  if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "❌ Project directory not found: $PROJECT_DIR" >&2
    exit 1
  fi
  pushd "$PROJECT_DIR" >/dev/null

  vercel env rm STRIPE_SECRET_KEY production -y >/dev/null 2>&1 || true
  vercel env rm STRIPE_PUBLISHABLE_KEY production -y >/dev/null 2>&1 || true
  vercel env rm STRIPE_WEBHOOK_SECRET production -y >/dev/null 2>&1 || true
  vercel env rm NEXT_PUBLIC_STRIPE_PRICE_BASIC production -y >/dev/null 2>&1 || true

  echo "$STRIPE_SECRET_KEY" | vercel env add STRIPE_SECRET_KEY production
  echo "$STRIPE_PUBLISHABLE_KEY" | vercel env add STRIPE_PUBLISHABLE_KEY production
  echo "$STRIPE_WEBHOOK_SECRET" | vercel env add STRIPE_WEBHOOK_SECRET production
  echo "$STRIPE_PRICE_BASIC" | vercel env add NEXT_PUBLIC_STRIPE_PRICE_BASIC production

  popd >/dev/null
  echo "✅ Vercel environment variables updated"
fi

echo ""
echo "🚀 Ready to deploy! Run: vercel --prod"
