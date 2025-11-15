# Software Supply Chain Security Guide (2025)
## SBOM Generation & SLSA Compliance

## Overview

Software Bill of Materials (SBOM) and Supply-chain Levels for Software Artifacts (SLSA) are complementary frameworks that ensure software supply chain integrity. This guide covers implementation of SLSA Level 2+ compliance with comprehensive SBOM management.

## SBOM Standards & Formats

### Supported Formats
```yaml
sbom_formats:
  spdx:
    version: "2.3"
    mime_type: "application/spdx+json"
    use_cases:
      - regulatory_compliance
      - vulnerability_management
      - license_compliance

  cyclonedx:
    version: "1.5"
    mime_type: "application/vnd.cyclonedx+json"
    use_cases:
      - security_analysis
      - component_tracking
      - dependency_management

  swid:
    version: "ISO/IEC 19770-2:2015"
    use_cases:
      - asset_management
      - legacy_systems
```

## SLSA Compliance Levels

### Level Requirements
| Level | Build | Source | Dependencies | Security | Implementation |
|-------|-------|--------|--------------|----------|----------------|
| **L1** | Scripted build | Version controlled | Listed | Basic | Days |
| **L2** | Build service | Verified history | Attested | Signed provenance | Weeks |
| **L3** | Hardened builds | Protected branches | Pinned | Non-falsifiable | Months |

### Current Target: SLSA Level 2 (Achievable in Weeks)

## Implementation Guide

### 1. SBOM Generation Pipeline

```bash
#!/bin/bash
# scripts/generate-sbom.sh

set -euo pipefail

echo "🔍 Generating Software Bill of Materials..."

# Detect project type and generate appropriate SBOM
detect_and_generate() {
    local path="$1"
    local format="${2:-spdx}"

    # Node.js projects
    if [ -f "$path/package.json" ]; then
        echo "📦 Detected Node.js project"
        syft "$path" -o "$format-json" > "$path/sbom.$format.json"

        # Also generate with CycloneDX for npm
        npx @cyclonedx/cli-bom -o "$path/sbom.cdx.json"
    fi

    # Python projects
    if [ -f "$path/requirements.txt" ] || [ -f "$path/pyproject.toml" ]; then
        echo "🐍 Detected Python project"
        syft "$path" -o "$format-json" > "$path/sbom.$format.json"

        # Use pip-audit for additional validation
        pip-audit --format json --output "$path/pip-audit.json"
    fi

    # Go projects
    if [ -f "$path/go.mod" ]; then
        echo "🐹 Detected Go project"
        syft "$path" -o "$format-json" > "$path/sbom.$format.json"

        # Use Go's built-in tooling
        go mod vendor
        go list -json -deps ./... > "$path/go-deps.json"
    fi

    # Rust projects
    if [ -f "$path/Cargo.toml" ]; then
        echo "🦀 Detected Rust project"
        syft "$path" -o "$format-json" > "$path/sbom.$format.json"

        # Use cargo-audit
        cargo audit --json > "$path/cargo-audit.json"
    fi

    # Container images
    if [ -f "$path/Dockerfile" ]; then
        echo "🐳 Detected container project"
        # Build and scan the image
        docker build -t temp-sbom-scan:latest "$path"
        syft temp-sbom-scan:latest -o "$format-json" > "$path/container-sbom.$format.json"
        docker rmi temp-sbom-scan:latest
    fi
}

# Generate for current directory
detect_and_generate "." "spdx"
detect_and_generate "." "cyclonedx"

# Sign the SBOM
echo "✍️  Signing SBOM..."
cosign sign-blob \
    --key cosign.key \
    --output-signature sbom.spdx.json.sig \
    sbom.spdx.json

# Generate attestation
echo "📜 Creating attestation..."
cosign attest \
    --predicate sbom.spdx.json \
    --type spdxjson \
    --key cosign.key \
    ${CONTAINER_IMAGE}

echo "✅ SBOM generation complete!"
```

### 2. SLSA Provenance Generation

