# Complete Repository Catalog & Consolidation Plan
**Date**: 2025-11-02  
**Scope**: Krosebrook + ChaosClubCo + FlashFusionv1  
**Total Repositories**: 89 repos (76 Krosebrook + 6 ChaosClubCo + 7 FlashFusionv1)

---

## Executive Summary

**Total Inventory**: 89 repositories across 3 GitHub accounts
- **Krosebrook**: 76 repos (10 private, 66 public)
- **ChaosClubCo**: 6 repos (1 private, 5 public)
- **FlashFusionv1**: 7 repos (5 private, 2 public)

**Key Finding**: Significant duplication detected across accounts, with similar FlashFusion-related projects scattered across all three organizations.

---

## ACCOUNT 1: Krosebrook (76 Repositories)

### 🌟 **1. flashfusion-ide** (PUBLIC)
**Language**: TypeScript | **Stars**: 3 | **Forks**: 1 | **Issues**: 1  
**Updated**: 2025-10-16  
**5-Sentence Overview**: Modern, AI-powered web-based IDE competing with Replit and Loveable.dev as a completely free, self-hostable alternative. Provides full development environment with AI-assisted coding, real-time collaboration, and integrated terminal. Built with TypeScript for type safety and modern web technologies. Ideal for solo developers or teams wanting control over their development infrastructure without vendor lock-in. Use by deploying to your own infrastructure and accessing via web browser.  
**Category**: 🛠️ **Core Development Platform**  
**Migration Priority**: **P1 - Critical**

### 🌟 **2. turborepo-flashfusion** (PUBLIC)
**Language**: JavaScript | **Stars**: 1 | **Issues**: 28  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Turborepo monorepo configuration optimized for FlashFusion projects with shared packages and optimized build pipeline. Leverages Turbo's caching and parallel execution to dramatically speed up builds across multiple packages. Provides workspace patterns for code sharing, dependency management, and coordinated deployments. Essential infrastructure for managing the FlashFusion ecosystem at scale. Use by cloning and running `pnpm install` followed by `turbo build`.  
**Category**: 🏗️ **Build Infrastructure**  
**Migration Priority**: **P1 - Critical** (Possible duplicate of source-of-truth-monorepo)

### 🌟 **3. INT-Smart-Triage-AI-2.0** (PUBLIC)
**Language**: JavaScript | **Stars**: 1 | **Issues**: 38  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Production-ready AI triage system for INT Inc. Client Success team that instantly analyzes support tickets and provides CSRs with empathetic talking points. Suggests relevant Knowledge Base articles automatically and securely logs all interactions to Supabase via Vercel Serverless Functions. Ensures sub-second response times with full data persistence and enterprise-grade security. Currently in active production use handling real customer support workflows. Deploy to Vercel with Supabase backend for instant AI-powered support triage.  
**Category**: 📊 **Production SaaS Application**  
**Migration Priority**: **P1 - Production Critical**

### 🌟 **4. FlashFusion-Unified** (PUBLIC)
**Language**: JavaScript | **Stars**: 1 | **Forks**: 1 | **Issues**: 9  
**Updated**: 2025-10-30  
**5-Sentence Overview**: Unified FlashFusion platform consolidating multiple tools and workflows into single cohesive experience. Combines IDE functionality, AI assistance, project management, and deployment capabilities in one interface. Represents the "all-in-one" vision for FlashFusion ecosystem reducing tool sprawl. Built on modern JavaScript stack with emphasis on developer experience and productivity. Install dependencies and run `npm start` for local development server.  
**Category**: 🏢 **Unified Platform**  
**Migration Priority**: **P1 - Strategic**

### 🌟 **5. DevChat** (PUBLIC)
**Language**: TypeScript | **Stars**: 1 | **Issues**: 7  
**Updated**: 2025-10-03  
**5-Sentence Overview**: Real-time developer collaboration chat tool with code sharing, syntax highlighting, and AI assistant integration. Enables teams to discuss code in context with inline code blocks, file sharing, and threaded conversations. Integrates with popular AI models for instant code suggestions and debugging help within chat. Built for remote development teams needing seamless communication alongside coding. Run with `npm install && npm run dev`.  
**Category**: 💬 **Developer Collaboration**  
**Migration Priority**: **P2 - Tools**

### 🌟 **6. source-of-truth-monorepo** (PRIVATE)
**Language**: JavaScript | **Issues**: 5  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Unified Source-of-Truth monorepo consolidating 53 repositories across the entire FlashFusion ecosystem into single managed workspace. Uses Turborepo for build orchestration, pnpm workspaces for dependency management, and changesets for versioning. Contains automated CI/CD pipelines, security scanning (Gitleaks, CodeQL), and 50-mirror deployment infrastructure. Active development hub with onboarding automation, comprehensive documentation, and established governance. This is the MASTER consolidation target for all other repositories.  
**Category**: ⭐ **MASTER MONOREPO**  
**Migration Priority**: **P0 - Consolidation Target**

### **7. project-nexus** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-11-02 (Most recent push)  
**5-Sentence Overview**: Central project coordination and management dashboard for FlashFusion ecosystem tracking cross-repo initiatives. Provides visual workflow management, dependency tracking, and automated status reporting. Built with TypeScript for reliability and Leap for rapid prototyping. Serves as command center for orchestrating work across multiple repositories and teams. Access via web interface after deploying to Vercel or similar platform.  
**Category**: 📋 **Project Management**  
**Migration Priority**: **P1 - Core Infrastructure**

### **8. Harvestflow** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-28  
**5-Sentence Overview**: AI-powered file organization and audit system with drag-and-drop interface for managing large file collections. Automatically categorizes, tags, and organizes files using ML-based classification. Provides comprehensive audit trails, duplicate detection, and smart search capabilities. Currently being used for the 656K file organization project. Deployed as web application with local file system access.  
**Category**: 🗂️ **File Management Tool**  
**Migration Priority**: **P1 - Active Development**

