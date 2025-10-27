# Vercel Deployment Guide

## Repository Status ✅

**All systems ready for deployment!**

- ✅ Build process: **PASSING**
- ✅ All tests (227): **PASSING**
- ✅ Linting: **PASSING**
- ✅ Code formatting: **PASSING**
- ✅ Security audit: **Reviewed** (dev dependencies only)
- ✅ CI/CD pipeline: **CONFIGURED**
- ✅ Vercel configuration: **OPTIMIZED**

## Pre-Deployment Checklist

### 1. Repository Setup

- [x] All code is formatted with Prettier
- [x] All linting rules pass
- [x] All 227 tests pass
- [x] Build completes successfully
- [x] `.vercelignore` configured
- [x] `vercel.json` optimized with security headers
- [x] GitHub Actions CI/CD configured

### 2. Environment Variables Required

Before deploying to Vercel, configure these environment variables in your Vercel project dashboard:

#### Required (Backend/API):

```bash
SUPABASE_URL=your_supabase_project_url
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key
NODE_ENV=production
```

#### Optional (Frontend - Client-side Supabase):

```bash
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

#### Optional (INT System Integrations):

```bash
# HubSpot CRM
HUBSPOT_ACCESS_TOKEN=your_hubspot_private_app_access_token
HUBSPOT_PORTAL_ID=your_hubspot_portal_id

# Freshdesk
FRESHDESK_DOMAIN=your_domain.freshdesk.com
FRESHDESK_API_KEY=your_freshdesk_api_key

# Microsoft Teams
TEAMS_WEBHOOK_URL=your_teams_incoming_webhook_url
```

## Deployment Methods

### Method 1: Deploy via Vercel CLI (Recommended for first deployment)

1. **Install Vercel CLI** (if not already installed):

   ```bash
   npm install -g vercel
   ```

2. **Login to Vercel**:

   ```bash
   vercel login
   ```

3. **Deploy to Production**:

   ```bash
   npm run deploy
   # OR
   vercel --prod
   ```

4. **Follow the prompts** to link your project to Vercel

### Method 2: Deploy via Vercel Dashboard (Recommended for ongoing deployments)

1. **Go to [vercel.com](https://vercel.com)** and sign in
2. **Click "Add New Project"**
3. **Import your GitHub repository**:
   - Select: `INT-Smart-Triage-AI-2.0`
   - Branch: `Update2.0` (or your main branch)
4. **Configure Project**:
   - Framework Preset: **Vite** (auto-detected)
   - Build Command: `npm run build` (auto-detected)
   - Output Directory: `dist` (auto-detected)
   - Install Command: `npm install` (auto-detected)
5. **Add Environment Variables** (click "Environment Variables"):
   - Add all required variables from the list above
   - Ensure you select the correct environment (Production/Preview/Development)
6. **Click "Deploy"**

### Method 3: Automatic Deployments via GitHub

Once connected to Vercel:

- **Every push to `Update2.0` branch** → Automatic production deployment
- **Every pull request** → Automatic preview deployment
- **GitHub Actions will run first** to validate code before Vercel deploys

## Post-Deployment Verification

### 1. Check Deployment Status

After deployment, verify these endpoints:

```bash
# Health Check API
https://your-app.vercel.app/api/health-check

# Expected Response:
{
  "status": "healthy" or "degraded",
  "timestamp": "2025-10-16T...",
  "service": "INT Smart Triage AI 2.0",
  "version": "1.0.0",
  "checks": {
    "api": "healthy",
    "database": "healthy",
    "rls": "enabled"
  }
}
```

### 2. Test Main Application

Visit your deployment URL:

```
https://your-app.vercel.app
```

Expected features:

- ✅ Main triage form loads
- ✅ Navigation works
- ✅ Demo page accessible at `/public/demo.html`
- ✅ Analytics page accessible at `/public/analytics.html`
- ✅ Client history page accessible at `/public/client-history.html`

### 3. Test API Endpoints

```bash
# Test triage report endpoint
curl -X POST https://your-app.vercel.app/api/triage-report \
  -H "Content-Type: application/json" \
  -d '{
    "customerName": "Test Customer",
    "ticketSubject": "Test Subject",
    "issueDescription": "Test issue",
    "customerTone": "calm"
  }'