```yaml
# .github/workflows/slsa-provenance.yml
name: SLSA Provenance Generation

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:

jobs:
  build:
    permissions:
      id-token: write
      contents: read
      attestations: write

    runs-on: ubuntu-latest
    outputs:
      image: ${{ steps.image.outputs.image }}
      digest: ${{ steps.build.outputs.digest }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build artifact
        id: build
        run: |
          # Build your artifact
          make build

          # Calculate digest
          DIGEST=$(sha256sum artifact | cut -d' ' -f1)
          echo "digest=$DIGEST" >> $GITHUB_OUTPUT

      - name: Generate SBOM
        uses: anchore/sbom-action@v0
        with:
          format: spdx-json
          output-file: sbom.spdx.json

      - name: Generate SLSA Provenance
        uses: slsa-framework/slsa-github-generator@v1.9.0
        with:
          subject-name: ${{ github.repository }}
          subject-digest: ${{ steps.build.outputs.digest }}
          push-to-registry: true

      - name: Sign with Sigstore
        uses: sigstore/cosign-installer@v3
        run: |
          # Keyless signing with OIDC
          cosign sign --yes ${IMAGE}@${DIGEST}

          # Attach SBOM attestation
          cosign attach sbom --sbom sbom.spdx.json ${IMAGE}@${DIGEST}

          # Verify the signature
          cosign verify --certificate-identity-regexp=".*" \
                       --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
                       ${IMAGE}@${DIGEST}
```

### 3. Vulnerability Scanning Integration

```python
#!/usr/bin/env python3
# scripts/scan-dependencies.py

import json
import subprocess
import sys
from typing import Dict, List, Tuple
from datetime import datetime

class DependencyScanner:
    def __init__(self, sbom_path: str):
        self.sbom_path = sbom_path
        self.vulnerabilities = []

    def scan_with_grype(self) -> Dict:
        """Scan SBOM with Grype for vulnerabilities"""
        cmd = f"grype sbom:{self.sbom_path} --output json"
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

        if result.returncode != 0:
            print(f"Error running Grype: {result.stderr}")
            return {}

        return json.loads(result.stdout)

    def scan_with_osv(self) -> List[Dict]:
        """Scan with OSV database"""
        cmd = f"osv-scanner --sbom={self.sbom_path} --format=json"
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

        if result.returncode != 0 and "No vulnerabilities found" not in result.stderr:
            print(f"Error running OSV Scanner: {result.stderr}")
            return []

        try:
            return json.loads(result.stdout).get('results', [])
        except:
            return []

    def categorize_vulnerabilities(self, vulns: List[Dict]) -> Dict:
        """Categorize vulnerabilities by severity"""
        categories = {
            'critical': [],
            'high': [],
            'medium': [],
            'low': [],
            'unknown': []
        }

        for vuln in vulns:
            severity = vuln.get('severity', 'unknown').lower()
            if severity in categories:
                categories[severity].append(vuln)
            else:
                categories['unknown'].append(vuln)

        return categories

    def generate_report(self) -> Dict:
        """Generate comprehensive vulnerability report"""
        grype_results = self.scan_with_grype()
        osv_results = self.scan_with_osv()

        # Combine and deduplicate results
        all_vulns = self._merge_results(grype_results, osv_results)
        categorized = self.categorize_vulnerabilities(all_vulns)

        report = {
            'timestamp': datetime.now().isoformat(),
            'sbom_file': self.sbom_path,
            'summary': {
                'total': len(all_vulns),
                'critical': len(categorized['critical']),
                'high': len(categorized['high']),
                'medium': len(categorized['medium']),
                'low': len(categorized['low'])
            },
            'vulnerabilities': categorized,
            'recommendations': self._generate_recommendations(categorized)
        }

        return report

    def _merge_results(self, grype: Dict, osv: List) -> List[Dict]:
        """Merge and deduplicate vulnerability results"""
        vulns = {}

        # Process Grype results
        for match in grype.get('matches', []):
            vuln_id = match.get('vulnerability', {}).get('id')
            if vuln_id:
                vulns[vuln_id] = {
                    'id': vuln_id,
                    'severity': match.get('vulnerability', {}).get('severity'),
                    'package': match.get('artifact', {}).get('name'),
                    'version': match.get('artifact', {}).get('version'),
                    'fix_available': bool(match.get('vulnerability', {}).get('fix'))
                }

        # Process OSV results
        for result in osv:
            for vuln in result.get('vulnerabilities', []):
                vuln_id = vuln.get('id')
                if vuln_id and vuln_id not in vulns:
                    vulns[vuln_id] = {
                        'id': vuln_id,
                        'severity': vuln.get('database_specific', {}).get('severity', 'unknown'),
                        'package': vuln.get('package', {}).get('name'),
                        'version': vuln.get('package', {}).get('version')
                    }

        return list(vulns.values())

    def _generate_recommendations(self, categorized: Dict) -> List[str]:
        """Generate actionable recommendations"""
        recommendations = []

        if categorized['critical']:
            recommendations.append("🚨 URGENT: Patch critical vulnerabilities immediately")

        if categorized['high']:
            recommendations.append("⚠️  Address high-severity vulnerabilities within 7 days")

        if len(categorized['critical']) + len(categorized['high']) > 10:
            recommendations.append("📊 Consider dependency update strategy review")

        return recommendations

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: scan-dependencies.py <sbom-file>")
        sys.exit(1)

    scanner = DependencyScanner(sys.argv[1])
    report = scanner.generate_report()

    # Print summary
    print(f"\n📊 Vulnerability Scan Report")
    print(f"{'='*50}")
    print(f"Total vulnerabilities: {report['summary']['total']}")
    print(f"  Critical: {report['summary']['critical']}")
    print(f"  High:     {report['summary']['high']}")
    print(f"  Medium:   {report['summary']['medium']}")
    print(f"  Low:      {report['summary']['low']}")

    # Save detailed report
    with open('vulnerability-report.json', 'w') as f:
        json.dump(report, f, indent=2)

    print(f"\n📁 Detailed report saved to vulnerability-report.json")

    # Exit with error if critical/high vulnerabilities found
    if report['summary']['critical'] > 0 or report['summary']['high'] > 0:
        sys.exit(1)
```

