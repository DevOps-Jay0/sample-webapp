FROM tomcat:latest
LABEL maintainer="Jay"
LABEL description="tomcat image with sample web application"
COPY target/sample-webapp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/sample-webapp-1.0-SNAPSHOT.war
EXPOSE 8080 
