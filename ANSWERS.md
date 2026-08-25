## Exercise 2a

## Task1
「TODO」を含むファイル
``` bash
% echo "TODO: fix later" > test.txt
% git add test.txt
% git commit -m "test: TODO"
TODO: fix later

ERROR: Possible secret found in staged files.
エラー：ステージングファイルにシークレットが見つかりました。

1. Rotate the credential immediately / まず認証情報を無効化する
2. Remove it from your code / コードから削除する
3. Then commit again / その後コミットする
```

きれいなファイル
``` bash
% echo "This is a clean file." > clean.txt
% git add clean.txt
% git commit -m "test: clean file"
[hooks2a/TachikawaKaito 50cd0da] test: clean file
 1 file changed, 1 insertion(+)
 create mode 100644 clean.txt
 ```

 ## Task2
 50文字以上の長いメッセージ
 ``` bash
 % git commit -m "This is a very long commit message that exceeds fifty characters"

ERROR: Commit message format is wrong.
エラー：コミットメッセージの形式が間違っています。

Required format / 必要な形式:
  feat: add login page
  fix: resolve null pointer in auth
  docs: update README

Your message was / あなたのメッセージ: "This is a very long commit message that exceeds fifty characters"
```

短い正しいメッセージ
``` bash
% git commit -m "test: short message"
[hooks2a/TachikawaKaito b74a8c5] test: short message
 1 file changed, 1 insertion(+)
 create mode 100644 test2.txt
```

## Task3
Gitのフックでは、`exit 0` は処理が正常に終了したことを示し、コミットなどの処理を続行できる。
一方、`exit 1` はエラーが発生したことを示し、Gitに処理を中止させるために使われる。

`.git/hooks/` は各ローカルリポジトリにあるGitの内部ディレクトリなので、通常はGitの管理対象にならず、GitHubにpushされない。