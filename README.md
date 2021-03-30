# GitHub Actions Runner

This image is an extension of [myoung34/docker-github-actions-runner](https://github.com/myoung34/docker-github-actions-runner) that:

- Includes an ARM64 compatible `docker-compose` shim.
- Supports scaling via [docker-compose up --scale SERVICE=NUM](https://docs.docker.com/compose/reference/up/) or the [compose file v2 scale](https://docs.docker.com/compose/compose-file/compose-file-v2/#scale) option.

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
