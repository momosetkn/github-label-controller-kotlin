# Amazon Linux 2ベースのイメージを使用
FROM amazonlinux:2023 as builder


# see https://github.com/GoodforGod/docker-amazonlinux-graalvm/blob/master/java17/arm64v8/Dockerfile
# 必要なパッケージをインストール
# RUN yum install -y gcc zlib-devel libffi-devel tar curl bash

RUN yum install -y tar gcc gcc-c++ bash zlib zlib-devel glibc-static zip gzip unzip openssl openssl-devel \
  && yum upgrade -y \
    && yum autoremove

 # SDKMAN!をインストール
RUN curl -s "https://get.sdkman.io" | bash

# SDKMAN!の環境変数を設定
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    sdk install java 21.0.4-graal"

# 作業ディレクトリを作成
WORKDIR /app

# アプリケーションのソースコードをコピー（jarファイル）
COPY ./build/libs/github-label-controller-kotlin-1.0-SNAPSHOT-all.jar .
#COPY ./reflection-config.json .

# native-imageコマンドでネイティブイメージをビルド
# https://docs.oracle.com/cd/F44923_01/enterprise/21/docs/reference-manual/native-image/Reflection/#manual-configuration
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
        native-image \
          --no-fallback \
      --initialize-at-build-time \
     -H:+ReportUnsupportedElementsAtRuntime \
    --no-server \
    --enable-url-protocols=http \
          -jar github-label-controller-kotlin-1.0-SNAPSHOT-all.jar \
    lambda-function"
#     native-image \
#       --no-fallback \
#       --initialize-at-build-time \
#       -H:Name=lambda-function \
#       -jar github-label-controller-kotlin-1.0-SNAPSHOT-all.jar \
#       --report-unsupported-elements-at-runtime \
#       -H:+ReportExceptionStackTraces \
#       -H:+UnlockExperimentalVMOptions"

#    native-image \
#      --no-fallback \
#      --initialize-at-build-time \
#      -H:Class=com.example.LambdaHandler \
#      -H:Name=lambda-function \
#      -jar github-label-controller-kotlin-1.0-SNAPSHOT-all.jar"




# 実行環境を新たに設定（Amazon Linux 2で実行するための軽量ステージ）
FROM amazonlinux:2023

# 作業ディレクトリを作成
WORKDIR /app

# ビルド済みのネイティブバイナリをコピー
#COPY --from=builder /app/myapp /app/myapp
COPY --from=builder /app/lambda-function /app/myapp
#COPY ./containers/boostrap /var/runtime/bootstrap
#RUN chmod +x /var/runtime/bootstrap

# エントリーポイントを設定してバイナリを実行
ENTRYPOINT ["/app/myapp"]
