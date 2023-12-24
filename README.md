# Zen Organizer

Zen Organizer es una aplicación integral de productividad diseñada para ayudar a mejorar y organizar tu vida. Combina un calendario, lista de tareas, timer Pomodoro, gestor de notas y seguimiento de hábitos en una sola plataforma.

## Configuración del Entorno de Desarrollo

### Creación y Activación del Entorno Virtual

Es recomendable utilizar un entorno virtual para manejar las dependencias.

1. **Crear el Entorno Virtual**:
   En la raíz del proyecto, ejecuta:

   ```bash
   python -m venv venv
   ```

   Esto creará un nuevo directorio `venv` en el proyecto.

2. **Activar el Entorno Virtual**:

   - En Windows:
     ```bash
     .\venv\Scripts\activate
     ```
   - En Unix o MacOS:
     ```bash
     source venv/bin/activate
     ```

3. **Instalar Dependencias**:
   Con el entorno virtual activado, instala todas las dependencias necesarias:
   ```bash
   pip install -r requirements.txt
   ```

### Desactivación del Entorno Virtual

Para salir del entorno virtual, simplemente ejecuta:

```bash
deactivate
```

## Ejecución del Proyecto

Para ejecutar Zen Organizer:

1. Asegúrate de que el entorno virtual esté activado.
2. Ejecuta el proyecto con Flet:
   ```bash
   flet run .
   ```

## Manejo de Commits en Git

Para mantener un historial claro y útil en Git, sigue estas mejores prácticas:

- **Commits Pequeños y Frecuentes**: Realiza commits pequeños y frecuentes. Esto facilita entender los cambios y solucionar problemas si surgen.
- **Mensajes Descriptivos**: Escribe mensajes de commit claros y descriptivos, que expliquen qué cambios se han realizado y por qué.
  - Ejemplo de un buen mensaje de commit:
    ```bash
    git commit -m "Agrega timer Pomodoro a la interfaz principal"
    ```
- **Uso de Branches**: Para nuevas características o correcciones importantes, considera usar branches. Esto mantiene el `main` estable mientras se desarrollan nuevas funcionalidades.
- **Pull Requests y Revisión de Código**: Si trabajas en equipo, utiliza Pull Requests para revisar el código antes de fusionarlo con el `main`.

## Roadmap

Este es el roadmap general para el desarrollo de Zen Organizer:

### Fase 1: Planificación y Diseño

- Definición de Requisitos
- Esbozo de la Interfaz de Usuario (UI)
- Selección de Tecnologías

### Fase 2: Desarrollo del Prototipo

- Configuración del Entorno de Desarrollo
- Desarrollo de un Prototipo Básico
- Pruebas Iniciales

### Fase 3: Desarrollo de Funcionalidades Específicas

- Calendario y Recordatorios
- Gestión de Notas
- Timer Pomodoro Mejorado
- Lista de Tareas Avanzada

### Fase 4: Optimización y Funcionalidades Adicionales

- Seguimiento de Hábitos y Metas a Largo Plazo
- Reportes de Productividad
- Pruebas y Depuración

### Fase 5: Interfaz de Usuario y Experiencia de Usuario

- Diseño de Interfaz de Usuario
- Pruebas de Usabilidad

### Fase 6: Preparación para el Lanzamiento

- Documentación
- Pruebas Finales
- Lanzamiento de la Versión Beta

### Fase 7: Lanzamiento y Mantenimiento

- Lanzamiento Oficial
- Mantenimiento y Actualizaciones

## Contribuciones

Las contribuciones son bienvenidas. Si deseas contribuir al proyecto, por favor envía un Pull Request con tus cambios para su revisión.