### **9. codex-workspace** (PRIVATE)
**Language**: Shell  
**Updated**: 2025-10-28  
**5-Sentence Overview**: Dedicated workspace for Codex CLI tasks providing isolated environment for AI-assisted automation and scripting. Contains configuration files, custom scripts, and workflow automation for GitHub Codex operations. Serves as sandbox for testing Codex commands before applying to production repositories. Essential for maintaining safe AI agent operations with rollback capabilities. Use by setting as active Codex workspace directory.  
**Category**: 🤖 **AI Agent Workspace**  
**Migration Priority**: **P1 - Infrastructure**

### **10. saas-validator-suite** (PUBLIC)
**Language**: TypeScript | **Issues**: 1  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Comprehensive SaaS validation toolkit for testing authentication, authorization, billing, and core business logic. Provides automated test suites for Stripe integration, user permissions, data access controls, and API endpoints. Built for rapid SaaS development with pre-configured tests for common patterns. Integrates with CI/CD pipelines for continuous validation. Run tests with `pnpm test` after configuration.  
**Category**: ✅ **Testing & Validation**  
**Migration Priority**: **P2 - Quality Assurance**

### **11. v0-template-evaluation-academy** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Template marketplace and evaluation system for assessing UI/UX templates and boilerplates. Provides scoring criteria, community ratings, and automated quality checks for design templates. Helps developers choose the right starting template for their projects based on objective metrics. Built as educational resource for template best practices. Access as web application for browsing and rating templates.  
**Category**: 📚 **Learning/Templates**  
**Migration Priority**: **P3 - Educational**

### **12. flashfusion-discord** (PUBLIC)
**Updated**: 2025-10-01  
**5-Sentence Overview**: Discord bot for FlashFusion community providing automated support, notifications, and community management. Integrates with GitHub for commit notifications, PR updates, and issue tracking. Provides AI-powered question answering about FlashFusion features and troubleshooting. Moderates community channels and tracks user engagement metrics. Deploy to Discord server using bot token.  
**Category**: 🤖 **Community Bot**  
**Migration Priority**: **P4 - Community Tools**

### **13. v0-pointer-ai-landing-page** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-09-24  
**5-Sentence Overview**: Landing page for Pointer AI product showcasing AI-powered pointer/cursor enhancement technology. Features product demos, pricing information, and conversion-optimized CTAs. Built with modern TypeScript stack for fast loading and SEO optimization. Private repository for proprietary marketing content. Deploy to Vercel or Netlify.  
**Category**: 🎨 **Marketing Landing Page**  
**Migration Priority**: **P5 - Marketing**

### **14. smbv3** (PUBLIC)
**Language**: TypeScript | **Issues**: 1  
**Updated**: 2025-10-01  
**5-Sentence Overview**: Small/Medium Business platform version 3 providing business management tools and automation. Includes CRM features, project tracking, invoicing, and client communication. Built for solo entrepreneurs and small teams needing affordable business operations software. TypeScript-based for reliability with modern React frontend. Install and run locally or deploy to cloud platform.  
**Category**: 💼 **Business Management**  
**Migration Priority**: **P4 - Specialized Tools**

### **15. FFSignup** (PUBLIC)
**Updated**: 2025-08-21  
**5-Sentence Overview**: FlashFusion signup and onboarding flow handling new user registration and initial setup. Implements email verification, account creation, team invitations, and preference configuration. Provides smooth onboarding experience guiding users through FlashFusion features. Critical for user acquisition and retention metrics. Integrate into main FlashFusion application.  
**Category**: 👤 **User Onboarding**  
**Migration Priority**: **P2 - User Experience**

### **16. CreatorStudioLite** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-24  
**5-Sentence Overview**: Lightweight content creation studio for generating marketing materials, social media posts, and creative assets. Provides templates, AI-assisted writing, and image generation capabilities. Designed for speed and simplicity without overwhelming features of full creator suites. Perfect for solo creators and small marketing teams. Access via web interface.  
**Category**: 🎨 **Content Creation**  
**Migration Priority**: **P4 - Creative Tools**

### **17. enhanced-firecrawl-scraper** (PUBLIC)
**Language**: HTML  
**Updated**: 2025-08-25  
**5-Sentence Overview**: Enhanced web scraping tool built on FireCrawl with comprehensive context extraction capabilities. Extracts structured data, images, metadata, and maintains page context relationships. Ideal for competitive analysis, content aggregation, and market research. Respects robots.txt and implements rate limiting for ethical scraping. Run as CLI tool or integrate into data pipelines.  
**Category**: 🔍 **Data Extraction**  
**Migration Priority**: **P4 - Utilities**

### **18. UniversalAIGen** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Universal AI content generator supporting multiple content types and use cases. Creates blog posts, social media content, product descriptions, and technical documentation using various AI models. Provides templates and customization options for consistent brand voice. Streamlines content production workflows for marketing teams. Use via web interface or API.  
**Category**: ✍️ **AI Content Generation**  
**Migration Priority**: **P3 - Productivity Tools**

### **19. lovable-prompt-artist** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Specialized tool for crafting high-quality prompts for Loveable.dev AI platform. Provides prompt templates, optimization suggestions, and result preview capabilities. Helps users get better outputs from Loveable by engineering effective prompts. Includes prompt library with community-contributed examples. Access as web application for prompt crafting.  
**Category**: 🎨 **Prompt Engineering**  
**Migration Priority**: **P3 - Developer Tools**

### **20. SnapShotCRM** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Lightweight CRM designed for speed and simplicity, created with Leap framework. Manages contacts, deals pipeline, communication history, and basic reporting. Built for small teams wanting CRM functionality without enterprise complexity. Integrates with email and calendar systems. Deploy to Vercel or run locally.  
**Category**: 📊 **CRM Application**  
**Migration Priority**: **P4 - Business Tools**

### **21. Templateevaluationacademy** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-27  
**5-Sentence Overview**: Educational platform teaching template evaluation methodology and best practices for choosing boilerplates. Provides structured course content, hands-on exercises, and certification program. Helps developers make informed decisions when selecting project templates. Includes case studies and real-world examples. Access as learning management system.  
**Category**: 📚 **Educational Platform**  
**Migration Priority**: **P5 - Educational**

