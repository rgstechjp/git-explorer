Name: Shunsuke TAMASHIRO
GitHub: tamasyun
Exercise 1: https://github.com/tamasyun/git-practice-tamasyun
## Q1
ERROR: Possible secret found in staged files.
エラー：ステージングファイルにシークレットが見つかりました。

1. Rotate the credential immediately / まず認証情報を無効化する
2. Remove it from your code / コードから削除する
3. Then commit again / その後コミットする

## Q2
ERROR: Commit message format is wrong.
エラー：コミットメッセージの形式が間違っています。

Required format / 必要な形式:
  feat: add login page
  fix: resolve null pointer in auth
  docs: update README

precious work 1
precious work 2

## Q3
## Q3

```text
8049401 HEAD@{1}: reset: moving to HEAD~2
800b148 HEAD@{2}: commit: wip: precious 2
302992c HEAD@{3}: commit: wip: precious 1
```

`git reflog` から `wip: precious 2` のコミットを確認し、`git reset --hard 'HEAD@{1}'` で復旧した。

復旧後：

```text
800b148 (HEAD -> exercise1/tamasyun) HEAD@{0}: reset: moving to HEAD@{1}
8049401 HEAD@{1}: reset: moving to HEAD~2
800b148 (HEAD -> exercise1/tamasyun) HEAD@{2}: commit: wip: precious 2
302992c HEAD@{3}: commit: wip: precious 1
```