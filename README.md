# Takeout Mall 管理システム

Spring Boot + Vue 2 + WeChat MiniProgramをベースにしたフルスタックのテイクアウト配送管理システムです。

## 🚀 オンラインデモ

**本システムの管理バックエンドとAPIは実際にデプロイされており、以下のリンクからアクセスできます：**

- **フロントエンド管理画面**: http://167.179.78.66
- **API ドキュメント**: http://167.179.78.66:8080/doc.html

### デモアカウント

**管理バックエンド:**
- ユーザー名: `admin`
- パスワード: `123456`

### デプロイに関する注意事項

**現在デプロイされているもの:**
- ✅ 管理バックエンド（Vue.js + Nginx）
- ✅ バックエンドAPI（Spring Boot）
- ✅ データベース（MySQL + Redis）

**デプロイされていないもの:**
- ⚠️ WeChat MiniProgram（ローカル開発用のみ）
  - 理由: WeChat MiniProgramの公開には、WeChat公式アカウントの認証と審査が必要で、個人開発者にとって手続きが複雑なため、デプロイしていません
  - ローカル開発: `miniprogram/` ディレクトリ内のコードをWeChat開発者ツールで開くことで、ローカルでテストできます

※ デモ環境のため、データは定期的にリセットされる可能性があります。

## 📋 プロジェクト概要

Takeout Mallは、完全なテイクアウト配送ソリューションで、管理バックエンド、WeChat MiniProgramクライアント（ローカル開発用）、および包括的なデータ管理システムを含みます。本システムは、料理管理、注文処理、スタッフ管理、データ統計などのコア機能をサポートしています。

**本プロジェクトは Docker を使用してコンテナ化されており、開発環境と本番環境の両方で Docker Compose を使用してデプロイできます。**

### 主要機能

**管理バックエンド:**
- ✅ スタッフログイン認証
- ✅ カテゴリ管理
- ✅ 料理管理
- ✅ セットメニュー管理
- ✅ 注文管理
- ✅ データ統計
- ✅ ダッシュボード

**WeChat MiniProgram（ローカル開発用）:**
- ✅ ユーザーログイン（WeChat認証）
- ✅ 料理・セットメニュー閲覧
- ✅ ショッピングカート
- ✅ 注文発注
- ✅ 注文履歴
- ✅ WeChat Pay統合（開発環境）
- ✅ 住所管理

**バックエンドAPI:**
- ✅ RESTful API
- ✅ JWT認証
- ✅ リアルタイム注文ステータス更新
- ✅ WeChat Pay統合
- ✅ Alibaba Cloud OSS統合

## 🛠️ 技術スタック

### バックエンド
- **フレームワーク**: Spring Boot 2.7.3
- **データアクセス**: MyBatis + Druid
- **キャッシュ**: Redis 7.0
- **データベース**: MySQL 8.0
- **認証**: JWT
- **オブジェクトストレージ**: Alibaba Cloud OSS
- **決済**: WeChat Pay
- **Java**: JDK 17

### フロントエンド
- **管理バックエンド**: Vue 2 + TypeScript + Element UI（本番環境にデプロイ済み）
- **WeChat MiniProgram**: uni-app（ローカル開発用のみ、デプロイなし）

### インフラストラクチャ
- **コンテナ化**: Docker + Docker Compose
  - バックエンド: Spring Boot アプリケーションを Docker コンテナ化
  - フロントエンド: Vue.js アプリケーションを Nginx コンテナで配信
  - データベース: MySQL 8.0 を Docker コンテナで実行
  - キャッシュ: Redis 7.0 を Docker コンテナで実行
- **Webサーバー**: Nginx（Docker コンテナ内で実行）
- **デプロイ**: Docker Compose v2 を使用した一括デプロイ
- **コンテナオーケストレーション**: Docker Compose によるマルチコンテナ管理

## 🚀 クイックスタート

### ローカル開発環境

```bash
# 1. プロジェクトをクローン
git clone <repository-url>
cd "takeout mall"

# 2. Docker Compose でサービスを起動
docker compose -f docker-compose.yml up -d

# 3. フロントエンド開発サーバーを起動（別ターミナル）
cd frontend-admin
npm install
npm run serve
```

**アクセス:**
- フロントエンド管理バックエンド: http://localhost:8888
- バックエンドAPI: http://localhost:8080
- デフォルトアカウント: `admin` / `123456`

### 本番環境デプロイ

**注意**: 現在のデプロイ構成には、管理バックエンドとバックエンドAPIのみが含まれています。WeChat MiniProgramはデプロイしていません（公開手続きが複雑なため）。

**本プロジェクトは Docker を使用してデプロイされます。すべてのサービス（MySQL、Redis、バックエンド、フロントエンド）は Docker コンテナとして実行されます。**

詳細なデプロイ手順については、[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) を参照してください。

**簡単なデプロイ手順:**

```bash
# 1. サーバーにプロジェクトファイルをアップロード
scp -r "/path/to/takeout mall" root@your-server:/root/takeout-mall

# 2. サーバーに SSH 接続
ssh root@your-server

# 3. サーバー環境を初期化
cd /root/takeout-mall
chmod +x server-setup.sh
./server-setup.sh

# 4. プロジェクトをデプロイ（管理バックエンド + バックエンドAPI）
chmod +x deploy.sh
./deploy.sh
```

**デプロイされるサービス（すべて Docker コンテナ）:**
- ✅ MySQL 8.0（Docker コンテナで実行）
- ✅ Redis 7.0（Docker コンテナで実行）
- ✅ Spring Boot バックエンド（Docker コンテナで実行）
- ✅ Vue.js 管理バックエンド（Nginx Docker コンテナで配信）