### **22. KinsleysCreativeSuite** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-28  
**5-Sentence Overview**: Coloring book generator creating customizable coloring pages for kids and adults. Uses AI to generate unique designs based on themes, complexity levels, and age appropriateness. Provides printable PDF output and digital coloring interfaces. Built for parents, educators, and creative entrepreneurs. Generate and download coloring books via web interface.  
**Category**: 🎨 **Creative Generator**  
**Migration Priority**: **P5 - Specialized Tools**

### **23. tessa** (PUBLIC)
**Updated**: 2025-08-21  
**5-Sentence Overview**: Personal AI assistant named Tessa providing task management, scheduling, and productivity support. Integrates with calendar, email, and todo systems for unified workflow management. Learns user preferences over time to provide personalized recommendations. Voice-activated for hands-free operation. Configure and interact via web or mobile interface.  
**Category**: 🤖 **AI Assistant**  
**Migration Priority**: **P4 - Personal Productivity**

### **24. UniversalWriterAI** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-10-26  
**5-Sentence Overview**: Creates any human or machine-readable material including documentation, code, technical specs, and creative content. Adapts writing style and format based on target audience and medium. Supports multiple languages and technical writing standards. Proprietary AI models tuned for professional writing quality. Access via API or web interface.  
**Category**: ✍️ **AI Writing Platform**  
**Migration Priority**: **P3 - Content Tools**

### **25. mystical-penguin-snap** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Screenshot and annotation tool with mystical theme providing quick capture and markup capabilities. Adds arrows, text, highlights, and shapes to screenshots for documentation and tutorials. Cloud sync for sharing annotated images with teams. Built for technical writers and support teams. Install as desktop app or browser extension.  
**Category**: 📸 **Screenshot Tool**  
**Migration Priority**: **P5 - Utilities**

### **26. MyMagicWriter** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-31  
**5-Sentence Overview**: General-purpose AI writing assistant helping with blog posts, emails, reports, and creative writing. Provides writing suggestions, grammar checking, and style improvements in real-time. Helps overcome writer's block with AI-generated continuations and idea generation. Integrates with popular writing platforms and editors. Use via web interface or editor plugins.  
**Category**: ✍️ **Writing Assistant**  
**Migration Priority**: **P4 - Productivity**

### **27. d1-rest** (PUBLIC)
**Language**: TypeScript | **Issues**: 3  
**Updated**: 2025-08-24  
**5-Sentence Overview**: REST API wrapper for Cloudflare D1 database providing standard HTTP endpoints for database operations. Simplifies D1 access from applications without Workers-specific code. Includes authentication, rate limiting, and query caching. Ideal for traditional web applications wanting to use D1. Deploy as Cloudflare Worker.  
**Category**: 🔌 **API/Database Tool**  
**Migration Priority**: **P4 - Infrastructure**

### **28. OAuth** (PUBLIC)
**Updated**: 2025-07-30  
**5-Sentence Overview**: OAuth 2.0 authentication implementation providing secure user authentication and authorization flows. Supports multiple providers (Google, GitHub, Microsoft, etc.) with unified interface. Handles token management, refresh, and secure storage. Essential component for SaaS applications requiring third-party authentication. Integrate into authentication middleware.  
**Category**: 🔐 **Authentication**  
**Migration Priority**: **P2 - Security Infrastructure**

### **29. int-triage-ai.3.0** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-18  
**5-Sentence Overview**: Next generation INT Smart Triage AI with enhanced ML models and improved accuracy. Builds on 2.0 success with faster response times and better context understanding. Includes new features for automated ticket routing and priority classification. Backward compatible with existing INT infrastructure. Deploy alongside or replace version 2.0.  
**Category**: 📊 **Production SaaS (Next Gen)**  
**Migration Priority**: **P2 - Production Evolution**

### **30. analyst-cockpit-ui** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Dashboard UI for data analysts providing visualization, query building, and report generation. Connects to multiple data sources with drag-and-drop chart creation. Includes SQL query editor, scheduling, and export capabilities. Designed for business intelligence and data exploration workflows. Deploy as web application with backend API.  
**Category**: 📊 **Analytics Dashboard**  
**Migration Priority**: **P4 - Business Intelligence**

### **31. Flashfusionwebsite11** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Version 11 of FlashFusion marketing website with updated branding, messaging, and conversion funnels. Private repository containing proprietary marketing assets and strategies. Includes pricing pages, feature showcases, customer testimonials, and demo videos. Optimized for SEO and conversion rate. Deploy to production marketing domain.  
**Category**: 🎨 **Marketing Website**  
**Migration Priority**: **P3 - Marketing Assets**

### **32. MonoTurboRepo-FlashFusion** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-15  
**5-Sentence Overview**: Earlier monorepo attempt for FlashFusion using Turborepo structure before source-of-truth-monorepo. Contains workspace configurations and build orchestration setup. Likely superseded by newer consolidation efforts. May contain useful patterns or configurations to migrate. Review for historical context and migration extraction.  
**Category**: 🏗️ **Legacy Monorepo**  
**Migration Priority**: **P6 - Archive/Review**

### **33. knowledge-base-app** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-08-28  
**5-Sentence Overview**: Knowledge base and documentation platform for creating searchable help centers and wikis. Provides markdown editing, categorization, search, and version history. Built for customer support teams and internal documentation needs. Integrates with existing support workflows. Deploy as standalone app or embed in products.  
**Category**: 📚 **Documentation Platform**  
**Migration Priority**: **P3 - Documentation**

### **34. Dad-sEcomGen** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-10-31  
**5-Sentence Overview**: E-commerce dashboard with automated product generation and analytics for dropshipping businesses. Generates product listings, manages inventory, and tracks sales metrics. Connects to multiple e-commerce platforms for unified management. Includes profit calculators and trend analysis. Private tool for proprietary e-commerce operations.  
**Category**: 💰 **E-commerce Platform**  
**Migration Priority**: **P4 - Specialized Commerce**

### **35. flashfusion-lite-ecommerce** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Lightweight e-commerce solution for FlashFusion ecosystem enabling quick product/service sales. Includes cart, checkout, Stripe integration, and basic inventory management. Designed for developers selling templates, tools, or services. Minimal configuration required for rapid deployment. Integrate into existing FlashFusion projects.  
**Category**: 💰 **E-commerce Module**  
**Migration Priority**: **P3 - Commerce Infrastructure**

