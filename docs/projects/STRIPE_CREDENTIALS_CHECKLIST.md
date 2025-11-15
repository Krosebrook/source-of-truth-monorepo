# ✅ Stripe Credentials Checklist

## 🎯 Get All 4 Stripe Credentials

### ☐ 1. STRIPE_SECRET_KEY
🔗 **Get it here:** [https://dashboard.stripe.com/test/apikeys](https://dashboard.stripe.com/test/apikeys)

**What it looks like:** `sk_test_51Oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

**Where to find it:**
1. Click link above
2. Look for "Secret key" section
3. Click "Reveal test key"
4. Click 📋 to copy
5. Paste below:

```
STRIPE_SECRET_KEY=sk_test_
```

---

### ☐ 2. STRIPE_PUBLISHABLE_KEY
🔗 **Same page:** [https://dashboard.stripe.com/test/apikeys](https://dashboard.stripe.com/test/apikeys)

**What it looks like:** `pk_test_51Oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

**Where to find it:**
1. Same page as above
2. Look for "Publishable key" section
3. It's already visible (no need to reveal)
4. Click 📋 to copy
5. Paste below:

```
STRIPE_PUBLISHABLE_KEY=pk_test_
```

---

### ☐ 3. STRIPE_WEBHOOK_SECRET
🔗 **Create webhook:** [https://dashboard.stripe.com/test/webhooks/create](https://dashboard.stripe.com/test/webhooks/create)

**What it looks like:** `whsec_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

**How to get it:**
1. Click link above
2. **Endpoint URL:** `https://flashfusion-3ei15stam-chaos-collective.vercel.app/api/webhooks/stripe`
3. **Description:** `FlashFusion payment webhook`
4. **Events to select:** Click "Select events" and choose:
   - ☑ `checkout.session.completed`
   - ☑ `payment_intent.succeeded`
   - ☑ `customer.subscription.created`
   - ☑ `customer.subscription.updated`
   - ☑ `customer.subscription.deleted`
   - ☑ `invoice.paid`
   - ☑ `invoice.payment_failed`
5. Click "Add endpoint"
6. **Copy the "Signing secret"** (appears after creation)
7. Paste below:

```
STRIPE_WEBHOOK_SECRET=whsec_
```

---

### ☐ 4. NEXT_PUBLIC_STRIPE_PRICE_BASIC
🔗 **Create product:** [https://dashboard.stripe.com/test/products/create](https://dashboard.stripe.com/test/products/create)

**What it looks like:** `price_1QRsT2UvW3XyZ4aBcDeFgHiJ`

**How to create it:**
1. Click link above
2. Fill in:
   - **Name:** `FlashFusion Basic`
   - **Description:** `AI-powered workflow automation - Basic tier`
   - **Price:** `29.00`
   - **Currency:** `USD`
   - **Billing period:** `Recurring` → `Monthly`
   - **Free trial:** ☑ `14 days`
3. Click "Save product"
4. **Copy the "Price ID"** from the pricing section
5. Paste below:

```
NEXT_PUBLIC_STRIPE_PRICE_BASIC=price_
```

---

## 🔄 **ONCE YOU HAVE ALL 4 VALUES:**

### Option A: Manual Update
Edit `/home/kyler/.env` and replace the placeholders with your actual values.

### Option B: Use the Update Script
1. Edit `UPDATE_STRIPE_ENV.sh`
2. Replace the placeholder values with your actual values
3. Run: `bash UPDATE_STRIPE_ENV.sh`

---

## 📋 **VERIFICATION CHECKLIST:**

After getting all credentials, verify:

- [ ] `STRIPE_SECRET_KEY` starts with `sk_test_`
- [ ] `STRIPE_PUBLISHABLE_KEY` starts with `pk_test_`
- [ ] `STRIPE_WEBHOOK_SECRET` starts with `whsec_`
- [ ] `NEXT_PUBLIC_STRIPE_PRICE_BASIC` starts with `price_`
- [ ] All values are from TEST mode (for now)
- [ ] Values are pasted into `.env` file
- [ ] No extra spaces or quotes around values
- [ ] File saved

---

## 🚀 **AFTER SETUP:**

### Test it:
```bash
cd /home/kyler/source-of-truth-monorepo/projects/local/flashfusion-consolidated/packages/ai-core

# Install Stripe
npm install stripe

# Test the webhook
curl -X POST http://localhost:3000/api/webhooks/stripe \
  -H "Content-Type: application/json" \
  -d '{"test": true}'
```

### Deploy to Vercel:
```bash
# Add to Vercel
vercel env add STRIPE_SECRET_KEY production
vercel env add STRIPE_PUBLISHABLE_KEY production
vercel env add STRIPE_WEBHOOK_SECRET production
vercel env add NEXT_PUBLIC_STRIPE_PRICE_BASIC production

# Deploy
vercel --prod
```

---

## 🔐 **SECURITY NOTES:**

✅ Use TEST mode keys for development
✅ Use LIVE mode keys only for production
✅ Never commit `.env` to git
✅ Rotate keys if they're ever exposed
✅ Keep webhook secret... secret!

---

## 📊 **COMPLETE .ENV TEMPLATE:**

```bash
# Anthropic API Configuration
ANTHROPIC_API_KEY=your_anthropic_api_key_here

# OpenAI API Configuration
OPENAI_API_KEY=your_openai_api_key_here

# Logging configuration
LOG_LEVEL=INFO
LOG_FILE=file_upload.log

# File upload limits (in bytes)
MAX_FILE_SIZE=104857600  # 100MB

# Stripe Configuration (TEST MODE)
STRIPE_SECRET_KEY=sk_test_YOUR_ACTUAL_SECRET_KEY
STRIPE_PUBLISHABLE_KEY=pk_test_YOUR_ACTUAL_PUBLISHABLE_KEY
STRIPE_WEBHOOK_SECRET=whsec_YOUR_ACTUAL_WEBHOOK_SECRET
NEXT_PUBLIC_STRIPE_PRICE_BASIC=price_YOUR_ACTUAL_PRICE_ID
```

---

## 🆘 **NEED HELP?**

**Can't find API keys?**
- Make sure you're in TEST mode (toggle at top of dashboard)
- Check you're logged into the correct Stripe account

**Webhook not working?**
- Verify endpoint URL is publicly accessible
- Check webhook secret matches exactly
- Look at webhook attempts in Stripe dashboard

**Price ID not showing?**
- Click on the product after creation
- Scroll to "Pricing" section
- Price ID is listed there

---

## ✅ **STATUS:**

- [ ] Got all 4 credentials
- [ ] Updated `.env` file
- [ ] Verified credentials format
- [ ] Tested locally
- [ ] Added to Vercel
- [ ] Deployed to production

---

**Ready to get your credentials!** 🚀

Start with step 1 (API Keys) and work your way down.
