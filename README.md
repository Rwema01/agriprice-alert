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

- Feature 1: View current prices for staple crops (Maize, Beans, Rice).
- Feature 2: Admin panel to update crop prices.
- Feature 3: Simple, mobile-friendly interface (planned for future iterations).

## Technology Stack

- Backend: Python (Flask)
- Frontend: HTML/CSS
- Database: SQLite
- DevOps: Docker, Docker Compose, GitHub Actions

## Getting Started

### Option 1: Running with Docker Compose (Recommended)

1. Ensure you have Docker Desktop installed and running.
2. Clone the repository and navigate into the project directory.
3. Run the following command:
   docker-compose up --build
4. Open your browser and go to http://localhost:5000

### Option 2: Running Locally with Python

#### Prerequisites

- Python 3.9+
- Git

#### Installation

1. Clone the repository:
   git clone https://github.com/Rwema01/agriprice-alert.git
2. Navigate into the project directory:
   cd agriprice-alert
3. Create a virtual environment:
   python -m venv venv
4. Activate the virtual environment:
   - On Windows:
     venv\Scripts\activate
   - On Mac/Linux:
     source venv/bin/activate
5. Install the required dependencies:
   pip install -r requirements.txt

#### Run the Application

python app.py

## Usage

1. Open your browser and go to http://127.0.0.1:5000 (or http://localhost:5000 if using Docker).
2. You will see the list of current crop prices.
3. Click Admin Panel to update a price and see it reflect on the main page.

## Project Structure

agriprice-alert/
├── .github/
│   ├── CODEOWNERS
│   └── workflows/
│       └── ci.yml
├── templates/
│   ├── index.html
│   └── admin.html
├── .dockerignore
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── LICENSE
├── README.md
├── app.py
├── requirements.txt
└── test_app.py

## Links

- Project Board: https://github.com/Rwema01/projects/2

## License

MIT