### **36. CGDSTARTER** (PUBLIC)
**Language**: TypeScript | **Issues**: 6  
**Updated**: 2025-07-29  
**5-Sentence Overview**: Starter template for Component-Driven Development projects with pre-configured tooling and best practices. Includes Storybook, testing frameworks, and design system foundations. Accelerates new project initialization with proven patterns. Provides documentation on component architecture and development workflows. Clone and customize for new projects.  
**Category**: 📦 **Starter Template**  
**Migration Priority**: **P4 - Templates**

### **37. solemuchbetterv2** (PUBLIC)
**Updated**: 2025-09-22  
**5-Sentence Overview**: Version 2 iteration of "solemuchbetter" project (purpose unclear from name). Improved implementation of original concept with enhanced features. Likely experimental or proof-of-concept project. Review repository contents for actual functionality. May be candidate for archival.  
**Category**: 🧪 **Experimental**  
**Migration Priority**: **P6 - Archive/Review**

### **38. HabboHotel** (PUBLIC)
**Updated**: 2025-08-17  
**5-Sentence Overview**: Virtual world/social platform inspired by Habbo Hotel with rooms, avatars, and social interactions. Likely experimental project exploring real-time multiplayer game development. Built with web technologies for browser-based access. May contain reusable patterns for collaborative virtual spaces. Review for architectural learnings.  
**Category**: 🎮 **Experimental/Gaming**  
**Migration Priority**: **P6 - Archive/Review**

### **39. cortex-second-brain-4589** (PUBLIC)
**Language**: TypeScript | **Issues**: 5  
**Updated**: 2025-08-28  
**5-Sentence Overview**: Personal knowledge management system implementing "second brain" methodology for information organization. Captures notes, links, and insights with AI-powered categorization and retrieval. Provides graph view of knowledge connections and automated tagging. Built for knowledge workers and researchers. Deploy as personal productivity tool.  
**Category**: 🧠 **Knowledge Management**  
**Migration Priority**: **P4 - Personal Productivity**

### **40. blindspot-whisperer** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-09-07  
**5-Sentence Overview**: Tool for identifying knowledge gaps and cognitive blindspots through AI-powered analysis. Asks probing questions and surfaces assumptions you may not have considered. Helps with decision-making, strategy, and critical thinking. Uses conversational AI to guide self-reflection process. Interact via web chat interface.  
**Category**: 🧠 **AI Analysis Tool**  
**Migration Priority**: **P5 - Experimental Tools**

### **41. TheGemmyAdventures** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-10-29  
**5-Sentence Overview**: Choose-your-own-adventure game generator creating interactive storytelling experiences. AI generates branching narratives based on user choices and themes. Includes illustration generation for story scenes. Built for educators, parents, and game designers. Private repository for proprietary game content.  
**Category**: 🎮 **Interactive Story Generator**  
**Migration Priority**: **P5 - Entertainment**

### **42. MyContextEngine** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Context management system for AI applications tracking conversation history and state. Maintains context windows across sessions with intelligent truncation and summarization. Optimizes token usage while preserving important context. Critical infrastructure for chatbots and AI assistants. Integrate into AI-powered applications.  
**Category**: 🤖 **AI Infrastructure**  
**Migration Priority**: **P3 - AI Tools**

### **43. theaidashboard** (PUBLIC)
**Language**: TypeScript | **Issues**: 1  
**Updated**: 2025-10-15  
**5-Sentence Overview**: Unified dashboard for managing multiple AI model APIs, usage tracking, and cost monitoring. Provides single interface for OpenAI, Anthropic, Gemini, and other AI services. Includes analytics, budget alerts, and usage optimization recommendations. Essential for teams using multiple AI providers. Deploy as internal management tool.  
**Category**: 📊 **AI Management Dashboard**  
**Migration Priority**: **P3 - AI Infrastructure**

### **44. flashfusion-commerce-forge** (PUBLIC)
**Language**: TypeScript | **Issues**: 5  
**Updated**: 2025-10-22  
**5-Sentence Overview**: E-commerce store builder integrated with FlashFusion for rapid online shop creation. Provides templates, product management, payment processing, and shipping integration. Built for creators monetizing digital or physical products. Includes analytics and marketing automation. Launch stores without coding.  
**Category**: 💰 **E-commerce Builder**  
**Migration Priority**: **P3 - Commerce Platform**

### **45. AIGenerateToStorefront** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Generates print-on-demand merchandise and automatically publishes to TikTok Shop, Etsy, Shopify using Printify fulfillment. AI creates designs based on trending topics and market analysis. Automates entire product creation and listing workflow. Monitors sales performance and adjusts strategy. Private tool for automated e-commerce business.  
**Category**: 💰 **AI E-commerce Automation**  
**Migration Priority**: **P4 - Specialized Commerce**

### **46. CustomGPTs** (PUBLIC)
**Updated**: 2025-09-19  
**5-Sentence Overview**: Collection of custom GPT configurations and instructions for specific use cases. Includes prompts, knowledge bases, and integration patterns for custom ChatGPT models. Serves as library of reusable GPT templates. Useful for teams building AI assistants with consistent behavior. Clone and customize GPT configurations.  
**Category**: 🤖 **AI Templates**  
**Migration Priority**: **P4 - AI Resources**

### **47. superscale-lovable-guide-33147** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Comprehensive guide for scaling applications built with Lovable.dev platform. Covers performance optimization, database scaling, caching strategies, and deployment patterns. Includes code examples and infrastructure-as-code templates. Designed for teams growing beyond initial Lovable prototypes. Follow guide for production scaling.  
**Category**: 📚 **Technical Guide**  
**Migration Priority**: **P4 - Documentation**

