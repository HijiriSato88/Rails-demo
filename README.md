# Rails API with Docker

このプロジェクトでは、Dockerを使用してRailsアプリケーションをAPIモードで作成します。以下は作成手順です。

## 手順

1. プロジェクトディレクトリを作成して移動します。
    ```bash
    mkdir new-name
    cd new-name
    ```

2. 以下のファイルをプロジェクトディレクトリに作成します。
   - `Dockerfile`
   - `docker-compose.yml`
   - `Gemfile`
   - `Gemfile.lock`（空の状態で作成）

3. `Dockerfile`に以下を記載します。
    ```Dockerfile
    FROM ruby:3.3.1

    RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs default-mysql-client

    RUN mkdir /app-demo
    WORKDIR /app-demo

    ADD Gemfile /app-demo/Gemfile
    ADD Gemfile.lock /app-demo/Gemfile.lock

    RUN bundle install

    ADD . /app-demo
    ```

4. `docker-compose.yml`に以下を記載します。
    ```yaml
    version: '3'
    services:
      db:
        image: mysql:8.0
        environment:
          MYSQL_ROOT_PASSWORD: password
          MYSQL_DATABASE: mydatabase
        volumes:
          - mysql_volume:/var/lib/mysql
        ports:
          - '3307:3306'
        command: --default-authentication-plugin=mysql_native_password

      web:
        build: .
        command: bundle exec rails s -p 3000 -b '0.0.0.0'
        volumes:
          - .:/app-demo
        ports:
          - "3000:3000"
    volumes:
      mysql_volume:
    ```

5. `Gemfile`に以下を記載します。
    ```ruby
    source 'https://rubygems.org'
    gem 'rails', '7.1.1'
    ```

6. 以下のコマンドでRailsアプリケーションをAPIモードで作成します。
    ```bash
    docker-compose run --rm web rails new . --force --database=mysql --api
    ```
    
7. Dockerfileを３にかきなおします。
    
8. Dockerイメージをビルドします。
    ```bash
    docker-compose build
    ```

9. `config/database.yml`の一部を以下のように修正します。
    ```yaml
    default: &default
      adapter: mysql2
      encoding: utf8mb4
      pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
      username: root
      password: password
      socket: /run/mysqld/mysqld.sock
      host: db
    ```

10. 再度Dockerイメージをビルドします。
    ```bash
    docker-compose build
    ```

11. データベースを作成します。
    ```bash
    docker-compose up db -d
    docker-compose run --rm web bundle exec rails db:create
    ```

12. コンテナを作成し、起動します。
    ```bash
    docker-compose up -d
    ```

13. ブラウザで[http://localhost:3000/](http://localhost:3000/)にアクセスして、アプリケーションが正しく動作していることを確認します。

