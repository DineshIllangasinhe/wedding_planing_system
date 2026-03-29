package com.wedding.config;

import javax.servlet.ServletContext;

public final class AppPaths {

    private AppPaths() {
    }

    public static String dataDir(ServletContext ctx) {
        Object v = ctx.getAttribute(DataDirectoryInitializer.ATTR_DATA_DIR);
        if (v == null) {
            throw new IllegalStateException("Data directory not initialized");
        }
        return v.toString();
    }
}
