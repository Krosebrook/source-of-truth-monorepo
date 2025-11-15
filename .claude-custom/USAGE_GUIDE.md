# Usage Guide

## How Skills and Agents Work

### Skills (Automatic, On-Demand)

Skills are **automatically loaded** by Claude when relevant to your request. You don't invoke them directly.

**How it works:**
1. You make a request
2. Claude scans available skills by reading name/description
3. If relevant, Claude loads the full skill content
4. Claude uses the skill as reference documentation

**Example:**
```
You: "Set up a new Turborepo monorepo"

Behind the scenes:
- Claude sees "Turborepo" and scans skills
- Finds "Turbo Monorepo Expert" skill
- Loads the skill content
- Uses it as reference to help you
```

### Agents (Explicit Invocation)

Agents are **automatically invoked** by Claude based on task requirements, or you can invoke them explicitly.

**How it works:**
1. Claude analyzes your request
2. Matches request to agent descriptions
3. Invokes appropriate agent(s)
4. Agent completes task using its skills

**Example:**
```
You: "Build a user authentication system with Next.js"

Behind the scenes:
- Claude matches this to fullstack-developer agent
- Invokes agent automatically
- Agent uses Next.js + FastAPI skill
- Returns implementation
```

---

## Real-World Usage Scenarios

### Scenario 1: Monorepo Setup

**Your Request:**
```
"I need to set up a new Turborepo monorepo with these packages:
- apps/web (Next.js)
- apps/api (FastAPI)
- packages/ui (React component library)
- packages/utils (shared utilities)

Configure it for optimal build performance."
```

**What Happens:**
1. Claude invokes **monorepo-architect** agent
2. Agent loads **Turbo Monorepo Expert** skill
3. Agent creates:
   - Project structure
   - turbo.json configuration
   - pnpm-workspace.yaml
   - Root package.json
   - Individual package configurations
   - CI/CD setup

**Expected Output:**
- Complete project structure
- Optimized turbo.json with caching
- pnpm workspace configuration
- Package templates
- Build scripts
- Documentation

---

### Scenario 2: AI Agent Development

**Your Request:**
```
"Build a research agent that:
1. Searches academic papers via Semantic Scholar API
2. Summarizes findings
3. Stores results in ChromaDB vector database
4. Provides citations

Use Pydantic AI framework."
```

**What Happens:**
1. Claude invokes **ai-orchestrator** agent
2. Agent loads:
   - **Pydantic AI Agent Builder** skill
   - **MCP Server Generator** skill (for API integration)
3. Agent creates:
   - Pydantic AI agent with tools
   - Semantic Scholar API integration
   - ChromaDB vector storage
   - Summarization logic
   - Citation formatting

**Expected Output:**
- Complete Pydantic AI agent code
- API integration functions
- Vector database setup
- Test suite
- Usage documentation

---

### Scenario 3: Microservices Architecture

**Your Request:**
```
"Design a microservices architecture for our e-commerce platform:
- User Service
- Product Service
- Order Service
- Payment Service
- Notification Service

Include API Gateway, message queue, and deployment configs."
```

**What Happens:**
1. Claude invokes **microservices-engineer** agent
2. Agent loads:
   - **Docker & Kubernetes Orchestrator** skill
   - **Next.js + FastAPI Full-Stack** skill (for service implementation)
3. Agent creates:
   - Architecture diagram
   - Service definitions
   - Docker Compose configuration
   - Kubernetes manifests
   - API Gateway setup
   - Message queue configuration

**Expected Output:**
- System architecture design
- Dockerfiles for each service
- docker-compose.yml
- Kubernetes deployment YAMLs
- API Gateway configuration
- Inter-service communication patterns

---

### Scenario 4: Full-Stack Feature

**Your Request:**
```
"Implement a real-time chat feature:
- Next.js frontend with typing indicators
- FastAPI backend with WebSocket support
- Store messages in PostgreSQL
- Add user authentication
- Implement read receipts"
```

**What Happens:**
1. Claude invokes **fullstack-developer** agent
2. Agent loads:
   - **Next.js + FastAPI Full-Stack** skill
   - **TypeScript Type Safety** skill
3. Potentially invokes **testing-specialist** for tests
4. Agent creates:
   - WebSocket server in FastAPI
   - React chat components
   - PostgreSQL schema
   - Authentication middleware
   - Real-time state management

**Expected Output:**
- Complete backend implementation
- Frontend components
- Database migrations
- WebSocket connection handling
- Authentication integration
- Tests

---

### Scenario 5: Cloud Deployment

**Your Request:**
```
"Deploy our Next.js app to AWS:
- Static assets on S3 + CloudFront
- API routes on Lambda
- PostgreSQL on RDS
- Set up CI/CD with GitHub Actions
- Add monitoring"
```

**What Happens:**
1. Claude invokes **cloud-deployer** agent
2. Agent loads:
   - **AWS & Azure Multi-Cloud** skill
   - **Docker & Kubernetes** skill (for containers)
3. Agent creates:
   - AWS CDK infrastructure code
   - GitHub Actions workflow
   - CloudFormation/CDK stack
   - Monitoring setup

**Expected Output:**
- Complete CDK/Terraform code
- S3 bucket configuration
- CloudFront distribution
- Lambda functions
- RDS setup
- GitHub Actions workflow
- Monitoring dashboards

---

### Scenario 6: ERP Feature Implementation

**Your Request:**
```
"Implement an order-to-cash workflow:
1. Sales order creation
2. Credit check
3. Inventory reservation
4. Shipment creation
5. Invoice generation
6. Payment recording

Include approval workflows for orders over $10,000."
```

