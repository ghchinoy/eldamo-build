FROM jetty

COPY eldamo/build/libs/eldamo-0.5.0.war /var/lib/jetty/webapps

RUN java -jar "$JETTY_HOME/start.jar" --create-startd --add-to-start=jmx,stats

