
### Task 1 — TODOをブロックする
hooks-examples/pre-commit を .git/hooks/pre-commit にコピーし、実行権限を付与。PATTERNS の正規表現を TODO に変更した。
テスト1:「TODO: fix later」を含むファイル → ブロックされる
$ echo "TODO: fix later" > todo_check.txt
$ git add todo_check.txt
$ git commit -m "check todo block"
TODO: fix later

ERROR: Possible secret found in staged files.
エラー：ステージングファイルにシークレットが見つかりました。

1. Rotate the credential immediately / まず認証情報を無効化する
2. Remove it from your code / コードから削除する
3. Then commit again / その後コミットする
テスト2: きれいなファイル → 通る
$ echo "just a normal line" > todo_check.txt
$ git add todo_check.txt
$ git commit -m "check clean commit passes"
[hooks2a/Daiki-TANAHARA cc68493] check clean commit passes
 1 file changed, 1 insertion(+)
 create mode 100644 todo_check.txt

### Task 2 — メッセージの長さルール

`hooks-examples/commit-msg` を `.git/hooks/commit-msg` にコピーし、実行権限を付与。既存のフォーマットチェックに加えて、メッセージ長が50文字を超える場合に拒否する条件を追加した（`${#MSG}` を使用）。

**テスト1: 正しい形式で60文字超 → 拒否される**

```
$ git commit -m "feat: add a really long description just to test message length here"

ERROR: Commit message is too long (68 chars, max 50).
エラー：コミットメッセージが長すぎます（68文字、上限50文字）。
```

**テスト2: 正しい形式で50文字以内 → 通過する**

```
$ git commit -m "feat: add login page validation"
[hooks2a/Daiki-TANAHARA eaaea07] feat: add login page validation
 1 file changed, 1 insertion(+)
 create mode 100644 msg_test.txt
```

## Exercise 2a

### Task 3 — 先生のように説明

Gitフックはシェルスクリプトの終了コード（exit code）で結果を伝える。exit 0 を返すとフックは「問題なし」と判断され、コミットなどの処理がそのまま続行される。一方 exit 1（0以外の値）を返すと、フックは処理を拒否したとみなされ、コミットが中断される。今回の演習でも、pre-commit や commit-msg フックが exit 1 を返すことでコミットがブロックされる様子を実際に確認できた。

また、.git/hooks/ の中身はGitHubにプッシュできない。理由は、.git/ ディレクトリはリポジトリの内容そのものではなく、Git自体が使う管理用データ（コミット履歴、設定、フックなど）を保存する場所であり、Gitの追跡対象外だからである。そのため、フックは各開発者がローカル環境ごとに個別にセットアップする必要があり、リポジトリをクローンしても自動的には引き継がれない。