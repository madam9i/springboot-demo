# ============================
# 1) Build Stage (Maven)
# ============================
FROM maven:3.9.6-eclipse-temurin-17 AS build

# App directory create
WORKDIR /app

# pom.xml and source code copy
COPY pom.xml .
COPY src ./src

# Application build (JAR generate)
RUN mvn clean package -DskipTests


# ============================
# 2) Run Stage (Lightweight JRE)
# ============================
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# JAR file copy (from build stage)
COPY --from=build /app/target/*.jar app.jar

# Expose port (Spring Boot default: 8080)
EXPOSE 8080

# Start application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
