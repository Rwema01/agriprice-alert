# Changelog

All notable changes to the AgriPrice Alert project will be documented in this file.

## [Summative] - 2026-11-24
### Added
- Complete end-to-end Git-to-Production pipeline.
- Terraform provisioning for Azure Bastion Host, Private Subnet, Azure PostgreSQL Database, and Azure Container Registry (ACR).
- Ansible playbook configured to SSH via Bastion and deploy from ACR.
- Continuous Deployment (`cd.yml`) pipeline automating image push and Ansible execution.

### Changed
- Migrated application database from local SQLite to Azure PostgreSQL.
- Updated Dockerfile to include PostgreSQL dependencies.

## [Formative 3] - 2026-11-13
### Added
- Terraform Infrastructure as Code (VNet, VMs, NSGs).
- Ansible configuration management.
- DevSecOps security scans (Checkov, Trivy, pip-audit).

## [Formative 2] - 2026-10-31
### Added
- Multi-stage Dockerfile and Docker Compose.
- CI Pipeline (`ci.yml`) with Ruff and Pytest.

## [Formative 1] - 2026-10-23
### Added
- Initial Flask application with SQLite.
- Project board and branch protection.