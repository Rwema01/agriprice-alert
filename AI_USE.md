# AI Use Annex

**Project:** AgriPrice Alert - Formative 3
**Team:** Rwema Gisa & Kelly Nshuti Dushimimana

## 1. AI Use Declaration
We did not use AI to generate our core DevOps code. The following files were written manually by the team, with AI used only as a debugging assistant to interpret error logs:
- Terraform configurations (`terraform/main.tf`, `variables.tf`, `outputs.tf`, `modules/`)
- Ansible playbook (`ansible/playbook.yml`, `inventory.ini`, `roles/`)
- GitHub Actions workflow (`.github/workflows/ci.yml`)

## 2. Summary of AI Usage for Other Parts
- **Dockerfile:** AI was used to help understand the syntax for multi-stage builds and the `HEALTHCHECK` command. The final implementation was reviewed and committed by us.
- **README.md & SECURITY.md:** AI was used to help structure and format the Markdown for clarity and professionalism, ensuring we met the rubric requirement for documenting findings and remediation.
- **Debugging:** AI was used to help interpret Checkov, Trivy, and pip-audit error logs (e.g., identifying specific rule IDs like `CKV_AWS_21` and CVE identifiers) so we could manually add the correct skip rules and dependency upgrades.

## 3. Modifications
All AI-suggested changes were reviewed, adapted to our specific project architecture, and manually committed by the team. The decision-making for what to skip, what to upgrade, and how to structure the pipeline was done entirely by Rwema and Kelly.

## 4. Declaration
We confirm that no AI tools were used to generate the Terraform configurations, Ansible playbooks, or GitHub Actions workflow files, in accordance with the course AI Use Policy.