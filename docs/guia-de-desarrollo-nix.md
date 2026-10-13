# Guía de desarrollo con Nix

Este proyecto proporciona un entorno de desarrollo reproducible mediante Nix flakes. El entorno incluye Node.js 24, Docker y comandos auxiliares para construir y ejecutar la aplicación, así como para construir y publicar imágenes Docker en GitHub Container Registry (GHCR).

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

| Comando                | Descripción                                                               |
| ---------------------- | ------------------------------------------------------------------------- |
| `build`                | Construye la aplicación TypeScript mediante `npm run build`.              |
| `run`                  | Ejecuta la aplicación mediante `npm start`.                               |
| `build-image`          | Construye la imagen Docker con Nix y la carga en Docker local.            |
| `tag-image <version>`  | Etiqueta la imagen local con la versión indicada para publicarla en GHCR. |
| `push-image <version>` | Publica en GHCR la imagen etiquetada con la versión indicada.             |

### Desarrollo de la aplicación

Para construir la aplicación:

```bash
build
```

Para ejecutar la aplicación:

```bash
run
```

El comando `run` ejecuta `npm start`, por lo que la aplicación debe estar construida previamente si ese script utiliza los archivos generados en `dist/`.

### Construcción y publicación de imágenes Docker

La publicación se divide en tres operaciones independientes. Esto permite repetir únicamente el paso que haya fallado, sin reconstruir la imagen innecesariamente.

#### 1. Construir la imagen

```bash
build-image
```

Este comando construye la imagen mediante `nix build .#default` y carga el resultado en Docker local con la etiqueta `pa-cuando:latest`.

#### 2. Etiquetar la imagen

```bash
tag-image 0.1.0
```

Este comando asigna a la imagen local una etiqueta con la versión que deseas publicar.

Por ejemplo, la imagen quedará etiquetada como:

```text
ghcr.io/samuelcarriles/pa-cuando:0.1.0
```

La imagen local original `pa-cuando:latest` se conserva.

#### 3. Publicar la imagen

```bash
push-image 0.1.0
```

Este comando publica en GHCR la imagen que ya tiene la etiqueta correspondiente.

Sustituye `0.1.0` por la versión que quieras publicar.

Si el envío falla por un problema de conexión, puedes volver a ejecutar `push-image` con la misma versión, siempre que la imagen siga disponible localmente y conserve su etiqueta.

## Autenticación en GHCR

Para publicar imágenes necesitas autenticarte en GitHub Container Registry. Utiliza un token personal de GitHub con los permisos necesarios para publicar paquetes, normalmente `write:packages`.

Ejecuta:

```bash
sudo docker login ghcr.io -u TU_USUARIO
```

Cuando Docker solicite la contraseña, introduce el token de GitHub.

> [!NOTE]
>  como los comandos de publicación utilizan `sudo docker`, la autenticación también debe realizarse con `sudo`. Docker almacena y consulta las credenciales del usuario root en este caso.

## Descargar y ejecutar una imagen publicada

Una vez publicada, puedes descargar una versión con:

```bash
docker pull ghcr.io/samuelcarriles/pa-cuando:0.1.0
```

Y ejecutarla con:

```bash
docker run --rm -p 3000:3000 \
  ghcr.io/samuelcarriles/pa-cuando:0.1.0
```

Ajusta el puerto y proporciona las variables de entorno necesarias según la configuración de la aplicación. Si la aplicación depende de MongoDB, también tendrás que proporcionar acceso a una instancia de ese servicio.

## Organización de Nix

La configuración se divide en los siguientes archivos:

* `flake.nix`: define los inputs, los sistemas compatibles y los módulos que componen la configuración.
* `nix/devshell.nix`: configura el entorno de desarrollo y selecciona los comandos que estarán disponibles.
* `nix/scripts.nix`: define los comandos auxiliares y sus dependencias de ejecución.
* `nix/packages.nix`: define el paquete de la aplicación y la imagen Docker.
* `scripts/build-image.sh`: contiene la lógica para construir la imagen y cargarla en Docker.
* `scripts/tag-image.sh`: contiene la lógica para etiquetar la imagen con una versión.
* `scripts/push-image.sh`: contiene la lógica para publicar la imagen en GHCR.

Esta separación mantiene la configuración del entorno, la construcción de la imagen y las operaciones de publicación en componentes independientes.

