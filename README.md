# Building Eldamo

[Eldamo](https://github.com/pfstrack/eldamo) is currently set up to build with Gradle 2.6 (sub 4.0) and 
jetty. As of this writing, Gradle is at version 5.5.1 and, as of v 4+, no longer supports a jetty plugin.

This repository contains instructions that will build Eldamo with the proper versions of software necessary.

## Prerequisites

* Docker


## Use the Gradle Image

There are a variety of gradle tasks (use `gradle tasks` to see them all).

The instance below shows how to use `jettyRunWar` which is the primary web-serving application.

Other useful tasks are:

* `war` - creates a war file for use on a java webserver, output located in `build/libs` dir
* `clean` - cleans everything
* `javadoc` - generates javadoc
* `jettyRun` - run directly from built files
* `jettyRunWar` - create a war, then run from that

```
# Setup
# clone the Eldamo source
git clone https://github.com/pfstrack/eldamo

# change into that directory
cd eldamo

# copy the data file to the webapp
cp -R src/data src/main/webapp

# Run gradle in a container
# This will download the Gradle 3.5 image with JDK 7
# and execute `gradle :jettyRun`
# and expose jetty on port 8080
docker run --rm -u gradle -p 8080:8080 -v "$PWD":/home/gradle/eldamo -w /home/gradle/eldamo gradle:3.5-jdk7 gradle jettyRunWar

```

You should then be able to go to localhost:8080/eldamo or localhost:8080/eldamo/pub/ to see the site.


