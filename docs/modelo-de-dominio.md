# Modelo de datos del dominio

Este documento describe las principales entidades del dominio de Pa-Cuando, sus campos, relaciones, restricciones y reglas de negocio.

## Índice

1. [Usuario (`User`)](#1-usuario-user)
2. [Rol (`Role`)](#2-rol-role)
3. [Área (`Area`)](#3-área-area)
4. [Notificación (`Notification`)](#4-notificación-notification)
5. [Incidencia (`Issue`)](#5-incidencia-issue)
6. [Comentario (`Comment`)](#6-comentario-comment)
7. [Relaciones entre entidades](#7-relaciones-entre-entidades)
8. [Decisiones pendientes](#8-decisiones-pendientes)

---

## 1. Usuario (`User`)

Representa a una persona registrada en el sistema.

### Campos

| Campo                    | Tipo                  | Obligatorio | Descripción                                                       |
| ------------------------ | --------------------- | ----------- | ----------------------------------------------------------------- |
| `name`                   | `string`              | Sí          | Nombre del usuario.                                               |
| `surnames`               | `string`              | Sí          | Apellidos del usuario.                                            |
| `email`                  | `string`              | Sí          | Correo electrónico. Debe ser único.                               |
| `universityId`           | `string`              | Sí          | Identificador universitario. Debe ser único.                      |
| `passwordHash`           | `string`              | Sí          | Hash de la contraseña del usuario.                                |
| `verificationStatus`     | `VerificationStatus`  | Sí          | Estado de verificación de la cuenta.                              |
| `role.id`                | `string`              | Sí          | Identificador del rol asignado.                                   |
| `role.display`           | `string`              | Sí          | Nombre visible del rol para este usuario.                         |
| `role.modifyPermissions` | `PermissionOverrides` | No          | Modificaciones opcionales a los permisos predeterminados del rol. |
| `createdAt`              | `Date`                | Sí          | Fecha y hora de creación de la cuenta.                            |

### Tipos

`VerificationStatus` admite los siguientes valores:

- `pending`: la cuenta está pendiente de verificación.
- `verified`: la cuenta ha sido verificada.
- `rejected`: la verificación de la cuenta ha sido rechazada.

`PermissionOverrides` contiene dos listas opcionales:

| Campo     | Tipo       | Descripción                                                    |
| --------- | ---------- | -------------------------------------------------------------- |
| `include` | `string[]` | Permisos adicionales concedidos al usuario.                    |
| `exclude` | `string[]` | Permisos que se retiran de los permisos efectivos del usuario. |

El objeto `modifyPermissions` es opcional, al igual que cada una de sus listas.

### Reglas de negocio

- `email` y `universityId` deben ser únicos.
- Las contraseñas nunca deben almacenarse en texto plano.
- Todo usuario debe tener un rol asignado.
- Al asignar un rol, `role.display` se inicializa con el valor de `Role.display`.
- El usuario no puede modificar `role.display` sin los permisos necesarios. Su valor puede diferir del nombre predeterminado del rol.
- Los permisos efectivos se calculan a partir de los permisos del rol, añadiendo los incluidos en `include` y eliminando los incluidos en `exclude`.
- Si un permiso aparece en ambas listas, prevalece `exclude`.
- En esta versión no se contempla un indicador de activación de la cuenta ni un historial de verificaciones.

---

## 2. Rol (`Role`)

Define un conjunto de permisos predeterminados y un nombre visible que se utiliza al asignar el rol a un usuario.

### Campos

| Campo         | Tipo       | Obligatorio | Descripción                                |
| ------------- | ---------- | ----------- | ------------------------------------------ |
| `_id`         | `string`   | Sí          | Identificador único del rol.               |
| `display`     | `string`   | Sí          | Nombre visible predeterminado del rol.     |
| `permissions` | `string[]` | Sí          | Permisos predeterminados asociados al rol. |

### Reglas de negocio

- `_id` identifica al rol; no es necesario añadir un campo `code` que duplique su identidad.
- `permissions` define los permisos predeterminados de los usuarios que tienen asignado el rol.
- Los permisos efectivos de un usuario pueden diferir de los del rol debido a sus modificaciones individuales.
- `User.role.display` se inicializa a partir de `Role.display`, pero se almacena por separado y puede tener un valor distinto si una operación autorizada lo modifica.

---

## 3. Área (`Area`)

Representa un área responsable de gestionar incidencias.

### Campos

| Campo         | Tipo     | Obligatorio | Descripción                                     |
| ------------- | -------- | ----------- | ----------------------------------------------- |
| `_id`         | `string` | Sí          | Identificador único del área.                   |
| `display`     | `string` | Sí          | Nombre visible del área. Debe ser único.        |
| `manager`     | `string` | Sí          | Identificador del usuario responsable del área. |
| `description` | `string` | No          | Descripción opcional del área.                  |

### Reglas de negocio

- Cada área tiene exactamente una persona responsable.
- Una persona puede ser responsable de varias áreas.
- La persona responsable debe tener una cuenta verificada.
- Las incidencias se asignan a áreas, no directamente a personas.
- Cambiar la persona responsable de un área no requiere modificar las incidencias asociadas.
- En esta versión no se mantiene un historial de responsables.
- Un área no puede eliminarse mientras tenga incidencias asociadas.
- No se necesita un campo `code` adicional, ya que `_id` identifica al área.

---

## 4. Notificación (`Notification`)

Representa una notificación enviada a un usuario.

### Campos

| Campo            | Tipo                 | Obligatorio | Descripción                                                         |
| ---------------- | -------------------- | ----------- | ------------------------------------------------------------------- |
| `_id`            | `string`             | Sí          | Identificador único de la notificación.                             |
| `sender.id`      | `string`             | Sí          | Identificador del usuario que generó la notificación.               |
| `sender.name`    | `string`             | Sí          | Copia del nombre del emisor en el momento de crear la notificación. |
| `receptor`       | `string`             | Sí          | Identificador del usuario destinatario.                             |
| `status`         | `NotificationStatus` | Sí          | Estado de lectura de la notificación.                               |
| `content.header` | `string`             | Sí          | Encabezado de la notificación.                                      |
| `content.body`   | `string`             | Sí          | Cuerpo de la notificación.                                          |
| `createdAt`      | `Date`               | Sí          | Fecha y hora de creación de la notificación.                        |

`NotificationStatus` admite los siguientes valores:

- `unread`: el destinatario todavía no ha leído la notificación.
- `read`: el destinatario ha leído la notificación.

### Reglas de negocio

- `sender.name` se conserva como una copia para poder mostrar el nombre del emisor sin consultar su documento de usuario.
- `receptor` identifica al destinatario de la notificación.
- El estado indica si la notificación ha sido leída.
- En esta versión no se mantiene un historial de cambios de estado.

---

## 5. Incidencia (`Issue`)

Representa una incidencia registrada y gestionada a través del sistema.

### Campos

| Campo            | Tipo          | Obligatorio | Descripción                                                  |
| ---------------- | ------------- | ----------- | ------------------------------------------------------------ |
| `_id`            | `string`      | Sí          | Identificador único de la incidencia.                        |
| `owner`          | `string`      | Sí          | Identificador del usuario que creó la incidencia.            |
| `assignedArea`   | `string`      | Sí          | Identificador del área a la que está asignada la incidencia. |
| `tags`           | `string[]`    | Sí          | Etiquetas utilizadas para clasificar y filtrar incidencias.  |
| `status`         | `IssueStatus` | Sí          | Estado actual de la incidencia.                              |
| `content.header` | `string`      | Sí          | Título o encabezado de la incidencia.                        |
| `content.body`   | `string`      | Sí          | Descripción de la incidencia.                                |
| `createdAt`      | `Date`        | Sí          | Fecha y hora de creación de la incidencia.                   |

`IssueStatus` admite los siguientes valores:

- `open`: la incidencia está abierta.
- `in_progress`: la incidencia está en curso.
- `resolved`: la incidencia ha sido resuelta.

### Reglas de negocio

- `owner` identifica al creador de la incidencia y no cambia cuando esta se reasigna.
- `assignedArea` identifica al área responsable de gestionar la incidencia y puede cambiar.
- Las incidencias se asignan a áreas, no directamente a personas.
- La incidencia no almacena una copia del nombre del área ni de su responsable.
- Cada incidencia puede tener un máximo de tres etiquetas.
- Las etiquetas deben estar escritas en minúsculas y no pueden contener espacios.
- No se permiten etiquetas duplicadas dentro de una misma incidencia.
- En esta versión no se mantiene un historial de cambios de estado ni de reasignaciones.

---

## 6. Comentario (`Comment`)

Representa un comentario asociado a una incidencia. También permite responder a otros comentarios.

### Campos

| Campo             | Tipo     | Obligatorio | Descripción                                                      |
| ----------------- | -------- | ----------- | ---------------------------------------------------------------- |
| `_id`             | `string` | Sí          | Identificador único del comentario.                              |
| `issueId`         | `string` | Sí          | Identificador de la incidencia a la que pertenece el comentario. |
| `parentCommentId` | `string` | No          | Identificador del comentario al que responde, si corresponde.    |
| `body`            | `string` | Sí          | Contenido del comentario.                                        |
| `owner.id`        | `string` | Sí          | Identificador del usuario que escribió el comentario.            |
| `owner.name`      | `string` | Sí          | Copia del nombre del autor en el momento de crear el comentario. |
| `createdAt`       | `Date`   | Sí          | Fecha y hora de creación del comentario.                         |

### Reglas de negocio

- Todo comentario pertenece a una incidencia.
- Si no tiene `parentCommentId`, es un comentario principal.
- Si tiene `parentCommentId`, es una respuesta a otro comentario.
- El comentario padre debe pertenecer a la misma incidencia indicada por `issueId`.
- Los comentarios se almacenan como documentos independientes y se relacionan mediante identificadores.
- El nombre del autor se conserva como una copia para mostrarlo sin consultar su documento de usuario.
- El alcance inicial incluye comentarios y respuestas básicas. No incluye edición, eliminación, reacciones, menciones ni notificaciones automáticas por cada respuesta.

---

## 7. Relaciones entre entidades

La siguiente tabla resume las referencias entre las entidades del sistema.

| Entidad de origen | Campo             | Entidad referenciada | Relación                                    |
| ----------------- | ----------------- | -------------------- | ------------------------------------------- |
| `User`            | `role.id`         | `Role`               | Cada usuario tiene un rol asignado.         |
| `Area`            | `manager`         | `User`               | Cada área tiene una persona responsable.    |
| `Notification`    | `sender.id`       | `User`               | La notificación registra quién la generó.   |
| `Notification`    | `receptor`        | `User`               | La notificación tiene un destinatario.      |
| `Issue`           | `owner`           | `User`               | Cada incidencia tiene un creador.           |
| `Issue`           | `assignedArea`    | `Area`               | Cada incidencia está asignada a un área.    |
| `Comment`         | `issueId`         | `Issue`              | Cada comentario pertenece a una incidencia. |
| `Comment`         | `parentCommentId` | `Comment`            | Un comentario puede responder a otro.       |
| `Comment`         | `owner.id`        | `User`               | Cada comentario tiene un autor.             |

Los campos que conservan copias de nombres o valores visibles, como `User.role.display`, `Notification.sender.name` y `Comment.owner.name`, son desnormalizaciones intencionales. Permiten mostrar esa información directamente sin tener que consultar los documentos relacionados.

Los tipos `string` utilizados para los identificadores representan el modelo lógico. La representación física dependerá de la implementación de la persistencia; por ejemplo, MongoDB puede utilizar `ObjectId` como identificador.

---

## 8. Decisiones pendientes

Los siguientes aspectos todavía deben definirse antes o durante la implementación:

- **Formato de los permisos:** establecer la sintaxis para identificar permisos, incluidos los permisos específicos de un área.
- **Profundidad de las respuestas:** decidir si se podrá responder a cualquier comentario o únicamente a los comentarios principales.
- **Transiciones de estado:** definir qué cambios de estado se permiten en las incidencias y qué usuarios pueden realizarlos.
- **Eliminación de áreas:** definir si un área sin incidencias asociadas puede eliminarse y bajo qué condiciones.
- **Validación del contenido:** establecer longitudes máximas y otras restricciones para los títulos, descripciones y comentarios.
