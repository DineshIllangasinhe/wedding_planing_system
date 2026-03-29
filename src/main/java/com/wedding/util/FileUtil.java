package com.wedding.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Centralized text file I/O using {@link BufferedReader} and file writers.
 * All persistence files live under the configured data directory.
 */
public final class FileUtil {

    private FileUtil() {
    }

    /**
     * Reads every line from a file under the data directory.
     *
     * @param dataDir absolute path to data folder
     * @param fileName e.g. users.txt
     * @return lines in order; empty list if file missing or empty
     */
    public static List<String> readAllLines(String dataDir, String fileName) throws IOException {
        Path path = Path.of(dataDir, fileName);
        if (!Files.exists(path)) {
            return new ArrayList<>();
        }
        List<String> lines = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(new FileInputStream(path.toFile()), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.isBlank()) {
                    lines.add(line);
                }
            }
        }
        return lines;
    }

    /**
     * Overwrites the file with the given lines (UTF-8).
     */
    public static void writeAllLines(String dataDir, String fileName, List<String> lines) throws IOException {
        ensureDataDir(dataDir);
        Path path = Path.of(dataDir, fileName);
        try (BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(path.toFile()), StandardCharsets.UTF_8))) {
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        }
    }

    /**
     * Appends a single line to the file (creates file if needed).
     */
    public static void appendLine(String dataDir, String fileName, String line) throws IOException {
        ensureDataDir(dataDir);
        Path path = Path.of(dataDir, fileName);
        try (BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(path.toFile(), true), StandardCharsets.UTF_8))) {
            writer.write(line);
            writer.newLine();
        }
    }

    public static void ensureDataDir(String dataDir) throws IOException {
        File dir = new File(dataDir);
        if (!dir.exists() && !dir.mkdirs()) {
            throw new IOException("Could not create data directory: " + dataDir);
        }
    }

    public static boolean fileExists(String dataDir, String fileName) {
        return Files.exists(Path.of(dataDir, fileName));
    }

    /**
     * Escapes delimiter characters in user-provided fields so records stay parseable.
     */
    public static String escapeField(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("|", "\\|").replace("\n", " ").replace("\r", " ");
    }

    public static String unescapeField(String value) {
        if (value == null || value.isEmpty()) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        boolean esc = false;
        for (int i = 0; i < value.length(); i++) {
            char c = value.charAt(i);
            if (esc) {
                sb.append(c);
                esc = false;
            } else if (c == '\\') {
                esc = true;
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }

    /**
     * Splits a persisted line on {@code |} while honoring escaped pipes.
     */
    public static String[] splitRecord(String line) {
        List<String> parts = new ArrayList<>();
        StringBuilder cur = new StringBuilder();
        boolean esc = false;
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (esc) {
                cur.append(c);
                esc = false;
            } else if (c == '\\') {
                esc = true;
            } else if (c == '|') {
                parts.add(unescapeField(cur.toString()));
                cur.setLength(0);
            } else {
                cur.append(c);
            }
        }
        parts.add(unescapeField(cur.toString()));
        return parts.toArray(new String[0]);
    }

    public static String joinRecord(String... parts) {
        List<String> escaped = new ArrayList<>(parts.length);
        for (String p : parts) {
            escaped.add(escapeField(p != null ? p : ""));
        }
        return String.join("|", escaped);
    }

    public static long nextId(List<String> lines, int idColumnIndex) {
        long max = 0;
        for (String line : lines) {
            String[] cols = splitRecord(line);
            if (cols.length > idColumnIndex) {
                try {
                    long id = Long.parseLong(cols[idColumnIndex].trim());
                    max = Math.max(max, id);
                } catch (NumberFormatException ignored) {
                    // skip malformed
                }
            }
        }
        return max + 1;
    }

    public static List<String> immutableCopy(List<String> lines) {
        return Collections.unmodifiableList(new ArrayList<>(lines));
    }
}
