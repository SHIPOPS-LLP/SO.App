# SO NextJS Application example

### Build with Nixpacks (Option 1)

```shell
nixpacks build . --name app-by-nixpacks:0.1.0
```

### Build with custom Dockerfile (Option 2)

```shell
docker build -t app-by-dockerfile:0.1.0 -f Dockerfile .
```

### Build with custom Shell-script (Option 3)

**Bash/Linux/macOS:**
```shell
SO_APP_NAME=app-by-shell SO_APP_VERSION=0.1.0 bash ./build.sh
```

**PowerShell (Windows):**
```powershell
bash -c 'SO_APP_NAME=app-by-shell SO_APP_VERSION="0.1.0" ./build.sh'
```

### Run App on localhost:

**Nixpacks version:**
```shell
docker run --rm -p 127.0.0.1:3000:3000 --name app -d app-by-nixpacks:0.1.0
```

**Dockerfile version:**
```shell
docker run --rm -p 127.0.0.1:3000:3000 --name app -d app-by-dockerfile:0.1.0
```

**Shell script version:**
```shell
docker run --rm -p 127.0.0.1:3000:3000 --name app -d app-by-shell:0.1.0
```

### Test

```shell
curl localhost:3000
```

Stop App

```shell
docker stop app
```

### Notes

- Uses standard Next.js build (without standalone mode) for better Nixpacks compatibility.
- Both Docker and Nixpacks use `npm run start` for consistent behavior.
- Build arg `APP_RESPONSE` is injected into the container as env; app usage optional.
