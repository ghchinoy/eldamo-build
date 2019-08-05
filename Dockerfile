FROM jetty

COPY eldamo/build/libs/eldamo-0.7.3.war $JETTY_HOME

RUN java -jar "$JETTY_HOME/eldamo-0.7.3.war" --add-to-startd=jmx,stats

