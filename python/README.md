# SO Python Application example

### Build with Nixpacks (Option 1)

```shell
nixpacks build . --name app-by-nixpacks:0.1.0
```

### Build with custom Dockerfile (Option 2)

Build image:

```shell
docker build -t app-by-dockerfile:0.1.0 -f Dockerfile .
```

> It creates a small image size, but requires the custom Dockerfile.

### Test

Run App on localhost:

```shell
docker run --rm -p 127.0.0.1:8080:8080 --name app -d app-by-nixpacks:0.1.0
```
or

```shell
docker run --rm -p 127.0.0.1:8080:8080 --name app -d app-by-dockerfile:0.1.0
```

Test App

```shell
curl localhost:8080
```

Stop App

```shell
docker stop app
```