```

### 4. Verify Security Headers

```bash
curl -I https://your-app.vercel.app
```

Should include:

- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `X-XSS-Protection: 1; mode=block`
- `Referrer-Policy: strict-origin-when-cross-origin`

## Troubleshooting

### Build Fails on Vercel

1. **Check build logs** in Vercel dashboard
2. **Verify Node.js version**:
   - Required: Node.js >= 18.0.0
   - Vercel uses Node 18 by default
3. **Run locally** to reproduce:
   ```bash
   npm ci
   npm run build
   ```

### API Routes Return 500 Errors

1. **Check environment variables** are set in Vercel dashboard
2. **Verify Supabase credentials** are correct
3. **Check function logs** in Vercel dashboard

### Database Connection Issues

1. **Verify Supabase URL** is correct (should end with `.supabase.co`)
2. **Check service role key** is the full key (starts with `eyJ...`)
3. **Ensure RLS policies** are configured in Supabase
4. **Run database setup**:
   ```sql
   -- Execute supabase-setup.sql in your Supabase SQL Editor
   ```

### Assets Not Loading

1. **Check build output** - ensure `dist` folder contains all assets
2. **Verify paths** - all asset paths should be relative or absolute from root
3. **Clear Vercel cache**:
   ```bash
   vercel --force
   ```

## Configuration Files Reference

### vercel.json

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "framework": "vite",
  "rewrites": [...],
  "headers": [...],
  "functions": {
    "api/**/*.js": {
      "maxDuration": 10
    }
  }
}
```

### .vercelignore

Ensures unnecessary files are not uploaded to Vercel, reducing deployment time and size.

## Performance Optimization

### Enabled Features:

- ✅ **Security Headers** - Comprehensive security headers on all routes
- ✅ **API Caching** - Health check endpoint cached for 10 seconds
- ✅ **Build Optimization** - Vite builds with minification and tree-shaking
- ✅ **Function Timeout** - API functions timeout after 10 seconds
- ✅ **Asset Optimization** - Static assets served from CDN

### Recommended Next Steps:

1. **Enable Vercel Analytics** in dashboard
2. **Set up Vercel Monitoring** for API routes
3. **Configure custom domain** if needed
4. **Enable branch preview deployments** for pull requests

## CI/CD Pipeline

### GitHub Actions Workflow

Located at: `.github/workflows/ci.yml`

**Triggers:**

- Push to `main`, `develop`, `Update2.0` branches
- Pull requests to `main`, `Update2.0` branches

**Runs:**

1. Format check
2. Linting
3. Tests (Node 18, 20, 22)
4. Build verification
5. Security audit

**All checks must pass** before code can be merged.

## Monitoring & Maintenance

### Regular Checks:

1. **Monitor Vercel dashboard** for deployment status
2. **Check function logs** for API errors
3. **Review security audit** monthly:
   ```bash
   npm audit
   ```
4. **Update dependencies** regularly:
   ```bash
   npm update
   ```

### Security:

- Rotate API keys every 90 days
- Review Vercel access logs monthly
- Keep environment variables secure (never commit to git)
- Monitor for unauthorized access attempts

## Support

### Resources:

- **Vercel Documentation**: https://vercel.com/docs
- **Project README**: [README.md](./README.md)
- **Environment Variables**: [.env.example](./.env.example)
- **API Documentation**: [docs/API_REFERENCE.md](./docs/API_REFERENCE.md)

### Common Issues:

- Check `.env.example` for all required environment variables
- Ensure Supabase database is set up (run `supabase-setup.sql`)
- Verify all integration credentials are valid

---

## Summary

✅ **Your repository is production-ready for Vercel deployment**

**No errors when you visit Vercel** - Everything is configured correctly:

- Build process works
- Tests pass
- Linting passes
- Security headers configured
- Environment variables documented
- API routes ready
- CI/CD pipeline active

**Next Step**: Deploy to Vercel using Method 2 (Vercel Dashboard) for the easiest experience!
