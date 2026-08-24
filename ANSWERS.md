## Exercise 2a
## Task1
```
cp hooks-examples/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
sed -n '5p' .git/hooks/pre-commit
PATTERNS="TODO"
echo "TODO: fix later" > todo_test.txt
git add todo_test.txt
git commit -m "test: try to commit a TODO"

ERROR: Possible secret found in staged files.
エラー：ステージングファイルにシークレットが見つかりました。

1. Rotate the credential immediately / まず認証情報を無効化する
2. Remove it from your code / コードから削除する
3. Then commit again / その後コミットする

git reset todo_test.txt
rm todo_test.txt
echo "this file is clean" > clean_test.txt
git add clean_test.txt
git commit -m "test: add clean file"
[hooks2a/Shun-N0 56657c6] test: add clean file
 1 file changed, 1 insertion(+)
 create mode 100644 clean_test.txt
```

## Task2
```
cp hooks-examples/commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
ls -l .git/hooks/commit-msg   
-rwxr-xr-x  1 shun.nakayama  staff  648  8月 24 15:19 .git/hooks/commit-msg
```
`.git/hooks/commit-msg`に追加したコード
```
if [ ${#MSG} -gt 50 ]; then
  echo ""
  echo "ERROR: Commit message is too long (${#MSG} chars, max 50)."
  echo "エラー：コミットメッセージが長すぎます（${#MSG}文字 / 最大50文字）。"
  echo ""
  echo "Your message / あなたのメッセージ: \"$MSG\""
  echo ""
  exit 1
fi    
```
```
grep -n '${#MSG}' .git/hooks/commit-msg
23:if [ ${#MSG} -gt 50 ]; then
25:  echo "ERROR: Commit message is too long (${#MSG} chars, max 50)."
26:  echo "エラー：コミットメッセージが長すぎます（${#MSG}文字 / 最大50文字）。"

echo "length test" > len_test.txt
git add len_test.txt
git commit -m "feat: add a very long commit message to test the limits here"

ERROR: Commit message is too long (60 chars, max 50).
エラー：コミットメッセージが長すぎます（60文字 / 最大50文字）。

Your message / あなたのメッセージ: "feat: add a very long commit message to test the limits here"

git commit -m "feat: add length test file"
[hooks2a/Shun-N0 7b5c5c3] feat: add length test file
 1 file changed, 1 insertion(+)
 create mode 100644 len_test.txt
```

## Task3
フックにおける exit 0 は「チェック合格」としてGitに処理の続行を指示し、exit 1（0以外の値）は「不合格」としてコミットなどの処理を中止させる。
.git/hooks/ がGitHubにプッシュできないのは、そもそも .git/ フォルダがGit自身の管理用ディレクトリであり、git add の対象にならないためである。
これは、他人のリポジトリをクローンした際に、悪意のあるスクリプトが自分のPCで勝手に実行されるのを防ぐための重要な安全策にもなっている。
そのため、今回のように見本（hooks-examples/）をGit管理下に置いて共有し、各自がローカルでコピーして設置する運用が取られている。