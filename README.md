# Subrosa/Postgres with Docker Compose

This is a test application to allow using  'docker-compose up' to start up a distributed blog and PostgreSQL database using Docker Compose. It is based off a fork of of the python blog software Subrosa (https://github.com/ayohrling/subrosa).  The original project is at https://github.com/exaroth/subrosa.
. 

This project does the following:

- Starts up a separate PostgreSQL 'db' and 'service' container that runs the software using 'docker-compose up'

- Is accessible on port 80 of the docker host

- Locks down Postgres to the docker network and not available from the host

I've tested creating an account, adding and publishing a post.  These persist through restarts, but would be lost if you deleted the containers and images. ( perhaps persistent volumes?  Something to look in to).

A couple of notes:

  1) This has only been tested on OSX El Capitan and macOS Sierra on Docker 1.12.1

  2) It uses the ubuntu:16.04 and postgres:9.5.4 images from Docker Hub.  I would extend those images to create custom images to speed start up but I wanted to "show my work", so to speak.  This does increase the initial startup time to about 5 minutes as it builds new images but subseqent startups are quick.
  
  3) I clone the Subrosa source from git into the container during the build.  If I were creating custom images based on core, I would clone the repo locally and copy the files over to the docker images as a part of the build. That would give me control over the version of the application code that gets pushed into the image as opposed to introducing bugs by always working on master.

  4) Subrosa prefers a local database by default but the requirements for this test are to connect to a separate db instance running in a different container. If you dig into the Subrosa docs, you will find details about installing into a Heroku instance with a remote database.  The docs don't go into detail, but if you look at the code as well, you can see that Subrosa accepts a DATABASE_URL environment variable to describe your database connection.

  5) This version requires a custom startup script for a few reasons:

      In Compose, even when you have dependencies, there isn't a way to make sure that the database is up before starting the app.  Per these docs (https://docs.docker.com/compose/startup-order/), I added a step in the startup script that checks the database server availability before starting the application.  This does require a dependency on psql being installed, but could be ported to python.

     I run the "create_db" command before starting the app as well.  Its not needed after the initial build, but it is non-destructive, runs quickly and verifies the tables are there as expected.

     I modified the app to bind to "0.0.0.0" so the app is available outside of the docker network.

  6) I think you could optimize the app container to run from a python image rather than an Ubuntu image.  This would require refactoring the Subrosa install script, the custom startup script that checks for Postgres availability, and so on.  If this was more than a test app, I would probably go through that effort to see if you could slim the images down.
  
