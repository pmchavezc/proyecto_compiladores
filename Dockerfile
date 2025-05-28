FROM openjdk:17-jdk-slim
LABEL authors="Pablo"
WORKDIR /app
COPY target/proyecto_compiladores-1.0-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-java", "app.jar"]