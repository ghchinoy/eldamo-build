# Building Eldamo

[Eldamo](https://github.com/pfstrack/eldamo) is Paul Strack's generated lexicon of Tolkien's languages.

This repository contains instructions to build a Eldamo into a Java container - a Dockerfile and instructions to do so.

Eldamo is currently set up to build with Gradle 2.6 (specifically, a version before v4.0) and 
jetty. As of this writing, Gradle is at version 6.9.1 and, as of v 4+, no longer supports a jetty plugin.

This repository contains a Dockerfile as well as instructions options that will build Eldamo with the proper versions of software necessary.

## Prerequisites

* Docker


## Use Eldamo

There are three ways to use/build Eldamo: via a preconfigured Docker image, building your own Docker image, or using a Gradle image directly.

### Preconfigured Docker image

Run Eldamo with a [prebuilt docker image](gcr.io/eldamo-build/eldamo) via:

```
docker run -d -p 8080:8080 --name eldamo-web gcr.io/eldamo-build/eldamo:0.8.0
```

Then open a browser to http://localhost:8080/ 

### Build a Docker Image

The supplied Dockerfile will create an Eldamo image using multistage Docker build, first cloning the Eldamo repository and generating a war, and second (and finally) creating a [distroless](https://github.com/GoogleContainerTools/distroless) (think as small as possible) [jetty](https://www.eclipse.org/jetty/) image.

```
# build an image eldamo:0.8.0
ELDAMO_VERSION=0.8.0
docker build -t "eldamo:${ELDAMO_VERSION}"  .

# run that image (interactively with -it ; detached, substitute -d)
docker run -it -p 8080:8080 --name eldamo-web eldamo:${ELDAMO_VERSION}
```

#### Build with Google Cloud Platform's Cloud Build

One can also build an image on the Google Cloud build service, [Cloud Build](https://cloud.google.com/build), using the included cloudbuild.yaml and optionally provide an Eldamo version number as a Cloud Build substitution. The default version is 0.8.0.

```
gcloud builds submit --config=cloudbuild.yaml --substitutions=_ELDAMO_VERSION=0.8.0
```

### Run Gradle Directly

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
