#!/usr/bin/env bash
set -euo pipefail

echo "🔐 Updating Stripe environment variables..."

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
# Update these with your actual Stripe values before running the script.
STRIPE_SECRET_KEY="${STRIPE_SECRET_KEY:-sk_test_YOUR_KEY_HERE}"
STRIPE_PUBLISHABLE_KEY="${STRIPE_PUBLISHABLE_KEY:-pk_test_YOUR_KEY_HERE}"
STRIPE_WEBHOOK_SECRET="${STRIPE_WEBHOOK_SECRET:-whsec_YOUR_SECRET_HERE}"
STRIPE_PRICE_BASIC="${STRIPE_PRICE_BASIC:-price_YOUR_PRICE_ID_HERE}"

# Location of the .env file to patch. Override with ENV_FILE=/path/to/.env
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$REPO_ROOT/.env}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "⚠️  No .env file found at $ENV_FILE"
  echo "    Create one (you can start from templates/env.example) and rerun."
  exit 1
fi

BACKUP_FILE="${ENV_FILE}.backup.$(date +%Y%m%d%H%M%S)"
cp "$ENV_FILE" "$BACKUP_FILE"
echo "📦 Backup created: $BACKUP_FILE"

# -----------------------------------------------------------------------------
# Update local .env file
# -----------------------------------------------------------------------------
tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

awk -v sk="$STRIPE_SECRET_KEY" \
    -v pk="$STRIPE_PUBLISHABLE_KEY" \
    -v wh="$STRIPE_WEBHOOK_SECRET" \
    -v price="$STRIPE_PRICE_BASIC" '
BEGIN {
  updated["STRIPE_SECRET_KEY"] = 0;
  updated["STRIPE_PUBLISHABLE_KEY"] = 0;
  updated["STRIPE_WEBHOOK_SECRET"] = 0;
  updated["NEXT_PUBLIC_STRIPE_PRICE_BASIC"] = 0;
}

/^STRIPE_SECRET_KEY=/ {
  print "STRIPE_SECRET_KEY=" sk;
  updated["STRIPE_SECRET_KEY"] = 1;
  next;
}
/^STRIPE_PUBLISHABLE_KEY=/ {
  print "STRIPE_PUBLISHABLE_KEY=" pk;
  updated["STRIPE_PUBLISHABLE_KEY"] = 1;
  next;
}
/^STRIPE_WEBHOOK_SECRET=/ {
  print "STRIPE_WEBHOOK_SECRET=" wh;
  updated["STRIPE_WEBHOOK_SECRET"] = 1;
  next;
}
/^NEXT_PUBLIC_STRIPE_PRICE_BASIC=/ {
  print "NEXT_PUBLIC_STRIPE_PRICE_BASIC=" price;
  updated["NEXT_PUBLIC_STRIPE_PRICE_BASIC"] = 1;
  next;
}
{
  print;
}
END {
  if (!updated["STRIPE_SECRET_KEY"]) print "STRIPE_SECRET_KEY=" sk;
  if (!updated["STRIPE_PUBLISHABLE_KEY"]) print "STRIPE_PUBLISHABLE_KEY=" pk;
  if (!updated["STRIPE_WEBHOOK_SECRET"]) print "STRIPE_WEBHOOK_SECRET=" wh;
  if (!updated["NEXT_PUBLIC_STRIPE_PRICE_BASIC"]) print "NEXT_PUBLIC_STRIPE_PRICE_BASIC=" price;
}
' "$ENV_FILE" > "$tmp_file"

mv "$tmp_file" "$ENV_FILE"
echo "✅ Updated $ENV_FILE with Stripe credentials"

# -----------------------------------------------------------------------------
# Optional: sync values to Vercel (requires logged-in Vercel CLI)
# -----------------------------------------------------------------------------
if command -v vercel >/dev/null 2>&1; then
  if [[ "${SYNC_VERCEL:-0}" == "1" ]]; then
    echo "📤 Syncing credentials to Vercel (production)..."
    {
      echo "$STRIPE_SECRET_KEY" | vercel env add STRIPE_SECRET_KEY production
      echo "$STRIPE_PUBLISHABLE_KEY" | vercel env add STRIPE_PUBLISHABLE_KEY production
      echo "$STRIPE_WEBHOOK_SECRET" | vercel env add STRIPE_WEBHOOK_SECRET production
      echo "$STRIPE_PRICE_BASIC" | vercel env add NEXT_PUBLIC_STRIPE_PRICE_BASIC production
    } && echo "✅ Vercel environment updated" || echo "⚠️  Vercel sync skipped (check CLI output)"
  else
    echo "ℹ️  Skipping Vercel sync (set SYNC_VERCEL=1 to enable)."
  fi
else
  echo "ℹ️  Vercel CLI not found; skipping remote sync."
fi

echo "🚀 Done! Review $ENV_FILE and deploy when ready."