### 4. License Compliance Checking

```javascript
// scripts/license-compliance.js
const fs = require('fs');
const path = require('path');

class LicenseCompliance {
    constructor(sbomPath) {
        this.sbom = JSON.parse(fs.readFileSync(sbomPath, 'utf8'));
        this.allowedLicenses = [
            'MIT', 'Apache-2.0', 'BSD-3-Clause', 'BSD-2-Clause',
            'ISC', 'CC0-1.0', 'Unlicense'
        ];
        this.restrictedLicenses = [
            'GPL-2.0', 'GPL-3.0', 'AGPL-3.0', 'LGPL-2.1', 'LGPL-3.0'
        ];
        this.prohibitedLicenses = [
            'SSPL', 'Commons-Clause', 'Elastic-2.0'
        ];
    }

    checkCompliance() {
        const results = {
            compliant: [],
            restricted: [],
            prohibited: [],
            unknown: [],
            summary: {
                total: 0,
                compliant: 0,
                issues: 0
            }
        };

        // Process SPDX format
        if (this.sbom.packages) {
            this.sbom.packages.forEach(pkg => {
                const license = this.extractLicense(pkg);
                const component = {
                    name: pkg.name,
                    version: pkg.versionInfo,
                    license: license
                };

                results.summary.total++;

                if (this.prohibitedLicenses.includes(license)) {
                    results.prohibited.push(component);
                    results.summary.issues++;
                } else if (this.restrictedLicenses.includes(license)) {
                    results.restricted.push(component);
                    results.summary.issues++;
                } else if (this.allowedLicenses.includes(license)) {
                    results.compliant.push(component);
                    results.summary.compliant++;
                } else {
                    results.unknown.push(component);
                    results.summary.issues++;
                }
            });
        }

        return results;
    }

    extractLicense(pkg) {
        // Handle various license field formats
        if (pkg.licenseConcluded && pkg.licenseConcluded !== 'NOASSERTION') {
            return pkg.licenseConcluded;
        }
        if (pkg.licenseDeclared && pkg.licenseDeclared !== 'NOASSERTION') {
            return pkg.licenseDeclared;
        }
        return 'UNKNOWN';
    }

    generateReport(results) {
        console.log('\n📋 License Compliance Report');
        console.log('='.repeat(50));
        console.log(`Total packages: ${results.summary.total}`);
        console.log(`Compliant: ${results.summary.compliant}`);
        console.log(`Issues found: ${results.summary.issues}`);

        if (results.prohibited.length > 0) {
            console.log('\n🚫 PROHIBITED LICENSES:');
            results.prohibited.forEach(pkg => {
                console.log(`  ❌ ${pkg.name}@${pkg.version} - ${pkg.license}`);
            });
        }

        if (results.restricted.length > 0) {
            console.log('\n⚠️  RESTRICTED LICENSES (Review Required):');
            results.restricted.forEach(pkg => {
                console.log(`  ⚠️  ${pkg.name}@${pkg.version} - ${pkg.license}`);
            });
        }

        if (results.unknown.length > 0) {
            console.log('\n❓ UNKNOWN LICENSES:');
            results.unknown.forEach(pkg => {
                console.log(`  ❓ ${pkg.name}@${pkg.version}`);
            });
        }

        // Save detailed report
        fs.writeFileSync(
            'license-compliance-report.json',
            JSON.stringify(results, null, 2)
        );

        console.log('\n📁 Detailed report saved to license-compliance-report.json');

        // Return exit code
        return results.summary.issues === 0 ? 0 : 1;
    }
}

// Main execution
if (require.main === module) {
    const sbomPath = process.argv[2];
    if (!sbomPath) {
        console.error('Usage: node license-compliance.js <sbom-file>');
        process.exit(1);
    }

    const checker = new LicenseCompliance(sbomPath);
    const results = checker.checkCompliance();
    const exitCode = checker.generateReport(results);
    process.exit(exitCode);
}

module.exports = LicenseCompliance;
```

