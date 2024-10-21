# Use Maven image to build the Java application
FROM maven:3.8.5-openjdk-11 AS build
# Set working directory inside the container
WORKDIR /app
# Copy the project files into the container
COPY pom.xml .
COPY src ./src
# Build the application using Maven
RUN mvn clean package
# Use a lightweight JDK to run the application
FROM openjdk:11-jre-slim
# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar /app/app.jar
# Expose port 8080 to the host
EXPOSE 8080
# Define the command to run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
