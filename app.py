import os
import sqlite3

from flask import Flask, redirect, render_template, request, url_for

app = Flask(__name__)


def get_db():
    conn = sqlite3.connect('prices.db')
    conn.row_factory = sqlite3.Row
    return conn


def init_db():
    """Create the database and table if they don't exist yet."""
    if not os.path.exists('prices.db'):
        db = get_db()
        db.execute('CREATE TABLE prices (crop TEXT PRIMARY KEY, price REAL)')
        db.execute("INSERT INTO prices VALUES ('Maize', 250.00), ('Beans', 600.00), ('Rice', 400.00)")
        db.commit()
        db.close()


# Run the initialization when the app starts
init_db()


@app.route('/')
def index():
    db = get_db()
    crops = db.execute('SELECT * FROM prices').fetchall()
    db.close()
    return render_template('index.html', crops=crops)


@app.route('/admin', methods=['GET', 'POST'])
def admin():
    if request.method == 'POST':
        crop = request.form['crop']
        price = request.form['price']
        db = get_db()
        db.execute('UPDATE prices SET price = ? WHERE crop = ?', (price, crop))
        db.commit()
        db.close()
        return redirect(url_for('index'))
    db = get_db()
    crops = db.execute('SELECT * FROM prices').fetchall()
    db.close()
    return render_template('admin.html', crops=crops)


if __name__ == '__main__':
    app.run(debug=True)