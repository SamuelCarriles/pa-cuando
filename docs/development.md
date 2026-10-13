# Guía de desarrollo con Nix

Este proyecto proporciona un entorno de desarrollo reproducible mediante Nix flakes. El entorno incluye Node.js 24, Docker y comandos auxiliares para construir y ejecutar la aplicación, así como para publicar imágenes Docker en GitHub Container Registry (GHCR).

## Requisitos

* [Nix](https://nixos.org/download/) con soporte para flakes.
* [Docker](https://docs.docker.com/get-started/get-docker/) instalado y funcionando.

## Configuración del entorno

Clona el repositorio y entra en su directorio:

```bash
git clone https://github.com/SamuelCarriles/pa-cuando.git
cd pa-cuando
```

Activa el entorno de desarrollo:

```bash
nix develop
```

Esto proporciona las herramientas y los comandos auxiliares definidos por el proyecto.

Si utilizas `direnv` y tienes configurado `use flake` en tu `.envrc`, el entorno también puede activarse automáticamente al entrar en el directorio.

## Comandos disponibles

Los siguientes comandos están disponibles dentro del entorno de desarrollo.

| Comando             | Descripción                                                                     |
| ------------------- | ------------------------------------------------------------------------------- |
| `build`             | Construye la aplicación TypeScript.                                             |
| `start`             | Ejecuta la aplicación mediante el script `npm start`.                           |
| `server-up`         | Construye la aplicación y, si la compilación termina correctamente, la ejecuta. |
| `release <version>` | Construye una imagen Docker y la publica en GHCR con la versión indicada.       |

Por ejemplo, para construir y ejecutar la aplicación:

```bash
build
start
```

O para realizar ambas operaciones consecutivamente:

```bash
server-up
```

## Publicación de imágenes Docker

El proyecto permite construir una imagen Docker mediante Nix y publicarla en GitHub Container Registry.

### 1. Autenticación en GHCR

Necesitas un token personal de GitHub con los permisos necesarios para publicar paquetes, normalmente `write:packages`.

Autentícate con:

```bash
sudo docker login ghcr.io -u TU_USUARIO
```

Cuando Docker solicite la contraseña, introduce el token.

> [!NOTE]
>  al utilizar `sudo`, Docker guarda y consulta las credenciales de root. Por eso, la autenticación y los comandos Docker del script de publicación utilizan el mismo contexto.

### 2. Publicar una versión

Desde el entorno de desarrollo, ejecuta:

```bash
release 0.1.0
```

El script realiza estas operaciones:

1. Construye la imagen Docker con `nix build .#default`.
2. Carga la imagen resultante en Docker.
3. Etiqueta la imagen local `pa-cuando:latest` con la versión indicada.
4. Publica la imagen versionada en GHCR.

La imagen publicada tendrá este formato:

```text
ghcr.io/samuelcarriles/pa-cuando:0.1.0
```

Sustituye `0.1.0` por la versión que quieras publicar.

### 3. Usar una imagen publicada

Una vez publicada, puedes descargar una versión con:

```bash
docker pull ghcr.io/samuelcarriles/pa-cuando:0.1.0
```

Y ejecutarla con:

```bash
docker run --rm -p 3000:3000 \
  ghcr.io/samuelcarriles/pa-cuando:0.1.0
```

Ajusta el puerto y añade las variables de entorno necesarias según la configuración de la aplicación.

## Organización de Nix

La configuración se divide en varios archivos:

* `flake.nix`: define los inputs y los sistemas compatibles, y reúne los módulos de Nix.
* `nix/devshell.nix`: configura el entorno de desarrollo y expone los comandos auxiliares.
* `nix/scripts.nix`: define los comandos `build`, `start`, `server-up` y `release`.
* `nix/packages.nix`: define el paquete de la aplicación y la imagen Docker.
* `scripts/release.sh`: contiene la lógica del proceso de publicación.

Esta separación mantiene la configuración del entorno, la construcción del paquete y las operaciones de publicación en archivos independientes.

