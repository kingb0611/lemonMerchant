# Dockerfile (multi-stage)
# Stage 1: build
FROM maven:3.9.3-eclipse-temurin-17 AS builder
WORKDIR /workspace

# Copy maven wrapper & pom first to leverage docker cache
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# If your repo uses modules, adjust copy strategy; we copy source after dependencies
RUN chmod +x mvnw
# Pre-download dependencies (optional)
RUN ./mvnw -B -DskipTests dependency:go-offline

# Copy everything and build
COPY src ./src
RUN ./mvnw -B -DskipTests package

# Stage 2: runtime
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
# copy built jar (assumes single jar in target)
COPY --from=builder /workspace/target/*.jar app.jar

# Expose Spring Boot default port (change if needed)
EXPOSE 9090

# Use minimal runtime flags (adjust as needed)
ENTRYPOINT ["java","-jar","/app/app.jar"]
