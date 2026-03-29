# Wedding Planning and Vendor Booking System

Production-style **Java web application** (JSP + Servlets, **Java 17**) for planning weddings and booking vendors (photography, catering, decoration). It uses a **layered architecture** and **text file persistence** with `BufferedReader` / writers via a shared utility.

## Architecture

| Layer | Package / location | Responsibility |
|--------|-------------------|----------------|
| **Model** | `com.wedding.model` | Entities, enums (`User`, `Vendor` hierarchy, `Booking`, `Payment`, …) |
| **Service** | `com.wedding.service` | CRUD and rules (double-booking checks, validation messages) |
| **Controller** | `com.wedding.controller` | HTTP handling (`BaseServlet`, feature servlets) |
| **Utility** | `com.wedding.util` | `FileUtil` (read/write/append, escaped `\|` records), `PasswordUtil` |
| **Config** | `com.wedding.config` | Data directory bootstrap (`DataDirectoryInitializer`) |
| **View** | `src/main/webapp` | JSP, Bootstrap 5, `css/app.css` |

**OOP:** encapsulation on all entities, **inheritance** `Vendor` → `Photographer`, `Caterer`, `DecoratorVendor`, **polymorphism** via `getSpecialtySummary()` / `getServiceDetails()` overrides.

## Data files

At runtime, data is stored under **`WEB-INF/data`** inside the deployed application (created on first startup). If those files are missing or empty, they are **seeded** from the classpath copies in `src/main/resources/data-seed/`.

The repository also includes a mirror under **`data/`** at the project root (`users.txt`, `vendors.txt`, `bookings.txt`, `payments.txt`) for easy inspection and version control.

Optional absolute path (e.g. shared or writable location):

```xml
<!-- WEB-INF/web.xml -->
<context-param>
    <param-name>dataDirectory</param-name>
    <param-value>C:/data/wedding-app</param-value>
</context-param>
```

## Modules (CRUD)

- **Users** — register, profile view/update/delete; admin user list & delete (`/admin/users`). Storage: `users.txt`.
- **Vendors** — full CRUD (admin only for mutations); search + category filter. Storage: `vendors.txt`.
- **Bookings** — create, list, update, cancel (frees date); optional admin hard delete. **Double booking** blocked for the same vendor on the same date while status is not `CANCELLED`. Storage: `bookings.txt`.
- **Payments** — create, list, update, delete (delete admin-only); packages **Basic / Standard / Premium**. Storage: `payments.txt`.

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

## Build & run

Requirements: **JDK 17** (set `JAVA_HOME`). Maven is optional if you use the included **Maven Wrapper**.

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

Open `http://localhost:8080/`.

Alternatively deploy `target/wedding-planning.war` to **Apache Tomcat 9** (or another **javax.servlet** container).

## Project layout (IntelliJ-style)

```
src/main/java/com/wedding/
  config/          DataDirectoryInitializer, AppPaths
  controller/      Servlets
  filter/          Encoding + auth + admin gate
  model/
  service/
  util/
src/main/webapp/
  WEB-INF/web.xml
  WEB-INF/jsp/     Protected views + includes
  css/
  index.jsp, login.jsp, register.jsp
src/main/resources/data-seed/
data/              Sample text files (mirror)
```

## Security notes

Passwords are **SHA-256** hashed with an application pepper (see `PasswordUtil`). For real production use, replace with a dedicated password hashing scheme (bcrypt, Argon2) and add CSRF protection, HTTPS, and server-side session hardening.
