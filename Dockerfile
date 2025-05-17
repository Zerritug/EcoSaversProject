# Build stage
FROM maven:3.9-eclipse-temurin-21-alpine AS build
WORKDIR /app

# Copy the Maven files from the correct path
COPY back_ecosavers/demo/pom.xml .
COPY back_ecosavers/demo/mvnw .
COPY back_ecosavers/demo/.mvn .mvn

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy source code from the correct path
COPY back_ecosavers/demo/src src

# Build the application
RUN mvn package -DskipTests

# Runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
