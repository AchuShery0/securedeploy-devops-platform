from app import create_app


def setup_app():
    app = create_app()
    app.config["TESTING"] = True
    return app.test_client()


def test_home_endpoint():
    client = setup_app()
    response = client.get("/")

    assert response.status_code == 200
    assert response.json["application"] == "SecureDeploy"


def test_health_endpoint():
    client = setup_app()
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json["status"] == "healthy"
