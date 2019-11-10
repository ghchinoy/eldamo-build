#
# Build image: create eldamo war
FROM gradle:3.5-jdk7 as builder

RUN git clone https://github.com/pfstrack/eldamo
RUN cp -R /home/gradle/eldamo/src/data /home/gradle/eldamo/src/main/webapp/

ARG ELDAMO_VERSION=0.5.0
# substitute the version into the build file
RUN sed -ie -E "/version/s/ = '(.+)'/ = '${ELDAMO_VERSION}'/" /home/gradle/eldamo/build.gradle

WORKDIR /home/gradle/eldamo
RUN gradle war

#
# Server image: Create jetty + war
FROM jetty
LABEL maintainer="ghchinoy@gmail.com"

COPY --from=builder /home/gradle/eldamo/build/libs/**.war /var/lib/jetty/webapps
RUN java -jar "$JETTY_HOME/start.jar" --create-startd --add-to-start=jmx,stats
