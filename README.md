# Inmigración Alemania 2028

Aplicación Kanban estática, sin dependencias de compilación. De forma predeterminada guarda las tareas en el navegador mediante `localStorage`; incluye semilla inicial, exportación/importación JSON, búsqueda, filtros combinados, estadísticas y arrastre nativo entre columnas.

## Ejecutar localmente

Abra `index.html` con un servidor estático (por ejemplo, la extensión Live Server de VS Code). Para probar el inicio de sesión por enlace, use `http://localhost` en vez de abrir el archivo directamente.

## Opción A: despliegue gratuito sin backend (GitHub Pages)

1. Cree un repositorio en GitHub y suba el contenido de esta carpeta, incluyendo `config.js` vacío.
2. En GitHub vaya a **Settings → Pages**, seleccione **Deploy from a branch**, rama `main` y carpeta `/ (root)`.
3. Espere a que GitHub publique la URL. Cada navegador conservará sus propios datos; use **Exportar JSON** como copia y **Importar JSON** para trasladarlos.

También puede importar el repositorio en Vercel y elegir el preset **Other**: no necesita comando de build y el directorio de salida es la raíz.

## Opción B: Supabase, multi-dispositivo y tiempo real

1. Cree un proyecto gratuito en Supabase. En la configuración de la Data API, active **Enable Data API** y **Enable automatic RLS**; deje desactivado **Automatically expose new tables**. En **SQL Editor**, ejecute [`supabase/schema.sql`](supabase/schema.sql).
2. En **Authentication → URL Configuration**, agregue sus URLs de desarrollo y producción a *Redirect URLs* (por ejemplo `https://usuario.github.io/inmigracion-alemania-2028/`).
3. En **Project Settings → API**, copie *Project URL* y la clave pública `anon`.
4. Copie `config.example.js` como `config.js` y complete las dos constantes. La `anon key` es pública por diseño; nunca incluya `service_role` en frontend.
5. Publique de nuevo. Aparecerá **Iniciar sincronización**: cada persona ingresa su correo, recibe un enlace y únicamente puede leer/modificar sus propias tareas gracias a RLS.

Al iniciar sesión por primera vez, las tareas locales se suben si aún no existe una colección en la nube. Si ya hay tareas en la nube, estas se convierten en la copia activa para evitar sobrescribir información de otro dispositivo.

### Trackers de ahorro, deuda y e-commerce

Las tarjetas de trackers guardan datos por usuario en Supabase. Si ya ejecutó el esquema antes de actualizar esta aplicación, ejecute una vez [`supabase/trackers-migration.sql`](supabase/trackers-migration.sql) desde el SQL Editor; no vuelva a ejecutar el esquema completo.

## Seguridad y fechas

El contenido editable se inserta con `textContent`, no HTML, y se limita antes de persistir. El cálculo de días normaliza ambas fechas a medianoche UTC; el formato también se fija a UTC para impedir el desfase de un día según la zona horaria.
