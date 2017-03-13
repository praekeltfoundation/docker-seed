# docker-seed

[![pyup.io](https://pyup.io/repos/github/praekeltfoundation/docker-seed/shield.svg)](https://pyup.io/repos/github/praekeltfoundation/docker-seed/)
[![Build Status](https://travis-ci.org/praekeltfoundation/docker-seed.svg?branch=master)](https://travis-ci.org/praekeltfoundation/docker-seed)

Dockerfiles for the Seed maternal health platform

## Components
The Seed maternal health platform is split into several components (or *services*) that work together. This repository contains Dockerfiles for the following components:
* [`seed-stage-based-messaging`](https://github.com/praekelt/seed-stage-based-messaging): [![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/seed-stage-based-messaging.svg)](https://hub.docker.com/r/praekeltfoundation/seed-stage-based-messaging/)
* [`seed-message-sender`](https://github.com/praekelt/seed-message-sender): [![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/seed-message-sender.svg)](https://hub.docker.com/r/praekeltfoundation/seed-message-sender/)

## Testing
The images are all tested with the same generic [test script](test.sh). Since there is a lot of commonality between the components (they are all Django-based with Celery workers), a single [Docker Compose file](docker-compose.yml) with environment [variable substitution](https://docs.docker.com/compose/compose-file/#variable-substitution) is used to test the images.

Run the tests by giving the test script an image name and, optionally, some arguments:
```
./test.sh praekeltfoundation/stage-based-messaging --no-beat
```

For all available arguments see the test script. See the [Travis file](.travis.yml) for how tests are run for each image.

The test script will set the environment variables for substitution in the Docker Compose file based on the name of the image. If you are using a non-standard name for the image, you will need to export the environment variables yourself (the test script won't overwrite them).