**デプロイされないサービス:**
- ⚠️ WeChat MiniProgram（ローカル開発用のみ）

## 📁 プロジェクト構造

```
takeout mall/
├── backend/                 # バックエンドサービス（Spring Boot）
│   ├── sky-common/         # 共通モジュール
│   ├── sky-pojo/           # エンティティクラス
│   └── sky-server/         # アプリケーションサービス
├── frontend-admin/          # 管理バックエンド（Vue.js）
│   ├── Dockerfile          # 前端 Dockerfile
│   ├── nginx.conf          # Nginx 配置
│   └── .dockerignore       # Docker 忽略文件
├── miniprogram/             # WeChat MiniProgram（ローカル開発用、デプロイなし）
├── docs/                    # ドキュメント
│   ├── sql/                # データベース初期化スクリプト
│   └── screenshots/        # スクリーンショット
├── docker-compose.yml       # ローカル開発用 Docker Compose 設定
├── docker-compose.prod.yml  # 本番環境用 Docker Compose 設定
├── Dockerfile               # バックエンド用 Dockerfile
├── frontend-admin/Dockerfile # フロントエンド用 Dockerfile
├── server-setup.sh          # サーバー環境初期化スクリプト
├── deploy.sh                # デプロイスクリプト
└── README.md                # プロジェクト説明
```

## 📚 ドキュメント

- [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) - 詳細なデプロイガイド
- [DEPLOYMENT_STEPS.md](./DEPLOYMENT_STEPS.md) - 簡易デプロイ手順
- [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md) - デプロイチェックリスト
- [USER_GUIDE.md](./USER_GUIDE.md) - ユーザー操作ガイド

## 🔧 前置要件

### ローカル開発
- **JDK 17**
- Maven 3.6+
- Node.js 14+
- Docker & Docker Compose v2

### 本番環境
- Docker & Docker Compose v2
- サーバー: Ubuntu 22.04+ または CentOS 7+
- メモリ: 最低 2GB RAM
- ディスク: 最低 20GB 空き容量

## 🐳 Docker デプロイメント

本プロジェクトは **Docker** と **Docker Compose** を使用してコンテナ化されています。すべてのサービスは Docker コンテナとして実行され、開発環境と本番環境の両方で一貫した動作を保証します。

### Docker を使用する利点

- ✅ **環境の一貫性**: 開発環境と本番環境で同じ Docker イメージを使用
- ✅ **簡単なデプロイ**: Docker Compose で一括起動・停止が可能
- ✅ **依存関係の管理**: データベース、キャッシュ、アプリケーションを個別にコンテナ化
- ✅ **スケーラビリティ**: コンテナ単位で簡単にスケールアップが可能
- ✅ **リソース効率**: コンテナ間でリソースを効率的に共有

### Docker Compose コマンド

### ローカル開発環境

```bash
# サービスを起動
docker compose -f docker-compose.yml up -d

# サービスを停止
docker compose -f docker-compose.yml down

# ログを確認
docker compose -f docker-compose.yml logs -f
```

### 本番環境

```bash
# サービスを起動
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d

# サービスを停止
docker compose -f docker-compose.prod.yml --env-file .env.prod down

# ログを確認
docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f
```

## ⚠️ トラブルシューティング

### Docker Compose コマンドが見つからない

**問題**: `docker-compose: command not found`

**解決策**: Docker Compose v2 では `docker compose`（ハイフンなし）を使用します。

```bash
# 正しいコマンド
docker compose version
```

### フロントエンドのビルドエラー

**問題**: `Cannot find module '../package.json'`

**解決策**: `.dockerignore` ファイルを作成して `node_modules` を除外します。

```bash
cd frontend-admin
echo "node_modules" > .dockerignore
```

### データベース接続に失敗

確認事項:
- MySQL サービスが起動しているか
- ユーザー名とパスワードが正しいか
- データベース `sky_take_out` が存在するか

```bash
# Docker 方式で MySQL ログを表示
docker compose -f docker-compose.yml logs mysql
```

## 📱 WeChat MiniProgram について

**ローカル開発:**
- WeChat MiniProgramは、`miniprogram/` ディレクトリ内のコードをWeChat開発者ツールで開くことで、ローカルでテストできます
- バックエンドAPIに接続して、すべての機能をテストできます

**デプロイについて:**
- WeChat MiniProgramの公開には、WeChat公式アカウントの認証と審査が必要です
- 個人開発者にとって手続きが複雑なため、本プロジェクトではデプロイしていません
- 管理バックエンドとAPIのみをデプロイしており、これで管理機能とAPIの動作確認が可能です

## 🔒 セキュリティ注意事項

1. **環境変数**: `.env.prod` ファイルは Git に含めないでください
2. **パスワード**: 本番環境では強力なパスワードを使用してください
3. **証明書**: 微信支付証明書ファイルは安全に保管してください
4. **ファイアウォール**: 必要最小限のポートのみ開放してください
5. **HTTPS**: 本番環境では HTTPS を使用することを推奨します
6. **WeChat MiniProgram**: ローカル開発環境でのみ使用し、本番環境ではデプロイしていません

## 📝 ライセンス

MIT License

## 🤝 貢献

Issue と Pull Request の提出を歓迎します！

## 📧 連絡先

問題がある場合は、Issueを提出するか、プロジェクトメンテナーに連絡してください。
