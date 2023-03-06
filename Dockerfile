#Before we can start making the application we need to have a base image.

FROM openjdk:lts

#Copying it to a directory
COPY . /var/lib/jenkins/workspace/test /src/java
WORKDIR /var/lib/jenkins/workspace/test/target

#To run the program
RUN ["javac","my-app-1.0-SNAPSHOT.jar"]

ENTRYPOINT [ "javac","my-app-1.0-SNAPSHOT.jar" ]
