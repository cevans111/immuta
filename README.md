# Docker implementation for a Subrosa blog with a Postgres backend

This is a POC to allow someone to use 'docker-compose up' to startup a distributed blog and PostgreSQL database container based off
of Subrosa (python blog software). It is using a fork (https://github.com/ayohrling/subrosa) of the original project (https://github.com/exaroth/subrosa) at 
. 

It does the following:

- starts up a separate PostgreSQL 'db' and 'service' container that runs the software using 'docker-compose up'

- it is accessible on port 80 of the docker host

- the database container does not expose the Postgres port to the host external network (i.e. the service should talk internally to the db)

It is only tested through the "Create Account" part of the blog.

A couple of notes:

  1) It uses the ubuntu:16.04 and postgres:9.5.4 images from Docker Hub.  Normally, I would build custom images and use those to speed up startup but I wanted to "show my work".  This does increase the initial startup time ( about 5 minutes in my test).
  
  2) It clones the subrosa source from git into the conatiner.  Again, I would normally clone the repo locally and copy the files over to the docker image when I built it. That gives me control over the version of the code that gets pushed into your image.  I'm directly cloning into the Ubuntu image in this POC to keep this repo small.
  
  3) This has only been tested on OSX El Capitan and macOS Sierra on Docker 1.12.1

  4) Subrosa prefers a local database, but if you dig into the docs about installing into a Heroku instance ( and look at tehe code a little bit), you can see that it accepts a DATABASE_URL environment variable to describe your database connection

  5) This required a custom startup script.
        1)  In Compose, even when you have dependencies, there isn't a way to make sure that the database is up before starting the app.  I added a step in the startup script that checks the database server availability before starting the application.

        2) I run the "create_db" command before starting the app as well.  Not needed on subsequetn starts, but it runs quickly and verifies the tables are there as expected.

        3) I modified the app start up to bind to "0.0.0.0" so the app is available outside of the container network

  6) It seems that you could optimize the app container to run from a python image rather than an Ubuntu image.  This would entail refactoring the applications install script, the startup script that checks for Postgres availability, and so on.  If this was more than a test app, I would probably go through that effort to see if you caould slim the images down.
  
