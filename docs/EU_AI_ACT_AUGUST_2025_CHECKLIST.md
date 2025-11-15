# EU AI Act Compliance Checklist (August 2, 2025 Deadline)

**Version:** 1.0
**Last Updated:** November 2, 2025
**Deadline:** August 2, 2025 (ACTIVE NOW)
**Owner:** Compliance & Legal Team
**Status:** MANDATORY

---

## ⚠️ CRITICAL NOTICE

**As of August 2, 2025, General Purpose AI (GPAI) model governance obligations are ACTIVE and MANDATORY.**

Organizations deploying GPAI systems MUST comply immediately or face penalties up to **7% of worldwide annual revenue**.

---

## Table of Contents

1. [Regulatory Timeline](#regulatory-timeline)
2. [Pre-Compliance Assessment](#pre-compliance-assessment)
3. [GPAI Obligations Checklist (August 2025)](#gpai-obligations-checklist-august-2025)
4. [Model Card Requirements](#model-card-requirements)
5. [High-Risk System Preparation (August 2026)](#high-risk-system-preparation-august-2026)
6. [Documentation Templates](#documentation-templates)
7. [Audit & Verification](#audit--verification)

---

## Regulatory Timeline

### Active Deadlines

| Date | Requirement | Status | Scope |
|------|-------------|--------|-------|
| **February 2, 2025** | Unacceptable risk AI systems banned; employee training mandatory | ✅ ACTIVE | All AI systems |
| **August 2, 2025** | GPAI model governance obligations | 🔴 ACTIVE NOW | GPAI providers & deployers |
| **August 2, 2026** | High-risk AI system requirements | ⏳ Upcoming | Biometrics, critical infrastructure, employment, law enforcement |
| **August 2, 2027** | High-risk AI in regulated products (extended transition) | ⏳ Future | Medical devices, transportation, etc. |

---

## Pre-Compliance Assessment

### Step 1: Classify Your AI Systems

Determine which category each AI system falls under:

#### ❌ Unacceptable Risk (BANNED as of Feb 2, 2025)
- [ ] Social scoring systems
- [ ] Real-time biometric identification in public spaces (law enforcement exceptions exist)
- [ ] Manipulation of vulnerable groups
- [ ] Subliminal techniques causing harm
- [ ] Indiscriminate scraping of facial images

**Action:** Immediately discontinue if deployed.

#### 🔴 High-Risk AI Systems (August 2026)
- [ ] Biometric identification systems
- [ ] Critical infrastructure management
- [ ] Educational/vocational training decisions
- [ ] Employment, worker management, self-employment access
- [ ] Access to essential services (credit scoring, insurance)
- [ ] Law enforcement (predictive policing, evidence evaluation, etc.)
- [ ] Migration, asylum, border control
- [ ] Administration of justice

**Action:** Prepare for August 2026 compliance requirements.

#### 🟡 Limited-Risk AI (Transparency Requirements)
- [ ] Chatbots and conversational agents
- [ ] Emotion recognition systems
- [ ] Deep fakes and synthetic content generation
- [ ] AI-generated content (text, images, video, audio)

**Action:** Implement transparency measures and user disclosure.

#### 🟢 Minimal Risk (No Additional Requirements)
- [ ] AI-enabled video games
- [ ] Spam filters
- [ ] Recommendation systems (non-critical)

**Action:** Continue monitoring; maintain basic documentation.

#### 🔵 General Purpose AI (GPAI) – August 2025 ACTIVE
- [ ] Foundation models (LLMs like GPT, Claude, Gemini, etc.)
- [ ] Multi-modal models
- [ ] Models adaptable to wide range of tasks
- [ ] Models integrated into products/services

**Action:** IMMEDIATE compliance required with checklist below.

---

## GPAI Obligations Checklist (August 2025)

### 1. Technical Documentation (Private "Black-Box" Dossier)

**Status:** ⬜ Not Started | ⬜ In Progress | ⬜ Complete

#### Required Contents:
- [ ] **Model Architecture:**
  - Model type (transformer, CNN, hybrid, etc.)
  - Number of parameters
  - Layer configuration
  - Attention mechanisms used

- [ ] **Training Procedure:**
  - Training dataset description (sources, size, composition)
  - Data preprocessing and augmentation techniques
  - Training duration and compute resources
  - Hyperparameters (learning rate, batch size, optimization algorithm)
  - Training stability measures and checkpoints

- [ ] **Data Sources:**
  - Complete list of training data sources
  - Data collection methodology
  - Data quality assurance processes
  - Data filtering and curation procedures

- [ ] **Validation Methods:**
  - Evaluation datasets and benchmarks
  - Performance metrics (accuracy, F1, perplexity, etc.)
  - Validation protocols and frequency
  - A/B testing results (if applicable)

- [ ] **Testing Results:**
  - Functional testing outcomes
  - Safety and robustness testing
  - Bias and fairness evaluations
  - Edge case and failure mode analysis

**Storage:** Maintain in secure, immutable storage with access controls.

**Retention:** Minimum 10 years from deployment date.

---

### 2. Model Card Publication (Public Disclosure)

**Status:** ⬜ Not Started | ⬜ In Progress | ⬜ Complete

**Deadline:** Must be published BEFORE deployment and kept current.

#### Mandatory Fields:

##### A. Intended Uses
- [ ] **Primary Use Cases:**
  - List all intended applications
  - Specify target users and contexts
  - Define acceptable use boundaries

- [ ] **Explicit Limitations:**
  - Known failure modes
  - Contexts where model should NOT be used
  - Performance degradation scenarios
  - Language/domain constraints

##### B. Copyright Compliance
- [ ] **Copyrighted Training Material Summary:**
  - High-level description of copyrighted content used
  - Categories of copyrighted works (books, articles, code, etc.)
  - Percentage of training data that is copyrighted (estimate)
  - Licensing arrangements or permissions obtained

- [ ] **Copyright Policy:**
  - Organization's copyright compliance policy
  - Data provenance tracking procedures
  - Opt-out mechanisms (if available)

##### C. Energy Consumption
- [ ] **Training Energy Metrics:**
  - Total energy consumed during training (kWh)
  - Carbon footprint estimate (CO2e)
  - Hardware used (GPU/TPU type and count)
  - Training duration

- [ ] **Inference Energy Metrics:**
  - Energy per query/request (estimated)
  - Optimization techniques used
  - Efficiency improvements vs. baseline

##### D. Testing & Validation
- [ ] **Performance Benchmarks:**
  - Scores on standard benchmarks (MMLU, HumanEval, etc.)
  - Internal evaluation results
  - Comparison to previous versions

- [ ] **Safety Testing:**
  - Red team testing results
  - Jailbreak resistance evaluation
  - Harmful content generation testing
  - Bias and fairness metrics

##### E. Ethical Considerations
- [ ] **Known Biases:**
  - Demographic biases identified
  - Cultural or linguistic biases
  - Mitigation strategies implemented

- [ ] **Dual-Use Concerns:**
  - Potential misuse scenarios
  - Safeguards implemented
  - Monitoring and detection mechanisms

- [ ] **Human Oversight:**
  - Required human oversight for critical applications
  - Escalation procedures
  - Human-in-the-loop requirements

##### F. Machine-Readable Format
- [ ] **AI Cards Framework Compliance:**
  - Model card available in JSON/YAML format
  - Schema validation passed
  - Automated parsing supported

**Publication Channels:**
- [ ] Organization website (dedicated compliance page)
- [ ] Model repository (Hugging Face, GitHub, etc.)
- [ ] API documentation
- [ ] Customer-facing documentation

**Review Frequency:** Quarterly or after significant model updates.

---

### 3. Transparency Measures

**Status:** ⬜ Not Started | ⬜ In Progress | ⬜ Complete

- [ ] **Capability Documentation:**
  - Comprehensive list of model capabilities
  - Task performance ranges (accuracy, quality)
  - Supported languages and modalities
  - API rate limits and constraints

- [ ] **Failure Mode Documentation:**
  - Known failure patterns
  - Edge cases and limitations
  - Recovery and fallback procedures
  - User notification mechanisms

- [ ] **Safe Deployment Guidance:**
  - Recommended deployment architectures
  - Security best practices
  - Monitoring and alerting requirements
  - Incident response procedures

---

### 4. Audit Trail & Governance

**Status:** ⬜ Not Started | ⬜ In Progress | ⬜ Complete

- [ ] **Decision Log:**
  - All major design decisions documented
  - Risk assessments and trade-offs
  - Approval chains and sign-offs
  - Change history

- [ ] **Compliance Log (`compliance_log.json`):**
  - Automated logging of model usage
  - User consent records
  - Data processing events
  - Compliance checkpoint results

- [ ] **Version Control:**
  - Model versioning scheme
  - Changelog maintenance
  - Rollback procedures
  - Backwards compatibility matrix

---

## Model Card Requirements

### Model Card Template (JSON Schema)

```json
{
  "$schema": "https://ai-cards.org/schema/v1",
  "modelName": "YourModel-v1.0",
  "version": "1.0.0",
  "releaseDate": "2025-08-01",
  "provider": "Your Organization",

  "intendedUses": {
    "primaryUseCases": [
      "Customer service automation",
      "Content generation",
      "Code assistance"
    ],
    "limitations": [
      "Not suitable for medical diagnosis",
      "May generate biased content without oversight",
      "Performance degrades for languages other than English"
    ],
    "targetUsers": ["Enterprise developers", "Content creators"],
    "prohibitedUses": ["Medical advice", "Legal judgment", "Financial decisions"]
  },

  "copyrightCompliance": {
    "trainingDataSummary": "Mix of public domain, licensed, and copyrighted content",
    "copyrightedContentPercentage": "Estimated 40%",
    "licensingArrangements": ["Fair use doctrine", "Commercial licenses"],
    "dataProvenanceTracking": "Enabled",
    "optOutMechanism": "Available at example.com/opt-out"
  },

  "energyConsumption": {
    "training": {
      "totalEnergyKWh": 125000,
      "carbonFootprintCO2e": 50,
      "hardware": "1024 A100 GPUs",
      "trainingDuration": "30 days"
    },
    "inference": {
      "energyPerQuery": "0.5 Wh",
      "optimizations": ["Quantization", "Distillation"]
    }
  },

  "testing": {
    "benchmarks": {
      "MMLU": 0.85,
      "HumanEval": 0.72,
      "TruthfulQA": 0.68
    },
    "safetyTesting": {
      "redTeam": "Completed 2025-07-15",
      "jailbreakResistance": "95% success rate",
      "biasMetrics": {
        "genderBias": 0.12,
        "racialBias": 0.08
      }
    }
  },

  "ethicalConsiderations": {
    "knownBiases": ["Gender representation", "Geographic bias toward Western contexts"],
    "mitigationStrategies": ["Diverse training data", "Bias detection filters"],
    "dualUseConcerns": ["Misinformation generation", "Social engineering"],
    "safeguards": ["Content filters", "Rate limiting", "Human oversight for sensitive tasks"]
  },

  "humanOversight": {
    "required": true,
    "contexts": ["Healthcare", "Legal", "Financial services"],
    "escalationProcedure": "See docs/escalation-policy.md"
  }
}
```

### Model Card Checklist

- [ ] All mandatory fields completed
- [ ] JSON schema validation passed
- [ ] Copyright disclosure accurate and complete
- [ ] Energy metrics calculated and verified
- [ ] Testing results up-to-date (< 90 days old)
- [ ] Known biases documented with mitigation strategies
- [ ] Human oversight requirements clearly specified
- [ ] Machine-readable format (JSON/YAML) published
- [ ] Human-readable format (Markdown/HTML) available
- [ ] Accessible via public URL
- [ ] Linked from main product documentation
- [ ] Version-controlled with change history

---

## High-Risk System Preparation (August 2026)

**Deadline:** August 2, 2026 (1 year to prepare)

### Requirements for High-Risk AI Systems

#### 1. Risk Management System
- [ ] Comprehensive risk identification and analysis
- [ ] Risk mitigation strategies documented
- [ ] Continuous risk monitoring
- [ ] Regular risk assessments (minimum quarterly)
- [ ] Risk register maintained

#### 2. Data Governance
- [ ] Training data quality assurance
- [ ] Data bias detection and mitigation
- [ ] Data lineage tracking
- [ ] Privacy impact assessment
- [ ] Data retention and deletion policies

#### 3. Technical Documentation
- [ ] System architecture documentation
- [ ] Data flow diagrams
- [ ] Security architecture
- [ ] Performance specifications
- [ ] Integration guidelines

#### 4. Transparency & User Information
- [ ] Clear user disclosure of AI use
- [ ] Explanation of AI decision factors
- [ ] User rights information (access, correction, deletion)
- [ ] Contact point for inquiries
- [ ] Appeals process for automated decisions

#### 5. Human Oversight
- [ ] Human-in-the-loop requirements defined
- [ ] Override mechanisms implemented
- [ ] Escalation procedures documented
- [ ] Training for human overseers
- [ ] Audit trail of human interventions

#### 6. Accuracy, Robustness, Cybersecurity
- [ ] Performance monitoring dashboards
- [ ] Accuracy thresholds defined and monitored
- [ ] Cybersecurity risk assessment
- [ ] Penetration testing (annual minimum)
- [ ] Incident response plan

#### 7. Quality Management System
- [ ] Quality policy documented
- [ ] Quality objectives set
- [ ] Quality metrics tracked
- [ ] Continuous improvement process
- [ ] Internal audits (minimum annual)

#### 8. Record-Keeping
- [ ] Automatic logging of all AI decisions
- [ ] Log retention for 10 years minimum
- [ ] Logs accessible for regulatory audits
- [ ] Log integrity protection
- [ ] Audit trail immutability

#### 9. Third-Party Audits
- [ ] Annual independent audit scheduled
- [ ] Certified auditor selected
- [ ] Audit scope defined
- [ ] Audit findings remediation plan
- [ ] Audit reports retained

---

## Documentation Templates

### Template 1: Technical Dossier Table of Contents

```
1. Executive Summary
   1.1 Model Overview
   1.2 Compliance Statement
   1.3 Key Metrics

2. Model Architecture
   2.1 Design Principles
   2.2 Network Architecture
   2.3 Parameter Count and Layer Configuration
   2.4 Training Methodology

3. Training Data
   3.1 Data Sources
   3.2 Data Collection
   3.3 Data Preprocessing
   3.4 Data Quality Assurance
   3.5 Copyright Assessment

4. Validation & Testing
   4.1 Evaluation Methodology
   4.2 Benchmark Results
   4.3 Safety Testing
   4.4 Bias Evaluation
   4.5 Edge Case Analysis

5. Energy Consumption
   5.1 Training Energy
   5.2 Inference Energy
   5.3 Carbon Footprint
   5.4 Optimization Measures

6. Risk Assessment
   6.1 Identified Risks
   6.2 Mitigation Strategies
   6.3 Residual Risks
   6.4 Monitoring Plan

7. Governance
   7.1 Decision Log
   7.2 Change Management
   7.3 Incident History
   7.4 Audit Trail

8. Appendices
   A. Model Card (Public)
   B. Benchmark Definitions
   C. Testing Protocols
   D. Compliance Certificates
```

### Template 2: Compliance Log Entry (JSON)

```json
{
  "timestamp": "2025-08-02T14:30:00Z",
  "eventType": "model_inference",
  "modelVersion": "v1.0.0",
  "user": {
    "id": "user-12345",
    "consentObtained": true,
    "consentDate": "2025-07-15"
  },
  "request": {
    "type": "text_generation",
    "riskTier": "medium",
    "humanOversight": true
  },
  "response": {
    "contentFiltered": false,
    "confidenceScore": 0.92,
    "reviewRequired": false
  },
  "compliance": {
    "euAIActCompliant": true,
    "gdprCompliant": true,
    "modelCardPublished": true
  }
}
```

### Template 3: Change Request Form

```markdown
# Model Change Request

## Change Details
- **Request ID:** CR-2025-001
- **Requested By:** [Name, Role]
- **Date:** 2025-08-02
- **Priority:** [Low / Medium / High / Critical]

## Description
[Detailed description of proposed change]

## Rationale
[Business justification and benefits]

## Impact Assessment
- **Performance Impact:** [Expected change in metrics]
- **Compliance Impact:** [EU AI Act, GDPR, other regulations]
- **User Impact:** [Changes to user experience]
- **Energy Impact:** [Training/inference energy change]

## Testing Plan
- [ ] Unit tests updated
- [ ] Integration tests passed
- [ ] Safety evaluation completed
- [ ] Bias assessment conducted
- [ ] Performance benchmarks run

## Rollback Plan
[Procedure to revert if issues arise]

## Approvals
- [ ] Technical Lead: ___________  Date: _______
- [ ] Compliance Officer: ________ Date: _______
- [ ] Product Owner: ____________ Date: _______
```

---

## Audit & Verification

### Internal Audit Checklist

**Frequency:** Quarterly

- [ ] **Documentation Review:**
  - Technical dossier complete and current
  - Model card published and accurate
  - Compliance logs intact and comprehensive

- [ ] **Process Verification:**
  - Change management process followed
  - Risk assessments up-to-date
  - Incident response tested

- [ ] **Technical Verification:**
  - Performance metrics within thresholds
  - Safety testing current (< 90 days)
  - Security patches applied

- [ ] **Compliance Verification:**
  - EU AI Act requirements met
  - GDPR obligations fulfilled
  - Model card reflects current state

### External Audit Preparation

**Frequency:** Annual (for high-risk systems after Aug 2026)

- [ ] **Documentation Package:**
  - Complete technical dossier
  - All compliance logs
  - Audit trail exports
  - Incident reports

- [ ] **Access Provisioning:**
  - Auditor accounts created
  - Data access permissions granted
  - Secure transfer mechanisms established

- [ ] **Stakeholder Interviews:**
  - Key personnel identified
  - Interview schedules prepared
  - Documentation of roles and responsibilities

- [ ] **Systems Demonstration:**
  - Demo environment prepared
  - Test scenarios documented
  - Performance monitoring dashboards accessible

---

## Penalties & Enforcement

### Violation Categories

| Violation | Maximum Fine | Example |
|-----------|--------------|---------|
| **Tier 1 (Most Serious)** | Up to 7% of worldwide annual revenue | Deploying banned AI system, failing to comply with GPAI obligations |
| **Tier 2 (Serious)** | Up to 3% of worldwide annual revenue | Non-compliance with high-risk AI requirements |
| **Tier 3 (Standard)** | Up to 1.5% of worldwide annual revenue | Incomplete documentation, delayed reporting |

### Enforcement Process
1. Regulatory inquiry or complaint
2. Preliminary investigation
3. Formal notice of non-compliance
4. Remediation period (typically 30-90 days)
5. Follow-up audit
6. Penalty assessment if non-compliance persists

---

## Contact & Resources

### Internal Contacts
- **Compliance Officer:** [Name, email]
- **Legal Counsel:** [Name, email]
- **Technical Lead:** [Name, email]
- **Data Protection Officer:** [Name, email]

### External Resources
- **EU AI Act Official Site:** https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai
- **AI Act Implementation Timeline:** https://artificialintelligenceact.eu/implementation-timeline/
- **Model Card Template Library:** https://huggingface.co/docs/hub/model-cards
- **AI Cards Framework:** https://ai-cards.org/

### Legal Support
- **Outside Counsel:** [Law firm, contact]
- **Industry Association:** [Name, membership number]

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-02 | Compliance Team | Initial release aligned with August 2, 2025 deadline |

---

**NEXT ACTIONS:**
1. Schedule compliance kickoff meeting with all stakeholders
2. Assign owners for each checklist section
3. Set internal deadline: July 15, 2025 (2 weeks before regulatory deadline)
4. Schedule weekly progress reviews
5. Engage external audit firm for pre-compliance assessment

**THIS DOCUMENT IS MANDATORY READING FOR ALL AI DEVELOPMENT TEAMS.**
