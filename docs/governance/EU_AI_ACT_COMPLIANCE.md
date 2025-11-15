# EU AI Act Compliance Guide (2025)

## Critical Dates & Deadlines

| Date | Requirement | Action Required |
|------|-------------|-----------------|
| **Feb 2, 2025** | Prohibited AI practices ban | Audit and remove any prohibited systems |
| **May 2025** | Code of Practice finalized | Implement recommended practices |
| **Aug 2, 2025** | GPAI obligations enforceable | Full compliance for AI models |
| **Aug 2, 2026** | Full AI Act applicable | Complete compliance framework |
| **Aug 2, 2027** | High-risk embedded systems | Extended deadline for regulated products |

## Risk Classification Framework

### 1. Prohibited AI Systems (Banned from Feb 2, 2025)
```yaml
prohibited_systems:
  - social_scoring_by_public_authorities
  - exploitation_of_vulnerabilities
  - subliminal_manipulation
  - biometric_categorization_sensitive_attributes
  - untargeted_facial_recognition_scraping
  - emotion_recognition_workplace_education
  - individual_risk_assessment_predicting_crimes
  - real_time_remote_biometric_identification  # With exceptions
```

### 2. Systemic Risk (GPAI Models)
```yaml
systemic_risk_criteria:
  compute_threshold: "10^25 FLOPs"

  requirements:
    - model_evaluation
    - adversarial_testing
    - systemic_risk_assessment
    - serious_incident_reporting
    - cybersecurity_protection
    - energy_consumption_tracking
```

### 3. High-Risk AI Systems
```yaml
high_risk_categories:
  - biometric_identification
  - critical_infrastructure_management
  - education_and_training
  - employment_and_workers_management
  - essential_services_access
  - law_enforcement
  - migration_and_border_control
  - justice_and_democratic_processes

high_risk_requirements:
  - risk_management_system
  - data_governance
  - technical_documentation
  - record_keeping
  - transparency_to_users
  - human_oversight
  - accuracy_robustness_cybersecurity
```

### 4. Limited Risk
```yaml
limited_risk_systems:
  - ai_chatbots
  - emotion_recognition_systems
  - biometric_categorization_systems
  - ai_generated_content

requirements:
  - inform_users_of_ai_interaction
  - label_ai_generated_content
  - implement_watermarking
```

### 5. Minimal Risk
```yaml
minimal_risk_systems:
  - spam_filters
  - ai_in_video_games
  - inventory_management_systems

requirements:
  - voluntary_codes_of_conduct
  - best_practices_encouraged
```

## Technical Implementation Requirements

### 1. Risk Management System
```python
# compliance/risk_management.py
class AIRiskManagement:
    def __init__(self):
        self.risk_categories = ['operational', 'technical', 'ethical', 'legal']
        self.assessment_frequency = 'quarterly'

    def assess_risk(self, ai_system):
        """ISO 42001 Clause 8.2 compliant risk assessment"""
        risks = {
            'bias_risk': self.assess_bias(ai_system),
            'security_risk': self.assess_security(ai_system),
            'privacy_risk': self.assess_privacy(ai_system),
            'safety_risk': self.assess_safety(ai_system),
            'transparency_risk': self.assess_transparency(ai_system)
        }

        return {
            'timestamp': datetime.now().isoformat(),
            'system_id': ai_system.id,
            'risk_tier': self.calculate_tier(risks),
            'risks': risks,
            'mitigations': self.generate_mitigations(risks)
        }

    def continuous_monitoring(self, ai_system):
        """ISO 42001 Clause 9 continuous monitoring"""
        return {
            'bias_monitoring': self.monitor_bias_drift(),
            'performance_monitoring': self.monitor_performance(),
            'incident_tracking': self.track_incidents()
        }
```

