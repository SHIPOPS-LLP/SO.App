#!/bin/env python3

import sys

from so_app.service import AppService


if __name__ == "__main__":
    service = AppService()

    if len(sys.argv) > 1:
        response = " ".join(sys.argv[1:])
        service.run(response=response)
    else:
        service.run()