### 5. Container Supply Chain Security

```dockerfile
# Secure Dockerfile with SBOM generation
FROM node:18-alpine AS builder

# Install security tools
RUN apk add --no-cache \
    git \
    curl \
    ca-certificates

# Install Syft for SBOM generation
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin

# Copy and install dependencies
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Generate SBOM for dependencies
RUN syft /app -o spdx-json > /app/sbom.json

# Copy application code
COPY . .

# Build application
RUN npm run build

# Final stage - minimal runtime
FROM gcr.io/distroless/nodejs18-debian11

# Copy application and SBOM
COPY --from=builder /app/dist /app
COPY --from=builder /app/sbom.json /app/sbom.json
COPY --from=builder /app/node_modules /app/node_modules

# Add labels for traceability
LABEL org.opencontainers.image.source="https://github.com/org/repo"
LABEL org.opencontainers.image.revision="${GIT_COMMIT}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL sbom.location="/app/sbom.json"

WORKDIR /app
USER nonroot
EXPOSE 3000

CMD ["index.js"]
```

### 6. CI/CD Pipeline with SLSA Level 2

```yaml
# .gitlab-ci.yml - GitLab CI with SLSA
stages:
  - scan
  - build
  - attest
  - deploy

variables:
  CONTAINER_IMAGE: ${CI_REGISTRY_IMAGE}:${CI_COMMIT_SHORT_SHA}

security-scan:
  stage: scan
  script:
    # Secret scanning
    - gitleaks detect --baseline-path=.gitleaks-baseline.json

    # SAST
    - semgrep ci --config=auto

    # Dependency check
    - npm audit --audit-level=moderate

    # License check
    - npx license-checker --production --onlyAllow="MIT;Apache-2.0;BSD-3-Clause"

build-and-sbom:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    # Build container
    - docker build -t ${CONTAINER_IMAGE} .

    # Generate SBOM
    - |
      docker run --rm \
        -v /var/run/docker.sock:/var/run/docker.sock \
        anchore/syft:latest \
        ${CONTAINER_IMAGE} \
        -o spdx-json > sbom.spdx.json

    # Scan for vulnerabilities
    - |
      docker run --rm \
        -v $(pwd):/workspace \
        anchore/grype:latest \
        sbom:/workspace/sbom.spdx.json \
        --fail-on high

    # Push to registry
    - docker push ${CONTAINER_IMAGE}

  artifacts:
    paths:
      - sbom.spdx.json
    expire_in: 1 week

attest-and-sign:
  stage: attest
  image: gcr.io/projectsigstore/cosign:latest
  script:
    # Sign container image (keyless with OIDC)
    - cosign sign --yes ${CONTAINER_IMAGE}

    # Attach SBOM attestation
    - cosign attest --yes --predicate sbom.spdx.json --type spdxjson ${CONTAINER_IMAGE}

    # Generate SLSA provenance
    - |
      cosign attest --yes \
        --predicate <(echo '{
          "buildType": "https://gitlab.com/slsa/v1.0",
          "builder": {
            "id": "'${CI_PROJECT_URL}'"
          },
          "invocation": {
            "configSource": {
              "uri": "'${CI_PROJECT_URL}'",
              "digest": {"sha1": "'${CI_COMMIT_SHA}'"}
            }
          },
          "materials": [
            {
              "uri": "'${CI_PROJECT_URL}'",
              "digest": {"sha1": "'${CI_COMMIT_SHA}'"}
            }
          ]
        }') \
        --type slsaprovenance \
        ${CONTAINER_IMAGE}

    # Verify signatures
    - cosign verify --certificate-identity-regexp=".*" ${CONTAINER_IMAGE}

deploy:
  stage: deploy
  script:
    # Verify before deployment
    - cosign verify --certificate-identity-regexp=".*" ${CONTAINER_IMAGE}

    # Check SBOM attestation
    - cosign verify-attestation --type spdxjson ${CONTAINER_IMAGE}

    # Deploy only if verified
    - kubectl set image deployment/app app=${CONTAINER_IMAGE}
  only:
    - main
```

