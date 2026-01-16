# 1. Сборка на JDK 8 (используем поддерживаемый образ Temurin)
FROM maven:3.9.6-eclipse-temurin-8-alpine AS builder
WORKDIR /app
COPY pom.xml .
# Кеширование зависимостей
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline
COPY src ./src
RUN --mount=type=cache,target=/root/.m2 mvn clean package -DskipTests

# 2. Запуск на JRE 8 (максимально легкий и стабильный)
FROM eclipse-temurin:8-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 1111
ENTRYPOINT ["java", "-jar", "app.jar"]
