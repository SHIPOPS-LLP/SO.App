__appname__="Py-App"
__appversion__="0.1.0"

class AppInfo:
    @property
    def name(self) -> str:
        return __appname__

    @property
    def version(self) -> str:
        return __appversion__

    @property
    def description(self) -> str:
        return "Backend application example for testing build system only"