**What Happens:**
1. Claude invokes **erp-consultant** agent
2. Agent loads **Enterprise ERP Consultant** skill
3. Agent creates:
   - Domain models
   - State machine for workflow
   - Approval workflow engine
   - Database schema
   - Business validation rules
   - Accounting entries

**Expected Output:**
- Complete workflow implementation
- Database schemas
- State transition logic
- Approval workflow
- Journal entry creation
- Audit trail implementation

---

## Agent Collaboration Examples

### Multi-Agent Workflow

**Your Request:**
```
"Build, test, and deploy a new payment processing microservice"
```

**Agent Flow:**
1. **api-designer** → Designs API contracts
2. **fullstack-developer** → Implements service code
3. **testing-specialist** → Creates test suite
4. **microservices-engineer** → Containerizes with Docker
5. **cloud-deployer** → Deploys to AWS
6. **monitoring setup** → Adds CloudWatch alarms

**Result:**
- Fully designed, implemented, tested, and deployed service

---

## Explicit Agent Invocation

If you want to invoke a specific agent:

```
"Use the ai-orchestrator agent to build a RAG system"
"Invoke monorepo-architect to optimize our build pipeline"
"Have the testing-specialist review our test coverage"
```

---

## Skill Usage Tips

### Skills Load Automatically

You don't need to "activate" skills. Just mention relevant topics:

```
✅ "How do I configure turbo.json for optimal caching?"
   → Loads Turbo Monorepo Expert skill

✅ "Show me how to create an MCP server in TypeScript"
   → Loads MCP Server Generator skill

✅ "What's the best way to implement branded types in TypeScript?"
   → Loads TypeScript Type Safety skill
```

### Combine Multiple Skills

```
"Set up a monorepo with:
- Turborepo for builds (Turbo Monorepo skill)
- Next.js + FastAPI apps (Full-Stack skill)
- Docker deployment (Docker & K8s skill)
- CI/CD on AWS (AWS & Azure skill)"
```

Claude will load multiple relevant skills and combine their knowledge.

---

## Agent Usage Tips

### Be Specific About Requirements

```
❌ "Build something for users"
✅ "Build a user authentication system with JWT tokens, refresh tokens, and role-based access control"
```

### Mention Your Stack

```
❌ "Create a web app"
✅ "Create a Next.js 14 app with FastAPI backend, PostgreSQL database, and Docker deployment"
```

### Request Complete Solutions

```
❌ "Write some code"
✅ "Implement the complete feature including code, tests, documentation, and deployment config"
```

---

## Common Patterns

### Pattern 1: New Project Setup

```
"Set up a new full-stack project:
- Turborepo monorepo structure
- Next.js 14 frontend
- FastAPI backend
- PostgreSQL database
- Docker Compose for local dev
- AWS deployment configuration
- CI/CD pipeline"
```

**Agents Involved:**
- monorepo-architect
- fullstack-developer
- microservices-engineer
- cloud-deployer

---

### Pattern 2: Add Feature to Existing Project

```
"Add a real-time notifications feature to our existing app:
- WebSocket support
- Push notifications
- Email notifications
- In-app notification center
- Include tests"
```

**Agents Involved:**
- fullstack-developer (main implementation)
- testing-specialist (test suite)

---

### Pattern 3: Optimize Existing System

```
"Optimize our monorepo build pipeline:
- Currently takes 10 minutes
- Need to reduce to under 3 minutes
- Configure remote caching
- Optimize dependency graph"
```

**Agents Involved:**
- monorepo-architect

---

### Pattern 4: Infrastructure Migration

```
"Migrate our app from Heroku to AWS:
- Currently using Heroku Postgres
- Move to AWS with ECS Fargate
- Set up RDS for database
- Configure auto-scaling
- Maintain zero downtime"
```

**Agents Involved:**
- cloud-deployer
- microservices-engineer

---

## Best Practices

### ✅ DO

- Be specific about your requirements
- Mention your tech stack explicitly
- Request complete solutions (code + tests + docs)
- Ask for best practices and patterns
- Request architecture diagrams when relevant

### ❌ DON'T

- Be vague ("build something")
- Assume Claude knows your exact stack
- Request only code without tests
- Skip documentation
- Forget to mention deployment requirements

---

## Troubleshooting

### Skills Not Being Used

**Problem:** Claude doesn't seem to use your skills

**Solution:**
1. Mention relevant keywords explicitly
2. Verify skills are installed: `ls ~/.claude/skills/`
3. Restart Claude Code
4. Be more specific in your request

---

### Agents Not Being Invoked

**Problem:** Wrong agent or no agent invoked

**Solution:**
1. Be more explicit: "Use the [agent-name] agent to..."
2. Check agent descriptions match your request
3. Verify agents installed: `ls ~/.claude/agents/`
4. Use clearer language about the task type

---

### Getting Generic Responses

**Problem:** Responses aren't using your custom content

**Solution:**
1. Be more specific about your tech stack
2. Mention frameworks/tools explicitly
3. Request "use the [skill-name] skill as reference"
4. Verify installation is correct

---

## Advanced Usage

### Chaining Agents

```
"First, have the api-designer create API specs,
then have the fullstack-developer implement them,
then have the testing-specialist add tests,
finally have the cloud-deployer set up AWS infrastructure"
```

### Requesting Specific Patterns

```
"Use the event-driven architecture pattern from the microservices-engineer
skill to design a distributed order processing system"
```

### Combining Skills Explicitly

```
"Reference both the Turbo Monorepo Expert and Git Advanced Workflow skills
to set up our monorepo with trunk-based development"
```

---

**Ready to use your custom skills and agents!** Start with simple requests and gradually explore more complex scenarios.