## Verification & Validation

### Verifying SLSA Compliance

```bash
#!/bin/bash
# scripts/verify-slsa.sh

echo "🔍 Verifying SLSA Compliance..."

IMAGE="$1"
EXPECTED_IDENTITY="$2"

# Verify image signature
echo "Checking signature..."
if ! cosign verify \
    --certificate-identity="${EXPECTED_IDENTITY}" \
    --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
    "${IMAGE}"; then
    echo "❌ Signature verification failed"
    exit 1
fi

# Verify SBOM attestation
echo "Checking SBOM attestation..."
if ! cosign verify-attestation \
    --type spdxjson \
    --certificate-identity="${EXPECTED_IDENTITY}" \
    --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
    "${IMAGE}"; then
    echo "❌ SBOM attestation verification failed"
    exit 1
fi

# Verify SLSA provenance
echo "Checking SLSA provenance..."
if ! cosign verify-attestation \
    --type slsaprovenance \
    --certificate-identity="${EXPECTED_IDENTITY}" \
    --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
    "${IMAGE}"; then
    echo "❌ SLSA provenance verification failed"
    exit 1
fi

# Extract and validate SBOM
echo "Validating SBOM content..."
cosign download attestation "${IMAGE}" | jq -r '.payload' | base64 -d > sbom.json

# Check for critical vulnerabilities
grype sbom:sbom.json --fail-on critical

echo "✅ SLSA Level 2 compliance verified!"
```

### Policy Enforcement with OPA

```rego
# policies/supply-chain.rego
package supply_chain

import future.keywords.if
import future.keywords.contains

# Deny deployment without SBOM
deny[msg] {
    input.attestations[_].type != "spdxjson"
    msg := "Deployment denied: SBOM attestation required"
}

# Deny deployment without signature
deny[msg] {
    not input.verified_signature
    msg := "Deployment denied: Image signature verification failed"
}

# Deny deployment with critical vulnerabilities
deny[msg] {
    input.vulnerabilities[_].severity == "CRITICAL"
    msg := "Deployment denied: Critical vulnerabilities detected"
}

# Deny deployment with prohibited licenses
deny[msg] {
    input.sbom.packages[_].license in ["SSPL", "Commons-Clause"]
    msg := "Deployment denied: Prohibited license detected"
}

# Require SLSA Level 2 for production
deny[msg] {
    input.environment == "production"
    input.slsa_level < 2
    msg := "Deployment denied: SLSA Level 2 required for production"
}

# Warning for outdated dependencies
warn[msg] {
    package := input.sbom.packages[_]
    package.days_since_update > 180
    msg := sprintf("Warning: Package %s is %d days old", [package.name, package.days_since_update])
}
```

