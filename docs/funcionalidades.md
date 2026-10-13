# Funcionalidades del producto

## F01. Registro de usuarios

### Descripción

El sistema permite que una persona cree una cuenta para utilizar Pa-Cuando.

### Comportamiento esperado

* La persona puede proporcionar la información necesaria para registrar una cuenta.
* El sistema valida la información proporcionada antes de completar el registro.
* Si el registro se completa correctamente, la cuenta queda creada.

## F02. Verificación de usuarios

### Descripción

El sistema permite verificar manualmente las cuentas de los usuarios para habilitar el acceso a las funcionalidades restringidas por este requisito.

### Comportamiento esperado

* El usuario puede consultar su perfil y el estado de verificación de su cuenta.
* La verificación de una cuenta la realiza un usuario que dispone del permiso correspondiente.
* Un usuario cuya cuenta no esté verificada puede consultar su perfil y crear y guardar borradores privados de incidencias.
* Un usuario cuya cuenta no esté verificada no puede publicar incidencias ni acceder a las demás funcionalidades restringidas por este requisito.
* Una vez verificada la cuenta, el usuario puede acceder a las funcionalidades correspondientes, sujeto a los permisos que tenga.

## F03. Autenticación de usuarios

### Descripción

El sistema permite que los usuarios accedan a su cuenta de forma autenticada.

### Comportamiento esperado

* El usuario puede iniciar sesión con sus credenciales.
* El sistema valida las credenciales proporcionadas.
* El usuario puede cerrar su sesión.
* Las funcionalidades protegidas solo están disponibles para usuarios autenticados.

## F04. Creación y publicación de incidencias

### Descripción

El sistema permite a los usuarios crear incidencias para reportar problemas dentro de la universidad.

### Comportamiento esperado

* El usuario puede crear una incidencia y proporcionar la información necesaria para describir el problema.
* El usuario puede guardar una incidencia como borrador privado y continuar editándola posteriormente.
* El usuario puede seleccionar el área a la que desea dirigir la incidencia al publicarla.
* El usuario puede publicar una incidencia cuando cumple los requisitos de acceso correspondientes.
* Una incidencia publicada queda disponible para su consulta y gestión según los permisos de cada usuario.
* El usuario puede consultar y editar sus propios borradores.
* Los borradores no son visibles para otros usuarios.

## F05. Consulta y búsqueda de incidencias

### Descripción

El sistema permite consultar y buscar incidencias según los permisos del usuario.

### Comportamiento esperado

* El usuario puede consultar las incidencias a las que tiene acceso.
* El usuario puede buscar incidencias mediante criterios de búsqueda relevantes.
* El usuario puede consultar los detalles de una incidencia, incluyendo su descripción, estado actual, área responsable y comentarios.
* El usuario puede distinguir sus propias incidencias de las que tiene disponibles para gestionar.
* Los resultados de búsqueda respetan los permisos de acceso del usuario.

## F06. Gestión del ciclo de vida de las incidencias

### Descripción

El sistema permite gestionar las incidencias publicadas desde su recepción hasta su resolución.

### Comportamiento esperado

* Los usuarios con los permisos correspondientes pueden consultar las incidencias que tienen asignadas para gestionar.
* Los usuarios con los permisos correspondientes pueden cambiar el estado de una incidencia según las transiciones permitidas.
* Los usuarios con los permisos correspondientes pueden resolver una incidencia.
* Los usuarios con los permisos correspondientes pueden cambiar el área responsable de una incidencia cuando sea necesario.
* El sistema muestra el estado actual de cada incidencia.
* El usuario propietario puede consultar el estado actual de sus incidencias.

## F07. Gestión de comentarios

### Descripción

El sistema permite intercambiar información mediante comentarios asociados a las incidencias.

### Comportamiento esperado

* Los usuarios con acceso a una incidencia pueden consultar sus comentarios.
* Los usuarios con los permisos correspondientes pueden añadir comentarios a una incidencia.
* Cada comentario está asociado a la incidencia correspondiente y al usuario que lo publica.
* Los comentarios permiten comunicar información relevante durante la gestión del problema.

## F08. Gestión de notificaciones

### Descripción

El sistema notifica a los usuarios los acontecimientos relevantes relacionados con las incidencias en las que están involucrados.

### Comportamiento esperado

* El usuario puede consultar sus notificaciones desde una bandeja de entrada.
* El usuario puede marcar sus notificaciones como leídas.
* El propietario de una incidencia recibe notificaciones cuando se producen acontecimientos relevantes, como comentarios, cambios de estado, reasignaciones o resolución.
* Los responsables de la gestión pueden recibir notificaciones cuando se les asignan incidencias o cuando se producen acontecimientos relevantes para su trabajo.
* Cada usuario solo puede consultar y gestionar sus propias notificaciones.

## F09. Gestión de áreas

### Descripción

El sistema permite administrar las áreas de la universidad y asignar a cada una una persona responsable de su gestión.

### Comportamiento esperado

* Los usuarios con los permisos correspondientes pueden consultar las áreas existentes y sus responsables.
* Los usuarios con los permisos correspondientes pueden crear nuevas áreas.
* Los usuarios con los permisos correspondientes pueden modificar la información de un área.
* Los usuarios con los permisos correspondientes pueden cambiar la persona responsable de un área.
* Cada área tiene exactamente una persona responsable.
* Los usuarios con los permisos correspondientes pueden eliminar áreas, sujeto a las restricciones necesarias para no dejar incidencias sin una asignación válida.

## F10. Gestión de usuarios

### Descripción

El sistema permite administrar las cuentas de usuario mediante las operaciones autorizadas por sus permisos.

### Comportamiento esperado

* Los usuarios con los permisos correspondientes pueden consultar los usuarios registrados.
* Los usuarios con los permisos correspondientes pueden consultar la información necesaria para gestionar las cuentas.
* Los usuarios con los permisos correspondientes pueden verificar las cuentas pendientes de verificación.
* Los usuarios con los permisos correspondientes pueden realizar las demás operaciones de administración de cuentas que contemple el sistema.
* Cada operación de gestión de usuarios está restringida por los permisos correspondientes.

