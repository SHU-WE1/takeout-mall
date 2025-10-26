# テイクアウト・マルシェ管理システム

Spring Boot + Vue 3 + 微信小程序をベースにしたフルスタックのテイクアウト配送管理システムです。

## プロジェクト概要

テイクアウト・マルシェ管理システムは、完全なテイクアウト配送ソリューションで、管理バックエンド、微信小程序クライアント、および包括的なデータ管理システムを含みます。システムは料理管理、注文処理、スタッフ管理、データ統計などのコア機能をサポートしています。

## 技術スタック

### バックエンド
- **フレームワーク**: Spring Boot 2.7.3
- **データアクセス**: MyBatis + Druid
- **キャッシュ**: Redis 7.0
- **データベース**: MySQL 8.0
- **認証**: JWT
- **オブジェクトストレージ**: 阿里云OSS
- **決済**: 微信支付

### フロントエンド
- **管理バックエンド**: Vue 2 + TypeScript + Element UI
- **微信小程序**: uni-app

## クイックスタート（プロジェクトをクローン後）

### 重要事項

⚠️ **現在のDocker設定にはデータベースとバックエンドサービスのみが含まれており、フロントエンドはローカルで個別に実行する必要があります**

Dockerに含まれるサービス：
- ✅ MySQL 8.0 データベース
- ✅ Redis 7.0 キャッシュ
- ✅ Spring Boot バックエンドサービス

フロントエンドはローカル実行が必要：
- ⚠️ Vue管理バックエンド（ローカルで `npm run serve` を実行する必要があります）

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

## 前置要件

- **JDK 11** （必須は11、他のバージョンは使用不可）
- Maven 3.6+
- Node.js 14+
- Docker & Docker Compose（推奨）
- MySQL 8.0+（Dockerを使用しない場合）
- Redis 7.0+（Dockerを使用しない場合）

## デフォルトアカウント

### 管理バックエンド
- ユーザー名: `admin`
- パスワード: `123456`

## サービスリスト

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
- ✅ 微信小程序注文
- ✅ 微信支付統合

## 一般的な問題のトラブルシューティング

### 1. ポートが使用中
```bash
lsof -i :8080  # バックエンドポート
lsof -i :8888  # フロントエンドポート
```

### 2. Javaバージョンの問題
JDK 11を使用する必要があります
```bash
java -version
jenv local 11.0
```

### 3. Dockerの起動に失敗
```bash
docker-compose logs
docker-compose down -v
docker-compose up -d
```

## ライセンス

MIT License

## 貢献

Issue と Pull Request の提出を歓迎します！
