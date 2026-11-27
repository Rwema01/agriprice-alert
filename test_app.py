from unittest.mock import MagicMock, patch

from app import app


@patch("app.get_db")
def test_home_status_code(mock_get_db):
    mock_conn = MagicMock()
    mock_cursor = MagicMock()

    mock_cursor.fetchall.return_value = [
        {"crop": "Maize", "price": 250.00},
        {"crop": "Beans", "price": 600.00},
    ]

    mock_conn.cursor.return_value = mock_cursor
    mock_get_db.return_value = mock_conn

    client = app.test_client()
    response = client.get("/")

    assert response.status_code == 200
    mock_conn.close.assert_called_once()


def test_add_rejects_invalid_price():
    client = app.test_client()

    response = client.post(
        "/prices/add",
        data={
            "crop": "Maize",
            "district": "Gasabo",
            "sector": "Kimironko",
            "price": "-100",
            "unit": "kg",
        },
    )

    assert response.status_code == 400


def test_edit_rejects_invalid_price():
    client = app.test_client()

    response = client.post(
        "/prices/1/update",
        data={
            "crop": "Maize",
            "district": "Gasabo",
            "sector": "Kimironko",
            "price": "0",
            "unit": "kg",
        },
    )

    assert response.status_code == 400


def test_add_requires_csrf_token():
    app.config["WTF_CSRF_ENABLED"] = True
    client = app.test_client()

    response = client.post(
        "/prices/add",
        data={
            "crop": "Maize",
            "district": "Gasabo",
            "sector": "Kimironko",
            "price": "250",
            "unit": "kg",
        },
    )

    assert response.status_code == 400
