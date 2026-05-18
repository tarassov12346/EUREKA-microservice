# Eureka-microservice

[![Java Version](https://shields.io)](https://oracle.com)
[![Spring Boot](https://shields.io)](https://spring.io)
[![Spring Cloud](https://shields.io)](https://spring.io)

Сервер регистрации и обнаружения (Service Discovery) на базе **Netflix Eureka Server**. Этот микросервис является центральным реестром для всей экосистемы приложения, позволяя остальным сервисам (Gateway, USERS, Движок и др.) находить друг друга без жесткого прописывания IP-адресов.

## 🛠️ Стек технологий и особенности

* **Язык:** Java 17
* **Фреймворк:** Spring Boot 3.1.1 + Spring Cloud 2022.0.3
* **Сборщик:** Maven
* **Оптимизация:** Полностью отключены автоконфигурации баз данных (`DataSource`, `JPA`) и шаблонизатор `Thymeleaf` для максимально легкого и быстрого запуска.

## 📋 Конфигурация

Микросервис настроен как **выделенный сервер** (Standalone Server):
* Он не регистрирует сам себя в реестре (`registerWithEureka=false`).
* Он не скачивает локально копию реестра (`fetchRegistry=false`).
* Имя конфигурационного файла переопределено в коде на `eureka-server`.

## 🚀 Запуск и окружение

### Требования
* Установленный JDK 17
* Установленный Maven 3.8+

### Порядок запуска
1. Клонируйте репозиторий и перейдите в папку проекта:
```bash
cd Eureka-microservice
```

2. Соберите и запустите проект с помощью Maven:
```bash
./mvnw clean spring-boot:run
```

## 🔌 Использование и Порты

После успешного запуска панель управления (Dashboard) Eureka будет доступна в браузере:

* **URL адрес:** `http://localhost:1111`

### Подключение других микросервисов (Клиентов)
Чтобы зарегистрировать любой другой микросервис в этом реестре, добавьте в его `pom.xml` зависимость `spring-cloud-starter-netflix-eureka-client` и укажите в его настройках адрес этого сервера:

```properties
eureka.client.serviceUrl.defaultZone=http://localhost:1111/eureka/
```

## 🧑‍💻 Главный класс приложения

Запуск приложения инициализирует сервер с помощью аннотации `@EnableEurekaServer`:

```java
@SpringBootApplication
@EnableEurekaServer
public class EurekaServer {
    public static void main(String[] args) {
        System.setProperty("spring.config.name", "eureka-server");
        SpringApplication.run(EurekaServer.class, args);
    }
}
```
