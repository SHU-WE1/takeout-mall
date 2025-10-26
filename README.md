# テイクアウト・マルシェ管理システム

Spring Boot + Vue 3 + WeChat MiniProgramをベースにしたフルスタックのテイクアウト配送管理システムです。

## プロジェクト概要

テイクアウト・マルシェ管理システムは、完全なテイクアウト配送ソリューションで、管理バックエンド、WeChat MiniProgramクライアント、および包括的なデータ管理システムを含みます。システムは料理管理、注文処理、スタッフ管理、データ統計などのコア機能をサポートしています。

## 技術スタック

### バックエンド
- **フレームワーク**: Spring Boot 2.7.3
- **データアクセス**: MyBatis + Druid
- **キャッシュ**: Redis 7.0
- **データベース**: MySQL 8.0
- **認証**: JWT
- **オブジェクトストレージ**: Alibaba Cloud OSS
- **決済**: WeChat Pay

### フロントエンド
- **管理バックエンド**: Vue 2 + TypeScript + Element UI
- **WeChat MiniProgram**: uni-app

## プロジェクト構造

```
takeout mall/
├── backend/              # バックエンドサービス
│   ├── sky-common/      # 共通モジュール
│   ├── sky-pojo/        # エンティティクラス
│   └── sky-server/      # アプリケーションサービス
├── frontend-admin/       # 管理バックエンド
├── miniprogram/          # WeChat MiniProgram
├── docker-compose.yml    # Docker編成設定
├── Dockerfile            # バックエンドイメージビルド
└── README.md             # プロジェクト説明
```

## クイックスタート（プロジェクトをクローン後）

### 重要事項

⚠️ **現在のDocker設定にはデータベースとバックエンドサービスのみが含まれており、フロントエンドはローカルで個別に実行する必要があります**

Dockerに含まれるサービス：
- ✅ MySQL 8.0 データベース
- ✅ Redis 7.0 キャッシュ
- ✅ Spring Boot バックエンドサービス

フロントエンドはローカル実行が必要：
- ⚠️ Vue管理バックエンド（ローカルで `npm run serve` を実行する必要があります）

### 方式1: ハイブリッドモード（推奨、最も簡単）

このモードでは、Dockerでデータベースとバックエンドを起動し、フロントエンドをローカル開発モードで実行します。

#### 1. プロジェクトをクローンしてディレクトリに移動

```bash
git clone <repository-url>
cd "takeout mall"
```

#### 2. Dockerサービスを起動（データベース + バックエンド）

```bash
docker-compose up -d
```

これにより以下が起動します：
- MySQL データベース（ポート 3306）
- Redis キャッシュ（ポート 6379）
- Spring Boot バックエンド（ポート 8080）

**デフォルト管理アカウント**: `admin` / `123456`

#### 3. バックエンドサービスの確認

```bash
# コンテナの状態を確認
docker ps

# バックエンドのログを確認
docker-compose logs -f backend

# バックエンドが起動しているかテスト
curl http://localhost:8080/
```

#### 4. フロントエンド開発サーバーを起動

**重要**: フロントエンドは必ずローカルで実行してください（Dockerにはフロントエンドはありません）

新しいターミナルウィンドウを開いて：

```bash
cd frontend-admin

# 依存関係をインストール（初回実行時のみ必要）
npm install

# 開発サーバーを起動
npm run serve
```

フロントエンドが起動すると、次のように表示されます：
```
App running at:
- Local:   http://localhost:8888/
- Network: http://172.16.31.6:8888/
```

#### 5. システムにアクセス

- **フロントエンド管理バックエンド**: http://localhost:8888
  - ユーザー名: `admin`
  - パスワード: `123456`
  
- **バックエンドAPI**: http://localhost:8080

#### 6. サービスを停止

```bash
# Dockerサービスを停止
docker-compose down

# フロントエンドを停止: フロントエンドを実行しているターミナルで Ctrl+C を押す
```

