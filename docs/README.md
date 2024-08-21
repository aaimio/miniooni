# miniooni for Docker

Docker wrapper for `miniooni`, a tool designed to measure internet censorship.

- Contribute spare bandwidth to help measure internet censorship
- [Things you should know before running miniooni](https://ooni.org/about/risks/)
- For more information visit the [OONI website](https://ooni.org) & [OONI Probe CLI repo](https://github.com/ooni/probe-cli)

> Also see [Docker wrapper for OONI Probe](https://github.com/aaimio/ooniprobe)

## Getting started

Running the Docker image will do the following:

1. Launches the miniooni CLI and starts tests defined through the `command[0-99]` environment variable(s)
2. After tests complete, the container will `sleep` for 6 hours until the next run (this is configurable)

### Docker Compose

```yaml
services:
  miniooni:
    image: aaimio/miniooni:latest
    container_name: miniooni
    volumes:
      - ./miniooni:/config
    environment:
      command1: web_connectivity@v0.5 --yes
      sleep: true
    restart: unless-stopped
```

### Docker CLI

```sh
docker run \
  --name miniooni \
  -v ./miniooni:/config \
  -e command1="web_connectivity@v0.5 --yes" \
  -e sleep=true \
  --restart unless-stopped \
  aaimio/miniooni:latest
```

## Environment variables

- **`command[0-99]`**: Tests to run with `miniooni` (tests are immediately executed one after another)
- **`seconds_between_tests`**: Number of seconds between full test cycles (default is 21600 seconds = 6 hours)
- **`sleep`**: Boolean indicating whether the Docker container should sleep between test executions
  - If `true`, the container will `sleep` after completing tests, ensuring that it doesn't exit
  - Alternatively, you could use a cron or other type of orchestration to periodically start the container

## License

- [miniooni for Docker](https://github.com/aaimio/miniooni/blob/main/LICENSE)
- [OONI Probe CLI license](https://github.com/ooni/probe-cli/blob/master/LICENSE)
- [OONI.org license](https://github.com/ooni/ooni.org/blob/master/LICENSE)