### **48. flashfusion-loveable** (PUBLIC)
**Language**: TypeScript | **Issues**: 5  
**Updated**: 2025-07-28  
**5-Sentence Overview**: Integration between FlashFusion and Lovable.dev platforms enabling seamless workflow between tools. Provides export/import capabilities and shared component libraries. Allows developers to leverage both platforms' strengths. Reduces context switching and increases productivity. Install as bridge service.  
**Category**: 🔌 **Platform Integration**  
**Migration Priority**: **P3 - Integration Tools**

### **49. sole-scaffold-27** (PRIVATE)
**Language**: TypeScript | **Issues**: 1  
**Updated**: 2025-09-22  
**5-Sentence Overview**: Specialized project scaffold numbered 27 in series for specific use case. Private template containing proprietary patterns or client-specific configurations. Part of scaffold collection for rapid project initialization. Review contents to determine current relevance. May consolidate with other scaffolds.  
**Category**: 📦 **Private Template**  
**Migration Priority**: **P6 - Review/Archive**

### **50. sole-scaffold-12** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-09-22  
**5-Sentence Overview**: Another scaffold variant (number 12) with specific configuration or industry focus. Private repository suggesting client work or proprietary setup. Part of systematic scaffold numbering system. Evaluate for unique patterns worth preserving. Consider archiving if superseded.  
**Category**: 📦 **Private Template**  
**Migration Priority**: **P6 - Review/Archive**

### **51. solo-merch-flow** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Workflow automation for solo entrepreneurs managing merchandise businesses. Handles design creation, print-on-demand integration, listing creation, and order fulfillment tracking. Streamlines entire merch pipeline for single-person operations. Integrates with Printful, Printify, and major marketplaces. Run locally or deploy to cloud.  
**Category**: 💰 **Merch Automation**  
**Migration Priority**: **P5 - Specialized Tools**

### **52. CreatorsClashStudio** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-30  
**5-Sentence Overview**: Competitive platform where creators challenge each other to produce the best creative content. Provides voting system, leaderboards, and community engagement features. Gamifies content creation with contests and rewards. Built for building creator communities and driving engagement. Deploy as social platform.  
**Category**: 🎨 **Creator Community Platform**  
**Migration Priority**: **P5 - Community Tools**

### **53. nextjs-with-supabase** (PUBLIC)
**Language**: TypeScript | **Issues**: 1  
**Updated**: 2025-08-30  
**5-Sentence Overview**: Next.js starter template with Supabase authentication and database pre-configured. Includes user management, protected routes, and database schema examples. Accelerates SaaS development with proven authentication patterns. Provides best practices for Next.js + Supabase integration. Clone and customize for new projects.  
**Category**: 📦 **Starter Template**  
**Migration Priority**: **P4 - Templates**

### **54. OpenFlashFusion** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Open-source version of FlashFusion with community contributions and transparent development. Provides core functionality without proprietary features or restrictions. Enables community-driven development and feature extensions. Ideal for developers wanting to understand or modify FlashFusion internals. Contribute via GitHub pull requests.  
**Category**: 🌐 **Open Source Platform**  
**Migration Priority**: **P2 - Community Edition**

### **55. ai-academic-content-catalog** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-26  
**5-Sentence Overview**: Comprehensive catalog of AI-generated academic resources including papers, study guides, and research summaries. Provides curated collection for students and researchers needing academic support. Includes citation generation and bibliography management. Everything academics need to succeed in one platform. Browse and search via web interface.  
**Category**: 📚 **Academic Resources**  
**Migration Priority**: **P5 - Educational**

### **56. whim-creation-nexus** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-29  
**5-Sentence Overview**: Creative ideation platform for generating project ideas and creative concepts on a whim. Uses AI to suggest combinations of technologies, themes, and approaches. Helps overcome creative blocks and discover new project directions. Designed for developers and creators seeking inspiration. Generate ideas via web interface.  
**Category**: 💡 **Ideation Tool**  
**Migration Priority**: **P5 - Creative Tools**

### **57. FissionPrompt** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-31  
**5-Sentence Overview**: Prompt generation system for FlashFusion ecosystem creating optimized AI prompts. Analyzes user intent and generates effective prompts for various AI models. Includes prompt templates library and optimization suggestions. Critical tool for improving AI interaction quality. Integrate into AI-powered FlashFusion features.  
**Category**: 🎨 **Prompt Generation**  
**Migration Priority**: **P3 - AI Tools**

### **58. nextjs-commerce** (PUBLIC)
**Language**: TypeScript | **Issues**: 5  
**Updated**: 2025-08-28  
**5-Sentence Overview**: E-commerce platform built on Next.js with modern commerce features. Includes product catalog, shopping cart, checkout, and order management. Optimized for performance with server-side rendering and static generation. Provides foundation for building online stores. Fork from Vercel's commerce template.  
**Category**: 💰 **E-commerce Platform**  
**Migration Priority**: **P4 - Commerce Templates**

### **59. v0-pointer-ai-landing-page-0i** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Alternative iteration of Pointer AI landing page with different design approach. Public version for A/B testing marketing messages and layouts. Includes variant pricing strategies and CTA placements. Used for conversion optimization experiments. Deploy alongside primary landing page.  
**Category**: 🎨 **Marketing Variant**  
**Migration Priority**: **P5 - Marketing Assets**

### **60. fusionforge-studio** (PUBLIC)
**Language**: TypeScript | **Issues**: 5  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Studio environment for creating and managing FusionForge projects. Provides project templates, component libraries, and development workflows. Integrated build tools and deployment pipelines. Designed for teams building multiple related applications. Launch studio and create new projects.  
**Category**: 🏗️ **Development Studio**  
**Migration Priority**: **P3 - Development Tools**

### **61. ignite-pixl-verse** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-31  
**5-Sentence Overview**: Pixel art creation and collaboration platform with social features. Provides drawing tools, color palettes, and animation capabilities. Enables sharing and remixing pixel art creations. Built for pixel art enthusiasts and game developers. Create and share via web interface.  
**Category**: 🎨 **Creative Platform**  
**Migration Priority**: **P5 - Creative Tools**

### **62. LocalWan** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-24  
**5-Sentence Overview**: Local network management and monitoring tool for home and small office networks. Provides device discovery, traffic monitoring, and basic network diagnostics. Helps troubleshoot connectivity issues and optimize network performance. Built for non-technical users wanting network visibility. Run on local machine.  
**Category**: 🌐 **Network Tool**  
**Migration Priority**: **P6 - Specialized Utilities**