### 2. Data Governance Framework
```yaml
# compliance/data_governance.yaml
data_governance:
  quality_measures:
    - completeness_check:
        threshold: 0.95
        action: "reject_if_below"

    - accuracy_validation:
        method: "cross_reference_trusted_sources"
        frequency: "before_each_training"

    - relevance_assessment:
        criteria: "domain_specific"
        review_cycle: "quarterly"

  bias_mitigation:
    pre_processing:
      - demographic_parity_check
      - representation_analysis
      - synthetic_minority_oversampling

    in_processing:
      - fairness_constraints
      - adversarial_debiasing
      - multi_objective_optimization

    post_processing:
      - equalized_odds_adjustment
      - calibrated_equalized_odds
      - threshold_optimization

  data_documentation:
    required_fields:
      - data_sources
      - collection_methods
      - processing_steps
      - quality_metrics
      - bias_analysis
      - limitations
      - retention_period
```

### 3. Technical Documentation Template
```markdown
# AI System Technical Documentation

## System Identification
- **Name**: [System Name]
- **Version**: [X.Y.Z]
- **Risk Category**: [Minimal/Limited/High/Systemic]
- **Deployment Date**: [YYYY-MM-DD]
- **Last Assessment**: [YYYY-MM-DD]

## Intended Use
### Primary Purpose
[Describe the main function and objectives]

### Target Users
[Identify intended user groups]

### Use Case Limitations
[Explicitly state out-of-scope uses]

## Technical Architecture
### Model Details
- Architecture: [e.g., Transformer, CNN]
- Parameters: [Number]
- Training Compute: [FLOPs]
- Inference Requirements: [Hardware specs]

### Data Pipeline
```yaml
input:
  types: [text, image, structured_data]
  preprocessing: [normalization, tokenization]

processing:
  model_inference: [details]
  post_processing: [details]

output:
  format: [classification, generation, recommendation]
  confidence_scoring: [enabled/disabled]
```

## Performance Metrics
| Metric | Value | Test Set | Date |
|--------|-------|----------|------|
| Accuracy | X.XX | [Dataset] | [Date] |
| Precision | X.XX | [Dataset] | [Date] |
| Recall | X.XX | [Dataset] | [Date] |
| F1 Score | X.XX | [Dataset] | [Date] |

## Risk Assessment
### Identified Risks
1. **Bias Risk**: [Assessment and mitigation]
2. **Security Risk**: [Assessment and mitigation]
3. **Privacy Risk**: [Assessment and mitigation]

### Mitigation Measures
[Detailed mitigation strategies]

## Human Oversight
### Oversight Mechanisms
- Review threshold: [Confidence/risk level]
- Override capability: [Yes/No]
- Audit frequency: [Schedule]

### Escalation Procedures
[Define escalation paths and responsible parties]

## Compliance Statement
This system complies with EU AI Act requirements for [risk category] AI systems.
Last compliance audit: [Date]
Next scheduled audit: [Date]
```

### 4. Transparency & User Notification
```typescript
// compliance/transparency.ts
interface AITransparency {
  systemInfo: {
    isAI: boolean;
    aiType: 'generative' | 'analytical' | 'decisional';
    riskCategory: RiskCategory;
  };

  userNotification: {
    message: string;
    displayProminently: boolean;
    optOutAvailable: boolean;
    optOutMechanism?: string;
  };

  watermarking: {
    algorithm: 'synthid' | 'c2pa' | 'custom';
    applied: boolean;
    verificationUrl?: string;
  };

  explanation: {
    decisionFactors?: string[];
    confidenceScore?: number;
    alternativeOptions?: string[];
  };
}

class TransparencyManager {
  notifyUser(interaction: AIInteraction): UserNotification {
    return {
      timestamp: new Date().toISOString(),
      message: this.generateNotification(interaction),
      aiGenerated: this.markAIGenerated(interaction),
      humanReviewAvailable: this.isHighRisk(interaction),
      appeals: this.getAppealsProcess(interaction)
    };
  }

  watermarkContent(content: GeneratedContent): WatermarkedContent {
    const watermark = this.applyWatermark(content);
    return {
      content: watermark.content,
      signature: watermark.signature,
      verifiable: true,
      algorithm: 'synthid',
      timestamp: new Date().toISOString()
    };
  }
}
```

