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

## Getting Started

### Prerequisites

- Python 3.9+
- Git

### Installation

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

### Run the Application

```bash
python app.py
```

## Usage

1. Open your browser and go to `http://127.0.0.1:5000`
2. You will see the list of current crop prices.
3. Click "Admin Panel" to update a price and see it reflect on the main page.

## Project Structure

```text
agriprice-alert/
├── .github/
│   └── CODEOWNERS
├── templates/
│   ├── index.html
│   └── admin.html
├── .gitignore
├── LICENSE
├── README.md
├── app.py
└── requirements.txt
```

## Links

- Project Board: https://github.com/users/Rwema01/projects/2

## License

MIT
