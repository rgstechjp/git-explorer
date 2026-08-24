## Task 1: TODOをブロック
```
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan] cp hooks-examples/pre-commit .git/hooks/pre-commit
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan] vim .git/hooks/pre-commit
# PATTERNS="TODO"に書き換えたりメッセージも少し変えた
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan] ls
code/           explore.sh      notes.txt       students/       text.txt
demo.txt        hooks-examples/ README.md       TEAM.md
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan] vim text.txt
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan*] cat text.txt
some typo
PLEASE WORK
TODO: fix later
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan*] chmod +x .git/hooks/pre-commit
```
実際にコミットしてみる
```
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan*] git add text.txt
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan+] git commit -m "add todo"
TODO: fix later

ERROR: 'TODO' found in staged files.
エラー: ステージングファイルに 'TODO' が見つかりました。
```

## Task 2: メッセージの長さルール

```
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan] cp hooks-examples/commit-msg .git/hooks/commit-msg
```

その後commit-msgを編集。50を超えるとエラー出すようにした。
```
#!/bin/bash
# Enforces: feat|fix|docs|chore|test: description
# 形式を強制: feat|fix|docs|chore|test: 説明

MSG=$(cat "$1")
PATTERN="^(feat|fix|docs|chore|test|refactor|style): .{5,}"

if [ ${#MSG} -gt 50 ]; then
  echo ""
  echo "ERROR: Commit message is too long (${#MSG} characters)."
  echo "エラー: コミットメッセージが50文字を超えています。"
  echo ""
  exit 1
fi

if ! echo "$MSG" | grep -qE "$PATTERN"; then
  echo ""
  echo "ERROR: Commit message format is wrong."
  echo "エラー：コミットメッセージの形式が間違っています。"
  echo ""
  echo "Required format / 必要な形式:"
  echo "  feat: add login page"
  echo "  fix: resolve null pointer in auth"
  echo "  docs: update README"
  echo ""
  echo "Your message was / あなたのメッセージ: \"$MSG\""
  echo ""
  exit 1
fi

exit 0
```

コミットをして確認する

```
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan] echo "test" > text.txt
git add text.txt
git commit -m "This commit message is intentionally made very long to fail the hook"
hint: The '.git/hooks/commit-msg' hook was ignored because it's not set as executable.
hint: You can disable this warning with `git config set advice.ignoredHook false`.
[hooks2a/ieyoukan f41c7be] This commit message is intentionally made very long to fail the hook
 1 file changed, 1 insertion(+), 2 deletions(-)

# 実行権限つけ忘れてた！
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan] chmod +x .git/hooks/commit-msg
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan] git reset --soft HEAD~1
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan+] git status
On branch hooks2a/ieyoukan
Your branch is up to date with 'origin/hooks2a/ieyoukan'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   text.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        .ANSWERS.md.swp

# もう一度コミットをしてみる
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan+] git commit -m "This commit message is intentionally made very long to fail the hook"

ERROR: Commit message is too long (68 characters).
エラー: コミットメッセージが50文字を超えています。
```

実際にエラーが出ることが確認できた

短い形式を試す
```
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan+] git commit -m "hoge"

ERROR: Commit message format is wrong.
エラー：コミットメッセージの形式が間違っています。

Required format / 必要な形式:
  feat: add login page
  fix: resolve null pointer in auth
  docs: update README

Your message was / あなたのメッセージ: "hoge"
```
feat,fix,docsがないためエラーが出る。

正しい形式を試す。

```
 ~/Documents/lecture/gitenshu/git-explorer/ [hooks2a/ieyoukan+] git commit -m "docs: test-text"
[hooks2a/ieyoukan e4b1ee4] docs: test-text
 1 file changed, 1 insertion(+), 2 deletions(-)

 ```
 コミットできた。

## Task 3 —先生のように説明
exit 0は正しく終了する。
exit 1のような0以外は例外として終了し、Gitの処理を中断させたりする。

#### .git/hooks/ が GitHub にプッシュできない理由
`.git`自体が隠しファイルとしてローカルのリポジトリについて管理するためリモートに上げることはできない。
