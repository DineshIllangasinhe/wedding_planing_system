package com.wedding.config;

import javax.servlet.ServletContext;
import javax.sql.DataSource;

public final class AppPaths {

    public static final String ATTR_DATA_SOURCE = "app.dataSource";

    private AppPaths() {
    }

    public static DataSource dataSource(ServletContext ctx) {
        Object v = ctx.getAttribute(ATTR_DATA_SOURCE);
        if (v == null) {
            throw new IllegalStateException("DataSource not initialized");
        }
        return (DataSource) v;
    }
}
