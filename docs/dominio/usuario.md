# Usuario

Representa a una persona que tiene una cuenta en el sistema.

| Propiedad            | Descripción                                      | Restricciones                     |
| -------------------- | ------------------------------------------------ | --------------------------------- |
| `id`                 | Identificador de la cuenta                       | Único                             |
| `name`               | Nombre de la persona                             | Obligatorio                       |
| `surnames`           | Apellidos de la persona                          | Obligatorio                       |
| `identifier`         | Identificador universitario                      | Obligatorio, único                |
| `email`              | Correo electrónico utilizado para iniciar sesión | Obligatorio, único                |
| `passwordHash`       | Hash de la contraseña de la cuenta               | Obligatorio                       |
| `verificationStatus` | Estado actual de verificación de identidad       | `pending`, `verified`, `rejected` |

### Relaciones

Un usuario puede crear incidencias, comentar en incidencias, recibir notificaciones y ser responsable de áreas.

### Notas

* Los nombres y apellidos no son únicos.
* Los permisos y las reglas de autorización todavía no están definidos en este modelo.

```json
{"permission": {
  "issue": ["create", "search:own"]
}

{"permissions": {
  "issue": {
    "create": true,
    "search": {"modifier": "own"},
    
  }
}}

```
