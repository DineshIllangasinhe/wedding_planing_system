# Wedding Planning and Vendor Booking System

Production-style **Java web application** (JSP + Servlets, **Java 17**) for planning weddings and booking vendors (photography, catering, decoration). It uses a **layered architecture** and **MySQL** persistence via **JDBC** and **HikariCP** connection pooling.

## MySQL setup

1. Create an empty schema in MySQL Workbench (or CLI), e.g. **`wedding`**.
2. Run the script **`src/main/resources/sql/schema.sql`** against that database (creates tables, foreign keys, and demo seed rows). Use a **fresh** database the first time; re-running inserts will duplicate keys if data already exists.
3. Copy **`src/main/resources/database.properties.example`** to **`src/main/resources/database.properties`** and set `jdbc.url`, `jdbc.username`, and `jdbc.password`. The file **`database.properties` is gitignored** so credentials are not committed.
4. Start the app; **`DatabaseListener`** opens the pool at startup. If `database.properties` is missing, the webapp fails fast with a clear error.

Example URL (adjust host, port, database name as needed):

```properties
jdbc.url=jdbc:mysql://localhost:3306/wedding?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false
jdbc.username=root
jdbc.password=your_password
```

## Architecture

| Layer | Package / location | Responsibility |
|--------|-------------------|----------------|
| **Model** | `com.wedding.model` | Entities, enums (`User`, `Vendor` hierarchy, `Booking`, `Payment`, …) |
| **Service** | `com.wedding.service` | CRUD and rules (double-booking checks, validation messages) |
| **Controller** | `com.wedding.controller` | HTTP handling (`BaseServlet`, feature servlets) |
| **Utility** | `com.wedding.util` | `PasswordUtil` (pepper + SHA-256 hashing) |
| **Config** | `com.wedding.config` | `DatabaseListener` (HikariCP), `AppPaths` (DataSource lookup) |
| **View** | `src/main/webapp` | JSP, **Tailwind CSS** (CDN), shared `header.jspf` / `footer.jspf`, `css/app.css` |

**OOP:** encapsulation on all entities, **inheritance** `Vendor` → `Photographer`, `Caterer`, `DecoratorVendor`, **polymorphism** via `getSpecialtySummary()` / `getServiceDetails()` overrides.

## Modules (CRUD)

- **Users** — register, profile view/update/delete; admin user list & delete (`/admin/users`). Storage: `users` table.
- **Vendors** — full CRUD (admin only for mutations); search + category filter. Type-specific fields in `extra1` / `extra2`. Storage: `vendors` table.
- **Bookings** — create, list, update, cancel (frees date); optional admin hard delete. **Double booking** blocked for the same vendor on the same date while status is not `CANCELLED`. Storage: `bookings` table.
- **Payments** — create, list, update, delete (delete admin-only); packages **Basic / Standard / Premium**. Storage: `payments` table.

## UI pages

- **Home** — `index.jsp`
- **Register / Login** — `/register` and `/login` (servlets forward to `register.jsp` / `login.jsp`; direct `.jsp` URLs still work)
- **Vendor listing** — `/vendors` (search & filter)
- **Bookings** — `/bookings` (form + history)
- **Dashboard** — `/dashboard`
- **Profile, payments, admin users** — `/profile`, `/payments`, `/admin/users`

## Demo accounts

| Username | Password   | Role     |
|----------|------------|----------|
| `admin`  | `admin123` | ADMIN    |
| `couple1`| `wedding2026` | CUSTOMER |

(Loaded by `schema.sql` seed data.)

## Build & run

Requirements: **JDK 17** (set `JAVA_HOME`), **MySQL** with schema applied, **`database.properties`** configured. Maven is optional if you use the included **Maven Wrapper**.

```powershell
# Windows (downloads Maven 3.9.9 on first run if needed)
.\mvnw.cmd -DskipTests package
```

macOS / Linux:

```bash
chmod +x mvnw
./mvnw -DskipTests package
```

Or with a global Maven install:

```bash
mvn clean package
```

Run with **Jetty** (embedded):

```powershell
.\mvnw.cmd jetty:run
```

```bash
mvn jetty:run
```

Open `http://localhost:8081/` (Jetty port is set in `pom.xml` as `jetty.http.port`).

### IntelliJ IDEA

1. **Open** the project folder (the one that contains `pom.xml`). Wait for Maven import to finish.
2. **File → Project Structure → Project** — set **SDK** to **17**.
3. Run the app in either way:
   - **Run** dropdown → choose **Jetty (localhost:8081)** (shared config from `.run/`), then click the green **Run** button; or
   - Open the **Maven** tool window → **Plugins → jetty → jetty:run** (double-click or right-click **Run**).

Keep the run window open. When the log shows **Started Jetty Server**, open **http://localhost:8081/**.

Alternatively deploy `target/wedding-planning.war` to **Apache Tomcat 9** (or another **javax.servlet** container).

## Project layout (IntelliJ-style)

```
src/main/java/com/wedding/
  config/          DatabaseListener, AppPaths
  controller/      Servlets
  filter/          Encoding + auth + admin gate
  model/
  service/
  util/
src/main/webapp/
  WEB-INF/web.xml
  WEB-INF/jsp/     Protected views + includes
  css/app.css (small complements to Tailwind)
  images/home/*.png (hero & story photography for the landing page)
  index.jsp, login.jsp, register.jsp
src/main/resources/
  sql/schema.sql
  database.properties.example
```

## Security notes

Passwords are **SHA-256** hashed with an application pepper (see `PasswordUtil`). For real production use, replace with a dedicated password hashing scheme (bcrypt, Argon2) and add CSRF protection, HTTPS, and server-side session hardening. **Do not commit** `database.properties`; use strong DB credentials and restrict MySQL `root` to localhost.
