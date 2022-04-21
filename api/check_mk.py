#!/usr/bin/python3

# from config import log
import host
import typer

app = typer.Typer()
app.add_typer(host.app, name="host")


if __name__ == "__main__":
    app()
