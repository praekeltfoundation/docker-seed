# docker-seed

[![pyup.io](https://pyup.io/repos/github/praekeltfoundation/docker-seed/shield.svg)](https://pyup.io/repos/github/praekeltfoundation/docker-seed/)
[![Build Status](https://travis-ci.org/praekeltfoundation/docker-seed.svg?branch=master)](https://travis-ci.org/praekeltfoundation/docker-seed)

Dockerfiles for the Seed maternal health platform

## Components
The Seed maternal health platform is split into several components (or *services*) that work together. This repository contains Dockerfiles for the following components:

| GitHub                                                                                         | PyPI                                                                                                                                                       | Docker Hub                                                                                                                                                                                                  |
|------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [`seed-control-interface-service`](https://github.com/praekelt/seed-control-interface-service) | [![PyPI](https://img.shields.io/pypi/v/seed-control-interface-service.svg?style=flat-square)](https://pypi.python.org/pypi/seed-control-interface-service) | [![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/seed-control-interface-service.svg?style=flat-square)](https://hub.docker.com/r/praekeltfoundation/seed-control-interface-service/) |
| [`seed-message-sender`](https://github.com/praekelt/seed-message-sender)                       | [![PyPI](https://img.shields.io/pypi/v/seed-message-sender.svg?style=flat-square)](https://pypi.python.org/pypi/seed-message-sender)                       | [![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/seed-message-sender.svg?style=flat-square)](https://hub.docker.com/r/praekeltfoundation/seed-message-sender/)                       |
| [`seed-scheduler`](https://github.com/praekelt/seed-scheduler)                                 | [![PyPI](https://img.shields.io/pypi/v/seed-scheduler.svg?style=flat-square)](https://pypi.python.org/pypi/seed-scheduler)                                 | [![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/seed-scheduler.svg?style=flat-square)](https://hub.docker.com/r/praekeltfoundation/seed-scheduler/)                                 |
| [`seed-stage-based-messaging`](https://github.com/praekelt/seed-stage-based-messaging)         | [![PyPI](https://img.shields.io/pypi/v/seed-stage-based-messaging.svg?style=flat-square)](https://pypi.python.org/pypi/seed-stage-based-messaging)         | [![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/seed-stage-based-messaging.svg?style=flat-square)](https://hub.docker.com/r/praekeltfoundation/seed-stage-based-messaging/)         |
| [`seed-auth-api`](https://github.com/praekelt/seed-auth-api)                                   | [![PyPI](https://img.shields.io/pypi/v/seed-auth-api.svg?style=flat-square)](https://pypi.python.org/pypi/seed-auth-api)                                   | [![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/seed-auth-api.svg?style=flat-square)](https://hub.docker.com/r/praekeltfoundation/seed-auth-api/)                                   |
| [`seed-control-interface`](https://github.com/praekelt/seed-control-interface)                 | [![PyPI](https://img.shields.io/pypi/v/seed-control-interface.svg?style=flat-square)](https://pypi.python.org/pypi/seed-control-interface)                 | [![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/seed-control-interface.svg?style=flat-square)](https://hub.docker.com/r/praekeltfoundation/seed-control-interface/)                 |
| [`seed-identity-store`](https://github.com/praekelt/seed-identity-store)                       | [![PyPI](https://img.shields.io/pypi/v/seed-identity-store.svg?style=flat-square)](https://pypi.python.org/pypi/seed-identity-store)                       | [![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/seed-identity-store.svg?style=flat-square)](https://hub.docker.com/r/praekeltfoundation/seed-identity-store/)                       |
| [`seed-service-rating`](https://github.com/praekelt/seed-service-rating)                       | [![PyPI](https://img.shields.io/pypi/v/seed-service-rating.svg?style=flat-square)](https://pypi.python.org/pypi/seed-service-rating)                       | [![Docker Pulls](https://img.shields.io/docker/pulls/praekeltfoundation/seed-service-rating.svg?style=flat-square)](https://hub.docker.com/r/praekeltfoundation/seed-service-rating/)                       |

## Testing
The images are all tested with the same generic [test script](test.sh). Since there is a lot of commonality between the components (they are all Django-based with Celery workers), a single [Docker Compose file](docker-compose.yml) with environment [variable substitution](https://docs.docker.com/compose/compose-file/#variable-substitution) is used to test the images.

Run the tests by giving the test script an image name and, optionally, some arguments:
```
./test.sh praekeltfoundation/stage-based-messaging --worker-metrics --worker-send
```

For all available arguments see the test script. See the [Travis file](.travis.yml) for how tests are run for each image.

The test script will set the environment variables for substitution in the Docker Compose file based on the name of the image. If you are using a non-standard name for the image, you will need to export the environment variables yourself (the test script won't overwrite them).
