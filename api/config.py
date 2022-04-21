from typing import Any, Dict

import requests
from loguru import logger as log
from requests import Response


def send_request(
    host: str, endpoint: str, username: str, password: str, data: dict[str, Any]
) -> Response:
    API_URL = f"{host}/cmk/check_mk/api/1.0"

    log.info("Sending request to {}/{}", API_URL, endpoint)
    return requests.post(
        f"{API_URL}/{endpoint}",
        headers={
            "Authorization": f"Bearer {username} {password}",
            "Accept": "application/json",
            "Content-Type": "application/json",
        },
        json=data,
    )


def get_host(
    host: str,
    username: str,
    password: str,
) -> None:
    API_URL = f"{host}/cmk/check_mk/api/1.0"
    import requests

    r = requests.get(
        f"{API_URL}//objects/host_config/{host}",
        headers={
            "Authorization": f"Bearer {username} {password}",
            "Accept": "application/json",
            "Content-Type": "application/json",
        },
    )
    print(r.json())
