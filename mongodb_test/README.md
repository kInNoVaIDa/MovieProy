# Documentación de Errores de Análisis Estático (Flake8)

Este documento describe los errores encontrados mediante la herramienta de análisis estático **Flake8**, su significado y cómo solucionarlos.

---

## ¿Qué es Flake8?

Flake8 es una herramienta que permite analizar el código sin ejecutarlo para detectar:

* Errores de sintaxis
* Problemas de estilo (PEP8)
* Código innecesario o mal estructurado

---

# Errores encontrados:

---

## ./main.py:4:45: W291 trailing whitespace

**Descripción:**
Espacios en blanco al final de una línea.

---

## ./main.py:47:1: W293 Blank line contains whitespace

**Descripción:**
Una línea vacía contiene espacios en blanco.

---

## ./service/rabbitmq.py:38:23: W292 No newline at end of file

**Descripción:**
El archivo no termina con una línea en blanco.

**Solución:**
Agregar una línea vacía al final del archivo.

---

## ./main.py:48:37: E201  Whitespace after '('

**Descripción:**
Espacio después de un paréntesis de apertura.

---

## ./main.py:48:70: E202 - Whitespace before ')'

**Descripción:**
Espacio antes de un paréntesis de cierre.

---

## ./service/mongo.py:8:14: E222 Multiple spaces after operator

**Descripción:**
Uso de múltiples espacios después de un operador.

---

## ./worker.py:1:1: F401 'pika' imported but unused

**Descripción:**
Se importó algo en un archivo, pero no fue usado.

## ./worker.py:13:34: E251 unexpected spaces around keyword / parameter equals 
Hay varios errores de estos en el codigo

**Descripción:**
Espacios incorrectos alrededor del signo igual en parámetros.

---

## ./main.py:10:1: E302 expected 2 blank lines, found 1

**Descripción:**
Se requieren 2 líneas en blanco antes de funciones o clases.

---

## ./service/mongo.py:4:80: E501 line too long (82 > 79 characters)

**Descripción:**
Se requieren 2 líneas en blanco después de una función o clase.

---

## ./service/mongo.py:4:80: E501 line too long (82 > 79 characters)

**Descripción:**
La línea excede el límite de caracteres (79 por defecto).

---

---

# Buenas prácticas aplicadas

Para solucionar estos errores se recomienda:

1. Ejecutar análisis:

   ```bash
   pip install flake8

   flake8 .
   ```

2. Corregir manualmente los errores restantes

---

# ✅ Conclusión

El chequeo de código estático permite:

* Mejorar la calidad del código
* Mantener estándares profesionales (PEP8)
* Reducir errores antes de ejecución
* Facilitar el mantenimiento del proyecto

---
