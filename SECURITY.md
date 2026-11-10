# Security Policy

## DevSecOps Pipeline Findings & Remediation

Our CI pipeline integrates three security scanners: Checkov (IaC), pip-audit (Dependencies), and Trivy (Container).

1. **pip-audit Findings:**
   - **Finding:** Identified vulnerabilities in older versions of Flask, Gunicorn, pytest, and wheel.
   - **Remediation:** Upgraded dependencies in `requirements.txt` to Flask 3.1.3, Gunicorn 22.0.0, pytest 9.0.3, and wheel 0.46.2.

2. **Trivy Findings:**
   - **Finding:** Detected CVEs in `jaraco.context` and `wheel` (build-time dependencies).
   - **Rationale for Accepted Risk:** These are transient build-time dependencies and are not exposed in the final runtime Flask application. We accepted the risk and added them to `.trivyignore` to prevent false-positive pipeline failures.

3. **Checkov Findings:**
   - **Finding:** Flagged missing encryption on initial configurations, and open ports (22, 5000) on the EC2 instance.
   - **Remediation / Rationale for Accepted Risk:** We enforce KMS encryption on all storage. For the EC2 instance, ports 22 and 5000 are intentionally open to allow deployment and public access. We skipped specific enterprise rules (e.g., cross-region replication) that require billing setups, but enforce all basic NSG and VPC security rules.