# Stage 1: Build application with Maven
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Pre-fetch dependencies to leverage Docker layer caching
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build executable jar
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Lightweight runtime image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Create a non-root group and user for security
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy built JAR artifact from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Application port
EXPOSE 8089

ENTRYPOINT ["java", "-jar", "app.jar"]

