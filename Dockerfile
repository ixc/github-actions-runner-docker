FROM myoung34/github-runner:latest

# Install an ARM64 compatible 'docker-compose' shim.
RUN curl -L --fail https://raw.githubusercontent.com/linuxserver/docker-docker-compose/master/run.sh -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Install Docker Compose CLI plugin for native ARM64 compatibility.
RUN apt-get install docker-compose-plugin -y

# Wrap the entrypoint and use an anonymous volume to persist a random unique ID so we
# can scale with Docker Compose.
COPY entrypoint-wrapper.sh /
ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["/actions-runner/bin/runsvc.sh"]
VOLUME /tmp/github-actions