### 5. Human Oversight Implementation
```python
# compliance/human_oversight.py
class HumanOversight:
    def __init__(self, risk_tier: str):
        self.risk_tier = risk_tier
        self.review_threshold = self.set_threshold(risk_tier)
        self.audit_trail = []

    def set_threshold(self, risk_tier: str) -> float:
        """Set confidence threshold based on risk tier"""
        thresholds = {
            'minimal': 0.50,
            'limited': 0.70,
            'high': 0.85,
            'systemic': 0.95
        }
        return thresholds.get(risk_tier, 0.85)

    def requires_human_review(self, decision: AIDecision) -> bool:
        """Determine if human review is required"""
        return any([
            decision.confidence < self.review_threshold,
            decision.impacts_fundamental_rights,
            decision.financial_impact > 10000,
            decision.affects_vulnerable_groups,
            self.risk_tier in ['high', 'systemic']
        ])

    def human_review_interface(self, decision: AIDecision):
        """Present decision for human review"""
        return {
            'decision_id': decision.id,
            'ai_recommendation': decision.recommendation,
            'confidence': decision.confidence,
            'explanation': decision.explanation,
            'factors': decision.decision_factors,
            'alternatives': decision.alternatives,
            'review_deadline': self.calculate_deadline(decision),
            'reviewer_actions': ['approve', 'reject', 'modify', 'escalate']
        }

    def log_human_decision(self, human_decision: HumanDecision):
        """Maintain audit trail of human oversight"""
        self.audit_trail.append({
            'timestamp': datetime.now().isoformat(),
            'decision_id': human_decision.decision_id,
            'ai_recommendation': human_decision.ai_recommendation,
            'human_decision': human_decision.final_decision,
            'rationale': human_decision.rationale,
            'reviewer': human_decision.reviewer_id,
            'compliance_check': self.verify_compliance(human_decision)
        })
```

## Compliance Automation Scripts

### 1. Compliance Checker
```bash
#!/bin/bash
# scripts/eu_ai_act_check.sh

echo "🇪🇺 EU AI Act Compliance Check Starting..."

# Check risk classification
RISK_TIER=$(cat compliance/system_config.yaml | grep risk_tier | cut -d: -f2)
echo "Risk Tier: $RISK_TIER"

# Verify required documentation
DOCS_REQUIRED=(
    "compliance/model_card.yaml"
    "compliance/risk_assessment.json"
    "compliance/technical_documentation.md"
    "compliance/data_governance.yaml"
)

for doc in "${DOCS_REQUIRED[@]}"; do
    if [ ! -f "$doc" ]; then
        echo "❌ Missing: $doc"
        exit 1
    else
        echo "✅ Found: $doc"
    fi
done

# Validate model card
python scripts/validate_model_card.py

# Check for watermarking implementation
grep -r "watermark" src/ > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Watermarking implemented"
else
    echo "⚠️  Watermarking not found"
fi

# Verify human oversight
grep -r "human_oversight" src/ > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Human oversight implemented"
else
    echo "❌ Human oversight not implemented"
    exit 1
fi

# Check bias testing results
if [ -f "tests/bias_test_results.json" ]; then
    BIAS_SCORE=$(cat tests/bias_test_results.json | jq .demographic_parity)
    if (( $(echo "$BIAS_SCORE < 0.05" | bc -l) )); then
        echo "✅ Bias testing passed"
    else
        echo "❌ Bias score too high: $BIAS_SCORE"
        exit 1
    fi
fi

echo "🎉 EU AI Act Compliance Check Complete!"
```

