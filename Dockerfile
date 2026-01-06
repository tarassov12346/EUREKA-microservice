FROM maven:3.8.6-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Было: FROM openjdk:17-jdk-slim
# Стало (рекомендуемый вариант):
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 1111
ENTRYPOINT ["java", "-jar", "app.jar"]
