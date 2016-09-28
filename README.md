# Docker implementation for a Subrosa blog with a Postgres backend

This is a POC to allow someone to use 'docker-compose up' to startup a distributed blog and PostgreSQL database container based off
of Subrosa (python blog software). It is using a fork (https://github.com/ayohrling/subrosa) of the original project (https://github.com/exaroth/subrosa).
. 

It does the following:

- Starts up a separate PostgreSQL 'db' and 'service' container that runs the software using 'docker-compose up'

- Is accessible on port 80 of the docker host

- Locks down Postgres to the docker network. 

I've tested creating an account, adding and publishing a post.  These persist through restarts, but obviously would be lost if you deleted the containers and images.

A couple of notes:

  1) This has only been tested on OSX El Capitan and macOS Sierra on Docker 1.12.1

  2) It uses the ubuntu:16.04 and postgres:9.5.4 images from Docker Hub.  Normally, I would build custom images and use those to speed up startup but I wanted to "show my work".  This does increase the initial startup time (about 5 minutes in my test), but subseqent startups are quick.
  
  3) It clones the subrosa source from git into the container during the build.  Again, I would normally clone the repo locally and copy the files over to the docker image as part of the build to give me control over the version of the application code that gets pushed into the image ( as opposed to  introducing bugs by always working on master).  I'm cloning into the Ubuntu image in this POC to keep this repo small.
  

  4) Subrosa prefers a local database by default but the requirements for this POC are to connect to a separate db instance. If you dig into the docs, you will find details about installing into a Heroku instance with a remote database.  The docs don't go into detail, but if you look at teh code, you can see that it accepts a DATABASE_URL environment variable to describe your database connection.

  5) This version requires a custom startup script for a few reasons:

        1)  In Compose, even when you have dependencies, there isn't a way to make sure that the database is up before starting the app.  Per these docs (https://docs.docker.com/compose/startup-order/), I added a step in the startup script that checks the database server availability before starting the application.  This does require a dependency on psql being installed, but could be ported to python.

        2) I run the "create_db" command before starting the app as well.  Its not needed after the initial build, but it runs quickly and verifies the tables are there as expected.

        3) I modified the app to bind to "0.0.0.0" so the app is available outside of the container network

  6) It seems that you could optimize the app container to run from a python image rather than an Ubuntu image.  This would entail refactoring the applications install script, the startup script that checks for Postgres availability, and so on.  If this was more than a test app, I would probably go through that effort to see if you caould slim the images down.
  
