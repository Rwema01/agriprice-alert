from unittest.mock import patch, MagicMock
from app import app

@patch('app.get_db')
def test_home_status_code(mock_get_db):
    # 1. Create a fake database connection and cursor
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    
    # 2. Tell the fake cursor what to return when fetchall() is called
    mock_cursor.fetchall.return_value = [
        {'crop': 'Maize', 'price': 250.00},
        {'crop': 'Beans', 'price': 600.00}
    ]
    
    # 3. Tell the fake connection to return the fake cursor
    mock_conn.cursor.return_value = mock_cursor
    
    # 4. Tell the patched get_db() to return the fake connection
    mock_get_db.return_value = mock_conn

    # 5. Now run the test
    client = app.test_client()
    response = client.get('/')
    
    # 6. Check the result
    assert response.status_code == 200