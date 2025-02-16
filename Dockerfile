# =======================================================
# ビルドステージ
# =======================================================
FROM node:lts-slim AS builder

# 作業ディレクトリを設定
WORKDIR /usr/src/app

# 依存関係をインストールするためにパッケージファイルをコピー
COPY package*.json ./

# 依存関係をインストール
RUN npm install

# アプリケーションのソースコードをすべてコピー
COPY . .

# アプリケーションをビルド
RUN npm run build

# =======================================================
# 本番ステージ
# =======================================================
FROM node:lts-slim

# 作業ディレクトリを設定
WORKDIR /usr/src/app

# 環境変数を本番モードに設定
ENV NODE_ENV=production

# 本番環境用の依存関係のみをインストールするためにパッケージファイルをコピー
COPY package*.json ./

# 本番環境用の依存関係のみをインストール
RUN npm install --only=production

# ビルドステージからビルド成果物（.next フォルダと public フォルダ）をコピー
COPY --from=builder /usr/src/app/.next ./.next
COPY --from=builder /usr/src/app/public ./public

# ポート番号は Cloud Run が自動的に提供するため設定不要

# アプリケーションの起動コマンドを指定
CMD ["npm", "start"]