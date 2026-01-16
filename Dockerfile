# Сборка на JDK 8
FROM maven:3.8.4-openjdk-8 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Запуск на JRE 8 (максимально легкий)
FROM openjdk:8-jre-slim
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 1111
ENTRYPOINT ["java", "-jar", "app.jar"]
