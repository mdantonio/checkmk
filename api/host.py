from typing import Optional

import typer
from config import log, send_request

app = typer.Typer()


@app.command()
def create(
    host: str = typer.Option(..., help="Host URL (http(s)://yourhostname/"),
    username: str = typer.Option(..., help="Your username"),
    password: str = typer.Option(
        ..., help="Your password", prompt=True, hide_input=True
    ),
    folder: str = typer.Option(..., help="Host folder"),
    name: str = typer.Option(..., help="Host name"),
    ip: str = typer.Option(
        None, help="Host ip. Will not be used if a parent is specified"
    ),
    parent: Optional[str] = typer.Option(
        None, help="Name of parent host (the will be assumed to be a docker container)"
    ),
) -> bool:

    folder = folder.lower()

    # Create a host

    if not ip and not parent:
        log.critical("IP address nor parent specified, add one of --ip or --parent")
        return False

    if parent is None:

        r = send_request(
            host=host,
            endpoint="domain-types/host_config/collections/all",
            username=username,
            password=password,
            data={
                "attributes": {"ipaddress": ip},
                "folder": f"/{folder}",
                "host_name": name,
            },
        )
    else:
        r = send_request(
            host=host,
            endpoint="domain-types/host_config/collections/all",
            username=username,
            password=password,
            data={
                "attributes": {
                    "parents": [parent],
                    "tag_address_family": "no-ip",
                    "tag_agent": "no-agent",
                    "tag_piggyback": "piggyback",
                },
                "folder": f"/{folder}",
                "host_name": name,
            },
        )

    if r.status_code != 200:
        log.error("Host creation failed, status code = {}", r.status_code)
        log.info("{}", r.json())
        return False

    log.info(r.status_code)

    # Execute a service discovery on a host

    r = send_request(
        host=host,
        endpoint=f"objects/host/{name}/actions/discover_services/invoke",
        username=username,
        password=password,
        data={"mode": "refresh"},
    )

    if r.status_code != 200:
        log.error("Service discovery failed, status code = {}", r.status_code)
        log.info("{}", r.json())
        return False

    log.info(r.status_code)

    # Activate pending changes

    r = send_request(
        host=host,
        endpoint="domain-types/activation_run/actions/activate-changes/invoke",
        username=username,
        password=password,
        data={
            # This activates changes also for other users... :o
            "force_foreign_changes": True,
            "redirect": False,
            "sites": [],
        },
    )

    if r.status_code != 200:
        log.error("Pending changes activation failed, status code = {}", r.status_code)
        log.info("{}", r.json())
        return False

    log.info(r.status_code)

    return True


if __name__ == "__main__":
    app()
