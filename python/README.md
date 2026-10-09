# SO Python Application example

### Build with Railpack (Option 1)

```shell
railpack --verbose build . --name python-app-by-railpack:0.1.0
```
> (!) Follow railpack instructions to prepare buildkit before

### Build with Nixpacks (Option 1) (deprecated)

```shell
nixpacks build . --name python-app-by-nixpacks:0.1.0
```

### Build with custom Dockerfile (Option 2)

```shell
docker build -t python-app-by-dockerfile:0.1.0 -f Dockerfile .
```

> It creates a small image size, but requires the custom Dockerfile.

### Build with custom Shell-script (Option 3)

```shell
SO_APP_NAME=python-app-by-shell SO_APP_VERSION=0.1.0 bash ./build.sh
```

### Test

Run App on localhost:

```shell
docker run --rm -p 127.0.0.1:8080:8080 --name app -d python-app-by-nixpacks:0.1.0
```
or

```shell
docker run --rm -p 127.0.0.1:8080:8080 --name app -d python-app-by-dockerfile:0.1.0
```

Test App

```shell
curl localhost:8080
```

Stop App

```shell
docker stop app
```