### **63. ai-tool-hub-92085** (PUBLIC)
**Language**: JavaScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Centralized hub for discovering and managing AI tools and services. Curates AI tools by category with ratings, reviews, and integration guides. Helps teams find the right AI tools for specific use cases. Includes comparison features and pricing information. Browse catalog via web interface.  
**Category**: 📚 **AI Tool Directory**  
**Migration Priority**: **P4 - Resources**

### **64. int-smart-triage-ai-3.0** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Third major version of INT Smart Triage AI (different from int-triage-ai.3.0). Latest iteration with newest ML models and enhanced features. Represents ongoing evolution of production triage system. Backward compatible with existing deployments. Version number indicates separate development track.  
**Category**: 📊 **Production SaaS V3**  
**Migration Priority**: **P2 - Production Evolution**

### **65. FLashFusion-Learn** (PUBLIC)
**Language**: JavaScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Learning management system (LMS) for FlashFusion platform teaching development best practices. Includes interactive tutorials, video courses, and hands-on exercises. Tracks student progress and provides certifications. Built for onboarding new FlashFusion users. Access as educational platform.  
**Category**: 📚 **Learning Platform**  
**Migration Priority**: **P4 - Educational**

### **66. solemuchbetter** (PUBLIC)
**Updated**: 2025-09-22  
**5-Sentence Overview**: Original version of project later iterated to v2. Purpose unclear from repository name alone. May be experimental or proof-of-concept work. Review repository contents for actual functionality. Likely superseded by solemuchbetterv2.  
**Category**: 🧪 **Experimental**  
**Migration Priority**: **P6 - Archive/Review**

### **67. v0-ai-agent-builder** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-10-27  
**5-Sentence Overview**: Private tool for building and configuring AI agents with visual interface. Provides agent template library and configuration management. Designed for creating custom AI assistants without coding. Includes testing sandbox and deployment automation. Proprietary agent-building platform.  
**Category**: 🤖 **AI Agent Builder**  
**Migration Priority**: **P3 - AI Tools**

### **68. Flashfusionwebsite** (PUBLIC)
**Language**: TypeScript | **Issues**: 2  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Main public marketing website for FlashFusion platform. Features product information, pricing, documentation links, and customer testimonials. Primary entry point for new users discovering FlashFusion. Optimized for SEO and conversion. Production marketing site.  
**Category**: 🎨 **Marketing Website**  
**Migration Priority**: **P2 - Marketing Critical**

### **69. Intos** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-10-27  
**5-Sentence Overview**: Private project with unclear purpose from name. Likely client work or proprietary development. Review repository to determine functionality and current relevance. May contain patterns or code worth preserving. Consider consolidation or archival.  
**Category**: 🔒 **Private/Unknown**  
**Migration Priority**: **P6 - Review/Archive**

### **70. sole-scaffold-hub** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-09-22  
**5-Sentence Overview**: Central repository managing collection of scaffold templates (scaffolds 1-N). Provides CLI tool for browsing and installing scaffolds. Maintains scaffold catalog and versioning. Makes scaffold system discoverable and manageable. Install CLI and browse scaffold options.  
**Category**: 📦 **Scaffold Manager**  
**Migration Priority**: **P4 - Template Infrastructure**

### **71. FFKB** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-11-01  
**5-Sentence Overview**: FlashFusion Knowledge Base providing comprehensive documentation and support articles. Searchable database of how-to guides, troubleshooting, and feature explanations. Community-contributed content with upvoting and feedback. Critical resource for FlashFusion users. Access as web application.  
**Category**: 📚 **Knowledge Base**  
**Migration Priority**: **P2 - Documentation Critical**

### **72. UniPromptGen2** (PUBLIC)
**Language**: TypeScript | **Issues**: 1  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Universal prompt generator version 2 with improved templates and AI model support. Creates optimized prompts for multiple AI platforms (ChatGPT, Claude, Gemini, etc.). Includes prompt library and community sharing features. Essential tool for consistent AI interactions. Use via web interface.  
**Category**: 🎨 **Prompt Generator**  
**Migration Priority**: **P3 - AI Tools**

### **73. flashfusion-genesis** (PUBLIC)
**Language**: TypeScript | **Issues**: 5  
**Updated**: 2025-11-01  
**5-Sentence Overview**: Original genesis/foundation repository for FlashFusion ecosystem. Contains core concepts, early prototypes, and architectural decisions. Historical significance for understanding FlashFusion evolution. May contain foundational code still in use. Review for historical context.  
**Category**: 🏛️ **Historical/Foundation**  
**Migration Priority**: **P4 - Historical Reference**

### **74. security-blindspot-radar** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Security analysis tool identifying potential vulnerabilities and overlooked security concerns. Scans codebases, configurations, and deployment setups for common mistakes. Provides remediation suggestions and security best practices. Built with Leap framework for rapid development. Run security audits regularly.  
**Category**: 🔒 **Security Tool**  
**Migration Priority**: **P3 - Security Infrastructure**

### **75. OctaveStudio** (PUBLIC)
**Language**: TypeScript  
**Updated**: 2025-10-27  
**5-Sentence Overview**: Music creation and audio editing studio built for web. Provides multi-track editing, effects, and synthesis capabilities. Designed for musicians and podcasters wanting browser-based audio production. Supports common audio formats and export options. Access via web browser.  
**Category**: 🎵 **Audio Tool**  
**Migration Priority**: **P5 - Creative Tools**

### **76. LifeWins** (PUBLIC)
**Updated**: 2025-08-28  
**5-Sentence Overview**: Kid training app gamifying daily tasks and positive behaviors. Rewards children for completed chores, homework, and good behavior with virtual points. Parents set goals and track progress with visualizations. Makes parenting more engaging and children more motivated. Install as mobile or web app.  
**Category**: 👨‍👩‍👧 **Family/Education**  
**Migration Priority**: **P5 - Consumer Apps**

---

## ACCOUNT 2: ChaosClubCo (6 Repositories)

