import os
import psycopg2
from psycopg2.extras import RealDictCursor
from flask import Flask, redirect, render_template, request, url_for

app = Flask(__name__)

def get_db():
    # Connect to RDS using environment variables
    conn = psycopg2.connect(
        host=os.environ.get('DB_HOST'),
        database=os.environ.get('DB_NAME', 'agriprice'),
        user=os.environ.get('DB_USER'),
        password=os.environ.get('DB_PASSWORD')
    )
    return conn

def init_db():
    try:
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS prices (
                crop VARCHAR(50) PRIMARY KEY, 
                price REAL
            )
        ''')
        cursor.execute("SELECT COUNT(*) FROM prices")
        if cursor.fetchone()[0] == 0:
            cursor.execute("INSERT INTO prices VALUES ('Maize', 250.00), ('Beans', 600.00), ('Rice', 400.00)")
        conn.commit()
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Database connection failed: {e}")

@app.route('/')
def index():
    conn = get_db()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM prices')
    crops = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('index.html', crops=crops)

@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if request.method == 'POST':
        crop = request.form['crop']
        price = request.form['price']
        conn = get_db()
        cursor = conn.cursor()
        cursor.execute('UPDATE prices SET price = %s WHERE crop = %s', (price, crop))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('index'))
    conn = get_db()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM prices')
    crops = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('admin.html', crops=crops)

@app.route('/health')
def health_check():
    return {"status": "healthy"}, 200

if __name__ == '__main__':
    init_db()
    app.run(debug=True)