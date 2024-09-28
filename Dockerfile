# Amazon Linux 2ベースのイメージを使用
FROM amazonlinux:2023 as builder

# see https://github.com/GoodforGod/docker-amazonlinux-graalvm/blob/master/java17/arm64v8/Dockerfile
# 必要なパッケージをインストール
# RUN yum install -y gcc zlib-devel libffi-devel tar curl bash

RUN yum install -y tar gcc gcc-c++ bash zlib zlib-devel glibc-static zip gzip java-21-amazon-corretto-devel unzip openssl openssl-devel \
  && yum upgrade -y \
    && yum autoremove

 # SDKMAN!をインストール
RUN curl -s "https://get.sdkman.io" | bash

# SDKMAN!の環境変数を設定
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    sdk install java 21.0.3-graal"

# 作業ディレクトリを作成
WORKDIR /app

# アプリケーションのソースコードをコピー（jarファイル）
COPY ./build/libs/github-label-controller-kotlin-1.0-SNAPSHOT-all.jar .

# native-imageコマンドでネイティブイメージをビルド
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    native-image -jar github-label-controller-kotlin-1.0-SNAPSHOT-all.jar --no-fallback"

# 実行環境を新たに設定（Amazon Linux 2で実行するための軽量ステージ）
FROM amazonlinux:2023

# 作業ディレクトリを作成
WORKDIR /app

# ビルド済みのネイティブバイナリをコピー
#COPY --from=builder /app/myapp /app/myapp
COPY --from=builder /app/github-label-controller-kotlin-1.0-SNAPSHOT-all /app/myapp

# エントリーポイントを設定してバイナリを実行
ENTRYPOINT ["/app/myapp"]
