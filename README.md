# AgriPrice Alert

Real-time crop price tracking for smallholder farmers.

## African Context

Smallholder farmers in Africa often lack access to current market prices, forcing them to sell to middlemen at unfavorable rates. This project addresses that gap by making real-time pricing information accessible, directly empowering farmers to make better financial decisions.

## Team Members

- Rwema Gisa - DevOps Lead - 1489019427
- Kelly Nshuti Dushimimana - App Lead - 5830290256

## Project Overview

AgriPrice Alert is a web application designed to bridge the information gap in the agricultural sector. It allows users to view current market prices for staple crops like Maize, Beans, and Rice. The application features a simple, mobile-friendly interface where farmers can check prices. It also includes an admin panel that allows administrators to update the crop prices in the database to keep the data current and accurate.

## Target Users

Smallholder farmers and agricultural traders across East Africa.

## Core Features

- **Feature 1:** View current prices for staple crops (Maize, Beans, Rice).
- **Feature 2:** Admin panel to update crop prices.
- **Feature 3:** Health check endpoint (`/health`) for container monitoring.
- **Feature 4:** Fully automated DevSecOps CI/CD pipeline with security scans.

## Technology Stack

- **Backend:** Python (Flask), Gunicorn
- **Frontend:** HTML/CSS
- **Database:** SQLite
- **Containerization:** Docker (Multi-stage build), Docker Compose
- **Infrastructure as Code:** Terraform (Modular VPC, EC2, NSG)
- **Configuration Management:** Ansible (Roles, SSH Hardening, UFW)
- **CI/CD & Security:** GitHub Actions, Ruff, Pytest, Checkov, pip-audit, Trivy

## DevSecOps Pipeline (Formative 3)

This project includes a fully automated CI/CD pipeline that runs on every push and pull request to ensure code quality, security, and reliability.

1.  **Lint & Test:** Uses `Ruff` for Python linting and `Pytest` for unit tests.
2.  **Build:** Creates a secure, multi-stage Docker image using a non-root user.
3.  **Security Scans:**
    -   **Checkov:** Scans Terraform files for AWS misconfigurations.
    -   **pip-audit:** Scans Python dependencies for known vulnerabilities (CVEs).
    -   **Trivy:** Scans the final Docker container image for OS and library vulnerabilities.

## Getting Started

### Option 1: Running with Docker Compose (Recommended)

1. Ensure you have Docker Desktop installed and running.
2. Clone the repository and navigate into the project directory.
3. Run the following command:
   ```bash
   docker-compose up --build
   ```
4. Open your browser and go to http://localhost:5000

### Option 2: Running Locally with Python

#### Prerequisites

- Python 3.9+
- Git

#### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Rwema01/agriprice-alert.git
   ```
2. Navigate into the project directory:
   ```bash
   cd agriprice-alert
   ```
3. Create a virtual environment:
   ```bash
   python -m venv venv
   ```
4. Activate the virtual environment:
   - On Windows:
     ```bash
     venv\Scripts\activate
     ```
   - On Mac/Linux:
     ```bash
     source venv/bin/activate
     ```
5. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

#### Run the Application

```bash
python app.py
```

## Usage

1. Open your browser and go to http://127.0.0.1:5000 (or http://localhost:5000 if using Docker).
2. You will see the list of current crop prices.
3. Click Admin Panel to update a price and see it reflect on the main page.

## Project Structure

```text
agriprice-alert/
├── .github/
│   ├── CODEOWNERS
│   └── workflows/
│       └── ci.yml
├── ansible/
│   ├── inventory.ini
│   ├── playbook.yml
│   ├── README.md
│   └── roles/
│       └── app_deploy/
│           ├── handlers/
│           │   └── main.yml
│           └── tasks/
│               └── main.yml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── README.md
│   └── modules/
│       └── vpc_compute/
│           └── main.tf
├── templates/
│   ├── index.html
│   └── admin.html
├── .dockerignore
├── .gitignore
├── .trivyignore
├── Dockerfile
├── docker-compose.yml
├── LICENSE
├── README.md
├── SECURITY.md
├── app.py
├── requirements.txt
└── test_app.py
```

## Links

- Project Board: https://github.com/Rwema01/projects/2

## License

MIT

## AI Use Declaration

We used AI tools for documentation formatting, Markdown writing, and debugging error logs (as permitted by the course policy). All core Terraform, Ansible, and CI YAML configurations were written manually. For full details, please read our [AI Use Annex](./AI_USE.md).