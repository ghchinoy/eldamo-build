#
# Build image: create eldamo war
FROM gradle:3.5-jdk7 as builder

RUN git clone https://github.com/pfstrack/eldamo
RUN cp -R /home/gradle/eldamo/src/data /home/gradle/eldamo/src/main/webapp/

# substitute the version into the build file
USER root
RUN apt-get update && apt-get install libxml2-utils -y
USER gradle
RUN VER=$(xmllint --xpath "string(/*/@version)" /home/gradle/eldamo/src/data/eldamo-data.xml) && \
    sed -ie -E "/version/s/ = '(.+)'/ = '${VER}'/" /home/gradle/eldamo/build.gradle

WORKDIR /home/gradle/eldamo
RUN gradle war

#
# Server image: Create jetty + war
FROM jetty
LABEL maintainer="ghchinoy@gmail.com"

COPY --from=builder /home/gradle/eldamo/build/libs/**.war /var/lib/jetty/webapps
RUN java -jar "$JETTY_HOME/start.jar" --create-startd --add-to-start=jmx,stats
