# FDP-Browser
A generic XSLT browser for FAIR Data Points


# Use via Docker-Compose

```
version: "3"
services:

  fdp-browser:
    image: markw/fdp-browser:0.0.1
    restart: always
    hostname: fdp-browser
    ports:
      - 4567:4567
```

then `docker-compose up` and surf to http://localhost:4567

# Use at command line

* You must have Ruby 2.5 or higher installed
* you must have bundler gem installed

`bundle install`

`ruby proxy.rb`

then surf to http://localhost:4567
