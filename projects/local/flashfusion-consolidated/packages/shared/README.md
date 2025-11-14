# FlashFusion Unified

## Overview

FlashFusion Unified is an AI-powered business operating system designed to transform ideas into automated revenue streams. It leverages multi-agent workflows and advanced AI capabilities (via Anthropic and OpenAI) to streamline business operations and drive automation.

This project is structured as a monorepo, encompassing a backend API, a frontend client application, and serverless functions.

## Technology Stack

### Backend

- **Language**: JavaScript/TypeScript
- **Framework**: Express.js
- **Database/Auth**: Firebase, Supabase
- **AI Integrations**: Anthropic AI SDK, OpenAI API
- **Task Queue**: Bull (Redis-backed)
- **Logging**: Winston
- **Other**: `axios`, `bcryptjs`, `compression`, `cors`, `dotenv`, `helmet`, `ioredis`, `joi`, `jsonwebtoken`, `lodash`, `morgan`, `multer`, `node-cron`, `playwright`, `uuid`, `ws`, `zod`.

### Frontend

- **Language**: TypeScript
- **Framework**: Likely React/Next.js (based on project structure and `next.config.js`, `next-env.d.ts` files)
- **Styling**: Tailwind CSS

### Serverless Functions

- **Language**: TypeScript
- **Platform**: Firebase Functions

### Development Tools

- **Package Manager**: npm
- **Monorepo Management**: Standard npm workspaces (implied by `cd` commands in scripts, not explicit Turborepo)
- **Linting**: ESLint
- **Formatting**: Prettier
- **Testing**: Jest, Supertest
- **Development Server**: Nodemon, Concurrently
- **Type Checking**: TypeScript

### Deployment

- **Frontend**: Vercel
- **Functions**: Firebase
- **Containerization**: Docker (implied by `Dockerfile`, `docker-compose.yml`)

## Project Structure

This project is organized as a monorepo with the following key directories:

- `api/`: Contains the main backend Express.js application.
- `client/`: Houses the frontend client application (likely Next.js).
- `functions/`: Contains Firebase serverless functions.
- `src/`: Core shared logic, agents, orchestration, and middleware.
- `tests/`: Unit and integration tests for various components.
- `scripts/`: Utility scripts for setup, validation, and testing.
- `database/`: Database-related configurations or migrations.
- `docs/`: (To be created) For additional documentation.
