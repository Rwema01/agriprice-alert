# AgriPrice Alert
**Real-time crop price tracking for smallholder farmers.**

## Problem Statement
Smallholder farmers in Africa often lack access to current market prices, forcing them to sell to middlemen at unfavorable rates. This project addresses that gap by making real-time pricing information accessible.

## Target Users
Smallholder farmers and agricultural traders across East Africa.

## Core Features
1. View current prices for staple crops (Maize, Beans, Rice).
2. Admin panel to update crop prices.
3. Simple, mobile-friendly interface (planned for future iterations).

## Technology Stack
- **Backend:** Python (Flask)
- **Database:** SQLite
- **Frontend:** HTML/CSS

## How to Run Locally

1. Clone the repository:
   `git clone https://github.com/Rwema01/agriprice-alert.git`
2. Navigate into the project directory:
   `cd agriprice-alert`
3. Create a virtual environment:
   `python -m venv venv`
4. Activate the virtual environment:
   - On Windows: `venv\Scripts\activate`
   - On Mac/Linux: `source venv/bin/activate`
5. Install the required dependencies:
   `pip install -r requirements.txt`
6. Run the application:
   `python app.py`
7. Open your browser and go to `http://127.0.0.1:5000`

## Team
- **Rwema Gisa:** DevOps Lead (Repository setup, CI/CD planning, Branch Protection)
- **Kelly Dushimimana:** App Lead (Flask application, Templates, Database)

## License
MIT
