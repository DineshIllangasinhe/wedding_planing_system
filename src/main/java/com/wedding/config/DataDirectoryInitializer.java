package com.wedding.config;

import com.wedding.util.FileUtil;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

/**
 * Resolves an absolute data directory and seeds empty files from classpath samples when needed.
 */
@WebListener
public class DataDirectoryInitializer implements ServletContextListener {

    public static final String ATTR_DATA_DIR = "app.dataDir";

    private static final String[] DATA_FILES = {
            "users.txt", "vendors.txt", "bookings.txt", "payments.txt"
    };

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        String configured = ctx.getInitParameter("dataDirectory");
        Path dataPath;
        if (configured != null && !configured.isBlank()) {
            dataPath = Path.of(configured.trim()).toAbsolutePath().normalize();
        } else {
            Path webInf = Path.of(ctx.getRealPath("/WEB-INF")).toAbsolutePath().normalize();
            dataPath = webInf.resolve("data");
        }
        try {
            Files.createDirectories(dataPath);
            for (String name : DATA_FILES) {
                Path target = dataPath.resolve(name);
                if (!Files.exists(target) || Files.size(target) == 0) {
                    seedFromClasspath(name, target);
                }
            }
            ctx.setAttribute(ATTR_DATA_DIR, dataPath.toString());
        } catch (IOException e) {
            throw new IllegalStateException("Failed to initialize data directory: " + dataPath, e);
        }
    }

    private void seedFromClasspath(String fileName, Path target) throws IOException {
        String resource = "/data-seed/" + fileName;
        try (InputStream in = DataDirectoryInitializer.class.getResourceAsStream(resource)) {
            if (in != null) {
                Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
            } else {
                FileUtil.ensureDataDir(target.getParent().toString());
                Files.writeString(target, "", StandardCharsets.UTF_8);
            }
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // nothing
    }
}
