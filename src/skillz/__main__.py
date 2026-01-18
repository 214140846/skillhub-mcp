"""Console script entry point for the Skills MCP server."""

from ._server import main


def run() -> None:
    """Execute the CLI using the stored entry point."""

    main()


if __name__ == "__main__":
    run()
