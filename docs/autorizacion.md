# Sistema de autorización

## 1. Objetivo

El sistema de autorización determina qué operaciones puede realizar cada usuario sobre los recursos de la aplicación.

La autorización se basa en permisos explícitos, organizados mediante roles y excepciones individuales. Los roles proporcionan conjuntos de permisos predeterminados, mientras que las excepciones permiten personalizar las capacidades de cada usuario sin tener que duplicar todos los permisos de su rol.

## 2. Permisos

Cada permiso representa una capacidad concreta y se identifica mediante una cadena con el siguiente formato:

`<entidad>.<acción>:<modificador>`

El modificador es opcional.

Ejemplos:

- `issue.read`
- `issue.create`
- `issue.edit-content:own`
- `issue.edit-state:in-charge`
- `comment.create`
- `comment.delete:own`
- `user.verify`
- `user.edit-profile`

La entidad identifica el tipo de recurso sobre el que se realiza la operación; la acción identifica la capacidad que se concede; y el modificador restringe el ámbito de aplicación del permiso cuando corresponda.

Los permisos deben ser suficientemente específicos para distinguir operaciones con propósitos diferentes. Por ejemplo, editar el contenido de una incidencia y modificar su estado son acciones distintas, al igual que editar el perfil de un usuario y cambiar su contraseña.

El catálogo de permisos válidos será definido por la aplicación. Los roles y las excepciones individuales podrán seleccionar permisos de ese catálogo, pero no introducir permisos arbitrarios.

## 3. Modificadores

Los modificadores permiten limitar el ámbito de un permiso sin necesidad de crear una acción diferente para cada situación.

Los modificadores contemplados inicialmente son:

- `own`: limita la operación a los recursos propios del usuario.
- `in-charge`: limita la operación a los recursos de los que el usuario es responsable.

Por ejemplo, `issue.edit-content:own` permite editar el contenido de las incidencias propias, mientras que `issue.edit-state:in-charge` permite modificar el estado de las incidencias de las que el usuario es responsable.

La comprobación del modificador depende de las relaciones existentes entre el usuario y el recurso. Por tanto, disponer de un permiso con modificador no concede automáticamente acceso a todos los recursos de esa entidad.

El formato definitivo de presentación y selección de los modificadores en la interfaz se definirá durante la implementación.

## 4. Roles

Un rol agrupa un conjunto de permisos predeterminados que pueden compartirse entre múltiples usuarios.

Cada usuario tendrá un rol asignado. Los roles no representan por sí mismos una autorización especial basada en su nombre: sus permisos determinan las capacidades que conceden.

Se contemplan inicialmente los siguientes roles:

- `user`: usuario ordinario.
- `area-manager`: usuario con permisos adicionales para gestionar las incidencias de las que es responsable.
- `admin`: administrador de la aplicación.
- `root`: usuario inicial con capacidad para configurar los permisos y administrar el sistema.

Estos roles constituyen una configuración inicial, no una jerarquía rígida impuesta por el código. Los permisos predeterminados de cada rol serán configurables por el usuario `root`.

La responsabilidad sobre un área o una incidencia se determina mediante las relaciones correspondientes del dominio, no únicamente por el rol del usuario. Por ejemplo, tener el rol `area-manager` no significa ser responsable de todas las incidencias.

## 5. Permisos individuales

Además de los permisos predeterminados del rol, cada usuario podrá tener excepciones individuales.

Estas excepciones se dividirán en dos conjuntos:

- `include`: permisos adicionales concedidos individualmente.
- `exclude`: permisos que se excluyen para ese usuario, aunque estén incluidos en los permisos predeterminados de su rol.

Los permisos efectivos se calcularán mediante la siguiente expresión:

`(permisos del rol ∪ include) \ exclude`

Si un mismo permiso aparece en los permisos concedidos y en los excluidos, prevalece la exclusión.

De esta forma, los usuarios comparten una configuración base y únicamente necesitan almacenar las diferencias individuales.

## 6. Configuración de roles y usuarios

El usuario `root` podrá configurar los permisos predeterminados de los roles y personalizar los permisos de usuarios concretos, tanto durante su creación como posteriormente.

Al crear un usuario, la aplicación tomará los permisos predeterminados del rol seleccionado y permitirá personalizarlos. Las diferencias se almacenarán como excepciones individuales, sin copiar todos los permisos del rol al documento del usuario.

Los cambios en los permisos predeterminados de un rol se aplicarán a las nuevas asignaciones de ese rol, pero no modificarán automáticamente las excepciones ni los permisos efectivos de los usuarios existentes. Los permisos de estos últimos se mantendrán determinados por su rol asignado y sus excepciones individuales.

La interfaz de administración podrá utilizar una representación estructurada de los permisos, agrupada por entidad, acción y modificador. Esta representación será independiente del formato utilizado para almacenarlos. Al recibir actualizaciones, el servidor validará los permisos y los convertirá al formato canónico antes de persistirlos.

## 7. Comprobación de permisos

La autorización se realizará comprobando los permisos efectivos del usuario, no comparando directamente el nombre de su rol.

Los permisos se almacenarán como cadenas y, cuando resulte conveniente, se transformarán en un conjunto (`Set`) durante la preparación del contexto de autorización. Esto permitirá comprobar eficientemente la pertenencia de un permiso al conjunto mediante operaciones como `Set.has()`.

La comprobación de un permiso no sustituye la validación del recurso concreto. Cuando existan modificadores, la aplicación deberá verificar también que se cumplan las condiciones correspondientes. Por ejemplo, para aplicar `issue.edit-state:in-charge`, deberá comprobarse que el usuario es responsable de la incidencia afectada.

## 8. Separación entre autorización y reglas de negocio

Los permisos determinan si un usuario dispone de capacidad para intentar realizar una operación. Las reglas de negocio determinan si esa operación es válida dadas las condiciones actuales del dominio.

Por ejemplo, que un usuario tenga permiso para editar el contenido de una incidencia no implica que pueda hacerlo si su estado actual impide esa modificación.

Del mismo modo, los filtros de búsqueda y los parámetros utilizados para consultar recursos no constituyen permisos por sí mismos. La autorización determina qué recursos puede consultar el usuario; los filtros determinan cuáles desea obtener dentro del ámbito permitido.

## 9. Flexibilidad administrativa

La configuración de permisos no impondrá restricciones rígidas basadas exclusivamente en el nombre del rol.

Por ejemplo, si el usuario `root` concede a un administrador el permiso necesario para gestionar a otros administradores, la aplicación deberá autorizar esa operación conforme al permiso concedido y a las reglas aplicables.

Las diferencias entre usuarios y roles se establecerán mediante sus permisos efectivos y las relaciones del dominio, no mediante comprobaciones especiales basadas únicamente en etiquetas como `admin` o `root`.

## 10. Aspectos pendientes

Los siguientes detalles se concretarán durante la implementación:

- La estructura exacta del catálogo de permisos y sus validaciones.
- La representación de los permisos en la interfaz de administración.
- La forma de seleccionar y combinar los modificadores.
- El mecanismo de invalidación de tokens cuando cambien los permisos de un usuario.
- Los permisos predeterminados concretos de cada rol.

```ts 
{"role": {
  "display": "Usuario",
  "code": "user",
  "modifyPermissions": {
    "include": ["issue.editContent"],
    "exclude": ["user.editProfile:own"]
  }
}}
```