### 2. Model Card Generator
```python
#!/usr/bin/env python3
# scripts/generate_model_card.py

import yaml
import json
from datetime import datetime
from typing import Dict, Any

class ModelCardGenerator:
    def __init__(self, model_config: Dict[str, Any]):
        self.config = model_config
        self.timestamp = datetime.now().isoformat()

    def generate(self) -> Dict[str, Any]:
        """Generate EU AI Act compliant model card"""
        return {
            'schema_version': '2.0',
            'generated_at': self.timestamp,

            'model_details': {
                'name': self.config['model_name'],
                'version': self.config['version'],
                'type': self.config['model_type'],
                'architecture': self.config['architecture'],
                'parameters': self.config.get('parameters'),
                'training_compute': self.config.get('training_flops'),
                'license': self.config.get('license', 'Proprietary')
            },

            'intended_use': {
                'primary_purpose': self.config['primary_purpose'],
                'primary_users': self.config['primary_users'],
                'out_of_scope_uses': self.config.get('out_of_scope', [])
            },

            'training_data': {
                'datasets': self.config.get('datasets', []),
                'preprocessing': self.config.get('preprocessing', []),
                'data_splits': {
                    'train': self.config.get('train_size'),
                    'validation': self.config.get('val_size'),
                    'test': self.config.get('test_size')
                }
            },

            'evaluation': {
                'metrics': self.config.get('metrics', {}),
                'test_datasets': self.config.get('test_datasets', []),
                'bias_evaluation': self.config.get('bias_metrics', {}),
                'robustness_testing': self.config.get('robustness', {})
            },

            'ethical_considerations': {
                'risks': self.config.get('risks', []),
                'mitigations': self.config.get('mitigations', []),
                'fairness_assessment': self.config.get('fairness', {}),
                'transparency_measures': self.config.get('transparency', [])
            },

            'regulatory_compliance': {
                'eu_ai_act': {
                    'risk_category': self.config['risk_category'],
                    'conformity_assessment': self.config.get('conformity', 'Pending'),
                    'ce_marking': self.config.get('ce_marking', False)
                },
                'gdpr': {
                    'data_processing_basis': self.config.get('gdpr_basis'),
                    'data_subjects_rights': self.config.get('data_rights', [])
                }
            },

            'deployment': {
                'compute_requirements': self.config.get('deployment_compute'),
                'update_frequency': self.config.get('update_frequency'),
                'monitoring': self.config.get('monitoring_strategy'),
                'human_oversight': self.config.get('human_oversight', {})
            },

            'contact': {
                'organization': self.config.get('organization'),
                'email': self.config.get('contact_email'),
                'documentation_url': self.config.get('docs_url')
            }
        }

    def validate(self, model_card: Dict[str, Any]) -> bool:
        """Validate model card against EU AI Act requirements"""
        required_fields = [
            'model_details.name',
            'model_details.version',
            'intended_use.primary_purpose',
            'regulatory_compliance.eu_ai_act.risk_category',
            'ethical_considerations.risks'
        ]

        for field_path in required_fields:
            if not self._check_field(model_card, field_path):
                print(f"❌ Missing required field: {field_path}")
                return False

        print("✅ Model card validation passed")
        return True

    def _check_field(self, data: Dict, path: str) -> bool:
        """Check if nested field exists in dictionary"""
        keys = path.split('.')
        current = data
        for key in keys:
            if key not in current:
                return False
            current = current[key]
        return current is not None

if __name__ == "__main__":
    # Load configuration
    with open('compliance/model_config.yaml', 'r') as f:
        config = yaml.safe_load(f)

    # Generate model card
    generator = ModelCardGenerator(config)
    model_card = generator.generate()

    # Validate
    if generator.validate(model_card):
        # Save model card
        with open('compliance/model_card.yaml', 'w') as f:
            yaml.dump(model_card, f, sort_keys=False)

        print(f"✅ Model card generated: compliance/model_card.yaml")
    else:
        print("❌ Model card validation failed")
        exit(1)
```

## Compliance Monitoring Dashboard

