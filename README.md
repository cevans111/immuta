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

  1) It uses the ubuntu:16.04 and postgres:9.5.4 images from Docker Hub.  Normally, I would build custom images and use those to speed up startup but I wanted to "show my work".  This does increase the initial startup time.
  
  2) It clones the subrosa source from git into the conatiner.  Again, I would normally clone the repo locally and copy the files over to the docker image when I built it. That gives me control over the version of the code that gets pushed into your image.  I'm directly cloning into the Ubuntu image in this POC to keep this repo small.
  
  3) This has only been tested on OSX El Capitan on Docker 1.12.1
  
