# Changelog

All notable changes to the AgriPrice Alert project will be documented in this file.

## [Summative] - 2026-11-24
### Added
- Complete end-to-end Git-to-Production pipeline.
- Terraform provisioning for Bastion Host, Private Subnet, RDS Database, and ECR Registry.
- Ansible playbook configured to SSH via Bastion and deploy from ECR.
- Continuous Deployment (`cd.yml`) pipeline automating image push and Ansible execution.

### Changed
- Migrated application database from local SQLite to AWS RDS (PostgreSQL).
- Updated Dockerfile to include PostgreSQL dependencies.

## [Formative 3] - 2026-11-13
### Added
- Terraform Infrastructure as Code (VPC, EC2, Security Groups).
- Ansible configuration management.
- DevSecOps security scans (Checkov, pip-audit, Trivy).

## [Formative 2] - 2026-10-31
### Added
- Multi-stage Dockerfile and Docker Compose.
- CI Pipeline (`ci.yml`) with Ruff and Pytest.

## [Formative 1] - 2026-10-23
### Added
- Initial Flask application with SQLite.
- Project board and branch protection.