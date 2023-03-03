#Before we can start making the application we need to have a base image.

FROM openjdk:lts

#Copying it to a directory
COPY . /src/java
WORKDIR /src/java
