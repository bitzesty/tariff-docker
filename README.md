# Trade Tariff docker setup

We'll be using [docker](https://www.docker.com/) and [fig](http://www.fig.sh/) to build and link docker containers.

## Setting up repos
1. Clone this repo
  ```
  ~$ git clone https://github.com/bitzesty/tariff-docker.git
  ```

2. Sync tariff subtrees

  Subtrees were added on [PR #3](https://github.com/bitzesty/tariff-docker/pull/3)

  ```
  # make sure we have tariff repos as remotes
  ~$ git remote add -f trade-tariff-backend git@github.com:bitzesty/trade-tariff-backend.git
  ~$ git remote add -f trade-tariff-admin git@github.com:bitzesty/trade-tariff-admin.git
  ~$ git remote add -f trade-tariff-frontend git@github.com:bitzesty/trade-tariff-frontend.git
  ~$ git remote add -f signonotron2 git@github.com:bitzesty/signonotron2.git
  ```

  ```
  # pull from tariff remotes on tariff-docker branch
  ~$ git pull -s subtree trade-tariff-backend tariff-docker
  ~$ git pull -s subtree trade-tariff-admin tariff-docker
  ~$ git pull -s subtree trade-tariff-frontend tariff-docker
  ~$ git pull -s subtree signonotron2 tariff-docker
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

  **Note:** It's important you start all containers together because they need to share environment variables at startup. Without them, you'll start to see `No route to host tariff-api.dev.gov.uk`

## Setting up apps
### Backend
- Create DB, run migrations and seeds

  ```
  ~/tariff-docker$ fig run backend bundle exec rake db:create db:migrate db:seed
  ```
  For more info see https://github.com/bitzesty/trade-tariff-backend#load-database

### Admin
- Create DB, run migrations and seeds

  ```
  ~/tariff-docker$ fig run admin bundle exec rake db:create db:migrate db:seed
  ```

### Signonotron2
- Create DB, run migrations
  ```
  ~/tariff-docker$ fig run signonotron2 bundle exec rake db:create db:migrate
  ```

- Create a user
  ```
  ~/tariff-docker$ fig run signonotron2 bundle exec rake users:create name="docker" email="docker@bitzesty.com" applications="trade-tariff-admin,trade-tariff-backend"
  ```
