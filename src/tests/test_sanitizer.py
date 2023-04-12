from fastapi.testclient import TestClient
from fastapi import FastAPI

from ..main import app

client = TestClient(app=app)


def test_version():
    response = client.get('/version')
    assert response.status_code == 200
    assert response.json() == {"version": "0.1.2"}


def test_empty_body():
    data = {"data": "", "replacement_email": "test@example.com"}
    response = client.post('/sanitize', json=data)
    assert response.status_code == 400
    assert response.json()['data'] == "Data field cannot be empty"

def test_success():
    data = {
        "data": "This is to check that test.something@dans.knaw.nl is properly sanitized.",
        "replacement_email": "test@example.com"
    }
    response = client.post('/sanitize', json=data)
    assert response.status_code == 200
    assert response.json()['data'] == "This is to check that test@example.com is properly sanitized."
