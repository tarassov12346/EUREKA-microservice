# Этап сборки: используем стабильный образ Maven с поддержкой TLS 1.2+
FROM maven:3.9.6-eclipse-temurin-8 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Этап запуска: используем поддерживаемый JRE образ
FROM eclipse-temurin:8-jre-alpine
WORKDIR /app
# Копируем jar (имя файла в target зависит от pom.xml, обычно это artifactId-version.jar)
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 1111
ENTRYPOINT ["java", "-jar", "app.jar"]

