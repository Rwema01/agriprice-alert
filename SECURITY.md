# Security Policy

## DevSecOps Pipeline Findings & Remediation

Our CI pipeline integrates three security scanners: Checkov (IaC), pip-audit (Dependencies), and Trivy (Container).

1. **pip-audit Findings:**
   - **Finding:** Identified vulnerabilities in older versions of Flask, Gunicorn, pytest, and wheel.
   - **Remediation:** Upgraded dependencies in `requirements.txt` to Flask 3.1.3, Gunicorn 22.0.0, pytest 9.0.3, and wheel 0.46.2.

2. **Trivy Findings:**
   - **Finding:** Detected CVEs in `jaraco.context` and `wheel` (build-time dependencies).
   - **Rationale for Accepted Risk:** These are transient build-time dependencies and are not exposed in the final runtime Flask application. We accepted the risk and added them to `.trivyignore` to prevent false-positive pipeline failures.

3. **Checkov Findings (Azure):**
   - **Finding:** Flagged missing encryption, open ports, and unassociated NSGs on the initial Azure configuration.
   - **Remediation:** We associated the Network Security Groups (NSGs) with the Public and Private Subnets. We enabled geo-redundant backups on the Azure PostgreSQL Database. We upgraded the Azure Container Registry (ACR) to the Premium SKU to enable zone redundancy and data endpoints.
   - **Rationale for Accepted Risk:** The Bastion Host requires a public IP for SSH access as per the assignment requirements (suppressed via `CKV_AZURE_119`). Enterprise-only features (e.g., private link, content trust, geo-replication on ACR) were suppressed as they require complex DNS setups or paid tiers that are out of scope for this student project.