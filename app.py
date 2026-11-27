
import os

import psycopg2
from psycopg2.extras import RealDictCursor
from flask import Flask, render_template, request, redirect, url_for, flash
from flask_wtf.csrf import CSRFProtect

app = Flask(__name__)
app.secret_key = os.environ["FLASK_SECRET_KEY"]

CSRFProtect(app)

CROPS = [
    "Maize", "Beans", "Rice", "Irish potatoes",
    "Sweet potatoes", "Cassava", "Sorghum", "Wheat",
    "Soybeans", "Peas", "Groundnuts", "Tomatoes",
    "Onions", "Cabbages", "Carrots", "Avocados", "Bananas"
]

DISTRICTS = ["Gasabo", "Kicukiro", "Nyarugenge", "Rwamagana"]

UNITS = ["kg", "tonne", "piece", "bunch", "sack"]


def validate_price_form(form):
    from decimal import Decimal, InvalidOperation

    crop = form.get("crop", "").strip()
    district = form.get("district", "").strip()
    sector = form.get("sector", "").strip()
    raw_price = form.get("price", "").strip()
    unit = form.get("unit", "").strip()

    if crop not in CROPS:
        raise ValueError("Select a valid crop.")

    if district not in DISTRICTS:
        raise ValueError("Select a valid district.")

    if not sector or len(sector) > 100:
        raise ValueError("Sector must contain 1–100 characters.")

    if unit not in UNITS:
        raise ValueError("Select a valid unit.")

    try:
        price = Decimal(raw_price)
    except InvalidOperation:
        raise ValueError("Enter a valid price.")

    if not price.is_finite() or price <= 0:
        raise ValueError("Price must be greater than zero.")

    if price > Decimal("9999999999.99"):
        raise ValueError("Price is too large.")

    if price.as_tuple().exponent < -2:
        raise ValueError("Price cannot have more than two decimal places.")

    return crop, district, sector, price, unit


def get_db():
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        port=int(os.environ.get("DB_PORT", "5432")),
        database=os.environ.get("DB_NAME", "agriprice"),
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        sslmode=os.environ.get("DB_SSLMODE", "require")
    )


@app.route("/")
def index():
    crop = request.args.get("crop", "All")
    district = request.args.get("district", "All")

    if crop not in ["All"] + CROPS:
        crop = "All"

    if district not in ["All"] + DISTRICTS:
        district = "All"

    conn = get_db()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT id, crop, district, sector, price, unit,
                       recorded_at, is_sample
                FROM prices
                WHERE (%s = 'All' OR crop = %s)
                  AND (%s = 'All' OR district = %s)
                ORDER BY recorded_at DESC NULLS LAST, id DESC
            """, (crop, crop, district, district))

            market_prices = cursor.fetchall()
    finally:
        conn.close()

    return render_template(
        "index.html",
        market_prices=market_prices,
        crops=CROPS,
        districts=DISTRICTS,
        selected_crop=crop,
        selected_district=district
    )


@app.route("/prices/add", methods=["POST"])
def add_price():
    try:
        crop, district, sector, price, unit = validate_price_form(request.form)

        conn = get_db()
        try:
            with conn.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO prices
                        (crop, district, sector, price, unit, recorded_at, is_sample)
                    VALUES (%s, %s, %s, %s, %s, CURRENT_TIMESTAMP, FALSE)
                """, (crop, district, sector, price, unit))
            conn.commit()
        finally:
            conn.close()

        flash("Price added successfully.", "success")

    except (ValueError, psycopg2.Error):
        app.logger.exception("Could not add price.")
        flash("Could not add the price. Check your information.", "error")

    return redirect(url_for("index"))


@app.route("/prices/<int:price_id>/update", methods=["POST"])
def update_price(price_id):
    try:
        crop, district, sector, price, unit = validate_price_form(request.form)

        conn = get_db()
        try:
            with conn.cursor() as cursor:
                cursor.execute("""
                    UPDATE prices
                    SET crop = %s, district = %s, sector = %s,
                        price = %s, unit = %s
                    WHERE id = %s
                """, (crop, district, sector, price, unit, price_id))

                if cursor.rowcount == 0:
                    conn.rollback()
                    flash("Price record not found.", "error")
                    return redirect(url_for("index"))

            conn.commit()
        finally:
            conn.close()

        flash("Price updated successfully.", "success")

    except (ValueError, psycopg2.Error):
        app.logger.exception("Could not update price.")
        flash("Could not update the price. Check your information.", "error")

    return redirect(url_for("index"))


@app.route("/prices/<int:price_id>/delete", methods=["POST"])
def delete_price(price_id):
    conn = get_db()
    try:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM prices WHERE id = %s", (price_id,))
            if cursor.rowcount == 0:
                flash("Price record not found.", "error")
            else:
                flash("Price deleted successfully.", "success")
        conn.commit()
    except psycopg2.Error:
        conn.rollback()
        app.logger.exception("Could not delete price.")
        flash("Could not delete the price.", "error")
    finally:
        conn.close()

    return redirect(url_for("index"))


@app.route("/health")
def health_check():
    return {"status": "healthy"}, 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