## Monitoring & Dashboards

### Grafana Dashboard Configuration

```json
{
  "dashboard": {
    "title": "Supply Chain Security",
    "panels": [
      {
        "title": "SBOM Generation Rate",
        "targets": [
          {
            "expr": "rate(sbom_generated_total[5m])"
          }
        ]
      },
      {
        "title": "Vulnerability Distribution",
        "targets": [
          {
            "expr": "sum by (severity) (vulnerabilities_detected)"
          }
        ]
      },
      {
        "title": "License Compliance",
        "targets": [
          {
            "expr": "license_compliance_score"
          }
        ]
      },
      {
        "title": "SLSA Level Distribution",
        "targets": [
          {
            "expr": "count by (level) (slsa_compliance)"
          }
        ]
      },
      {
        "title": "Signature Verification Success Rate",
        "targets": [
          {
            "expr": "rate(signature_verification_success[5m]) / rate(signature_verification_total[5m])"
          }
        ]
      }
    ]
  }
}
```

### Prometheus Metrics

```yaml
# monitoring/supply-chain-metrics.yaml
metrics:
  - name: sbom_generated_total
    type: counter
    help: "Total number of SBOMs generated"
    labels:
      - format
      - project

  - name: vulnerabilities_detected
    type: gauge
    help: "Number of vulnerabilities detected"
    labels:
      - severity
      - scanner

  - name: license_compliance_score
    type: gauge
    help: "License compliance score (0-100)"
    labels:
      - project

  - name: slsa_compliance
    type: gauge
    help: "SLSA compliance level"
    labels:
      - level
      - project

  - name: signature_verification_total
    type: counter
    help: "Total signature verification attempts"

  - name: signature_verification_success
    type: counter
    help: "Successful signature verifications"

  - name: supply_chain_attack_blocked
    type: counter
    help: "Supply chain attacks blocked by policy"
    labels:
      - attack_type
      - policy
```

## Incident Response

### Supply Chain Incident Playbook

```yaml
# incident-response/supply-chain-compromise.yaml
incident_type: supply_chain_compromise

detection_sources:
  - signature_verification_failure
  - unexpected_sbom_changes
  - vulnerability_spike
  - policy_violations
  - external_threat_intel

immediate_actions:
  - isolate_affected_systems
  - halt_deployments
  - revoke_compromised_keys
  - notify_security_team

investigation:
  - analyze_sbom_differences
  - review_build_logs
  - check_dependency_changes
  - verify_all_signatures
  - scan_for_malware

containment:
  - rollback_to_known_good
  - block_malicious_packages
  - update_security_policies
  - regenerate_signing_keys

remediation:
  - patch_vulnerabilities
  - update_dependencies
  - rebuild_from_clean_source
  - regenerate_attestations
  - update_sboms

recovery:
  - verify_clean_state
  - gradual_redeployment
  - enhanced_monitoring
  - stakeholder_notification

lessons_learned:
  - document_timeline
  - identify_gaps
  - update_playbooks
  - improve_detection
```

## Best Practices Checklist

### Daily Operations
- [ ] Review vulnerability scan results
- [ ] Check license compliance status
- [ ] Verify signature verification rate
- [ ] Monitor SBOM generation success

### Weekly Tasks
- [ ] Update dependency vulnerability database
- [ ] Review and update allowed license list
- [ ] Audit unusual SBOM changes
- [ ] Check SLSA compliance levels

### Monthly Tasks
- [ ] Full dependency update cycle
- [ ] Security audit of build pipeline
- [ ] Review and rotate signing keys
- [ ] Update security policies

### Quarterly Tasks
- [ ] Supply chain security assessment
- [ ] Third-party dependency review
- [ ] Incident response drill
- [ ] Policy and procedure update

## Tools & Resources

