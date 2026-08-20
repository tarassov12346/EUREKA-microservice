# === Этап 1: Лёгкая сборка приложения ===
FROM maven:3.9.6-eclipse-temurin-21-alpine AS builder
WORKDIR /app

# Кэшируем зависимости Maven в изолированном слое Docker
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Копируем исходный код и собираем JAR
COPY src ./src
RUN mvn clean package -DskipTests

# === Этап 2: Минималистичный рантайм ===
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Настраиваем безопасного не-root пользователя
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Копируем собранный JAR-файл из этапа сборки
COPY --from=builder /app/target/Eureka-microservice-0.0.1-SNAPSHOT.jar app.jar

# Открываем главный порт сервера регистрации из твоих пропертей
EXPOSE 1111

# Запуск с поддержкой лимитов Docker, ZGC для мгновенной работы таймеров Loom
# и явным указанием имени конфигурации для Спринга
ENTRYPOINT ["java", \
            "-XX:+UseContainerSupport", \
            "-XX:+UseZGC", \
            "-jar", "app.jar", \
            "--spring.config.name=eureka-server"]

