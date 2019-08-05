FROM gradle:3.5-jdk7 as builder

RUN git clone https://github.com/pfstrack/eldamo
RUN cp -R /home/gradle/eldamo/src/data /home/gradle/eldamo/src/main/webapp/
WORKDIR /home/gradle/eldamo
RUN gradle war


FROM jetty

COPY --from=builder /home/gradle/eldamo/build/libs/**.war /var/lib/jetty/webapps
RUN java -jar "$JETTY_HOME/start.jar" --create-startd --add-to-start=jmx,stats

