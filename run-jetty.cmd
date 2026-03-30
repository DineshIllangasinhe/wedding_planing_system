@echo off
setlocal EnableDelayedExpansion

if defined JAVA_HOME if exist "!JAVA_HOME!\bin\java.exe" goto :run

set "JAVA_HOME="
for /d %%J in ("%ProgramFiles%\Microsoft\jdk-*") do (
  if exist "%%J\bin\java.exe" set "JAVA_HOME=%%J"
)
if not defined JAVA_HOME for /d %%J in ("%ProgramFiles%\Eclipse Adoptium\jdk-*") do (
  if exist "%%J\bin\java.exe" set "JAVA_HOME=%%J"
)
if not defined JAVA_HOME for /d %%J in ("%ProgramFiles%\Java\jdk-*") do (
  if exist "%%J\bin\java.exe" set "JAVA_HOME=%%J"
)

if not defined JAVA_HOME (
  echo ERROR: JAVA_HOME is not set and no JDK was found in common locations.
  echo Install JDK 17+ or set JAVA_HOME to your JDK folder, then run this script again.
  exit /b 1
)

:run
cd /d "%~dp0"
echo Using JAVA_HOME=%JAVA_HOME%
echo App URL: http://localhost:8081/
echo Press Ctrl+C to stop the server.
call mvnw.cmd jetty:run