```yaml
# compliance/monitoring_dashboard.yaml
compliance_metrics:
  real_time:
    - risk_assessment_status
    - human_review_queue_size
    - confidence_threshold_breaches
    - bias_drift_detection
    - watermark_verification_rate

  daily:
    - automated_decisions_count
    - human_overrides_count
    - transparency_notifications_sent
    - opt_out_requests
    - incident_reports

  monthly:
    - compliance_audit_results
    - model_performance_metrics
    - bias_testing_results
    - user_complaints
    - regulatory_inquiries

alerts:
  critical:
    - prohibited_system_detected
    - human_oversight_bypassed
    - watermarking_failure
    - bias_threshold_exceeded

  warning:
    - documentation_outdated
    - performance_degradation
    - unusual_decision_patterns
    - compliance_check_failed

dashboards:
  - name: "EU AI Act Compliance"
    panels:
      - risk_classification_distribution
      - human_review_metrics
      - transparency_compliance
      - bias_monitoring
      - incident_tracking

  - name: "Model Performance"
    panels:
      - accuracy_over_time
      - confidence_distribution
      - decision_outcomes
      - fairness_metrics
      - robustness_tests
```

## Incident Response Procedures

```yaml
# compliance/incident_response.yaml
incident_categories:
  prohibited_use:
    severity: critical
    response_time: immediate
    actions:
      - disable_system
      - notify_dpo
      - notify_regulators
      - initiate_investigation

  bias_detection:
    severity: high
    response_time: 24h
    actions:
      - flag_affected_decisions
      - enable_human_review
      - analyze_root_cause
      - implement_mitigation

  transparency_failure:
    severity: medium
    response_time: 48h
    actions:
      - identify_affected_users
      - send_notifications
      - update_documentation
      - fix_transparency_mechanism

  human_oversight_bypass:
    severity: high
    response_time: 4h
    actions:
      - halt_automated_decisions
      - review_recent_decisions
      - fix_oversight_mechanism
      - retrain_staff

response_team:
  - role: incident_commander
    responsibilities: [coordination, communication, decision_making]

  - role: technical_lead
    responsibilities: [system_analysis, fix_implementation]

  - role: compliance_officer
    responsibilities: [regulatory_notification, documentation]

  - role: data_protection_officer
    responsibilities: [privacy_assessment, user_notification]

communication_plan:
  internal:
    - slack: "#ai-incidents"
    - email: "ai-compliance@company.com"
    - escalation: "cto@company.com"

  external:
    - regulators: "Within 72 hours"
    - users: "Without undue delay"
    - public: "Via status page if widespread"
```

## Testing & Validation Suite

```python
# tests/eu_ai_act_compliance_test.py
import unittest
from datetime import datetime
from compliance import AIRiskManagement, HumanOversight, TransparencyManager

class EUAIActComplianceTests(unittest.TestCase):

    def setUp(self):
        self.risk_manager = AIRiskManagement()
        self.oversight = HumanOversight('high')
        self.transparency = TransparencyManager()

    def test_risk_classification(self):
        """Test correct risk tier classification"""
        test_cases = [
            ('chatbot', 'limited'),
            ('credit_scoring', 'high'),
            ('spam_filter', 'minimal'),
            ('facial_recognition', 'high')
        ]

        for system_type, expected_tier in test_cases:
            result = self.risk_manager.classify_system(system_type)
            self.assertEqual(result, expected_tier)

    def test_human_oversight_threshold(self):
        """Test human review triggers correctly"""
        # Low confidence should trigger review
        decision = AIDecision(confidence=0.6, impact='high')
        self.assertTrue(self.oversight.requires_human_review(decision))

        # High confidence, low impact shouldn't trigger
        decision = AIDecision(confidence=0.95, impact='minimal')
        self.assertFalse(self.oversight.requires_human_review(decision))

    def test_watermarking_implementation(self):
        """Test watermarking is applied to generated content"""
        content = "AI generated text content"
        result = self.transparency.watermark_content(content)

        self.assertIsNotNone(result.signature)
        self.assertEqual(result.algorithm, 'synthid')
        self.assertTrue(result.verifiable)

    def test_bias_detection(self):
        """Test bias metrics are within acceptable range"""
        metrics = self.risk_manager.calculate_bias_metrics(test_data)

        self.assertLess(metrics['demographic_parity'], 0.05)
        self.assertLess(metrics['equalized_odds'], 0.10)
        self.assertGreater(metrics['fairness_score'], 0.90)

    def test_transparency_notification(self):
        """Test user notification for AI interaction"""
        interaction = AIInteraction(type='chatbot', risk='limited')
        notification = self.transparency.notify_user(interaction)

        self.assertIn("AI system", notification.message)
        self.assertTrue(notification.opt_out_available)
        self.assertIsNotNone(notification.timestamp)

    def test_audit_trail_completeness(self):
        """Test audit trail captures all required information"""
        decision = AIDecision(id='123', recommendation='approve')
        human_decision = HumanDecision(
            decision_id='123',
            final_decision='reject',
            rationale='Insufficient documentation'
        )

        self.oversight.log_human_decision(human_decision)
        audit_entry = self.oversight.audit_trail[-1]

        required_fields = [
            'timestamp', 'decision_id', 'ai_recommendation',
            'human_decision', 'rationale', 'reviewer'
        ]

        for field in required_fields:
            self.assertIn(field, audit_entry)

if __name__ == '__main__':
    unittest.main()
```

