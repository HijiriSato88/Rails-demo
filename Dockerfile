# 現在の最新の安定版
FROM ruby:3.3.1
# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs default-mysql-client
# ディレクトリを作成する　これはコンテナの中の話
RUN mkdir /app-demo


# 作業ディレクトリを指定する
WORKDIR /app-demo
#　gemfileをコンテナに追加する
ADD Gemfile /app-demo/Gemfile
# gemfile.lockをコンテナに追加する
ADD Gemfile.lock /app-demo/Gemfile.lock
# gemfileに記述された依存関係をインストール
RUN bundle install
# そのほかのファイルをapp-demoに追加
ADD . /app-demo