# Use official Maven image with JDK 17 for building
FROM maven:3.9.2-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven wrapper and pom.xml first to leverage Docker cache
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies only (for caching)
RUN ./mvnw dependency:go-offline

# Copy source code
COPY src src

# Run tests and build the jar
RUN ./mvnw clean package -DskipTests=false

# ------------------------------
# Optional: create a lighter image for deployment
# ------------------------------
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Copy the built jar from previous stage
COPY --from=build /app/target/*.jar ./app.jar

# Expose application port
EXPOSE 8080

# Command to run app (you can comment it if only testing)
CMD ["java", "-jar", "app.jar"]
