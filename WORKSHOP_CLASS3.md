# Class 3 Workshop — Automation & Disaster Recovery
# クラス3 ワークショップ — 自動化と障害復旧

> Same repo. Three classes of history behind you. Now protect and automate it.
> 同じリポジトリ。3クラス分の履歴がある。今度はそれを保護・自動化する。

---

## SETUP — Start of Class / クラス開始時

```bash
cd git-explorer
git checkout main
git pull upstream main
git log --oneline --graph --all   # see the full 3-class history
```

---

## SLIDE 17 & 18 — Git Hooks / Gitフック

Hooks live in `.git/hooks/` — they are NOT committed to the repo.  
フックは `.git/hooks/` にある — リポジトリにはコミットされない。

**Step 1: Install the pre-commit hook from this repo:**  
**ステップ1：このリポジトリのpre-commitフックをインストール:**

```bash
cp hooks-examples/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

**Step 2: Try to commit a secret — hook should block it:**  
**ステップ2：シークレットをコミットしようとする — フックがブロックするはず:**

```bash
git checkout -b hooks-test/<your-name>
echo 'api_key = "abc123supersecret"' >> students/<your-username>.json
git add students/<your-username>.json
git commit -m "test: does the hook catch this?"
```

→ Commit should be **blocked** with an error message.  
→ エラーメッセージでコミットが **ブロック** されるはず。

**Step 3: Install the commit-msg hook:**  
**ステップ3：commit-msgフックをインストール:**

```bash
cp hooks-examples/commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
```

**Step 4: Try a bad commit message — hook blocks it:**  
**ステップ4：悪いコミットメッセージを試す — フックがブロック:**

```bash
# Undo the bad staged file first
git checkout -- students/<your-username>.json

echo "my class 3 note" >> students/<your-username>.json
git add students/<your-username>.json

git commit -m "stuff"              # BLOCKED — bad format
git commit -m "feat: add class 3 note"   # PASSES
```

> **Key insight:** The hook runs on YOUR machine. Push to team = everyone needs the hook.  
> **ポイント:** フックはあなたのマシンで動く。チーム全員が必要なら全員にインストール必要。  
> **Solution:** Use `husky` (Node) or `pre-commit` (Python) to share hooks via the repo.  
> **解決策:** `husky`や`pre-commit`でリポジトリ経由でフックを共有する。

---

## SLIDE 19 — Git Worktrees / Gitワークツリー

**Scenario: You are in the middle of something. Urgent bug.**  
**シナリオ：作業中に緊急バグが来た。**

```bash
# You're mid-work on your hooks branch
# Don't stash — use a worktree instead

git worktree add ../git-explorer-hotfix main
cd ../git-explorer-hotfix

git checkout -b hotfix/urgent-fix
echo "hotfix" >> TEAM.md
git add TEAM.md
git commit -m "fix: urgent fix without touching my work"
git push origin hotfix/urgent-fix

# Go back to your original work — untouched
cd ../git-explorer
git log --oneline   # your hooks-test branch is exactly as you left it

# Clean up
git worktree remove ../git-explorer-hotfix
```

---

## SLIDE 20 — git reflog / Gitリフログ

**Simulate a disaster — then recover:**  
**障害をシミュレート — そして復旧する:**

```bash
git checkout main

# Make 3 commits
echo "v1" >> TEAM.md && git add . && git commit -m "commit A"
echo "v2" >> TEAM.md && git add . && git commit -m "commit B"
echo "v3" >> TEAM.md && git add . && git commit -m "commit C"

git log --oneline   # see A, B, C

# "Accidentally" reset hard — commits appear gone
git reset --hard HEAD~3

git log --oneline   # A, B, C are gone!
```

**Recover with reflog:** / **reflogで復旧:**

```bash
git reflog          # find HEAD@{3} — before the reset

git reset --hard HEAD@{3}   # travel back

git log --oneline   # A, B, C are back!
```

> **Nothing is truly lost in Git until garbage collection (30 days by default).**  
> **Gitでは何も本当には失われない — ガベージコレクションまで（デフォルト30日）。**

---

## LAB — The Disaster Drill / 障害復旧ドリル
### (~25 min — do these in order)

**Disaster 1: Delete a branch "by accident"**  
**障害1：「間違えて」ブランチを削除**

```bash
git checkout -b disaster-test/<your-name>
echo "important work" >> students/<your-username>.json
git add . && git commit -m "feat: important work"
git checkout main
git branch -D disaster-test/<your-name>   # force delete
git log --oneline    # branch is gone

# Recover:
git reflog
git checkout -b disaster-test/<your-name> HEAD@{1}   # it's back
```

**Disaster 2: Push --force over someone's work**  
**障害2：push --forceで誰かの作業を上書き**

```bash
# Instructor will demo this on screen — watch git reflog show origin/main
# 講師がスクリーンでデモ — git reflog show origin/main を見る
```

**Disaster 3: Committed a secret**  
**障害3：シークレットをコミット**

```bash
echo 'SECRET_KEY="abc123"' > oops.txt
git add oops.txt && git commit -m "oops"
git log --oneline   # it's in history

# Remove it:
git reset HEAD~1        # unstage the commit
rm oops.txt
git push --force-with-lease origin <your-branch>

# Real world: rotate the key FIRST, then clean history
```

---

## Final — Full Class History / 最終 — クラス全体の履歴

```bash
git pull upstream main
git log --oneline --graph --all
```

You now see: / 今、見えるもの:
- **Class 1:** profile branches + conflict resolutions
- **Class 2:** rebase-practice branches + clean commits
- **Class 3:** hooks-test + hotfix + disaster-test branches

**This is what a real team's git history looks like.**  
**これが実際のチームのgit履歴。**

Every branch, every merge, every fix — all traceable, all recoverable.  
すべてのブランチ、マージ、修正 — すべて追跡可能、すべて復旧可能。