### 方式2: ローカル開発（手動構成）

#### ステップ1: プロジェクトをクローン

```bash
git clone <repository-url>
cd "takeout mall"
```

#### ステップ2: データベースの準備

MySQLデータベースを作成：

```bash
mysql -u root -p
```

```sql
-- データベースを作成
CREATE DATABASE sky_take_out CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- データベースを使用
USE sky_take_out;

-- 初期化スクリプトをインポート
SOURCE docs/sql/init.sql;
```

#### ステップ3: Redisをインストール

**macOS**:
```bash
brew install redis
brew services start redis
```

**Linux**:
```bash
sudo apt-get install redis-server
sudo systemctl start redis
```

#### ステップ4: バックエンドを構成

`backend/sky-server/src/main/resources/application-dev.yml` を編集：

```yaml
sky:
  datasource:
    host: localhost
    port: 3306
    database: sky_take_out
    username: root
    password: your_password  # あなたのMySQLパスワードに変更

  redis:
    host: localhost
    port: 6379
    password: 123456         # Redisパスワード（設定されている場合）
    database: 10
```

#### ステップ5: バックエンドをコンパイル（JDK 11が必要）

**重要**: JDK 11を使用する必要があります

```bash
# Javaバージョンを確認
java -version  # 11.x.x が表示されるはず

# バージョンが正しくない場合は、JDK 11に切り替え
# macOSでjenvを使用：
jenv local 11.0

# またはJAVA_HOMEを設定
export JAVA_HOME=$(/usr/libexec/java_home -v 11)

# バックエンドディレクトリに移動
cd backend

# クリーンアップしてパッケージ化
mvn clean package -DskipTests

# コンパイル完了を待つ...
```

#### ステップ6: バックエンドを実行

```bash
cd backend
java -jar sky-server/target/sky-server-1.0-SNAPSHOT.jar
```

以下の情報が表示されれば起動成功です：
```
Started SkyApplication in X.XXX seconds
```

#### ステップ7: フロントエンドをインストールして実行

新しいターミナルを開いて：

```bash
cd frontend-admin

# 依存関係をインストール（初回実行時）
npm install

# 開発サーバーを起動
npm run serve
```

フロントエンド起動後、アクセス: http://localhost:8888

#### ステップ8: システムにログイン

- ユーザー名: `admin`
- パスワード: `123456`

### なぜフロントエンドがDockerにないのか？

1. **開発に適している**: ローカル開発モードにはホットリロードがあり、コードを変更すると即座に反映されます
2. **デバッグが容易**: ブラウザで直接デバッグでき、ソースコードを確認できます
3. **パフォーマンスの問題**: フロントエンドの本番ビルドで依存関係の互換性の問題が発生しました（node-fibersがARM Macで問題）
4. **現在の状態**: 開発モードでフロントエンドは正常に動作し、すべての機能を正常に使用できます

## 前置要件

- **JDK 11** （必須は11、他のバージョンは使用不可）
- Maven 3.6+
- Node.js 14+
- Docker & Docker Compose（推奨方式）
- MySQL 8.0+（Dockerを使用しない場合）
- Redis 7.0+（Dockerを使用しない場合）

## デフォルトアカウント

### 管理バックエンド
- ユーザー名: `admin`
- パスワード: `123456`

### データベース
- ホスト: `localhost`
- ポート: `3306`
- データベース名: `sky_take_out`
- ユーザー名: `root`
- パスワード: `root123456`（Docker環境）
- パスワード: あなたのローカルパスワード（ローカル環境）

### Redis
- ホスト: `localhost`
- ポート: `6379`
- パスワード: `123456`（Docker環境）
- パスワード: なしまたはあなたの設定（ローカル環境）

## クイックスタート手順まとめ

### 最も簡単な起動方法（3ステップ）

