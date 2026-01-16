# --- Этап 1: Сборка (Maven + Alpine) ---
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder
WORKDIR /app

# Используем кэш для зависимостей, чтобы не качать их каждый раз
RUN --mount=type=cache,target=/root/.m2 \
    COPY pom.xml . && \
    mvn dependency:go-offline

COPY src ./src

# Сборка с использованием кэша
RUN --mount=type=cache,target=/root/.m2 \
    mvn clean package -DskipTests

# --- Этап 2: Запуск (JRE вместо JDK + Alpine) ---
# JRE весит в 2-3 раза меньше, чем JDK. Alpine — самый легкий дистрибутив.
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Создаем не-привилегированного пользователя для безопасности
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Копируем только готовый JAR
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 1111

ENTRYPOINT ["java", "-jar", "app.jar"]
