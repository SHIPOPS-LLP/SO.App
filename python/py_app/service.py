import os
import sys
import uvicorn
import json

from typing import Optional
from pathlib import Path
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.openapi.docs import get_swagger_ui_html
from fastapi.openapi.utils import get_openapi
from fastapi.responses import JSONResponse, PlainTextResponse

from py_app.app_info import AppInfo


class AppService:
    app_info = AppInfo()

    def __init__(self):
        api = FastAPI(docs_url=None)

        self._response = None

        api.mount(
            "/static",
            StaticFiles(directory=self.get_resource_path("static")),
            name="static",
        )

        @api.get("/docs", include_in_schema=False)
        async def custom_swagger_ui_html():
            title = f"{self.app_info.name} API Docs"
            return get_swagger_ui_html(
                openapi_url="/shipops.json",
                title=title,
                swagger_favicon_url="/static/favicon.png",
                swagger_ui_parameters={"defaultModelsExpandDepth": -1},
            )

        @api.get("/shipops.json", include_in_schema=False)
        async def openapi():
            title = f"{self.app_info.name} API"
            return get_openapi(
                title=title,
                version=self.app_info.version,
                description=self.app_info.description,
                routes=api.routes,
            )

        @api.get("/")
        def main():
            return self._main()

        self._api = api

    @property
    def api(self):
        return self._api

    @property
    def response(self) -> str:
        if self._response is None:
            raise ValueError("Response was not set")
        return self._response

    @response.setter
    def response(self, response: str):
        self._response = response

    def _main(self):
        """Business logic is here"""
        result = self.response

        if (result.startswith("{") and result.endswith("}")) or (
            result.startswith("[") and result.endswith("]")
        ):
            return JSONResponse(json.loads(result))

        return PlainTextResponse(content=result)

    @staticmethod
    def get_resource_path(relative_path: Path) -> Path:
        """Get the absolute path to the resource, works for dev and for PyInstaller"""
        try:
            # PyInstaller creates a temp folder and stores path in _MEIPASS
            base_path = sys._MEIPASS
        except AttributeError:
            base_path = os.path.abspath(".")

        return Path(base_path) / relative_path

    def run(
        self,
        api_ip: Optional[str] = "0.0.0.0",
        port: Optional[int] = 8080,
        response: Optional[str] = "{}",
    ):
        self.response = response
        uvicorn.run(
            self.api,
            host=api_ip,
            port=port,
        )
