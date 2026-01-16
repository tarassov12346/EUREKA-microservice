# --- Этап 1: Сборка ---
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder
WORKDIR /app

# 1. Сначала копируем только pom.xml
COPY pom.xml .

# 2. Скачиваем зависимости (используем кеш монтирования .m2)
# Это ускорит сборку в десятки раз при повторных запусках
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline

# 3. Копируем исходники и собираем
COPY src ./src
RUN --mount=type=cache,target=/root/.m2 mvn clean package -DskipTests

# --- Этап 2: Финальный образ ---
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Копируем результат сборки
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 1111

# Запуск
ENTRYPOINT ["java", "-jar", "app.jar"]
