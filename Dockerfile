# Используем образ с обновленными сертификатами TLS
FROM maven:3.8.6-jdk-8 AS builder
WORKDIR /app
COPY . .
# Пропускаем тесты для ускорения сборки
RUN mvn clean package -DskipTests

FROM openjdk:8-jre-alpine
WORKDIR /app
# Копируем jar файл (убедитесь, что имя файла совпадает с тем, что генерирует maven)
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 1111
ENTRYPOINT ["java", "-jar", "app.jar"]

