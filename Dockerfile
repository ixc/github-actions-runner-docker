FROM myoung34/github-runner:latest

# Install an ARM64 compatible 'docker-compose' shim.
RUN curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Wrap the entrypoint and use an anonymous volume to persist a random unique ID so we
# can scale with Docker Compose.
COPY entrypoint-wrapper.sh /
ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["/actions-runner/bin/runsvc.sh"]
VOLUME /tmp/github-actions