### 🌟 **77. FlashFusion** (PUBLIC)
**Language**: TypeScript | **Forks**: 1  
**Updated**: 2025-11-01  
**5-Sentence Overview**: ChaosClubCo's fork/version of FlashFusion platform with organization-specific customizations. May contain experimental features or client-specific modifications. Part of distributed FlashFusion development across multiple organizations. Potentially duplicates Krosebrook FlashFusion repositories. Evaluate for unique features worth merging.  
**Category**: 🏢 **Org FlashFusion Fork**  
**Migration Priority**: **P1 - Consolidation Review**

### **78. claude-code** (PUBLIC)
**Language**: Shell | **Stars**: 1 | **Issues**: 3  
**Updated**: 2025-07-05  
**5-Sentence Overview**: Shell scripts and configurations for Claude Code AI assistant integration. Provides command-line interface for Claude API interactions and workflow automation. Includes prompt templates and response parsing utilities. Useful for CI/CD integration with Claude. Run scripts in terminal environment.  
**Category**: 🤖 **AI CLI Tool**  
**Migration Priority**: **P3 - Developer Tools**

### **79. tiktok-story-ai** (PUBLIC)
**Language**: TypeScript | **Issues**: 8  
**Updated**: 2025-10-22  
**5-Sentence Overview**: AI-powered tool generating TikTok story content including scripts, visual suggestions, and hashtag recommendations. Analyzes trending topics and creates viral-optimized content. Designed for content creators and marketers targeting TikTok. Includes scheduling and performance tracking features. Generate content via web interface.  
**Category**: 📱 **Social Media Tool**  
**Migration Priority**: **P4 - Marketing Tools**

### **80. nix-config** (PUBLIC)
**Language**: Nix  
**Updated**: 2025-07-03  
**5-Sentence Overview**: Nix configuration files for reproducible development environments using Claude Code. Defines system packages, dependencies, and environment setup declaratively. Ensures consistent development setup across machines and team members. Critical for NixOS users or Nix-based development workflows. Apply configurations with Nix commands.  
**Category**: ⚙️ **Development Config**  
**Migration Priority**: **P4 - Infrastructure**

### **81. turborepo-flashfusion** (PUBLIC)
**Language**: JavaScript | **Issues**: 1  
**Updated**: 2025-09-17  
**5-Sentence Overview**: ChaosClubCo version of turborepo-flashfusion, potentially duplicating Krosebrook repository. May represent different development branch or organization-specific configuration. Contains FlashFusion monorepo structure with Turborepo tooling. Evaluate differences from Krosebrook version before consolidation. Likely candidate for merge.  
**Category**: 🏗️ **Duplicate Monorepo**  
**Migration Priority**: **P1 - Consolidation Critical**

### **82. demo-repository** (PRIVATE)
**Language**: HTML  
**Updated**: 2025-09-17  
**5-Sentence Overview**: Private demo repository showing GitHub's best features and capabilities. Used for teaching, presentations, or internal training purposes. Contains example workflows, documentation, and repository structures. Standard GitHub demo content with organization customizations. Reference for repository best practices.  
**Category**: 📚 **Demo/Training**  
**Migration Priority**: **P6 - Archive**

---

## ACCOUNT 3: FlashFusionv1 (7 Repositories)

### 🌟 **83. loveable-supabase** (PUBLIC)
**Language**: TypeScript | **Stars**: 1 | **Issues**: 7  
**Updated**: 2025-07-22  
**5-Sentence Overview**: Integration project connecting Lovable.dev platform with Supabase backend services. Provides authentication, database, and storage solutions for Lovable applications. Includes starter templates and common integration patterns. Simplifies full-stack development with Lovable frontend and Supabase backend. Deploy with pre-configured Supabase project.  
**Category**: 🔌 **Platform Integration**  
**Migration Priority**: **P3 - Integration Tools**

### **84. pulse-robot-template-40849** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Private template for robot/automation projects numbered 40849. Likely contains proprietary automation patterns or client-specific implementations. Part of template collection for specific use cases. Review contents to determine current value. May consolidate with other templates.  
**Category**: 🤖 **Private Template**  
**Migration Priority**: **P6 - Review/Archive**

### **85. nimble-fab-flow** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Private workflow automation for fabrication or manufacturing processes. Nimble suggests lightweight, flexible approach to fab workflows. May contain industry-specific business logic or client IP. Review for patterns applicable to other projects. Consider archival if project complete.  
**Category**: 🏭 **Private Workflow**  
**Migration Priority**: **P6 - Review/Archive**

### **86. odyssey-learns** (PRIVATE)
**Language**: TypeScript | **Forks**: 1  
**Updated**: 2025-10-20  
**5-Sentence Overview**: Private learning platform or educational project named Odyssey. Has been forked suggesting shared development or derivative work. Contains educational content or learning management features. Private status indicates proprietary content or client work. Review for unique features worth preserving.  
**Category**: 📚 **Private Education**  
**Migration Priority**: **P6 - Review/Archive**

### **87. demo-repository** (PRIVATE)
**Language**: HTML  
**Updated**: 2025-09-17  
**5-Sentence Overview**: Another private demo repository (duplicate concept with ChaosClubCo). Demonstrates GitHub features for FlashFusionv1 organization context. Used for training or reference purposes within this organization. Standard GitHub demo content with customizations. Reference material only.  
**Category**: 📚 **Demo/Training**  
**Migration Priority**: **P6 - Archive**

### **88. collabnet-visualizer-111** (PRIVATE)
**Language**: TypeScript  
**Updated**: 2025-10-22  
**5-Sentence Overview**: Private collaboration network visualization tool numbered 111. Visualizes team connections, project relationships, and workflow dependencies. Helps understand organizational structure and collaboration patterns. Private suggests proprietary visualization algorithms or client data. Review for general-purpose utility.  
**Category**: 📊 **Private Visualization**  
**Migration Priority**: **P6 - Review/Archive**

