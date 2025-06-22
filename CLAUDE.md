# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリでコードを扱う際のガイダンスを提供します。

## 開発コマンド

### セットアップ
```bash
make setup
```
mise、SwiftFormat、Xcodeテンプレートをインストールします。

### ビルド＆テスト
```bash
# プロジェクトをビルド
xcodebuild -project Natura.xcodeproj -scheme Natura -configuration Debug build

# テスト実行（Swift Testing framework使用）
xcodebuild test -project Natura.xcodeproj -scheme Natura -destination 'platform=iOS Simulator,name=iPhone 15'

# ユニットテストのみ実行
xcodebuild test -project Natura.xcodeproj -scheme NaturaTests -destination 'platform=iOS Simulator,name=iPhone 15'
```

### コードフォーマット
```bash
# コードフォーマット（SwiftFormatはmiseで管理）
mise exec -- swiftformat .
```

## アーキテクチャ概要

SwiftUIとThe Composable Architecture（TCA）で構築されたiOSアプリで、マルチモジュールSwift Packageとして組織されています。

### モジュール構成
- **RootFeature**: タブベースナビゲーションを持つアプリのルート
- **DashboardFeature**: データベース統合を持つダッシュボード機能
- **HashtagFeature**: CRUD操作を持つハッシュタグ管理
- **PipelineFeature**: パイプライン管理機能
- **GraphFeature**: グラフ管理機能
- **CommonUI**: 共有UIコンポーネント（EmptyStateView、LoadingView）
- **Domain**: ドメインモデルとビジネスロジック
- **Database**: SharingGRDBを使用したGRDBデータベース層

### 主要な依存関係
- **ComposableArchitecture**: 状態管理とアーキテクチャ
- **SharingGRDB**: TCAとのデータベース統合
- **SwiftNavigation**: ナビゲーションユーティリティ

### フィーチャーアーキテクチャパターン
各フィーチャーはTCAパターンに従います：
- `State`、`Action`、`body`を持つ`@Reducer`構造体
- `StoreOf<FeatureReducer>`を受け取るView構造体
- ストア初期化を持つ`#Preview`
- データアクセス用の`@SharedReader`によるデータベース統合

### ファイル構造
```
Modules/Sources/
├── RootFeature/         # TabViewを持つアプリルート
├── DashboardFeature/    # メインダッシュボード
├── HashtagFeature/      # ハッシュタグCRUD
├── PipelineFeature/     # パイプライン管理
├── GraphFeature/        # グラフ管理
├── CommonUI/            # 共有UIコンポーネント
├── Domain/              # モデル（Hashtagなど）
└── Database/            # GRDBスキーマとアクセス
```

## 開発ガイドライン

### 新機能の作成
一貫性のためにXcodeテンプレートを使用：
1. `scripts/natura-templates/Feature.xctemplate`を使用
2. TCAリデューサーパターンに従う
3. `Package.swift`のproducts、targets、String extensionにモジュールを追加
4. 必要な依存関係をインポート（CommonUI、ComposableArchitecture、Domain）

### コードスタイル
- Swiftファイルヘッダーにはファイル名、モジュール、作成日を含める
- SwiftUIプレビューには`#Preview`マクロを使用
- 4スペースインデント、120文字行制限
- 既存の命名規則に従う（型はUpperCamelCase、プロパティはlowerCamelCase）

### データベース統合
- 読み取り専用データベースアクセスには`@SharedReader`を使用
- データベースの変更はStoreアクションを通じて行う
- GRDBモデルはDomainモジュールで定義
- スキーマは`Database/DatabaseSchema.swift`にある

### テスト
- ユニットテストはSwift Testing framework（`@Test`）を使用
- テストファイルは命名パターンに従う：`ModuleNameTests.swift`
- UIテストは`NaturaUITests/`にある