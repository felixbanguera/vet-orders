# 🩺 Microservicio de Órdenes Médicas Veterinarias

Este microservicio maneja las **órdenes médicas veterinarias** de pacientes. Cada orden pertenece a un **cliente** y un **paciente**, pero estos datos provienen de otros microservicios (Clientes y Pacientes).  
El microservicio se implementa con **Ruby on Rails 8.0.3**, **MongoDB**, y **Mongoid 9.0.4** como ODM.

---

## 🚀 Características principales

- CRUD completo para órdenes médicas (`Order`)
- Base de datos NoSQL con **MongoDB**
- Arquitectura **API-only** para integración con otros microservicios
- Autenticación mediante **API Key**
- Compatible con Ruby **3.3.3**

---

## 🧰 Tecnologías utilizadas

| Componente | Versión | Descripción |
|-------------|----------|-------------|
| Ruby | 3.3.3 | Lenguaje principal |
| Rails | 8.0.3 (API Mode) | Framework web |
| MongoDB | Latest stable | Base de datos NoSQL |
| Mongoid | 9.0.4 | ODM para MongoDB |
| dotenv-rails | Latest | Manejo de variables de entorno |

---

## ⚙️ Instalación y configuración

### 1️⃣ Clonar el repositorio
```bash
git clone https://github.com/tuusuario/vet-orders.git
cd vet-orders
```

### 2️⃣ Verificar versiones
Asegúrate de tener instaladas las versiones requeridas:
```bash
ruby -v    # => ruby 3.3.3
rails -v   # => Rails 8.0.3
mongod --version
```

### 3️⃣ Instalar dependencias
```bash
bundle install
```

### 4️⃣ Configurar Mongoid
El archivo `config/mongoid.yml` debe contener algo como:
```yaml
development:
  clients:
    default:
      database: vet_orders_db
      hosts:
        - localhost:27017
  options:
```

### 5️⃣ Variables de entorno
Crea un archivo `.env` en la raíz del proyecto con tu clave privada:

```
API_KEY=miclaveprivada123
```

---

## 🧱 Modelo de datos

**Modelo:** `Order`

| Campo | Tipo | Descripción |
|--------|------|-------------|
| order_number | String | Número de orden única |
| client_id | Integer | ID del cliente (proveniente del microservicio de clientes) |
| patient_id | Integer | ID del paciente (proveniente del microservicio de pacientes) |
| diagnosis | String | Diagnóstico médico |
| treatment | String | Tratamiento recomendado |
| date | Date | Fecha de emisión |
| notes | String | Notas adicionales |

Ejemplo de documento en MongoDB:
```json
{
  "_id": "670f2bbfa1b7c00012f6c1a4",
  "order_number": "ORD-1001",
  "client_id": 1,
  "patient_id": 10,
  "diagnosis": "Otitis",
  "treatment": "Antibiótico tópico",
  "date": "2025-10-16",
  "notes": "Revisión en 10 días"
}
```

---

## 🧠 Endpoints disponibles

| Método | Endpoint | Descripción |
|---------|-----------|-------------|
| GET | `/orders` | Listar todas las órdenes |
| GET | `/orders/:id` | Obtener una orden por ID |
| POST | `/orders` | Crear una nueva orden |
| PUT | `/orders/:id` | Actualizar una orden existente |
| DELETE | `/orders/:id` | Eliminar una orden |

Todos los endpoints requieren el header:
```
x-api-key: miclaveprivada123
```

---

## 🧪 Ejemplo de uso (cURL)

### Crear una orden
```bash
curl -X POST http://localhost:3000/orders   -H "Content-Type: application/json"   -H "x-api-key: miclaveprivada123"   -d '{
    "order_number": "ORD-1001",
    "client_id": 1,
    "patient_id": 10,
    "diagnosis": "Otitis",
    "treatment": "Antibiótico tópico",
    "date": "2025-10-16",
    "notes": "Revisión en 10 días"
  }'
```

### Obtener todas las órdenes
```bash
curl -H "x-api-key: miclaveprivada123" http://localhost:3000/orders
```

---

## 🔐 Seguridad

El microservicio utiliza autenticación por **API Key**.  
Cada solicitud debe incluir la cabecera:

```
x-api-key: <tu_api_key>
```

Si la clave no está presente o no coincide con `ENV["API_KEY"]`, se denegará el acceso.

---

## ▶️ Ejecutar el servidor

Inicia MongoDB localmente:
```bash
mongod --dbpath /usr/local/var/mongodb
```

Luego inicia Rails:
```bash
rails s
```

La API estará disponible en:
```
http://localhost:3000
```

---

## 🧩 Integración con otros microservicios

Este servicio está diseñado para integrarse con:

- **Microservicio de Clientes** → provee `client_id`
- **Microservicio de Pacientes** → provee `patient_id`

Cada orden puede consultar datos externos (si se desea en futuras versiones) mediante llamadas HTTP autenticadas.

---

## 📁 Estructura del proyecto

```
vet-orders/
├── app/
│   ├── controllers/
│   │   └── orders_controller.rb
│   ├── models/
│   │   └── order.rb
├── config/
│   ├── mongoid.yml
│   └── routes.rb
├── .env
├── Gemfile
└── README.md
```

---

## 🧾 Licencia

Proyecto educativo desarrollado como ejemplo de microservicio con **Ruby on Rails + MongoDB**.  
Licencia MIT.