```bash
# 1. プロジェクトをクローン
git clone <repository-url>
cd "takeout mall"

# 2. データベースとバックエンドを起動（Docker）
docker-compose up -d

# 3. フロントエンドを起動（新しいターミナル）
cd frontend-admin
npm install  # 初回実行時のみ必要
npm run serve
```

アクセス: http://localhost:8888（admin / 123456）

### サービスリスト

| サービス | アドレス | 説明 |
|---------|----------|------|
| フロントエンド管理バックエンド | http://localhost:8888 | ローカルで `npm run serve` を実行 |
| バックエンドAPI | http://localhost:8080 | Dockerで実行 |
| MySQL | localhost:3306 | Dockerで実行 |
| Redis | localhost:6379 | Dockerで実行 |

## コア機能

- ✅ スタッフログイン認証
- ✅ カテゴリ管理
- ✅ 料理管理
- ✅ セットメニュー管理
- ✅ 注文管理
- ✅ データ統計
- ✅ WeChat MiniProgram注文
- ✅ WeChat Pay統合
- ✅ 注文ステータスリアルタイム更新

## 一般的な問題のトラブルシューティング

### 1. ポートが使用中

```bash
# ポートの使用状況を確認
lsof -i :8080  # バックエンドポート
lsof -i :3306  # MySQLポート
lsof -i :6379  # Redisポート
lsof -i :8888  # フロントエンドポート

# 使用中の場合、プロセスを停止するか設定を変更
```

### 2. Javaバージョンの問題

**エラーメッセージ**: `Fatal error compiling: java.lang.NoSuchFieldError`

**解決策**: JDK 11を使用する必要があります
```bash
# バージョンを確認
java -version

# JDK 11に切り替え
jenv local 11.0
```

### 3. フロントエンドがバックエンドに接続できない

確認：
- バックエンドサービスが起動しているか（http://localhost:8080）
- ファイアウォール設定
- `frontend-admin/vue.config.js` のプロキシ設定を確認

### 4. Dockerの起動に失敗

```bash
# 詳細ログを表示
docker-compose logs

# コンテナの状態を確認
docker ps -a

# サービスを再起動
docker-compose restart

# 完全にリセット（データは削除されます）
docker-compose down -v
docker-compose up -d
```

### 5. データベース接続に失敗

確認：
- MySQLサービスが起動しているか
- ユーザー名とパスワードが正しいか
- データベース `sky_take_out` が存在するか
- `init.sql` がインポートされているか

```bash
# Docker方式でMySQLログを表示
docker-compose logs mysql

# MySQLコンテナに入る
docker exec -it sky-mysql mysql -uroot -proot123456
```

### 6. フロントエンドの依存関係のインストールに失敗

```bash
# node_modulesを削除して再インストール
rm -rf node_modules package-lock.json
npm install

# npmが遅い場合は、淘宝ミラーを使用
npm install --registry=https://registry.npmmirror.com
```

## 開発モード vs 本番モード

### 開発モード（現在推奨）
- バックエンド: `java -jar sky-server/target/sky-server-1.0-SNAPSHOT.jar`
- フロントエンド: `npm run serve`
- 利点: ホットリロード、デバッグが容易
- 欠点: ターミナルを開き続ける必要がある

### 本番モード（デプロイ時）
- バックエンド: JARとしてパッケージ化済み、直接実行可能
- フロントエンド: `npm run build` 後にNginxにデプロイ
- 利点: パフォーマンスが良く、バックグラウンドで実行可能
- 欠点: Nginxの設定が必要

## サービスの停止

### Dockerサービスを停止
```bash
docker-compose down        # 停止してコンテナを削除
docker-compose stop        # コンテナを停止するだけで削除しない
```

### ローカルサービスを停止
- バックエンド/フロントエンド: 実行中のターミナルで `Ctrl+C` を押す

## ライセンス

MIT License

## 貢献

Issue と Pull Request の提出を歓迎します！

## 連絡先

問題がある場合は、Issueを提出するか、プロジェクトメンテナーに連絡してください。
