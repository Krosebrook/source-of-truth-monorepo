# SDK Integration Guide (Q4 2025)

**Version:** 1.0
**Last Updated:** November 2, 2025
**Owner:** Engineering Team
**Status:** Active

## Overview

This guide provides comprehensive integration patterns for Claude SDKs, Model Context Protocol (MCP), and AI agent frameworks. Use this guide to accelerate development while maintaining security, compliance, and operational best practices.

---

## Table of Contents

1. [Claude Official SDKs](#claude-official-sdks)
2. [Model Context Protocol (MCP)](#model-context-protocol-mcp)
3. [LangChain Integration](#langchain-integration)
4. [LlamaIndex Integration](#llamaindex-integration)
5. [Agent Frameworks Comparison](#agent-frameworks-comparison)
6. [Common Patterns](#common-patterns)
7. [Troubleshooting](#troubleshooting)

---

## Claude Official SDKs

### Python SDK

**Package:** `anthropic` (https://github.com/anthropics/anthropic-sdk-python)

#### Installation
```bash
pip install anthropic
```

#### Basic Usage
```python
import anthropic

client = anthropic.Anthropic(api_key="your-api-key")

message = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Explain quantum computing in simple terms"}
    ]
)

print(message.content)
```

#### Extended Thinking Configuration
```python
message = client.messages.create(
    model="claude-opus-4-20250514",
    max_tokens=4096,
    extended_thinking=True,
    budget_tokens=16000,  # Optimal range: 8K-32K
    messages=[
        {"role": "user", "content": "Design a distributed system architecture for..."}
    ],
    extra_headers={
        "anthropic-beta": "interleaved-thinking-2025-05-14"  # For interleaved thinking with tools
    }
)
```

#### Parallel Tool Execution
```python
tools = [
    {
        "name": "get_weather",
        "description": "Get weather for a location",
        "input_schema": {
            "type": "object",
            "properties": {
                "location": {"type": "string"}
            }
        }
    }
]

message = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=1024,
    tools=tools,
    messages=[{"role": "user", "content": "What's the weather in NYC and SF?"}]
)
# Claude will call both tools in parallel automatically
```

---

### TypeScript/JavaScript SDK

**Package:** `@anthropic-ai/sdk` (npm)

#### Installation
```bash
npm install @anthropic-ai/sdk
```

#### Basic Usage
```typescript
import Anthropic from '@anthropic-ai/sdk';

const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

const message = await client.messages.create({
  model: 'claude-sonnet-4-5-20250929',
  max_tokens: 1024,
  messages: [
    { role: 'user', content: 'Explain quantum computing' }
  ]
});

console.log(message.content);
```

#### Computer Use Tool (Beta)
```typescript
const message = await client.messages.create({
  model: 'claude-sonnet-4-5-20250929',
  max_tokens: 1024,
  tools: [{
    type: 'computer_20250124',
    name: 'computer',
    display_width_px: 1920,
    display_height_px: 1080
  }],
  messages: [
    { role: 'user', content: 'Open browser and navigate to example.com' }
  ],
  extra_headers: {
    'anthropic-beta': 'computer-use-2025-01-24'
  }
});
```

---

### Java SDK (Beta)

**Status:** Moved from Alpha to Beta in 2025
**Repository:** Check Anthropic official documentation

#### Installation (Maven)
```xml
<dependency>
    <groupId>com.anthropic</groupId>
    <artifactId>anthropic-sdk</artifactId>
    <version>1.0.0-beta</version>
</dependency>
```

---

### PHP SDK (Beta)

**Status:** Newly launched in Beta (2025)
**Repository:** Check Anthropic official documentation

---

## Model Context Protocol (MCP)

### Overview
MCP is the universal standard for connecting AI assistants to data sources. Adopted by Anthropic (2024), OpenAI (March 2025), and Google (April 2025).

### Architecture
- **MCP Servers:** Expose data sources, APIs, tools
- **MCP Clients:** AI applications (Claude, ChatGPT, etc.)
- **Protocol:** Single integration point replaces fragmented adapters

### Python MCP Server Example

#### Installation
```bash
pip install mcp
```

#### Basic Server
```python
from mcp.server import Server
from mcp.server.stdio import stdio_server

server = Server("example-server")

@server.list_resources()
async def list_resources():
    return [
        {
            "uri": "file:///data/users.json",
            "name": "Users Database",
            "mimeType": "application/json"
        }
    ]

@server.read_resource()
async def read_resource(uri: str):
    if uri == "file:///data/users.json":
        return {
            "contents": [
                {
                    "uri": uri,
                    "mimeType": "application/json",
                    "text": json.dumps(load_users())
                }
            ]
        }

if __name__ == "__main__":
    stdio_server(server)
```

#### Register Server with Claude Desktop
Add to `claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "example-server": {
      "command": "python",
      "args": ["path/to/server.py"]
    }
  }
}
```

### TypeScript MCP Server Example

#### Installation
```bash
npm install @modelcontextprotocol/sdk
```

#### Basic Server
```typescript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

const server = new Server({
  name: 'example-server',
  version: '1.0.0'
}, {
  capabilities: {
    resources: {}
  }
});

server.setRequestHandler('resources/list', async () => {
  return {
    resources: [
      {
        uri: 'file:///data/users.json',
        name: 'Users Database',
        mimeType: 'application/json'
      }
    ]
  };
});

const transport = new StdioServerTransport();
await server.connect(transport);
```

### Pre-built MCP Servers
Use production-ready servers for common integrations:

| Server | Purpose | Package |
|--------|---------|---------|
| **GitHub** | Repository access, issues, PRs | `@modelcontextprotocol/server-github` |
| **Google Drive** | Workspace documents | `@modelcontextprotocol/server-gdrive` |
| **Slack** | Channels, messages, search | `@modelcontextprotocol/server-slack` |
| **Postgres** | Database queries | `@modelcontextprotocol/server-postgres` |
| **Puppeteer** | Browser automation | `@modelcontextprotocol/server-puppeteer` |

#### Installation Example
```bash
npm install @modelcontextprotocol/server-github
```

---

## LangChain Integration

**Package:** `langchain-anthropic` (Python), `@langchain/anthropic` (TypeScript)
**Best For:** Rapid agent prototyping, RAG systems

### Python Integration

#### Installation
```bash
pip install langchain-anthropic langchain
```

#### Basic Chat Model
```python
from langchain_anthropic import ChatAnthropic
from langchain_core.messages import HumanMessage, SystemMessage

model = ChatAnthropic(
    model="claude-sonnet-4-5-20250929",
    api_key="your-api-key",
    max_tokens=1024
)

messages = [
    SystemMessage(content="You are a helpful AI assistant"),
    HumanMessage(content="What is machine learning?")
]

response = model.invoke(messages)
print(response.content)
```

#### RAG Pipeline Example
```python
from langchain_anthropic import ChatAnthropic
from langchain.chains import RetrievalQA
from langchain.vectorstores import FAISS
from langchain.embeddings import OpenAIEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter

# Load and split documents
documents = load_documents()
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000)
docs = text_splitter.split_documents(documents)

# Create vector store
embeddings = OpenAIEmbeddings()
vectorstore = FAISS.from_documents(docs, embeddings)

# Create QA chain
llm = ChatAnthropic(model="claude-sonnet-4-5-20250929")
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    retriever=vectorstore.as_retriever(),
    return_source_documents=True
)

result = qa_chain("What are the main points in the documentation?")
```

#### Agent with Tools
```python
from langchain.agents import initialize_agent, Tool
from langchain_anthropic import ChatAnthropic

tools = [
    Tool(
        name="Calculator",
        func=lambda x: eval(x),
        description="Useful for mathematical calculations"
    )
]

llm = ChatAnthropic(model="claude-sonnet-4-5-20250929")
agent = initialize_agent(
    tools,
    llm,
    agent="zero-shot-react-description",
    verbose=True
)

result = agent.run("What is 15 * 23 + 47?")
```

### Best Practices
1. **System Messages First:** Always place system messages before user messages (Anthropic requirement)
2. **Context Quality > Quantity:** Use dynamic editing and efficient memory management
3. **Tool Selection:** Use LangChain for quick builds; LangGraph for advanced deterministic + agentic workflows

---

## LlamaIndex Integration

**Package:** `llama-index-llms-anthropic`
**Best For:** Advanced RAG, multi-modal processing, structured output

### Installation
```bash
pip install llama-index-llms-anthropic llama-index-core
```

### Basic Usage
```python
from llama_index.llms.anthropic import Anthropic

llm = Anthropic(
    model="claude-sonnet-4-5-20250929",
    api_key="your-api-key"
)

response = llm.complete("Explain quantum computing")
print(response.text)
```

### RAG with Citable Tool Results
Requires: `llama-index-core >= 0.12.46`, `llama-index-llms-anthropic >= 0.7.6`

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.llms.anthropic import Anthropic
from llama_index.core.node_parser import SentenceSplitter

# Load documents
documents = SimpleDirectoryReader("./data").load_data()

# Configure LLM
llm = Anthropic(
    model="claude-sonnet-4-5-20250929",
    api_key="your-api-key"
)

# Create index
text_splitter = SentenceSplitter(chunk_size=1024)
index = VectorStoreIndex.from_documents(
    documents,
    transformations=[text_splitter]
)

# Query with citations
query_engine = index.as_query_engine(llm=llm, response_mode="tree_summarize")
response = query_engine.query("What are the key findings?")

# Access source citations
print(response.response)
for source in response.source_nodes:
    print(f"Source: {source.node.metadata['file_name']}, Score: {source.score}")
```

### Server-Side Tool Calling with Web Search
```python
from llama_index.llms.anthropic import Anthropic

llm = Anthropic(
    model="claude-sonnet-4-5-20250929",
    tools=["web_search_20250305"]  # Anthropic server-side tool
)

response = llm.complete("What are the latest developments in quantum computing?")
print(response.text)
```

---

## Agent Frameworks Comparison

### Visual/Low-Code Platforms

| Framework | Best For | Key Features | Learning Curve |
|-----------|----------|--------------|----------------|
| **n8n** | Workflow automation | Visual editor, 400+ integrations | Low |
| **Flowise** | RAG pipelines | Drag-and-drop, LangChain wrapper | Low |
| **Zapier Agents** | Business automation | Pre-built connectors, no code | Very Low |

### Code-First SDKs

| Framework | Best For | Key Features | Learning Curve |
|-----------|----------|--------------|----------------|
| **LangGraph** | Complex agentic workflows | State machines, deterministic execution | Medium |
| **CrewAI** | Multi-agent collaboration | Role-based agents, task delegation | Medium |
| **OpenAI Agents SDK** | OpenAI ecosystem | Native function calling, async support | Medium |
| **MS Semantic Kernel** | Enterprise .NET/Python | Plugin architecture, enterprise features | Medium-High |

### Enterprise Infrastructure

| Platform | Best For | Key Features | Learning Curve |
|----------|----------|--------------|----------------|
| **AWS Bedrock Agents** | AWS-native deployments | Managed infrastructure, IAM integration | Medium |
| **Vertex AI Agent Builder** | GCP environments | BigQuery integration, Google Cloud AI | Medium |
| **Azure AI Agent Service** | Microsoft ecosystem | Azure integration, governance tools | Medium |

### Selection Matrix

```
┌─────────────────────┬──────────────┬─────────────────┬──────────────┐
│ Use Case            │ Recommended  │ Alternative     │ Avoid        │
├─────────────────────┼──────────────┼─────────────────┼──────────────┤
│ Quick prototype     │ LangChain    │ LlamaIndex      │ Custom       │
│ Production RAG      │ LlamaIndex   │ LangChain       │ Visual tools │
│ Complex state mgmt  │ LangGraph    │ Semantic Kernel │ n8n          │
│ Multi-agent system  │ CrewAI       │ LangGraph       │ Zapier       │
│ Business automation │ Zapier       │ n8n             │ Custom       │
│ Enterprise AWS      │ Bedrock      │ LangGraph       │ OpenAI SDK   │
└─────────────────────┴──────────────┴─────────────────┴──────────────┘
```

---

## Common Patterns

### Pattern 1: Retry with Exponential Backoff
```python
import time
from anthropic import Anthropic, APIError

def call_claude_with_retry(client, max_retries=3):
    for attempt in range(max_retries):
        try:
            return client.messages.create(
                model="claude-sonnet-4-5-20250929",
                max_tokens=1024,
                messages=[{"role": "user", "content": "Hello"}]
            )
        except APIError as e:
            if attempt == max_retries - 1:
                raise
            wait_time = 2 ** attempt
            print(f"Retry {attempt + 1} after {wait_time}s")
            time.sleep(wait_time)
```

### Pattern 2: Prompt Caching (Cost Optimization)
```python
message = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=1024,
    system=[
        {
            "type": "text",
            "text": "Large system prompt here...",
            "cache_control": {"type": "ephemeral"}  # Cache this
        }
    ],
    messages=[{"role": "user", "content": "Question"}]
)
# Subsequent calls within 1 hour will use cached system prompt
```

### Pattern 3: Streaming Responses
```python
with client.messages.stream(
    model="claude-sonnet-4-5-20250929",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Write a story"}]
) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)
```

### Pattern 4: Structured Output Parsing
```python
from pydantic import BaseModel

class Person(BaseModel):
    name: str
    age: int
    occupation: str

response = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=1024,
    messages=[{
        "role": "user",
        "content": "Extract person info: John is 30 and works as an engineer"
    }],
    tools=[{
        "name": "extract_person",
        "description": "Extract person information",
        "input_schema": Person.schema()
    }],
    tool_choice={"type": "tool", "name": "extract_person"}
)
```

---

## Troubleshooting

### Issue: Rate Limiting

**Symptoms:** `RateLimitError` exceptions

**Solutions:**
1. Implement exponential backoff (see Pattern 1)
2. Request rate limit increase: https://console.anthropic.com/settings/limits
3. Use prompt caching to reduce token usage
4. Batch requests when possible

### Issue: Context Window Exceeded

**Symptoms:** `ContextWindowExceededError`

**Solutions:**
1. Use prompt caching for large system prompts
2. Implement sliding window context management
3. Summarize conversation history periodically
4. Switch to extended output mode for Sonnet 3.7 (128K output)

### Issue: MCP Server Not Connecting

**Symptoms:** Claude Desktop doesn't see MCP server

**Solutions:**
1. Check `claude_desktop_config.json` syntax
2. Verify server script path is absolute
3. Test server standalone: `python server.py` (should not error)
4. Check Claude Desktop logs: `~/Library/Logs/Claude/` (macOS)

### Issue: Tool Calls Not Working

**Symptoms:** Claude doesn't use provided tools

**Solutions:**
1. Verify tool schema matches JSON Schema spec
2. Add clear tool descriptions with examples
3. Explicitly prompt Claude to use tools: "Use the get_weather tool to..."
4. Check tool_choice parameter: `{"type": "auto"}` or `{"type": "any"}`

### Issue: Prompt Injection Detected

**Symptoms:** Azure Prompt Shields / AWS Guardrails blocking requests

**Solutions:**
1. Review input for malicious patterns
2. Sanitize user input before submission
3. Use parameterized prompts (see CLAUDE.md Prompt Injection Defense section)
4. Adjust sensitivity thresholds in shield configuration
5. Whitelist false positives

---

## Additional Resources

### Official Documentation
- Claude API Docs: https://docs.anthropic.com/
- MCP Specification: https://modelcontextprotocol.io/
- LangChain Anthropic: https://python.langchain.com/docs/integrations/providers/anthropic/
- LlamaIndex Anthropic: https://docs.llamaindex.ai/en/stable/examples/llm/anthropic/

### Community Resources
- Anthropic Cookbook: https://github.com/anthropics/anthropic-cookbook
- MCP Servers Repository: https://github.com/modelcontextprotocol/servers
- LangChain Templates: https://github.com/langchain-ai/langchain/tree/master/templates

### Internal Documentation
- CLAUDE.md: Claude operations charter, model matrix, compliance
- AGENTS.md: Multi-agent playbook, governance, orchestration patterns
- EU_AI_ACT_AUGUST_2025_CHECKLIST.md: Compliance checklist

---

**Maintained by:** Engineering Team
**Questions:** Contact #ai-engineering Slack channel
**Last Review:** November 2, 2025
