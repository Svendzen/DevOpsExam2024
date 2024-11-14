# Bygg-steg: Dette steget bruker Maven og Java 17 til å bygge Java-applikasjonen.
FROM maven:3.8-eclipse-temurin-17 AS builder

# Setter arbeidskatalogen i containeren til /app for å holde prosjektfilene samlet.
WORKDIR /app

# Kopierer Maven-prosjektkonfigurasjonen (pom.xml) først for å cache avhengigheter og redusere byggetid.
COPY pom.xml .

# Kopierer kildekoden inn i containeren, slik at mvn package kan kompilere koden og lage en JAR-fil.
COPY src ./src

# Kjør mvn package for å bygge applikasjonen, der JAR-filen lagres i /app/target-katalogen.
RUN mvn package

# Slutt-steg: Opprett et minimalt image med kun Java runtime environment for å redusere størrelsen.
FROM eclipse-temurin:17-jre-alpine

# Setter arbeidskatalogen i sluttbildet til /app for å ha en ryddig struktur.
WORKDIR /app

# Kopierer JAR-filen fra bygg-steget inn i runtime imaget for å inkludere bare den kompilerte applikasjonen.
COPY --from=builder /app/target/*.jar /app/application.jar

# Definerer en miljøvariabel for SQS Queue URL, som kan settes ved runtime eller i Docker Compose.
ENV SQS_QUEUE_URL=""

# Setter standardkommandoen til å kjøre applikasjonen med Java og spesifiserer JAR-filen i /app-katalogen.
ENTRYPOINT ["java", "-jar", "/app/application.jar"]
