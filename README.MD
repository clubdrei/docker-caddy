Caddy docker images that are used at [clubdrei.com](https://www.clubdrei.com).

* GitHub repository: [https://github.com/clubdrei/docker-caddy](https://github.com/clubdrei/docker-caddy)
* quay.io repository: [https://quay.io/repository/clubdrei/caddy](https://quay.io/repository/clubdrei/caddy)
* Original Caddy docker images: [https://hub.docker.com/_/caddy](https://hub.docker.com/_/caddy)
* Caddy HTTP Rate Limit Module repository: [https://github.com/mholt/caddy-ratelimit](https://github.com/mholt/caddy-ratelimit)
* blocklist-abuseipdb repository: [https://github.com/borestad/blocklist-abuseipdb](https://github.com/borestad/blocklist-abuseipdb)

# Examples

The easiest way to run the provided examples is by using docker compose in the project directory:
```bash
docker compose -f examples/{{ name_of_the_example }}/docker-compose.yml up --build
```
