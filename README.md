# GitHub Actions Runner

This image is an extension of [myoung34/docker-github-actions-runner] that:

- Runs `docker-compose` in a container for ARM compatibility.
- Supports scaling via [docker-compose up --scale SERVICE=NUM] or the [compose file v2 scale] option.

## Usage

Here is an example compose file with scaling:

```yaml
version: '2.4'

services:
  github-actions:
    environment:
      ACCESS_TOKEN: ${GITHUB_ACTIONS_ACCESS_TOKEN}
      ORG_NAME: ${GITHUB_ACTIONS_ORG_NAME}
      ORG_RUNNER: 'true'
      RUNNER_NAME: ${GITHUB_ACTIONS_RUNNER_NAME}
      RUNNER_WORKDIR: ${PWD}/_work
    image: interaction/github-actions-runner
    restart: always
    scale: ${GITHUB_ACTIONS_SCALE:-2}
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ${PWD}/_work:${PWD}/_work
```

## Running `docker-compose` in a container

There is no official `docker-compose` [binary] or [container] release for ARM.

The [myoung34/docker-github-actions-runner] base image does not install `docker-compose` at all on ARM.

We use the unofficial [linuxserver/docker-compose](https://hub.docker.com/r/linuxserver/docker-compose) for ARM compatibility.

Running `docker-compose` in a container has one limitation where environment variables from your shell are not automatically passed through to the container.

If your compose file needs access to your environment, for example:

    services:
      foo:
        image: org/repo:${TAG}

...you can manually pass individual variables through to the container:

    COMPOSE_OPTIONS='-e TAG' TAG='bar' docker-compose ...

`${COMPOSE_OPTIONS}` will be appended to the `docker run` command that runs `docker-compose`. See [run.sh] shim for all the details.

[binary]: https://github.com/docker/compose/releases
[compose file v2 scale]: https://docs.docker.com/compose/compose-file/compose-file-v2/#scale
[container]: https://hub.docker.com/r/docker/compose/tags
[docker-compose up --scale SERVICE=NUM]: https://docs.docker.com/compose/reference/up/
[linuxserver/docker-compose]: https://hub.docker.com/r/linuxserver/docker-compose
[myoung34/docker-github-actions-runner]: https://github.com/myoung34/docker-github-actions-runner
[run.sh]: https://github.com/linuxserver/docker-docker-compose/blob/master/run.sh
