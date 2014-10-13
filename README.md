# Trade Tariff docker setup

We'll be using [docker](https://www.docker.com/) and [fig](http://www.fig.sh/) to build and link docker containers.

## Setting up repos
1. Clone this repo
  ```
  ~$ git clone https://github.com/bitzesty/tariff-docker.git
  ```

2. Clone backend, admin and frontend. All on `tariff-docker` branch. You'll be working inside this project's folder as you'll use it's `fig.yml` to build the containers.
  ```
  ~$ cd tariff-docker
  ~/tariff-docker$ git clone -b tariff-docker https://github.com/bitzesty/trade-tariff-backend.git
  ~/tariff-docker$ git clone -b tariff-docker https://github.com/bitzesty/trade-tariff-admin.git
  ~/tariff-docker$ git clone -b tariff-docker https://github.com/bitzesty/trade-tariff-frontend.git
  ```

## Setting up docker containers
1. [Install docker](https://docs.docker.com/installation/#installation)
2. [Install fig](http://www.fig.sh/install.html)
3. Build docker images: `fig build`
  - You'll need to login before you can pull `bitzesty/trade-tariff-backend` as it's a private image. See https://docs.docker.com/userguide/dockerrepos/#working-with-the-repository.
  - If you don't have access to `bitzesty/trade-tariff-backend` image you still can build it from the project's `Dockerfile`. See [bitzesty/trade-tariff-backend#fig-docker-setup](https://github.com/bitzesty/trade-tariff-backend/tree/docker-setup#fig--docker-setup)
  - This process can take a while as it needs to download and build docker images.

4. Start containers: `fig up -d --no-recreate`
  - `-d` option will run them in background
  - `--no-recreate` is important so fig doesn't recreate environments (included DBs)

You can start / stop all containers using `fig start` / `fig stop`

## Setting up apps
### Backend
- Run migrations and seeds
  ```
  ~/tariff-docker$ fig run backend bundle exec rake db:migrate db:seed
  ```
  For more info see https://github.com/bitzesty/trade-tariff-backend#load-database

### Admin
- Run migrations and seeds
  ```
  ~/tariff-docker$ fig run admin bundle exec rake db:migrate db:seed
  ```