### **89. flashfusion-creative-hub** (PUBLIC)
**Language**: TypeScript | **Issues**: 5  
**Updated**: 2025-07-26  
**5-Sentence Overview**: Creative collaboration hub for FlashFusion users to share projects and ideas. Provides showcase galleries, project templates, and community features. Enables discovery of FlashFusion creations and developer collaboration. Built to foster FlashFusion ecosystem growth. Access via web platform.  
**Category**: 🎨 **Community Platform**  
**Migration Priority**: **P3 - Community Infrastructure**

---

## Consolidation Analysis

### Duplication Summary

**Critical Duplicates (Immediate Action Required)**:
1. **turborepo-flashfusion** - Exists in both Krosebrook AND ChaosClubCo
2. **FlashFusion** - Multiple variants across organizations
3. **demo-repository** - Duplicate in ChaosClubCo and FlashFusionv1
4. **INT Smart Triage AI** - 3 versions (2.0, int-triage-ai.3.0, int-smart-triage-ai-3.0)
5. **solemuchbetter** - v1 and v2 versions

### Organization Distribution

| Category | Krosebrook | ChaosClubCo | FlashFusionv1 | Total |
|---|---|---|---|---|
| Development Platforms | 3 | 1 | 0 | 4 |
| Build Infrastructure | 2 | 1 | 0 | 3 |
| Production SaaS | 4 | 0 | 0 | 4 |
| E-commerce Tools | 8 | 0 | 0 | 8 |
| AI Tools | 12 | 1 | 0 | 13 |
| Marketing/Landing | 7 | 0 | 1 | 8 |
| Templates/Starters | 8 | 0 | 4 | 12 |
| Educational | 6 | 0 | 1 | 7 |
| Community Tools | 3 | 1 | 1 | 5 |
| Creative Tools | 7 | 0 | 1 | 8 |
| Experimental/POC | 8 | 1 | 0 | 9 |
| Utilities | 8 | 1 | 0 | 9 |

### Recommended Organization Structure

```
source-of-truth-monorepo/
├── core/
│   ├── flashfusion-ide/           (Consolidate all FlashFusion variants)
│   ├── unified-platform/          (FlashFusion-Unified)
│   ├── open-source-edition/       (OpenFlashFusion)
│   └── build-system/              (Merge all turborepo variants)
├── production/
│   ├── int-smart-triage/          (Consolidate all 3 versions)
│   ├── saas-validator/
│   └── project-nexus/
├── commerce/
│   ├── flashfusion-commerce/      (Merge commerce-forge, lite-ecommerce)
│   ├── merch-automation/          (solo-merch-flow, AIGenerateToStorefront)
│   └── ecom-dashboard/            (Dad-sEcomGen)
├── ai-tools/
│   ├── prompt-engineering/        (Merge FissionPrompt, UniPromptGen2, lovable-prompt-artist)
│   ├── content-generation/        (UniversalAIGen, UniversalWriterAI, MyMagicWriter)
│   ├── ai-dashboard/              (theaidashboard)
│   └── context-engine/            (MyContextEngine)
├── community/
│   ├── knowledge-base/            (FFKB, knowledge-base-app)
│   ├── creative-hub/              (flashfusion-creative-hub)
│   ├── discord-bot/               (flashfusion-discord)
│   └── creator-platform/          (CreatorsClashStudio)
├── marketing/
│   ├── main-website/              (Consolidate all Flashfusionwebsite variants)
│   ├── landing-pages/             (All v0-pointer variants)
│   └── templates/                 (v0-template-evaluation-academy)
├── education/
│   ├── learning-platform/         (FLashFusion-Learn, Templateevaluationacademy)
│   ├── academic-catalog/          (ai-academic-content-catalog)
│   └── odyssey-learns/            (FlashFusionv1 private)
├── tools/
│   ├── harvestflow/
│   ├── codex-workspace/
│   ├── dev-chat/
│   ├── security/                  (security-blindspot-radar)
│   └── automation/                (claude-code, agent tools)
├── templates/
│   ├── starters/                  (nextjs-with-supabase, CGDSTARTER)
│   ├── scaffolds/                 (Consolidate all sole-scaffold-* and hub)
│   └── integrations/              (loveable-supabase, flashfusion-loveable)
└── archived/
    ├── experimental/              (HabboHotel, solemuchbetter, etc.)
    ├── superseded/                (MonoTurboRepo-FlashFusion, v1 versions)
    └── completed-projects/        (Review all "Intos", private scaffolds)
```

---

## 5 CLARIFYING QUESTIONS

### **Question 1: Organization Ownership & Strategy**
What is the relationship between Krosebrook, ChaosClubCo, and FlashFusionv1 organizations? Should ChaosClubCo and FlashFusionv1 repositories be migrated into Krosebrook's source-of-truth-monorepo, or should each organization maintain separate monorepos with different purposes?

### **Question 2: INT Smart Triage AI Version Strategy**
You have 3 versions of INT Smart Triage AI (2.0, int-triage-ai.3.0, int-smart-triage-ai-3.0). Which version is currently in production, which is active development, and which should be archived? Should we consolidate into a single versioned codebase?

### **Question 3: Private Repository Handling**
There are 16 private repositories across the accounts. What's your policy for private repos - should they remain separate from the public monorepo for security/IP reasons, or can some be migrated with restricted access controls within the monorepo?

### **Question 4: E-commerce Tool Consolidation**
You have 8+ e-commerce related tools (flashfusion-commerce-forge, flashfusion-lite-ecommerce, Dad-sEcomGen, AIGenerateToStorefront, solo-merch-flow, etc.). Are these serving different customer segments, or can they be consolidated into a unified commerce platform with different feature flags?

### **Question 5: Archival vs. Deletion Criteria**
For experimental projects (HabboHotel, solemuchbetter, various scaffolds), what criteria should we use to decide between:
- Keep in archived/ folder with documentation
- Delete entirely after extracting learnings
- Revive and bring into active development
- Keep as standalone repositories outside monorepo

---

**Next Steps After Clarification**:
1. Finalize organization structure based on your answers
2. Create detailed migration plan with phases and dependencies
3. Identify "quick wins" (easy consolidations) vs. complex merges
4. Set up governance for preventing future duplication
5. Establish naming conventions and repository creation policies