## Regulatory Reporting Templates

```markdown
# EU AI Act Compliance Report

**Report Period**: [Start Date] - [End Date]
**System Name**: [AI System Name]
**Risk Category**: [Minimal/Limited/High/Systemic]

## Executive Summary
[Brief overview of compliance status and key findings]

## Compliance Status

### Documentation
- [ ] Technical documentation complete
- [ ] Model card updated
- [ ] Risk assessment current
- [ ] User instructions available

### Technical Requirements
- [ ] Watermarking implemented
- [ ] Human oversight functional
- [ ] Transparency measures in place
- [ ] Bias testing completed

### Operational Metrics
- Total AI decisions: [Number]
- Human reviews conducted: [Number]
- Override rate: [Percentage]
- Incidents reported: [Number]

## Risk Assessment Summary
[Summary of identified risks and mitigation status]

## Bias Testing Results
[Summary of bias metrics and fairness assessments]

## Incident Log
[List of incidents and responses during reporting period]

## Recommendations
[Actions needed to maintain or improve compliance]

## Attestation
I certify that this report accurately represents the compliance status of the AI system.

**Name**: [Compliance Officer]
**Date**: [Date]
**Signature**: [Digital signature]
```

## Quick Reference Checklist

### Pre-Deployment Checklist
- [ ] Risk tier determined
- [ ] Technical documentation complete
- [ ] Model card generated
- [ ] Risk assessment conducted
- [ ] Data governance implemented
- [ ] Bias testing completed
- [ ] Human oversight configured
- [ ] Transparency mechanisms tested
- [ ] Watermarking enabled
- [ ] Audit logging active
- [ ] Incident response plan ready
- [ ] Staff training completed

### Monthly Compliance Tasks
- [ ] Review and update model card
- [ ] Conduct bias testing
- [ ] Analyze human oversight metrics
- [ ] Review incident logs
- [ ] Update risk assessment if needed
- [ ] Check for regulatory updates
- [ ] Review user complaints
- [ ] Generate compliance report

### Quarterly Compliance Tasks
- [ ] Full risk reassessment
- [ ] Comprehensive bias audit
- [ ] System performance review
- [ ] Update technical documentation
- [ ] Conduct adversarial testing
- [ ] Review and update training materials
- [ ] External audit preparation
- [ ] Regulatory filing if required

## Contact Information

### Internal Contacts
- **AI Ethics Officer**: ai-ethics@company.com
- **Data Protection Officer**: dpo@company.com
- **Compliance Team**: ai-compliance@company.com
- **Incident Response**: ai-incidents@company.com

### Regulatory Bodies
- **European Commission AI Office**: [Contact details]
- **National Supervisory Authority**: [Contact details]
- **Industry Association**: [Contact details]

### Resources
- [EU AI Act Full Text](https://artificialintelligenceact.eu/)
- [European Commission AI Act Portal](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)
- [Harmonized Standards](https://ec.europa.eu/growth/tools-databases/nando/)
- [Code of Practice for GPAI](https://ec.europa.eu/info/law/better-regulation/)

---

*Last Updated: January 2025*
*Next Review: February 2025*
*Version: 1.0*