### Essential Tools
```yaml
tools:
  sbom_generation:
    - syft: "Multi-ecosystem SBOM generator"
    - cyclonedx-cli: "CycloneDX format tools"
    - spdx-sbom-generator: "SPDX format generator"

  vulnerability_scanning:
    - grype: "Vulnerability scanner for containers and filesystems"
    - trivy: "Comprehensive vulnerability scanner"
    - osv-scanner: "Open Source Vulnerability scanner"

  signing_verification:
    - cosign: "Container signing and verification"
    - sigstore: "Keyless signing infrastructure"
    - notation: "OCI artifact signing"

  policy_enforcement:
    - opa: "Open Policy Agent"
    - kyverno: "Kubernetes native policies"
    - falco: "Runtime security"

  monitoring:
    - grafana: "Dashboards and visualization"
    - prometheus: "Metrics and alerting"
    - elasticsearch: "Log aggregation"
```

### Automation Scripts

```bash
# Makefile targets for supply chain security
.PHONY: sbom sign verify scan

sbom: ## Generate SBOM for current project
	@syft . -o spdx-json > sbom.spdx.json
	@syft . -o cyclonedx-json > sbom.cdx.json
	@echo "✅ SBOM generated"

sign: ## Sign artifacts and attestations
	@cosign sign-blob --key cosign.key sbom.spdx.json
	@echo "✅ SBOM signed"

verify: ## Verify signatures and attestations
	@cosign verify-blob --key cosign.pub --signature sbom.spdx.json.sig sbom.spdx.json
	@echo "✅ Signature verified"

scan: sbom ## Scan for vulnerabilities
	@grype sbom:sbom.spdx.json --fail-on high
	@npm audit --audit-level=moderate
	@echo "✅ Vulnerability scan complete"

compliance: sbom ## Check license compliance
	@node scripts/license-compliance.js sbom.spdx.json
	@echo "✅ License compliance checked"

slsa-verify: ## Verify SLSA compliance
	@./scripts/verify-slsa.sh $(IMAGE) $(IDENTITY)
	@echo "✅ SLSA compliance verified"

supply-chain-check: sbom sign verify scan compliance slsa-verify ## Full supply chain security check
	@echo "🎉 Supply chain security check complete!"
```

## Integration Examples

### GitHub Actions Integration
```yaml
- uses: anchore/sbom-action@v0
  with:
    format: spdx-json

- uses: aquasecurity/trivy-action@master
  with:
    scan-type: 'fs'
    scan-ref: '.'

- uses: sigstore/cosign-installer@v3
- run: cosign sign --yes ${{ env.IMAGE }}
```

### Jenkins Integration
```groovy
pipeline {
    stages {
        stage('Generate SBOM') {
            steps {
                sh 'syft . -o spdx-json > sbom.json'
            }
        }
        stage('Scan') {
            steps {
                sh 'grype sbom:sbom.json --fail-on high'
            }
        }
        stage('Sign') {
            steps {
                sh 'cosign sign-blob --key cosign.key sbom.json'
            }
        }
    }
}
```

### Kubernetes Admission Control
```yaml
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: require-sbom-attestation
spec:
  validationFailureAction: enforce
  background: false
  rules:
    - name: check-sbom
      match:
        any:
        - resources:
            kinds:
            - Pod
      verifyImages:
      - imageReferences:
        - "*"
        attestations:
        - predicateType: https://spdx.dev/Document
          conditions:
          - all:
            - key: "{{ time_since('', '{{metadata.creationTimestamp}}', '') }}"
              operator: LessThan
              value: "24h"
```

## Compliance & Reporting

### Monthly Supply Chain Report Template
```markdown
# Supply Chain Security Report - [Month Year]

## Executive Summary
- Total artifacts scanned: X
- Vulnerabilities found: X (Critical: X, High: X)
- License violations: X
- SLSA compliance rate: X%

## Key Metrics
| Metric | This Month | Last Month | Trend |
|--------|------------|------------|-------|
| SBOM Coverage | X% | X% | ↑ |
| Mean Time to Patch | X days | X days | ↓ |
| Signature Verification Rate | X% | X% | → |

## Critical Findings
[List any critical issues]

## Recommendations
[Improvement recommendations]

## Compliance Status
- [ ] All production images signed
- [ ] SBOM for all deployments
- [ ] No critical vulnerabilities
- [ ] License compliance achieved
```

---

*Version: 1.0*
*Last Updated: January 2025*
*Next Review: April 2025*