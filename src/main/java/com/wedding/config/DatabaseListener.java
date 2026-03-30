package com.wedding.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Builds a pooled MySQL {@link javax.sql.DataSource} from {@code database.properties} on the classpath.
 */
@WebListener
public class DatabaseListener implements ServletContextListener {

    private HikariDataSource dataSource;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        Properties p = new Properties();
        try (InputStream in = DatabaseListener.class.getClassLoader().getResourceAsStream("database.properties")) {
            if (in == null) {
                throw new IllegalStateException(
                        "Missing database.properties. Copy database.properties.example to src/main/resources/database.properties.");
            }
            p.load(in);
        } catch (IOException e) {
            throw new IllegalStateException("Could not load database.properties", e);
        }
        String url = p.getProperty("jdbc.url");
        String user = p.getProperty("jdbc.username");
        String pass = p.getProperty("jdbc.password");
        if (url == null || url.isBlank() || user == null || user.isBlank()) {
            throw new IllegalStateException("database.properties must define jdbc.url and jdbc.username");
        }
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(url.trim());
        config.setUsername(user.trim());
        config.setPassword(pass == null ? "" : pass);
        config.setMaximumPoolSize(10);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        config.setPoolName("wedding-pool");
        dataSource = new HikariDataSource(config);
        ctx.setAttribute(AppPaths.ATTR_DATA_SOURCE, dataSource);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
