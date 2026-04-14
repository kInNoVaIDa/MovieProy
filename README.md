# 🎬 MovieProy

MovieProy es una API REST para la gestión de películas. Permite crear, consultar, actualizar informacion de peliculas y eliminar peliculas
de forma sencilla. 

---

## 🚀 Características

- Crear películas con atributos como:
  - Título
  - Año
  - Duración
- Obtener todas las películas
- Obtener una película por nombre
- Actualizar información de una película
- Eliminar peliculas
- Arquitectura basada en servicios (API + worker opcional)

---

## 🧠 Tecnologías utilizadas

- Python
- Flask (ajusta según tu proyecto)
- MongoDB
- Docker y Docker Compose
- RabbitMQ con worker
- Postman (para pruebas)

---

## 📁 Estructura del proyecto

```bash
MovieProy/
│
├── main.py              # Endpoints
├── models/              # Modelos de datos
├── services/            # MongoDB - RabbitMQ
├── worker/              # Procesamiento asincrónico
├── docker-compose.yml   # Configuración de servicios
├── Dockerfile
└── requirements.txt

```
## Ejecutar el proyecto
## 🧩 Requisitos previos

Antes de comenzar, asegúrate de tener instalado:

- Docker
- Docker Compose

Verificar instalación:

```bash
docker --version
docker compose version
```
Clonar el repositorio: 
```bash
git clone https://github.com/kInNoVaIDa/MovieProy.git
cd MovieProy
```

1. Ejecutar con Docker: Se levantan todos los contenedores

```bash
docker compose up --build
```
2. Ejecutar manualmente: 

Crear el entorno virtual:
```bash
python -m venv venv
source venv/bin/activate
```
Instalar dependencias:
```bash
pip install -r requirements.txt
```
Ejecutar la API:
```bash
python app/main.py
```
