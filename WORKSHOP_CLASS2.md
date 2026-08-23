# Class 2 Workshop — Rewriting History Safely
# クラス2 ワークショップ — 履歴を安全に書き換える

> Same repo as Class 1. You already have your profile, your branch, and a conflict in the history.
> クラス1と同じリポジトリ。すでにプロフィール、ブランチ、履歴のコンフリクトがある。

---

## SETUP — Start of Class / クラス開始時

```bash
cd git-explorer
git checkout main
git pull upstream main
git log --oneline --graph --all   # remember the class 1 history
```

---

## SLIDE 12 — Interactive Rebase / 対話的リベース

**First — make some intentionally messy commits:**  
**まず — 意図的に汚いコミットを作る:**

```bash
git checkout -b rebase-practice/<your-name>

echo "first attempt" >> students/<your-username>.json
git add . && git commit -m "WIP"

echo "second attempt" >> students/<your-username>.json
git add . && git commit -m "fix"

echo "third attempt" >> students/<your-username>.json
git add . && git commit -m "ok now for real"

echo "final version" >> students/<your-username>.json
git add . && git commit -m "PLEASE WORK"

git log --oneline   # see the mess
```

**Now clean it up with interactive rebase:**  
**対話的リベースで整理する:**

```bash
git rebase -i HEAD~4
```

In the editor, change to: / エディタで変更:
```
pick   xxxxxxx  WIP
squash xxxxxxx  fix
squash xxxxxxx  ok now for real
squash xxxxxxx  PLEASE WORK
```

Save → write one clean message: / 保存 → きれいなメッセージを1つ書く:
```
feat: update my student profile with final info
```

```bash
git log --oneline   # one clean commit
```

> **Rule:** Only rebase commits NOT yet pushed to shared branch.  
> **ルール:** 共有ブランチにプッシュ済みのコミットはリベースしない。

---

## SLIDE 13 — git bisect / バグの二分探索

**The instructor has added a bug to `code/calculator.js`.**  
**講師が `code/calculator.js` にバグを追加した。**

```bash
git pull upstream main
node code/calculator.js   # something is wrong
```

**Find which commit broke it:**  
**どのコミットで壊れたか見つける:**

```bash
git bisect start
git bisect bad                           # current commit is broken
git bisect good $(git log --oneline | tail -5 | tail -1 | cut -c1-7)

# Git checks out the midpoint each time — run the test:
node code/calculator.js

# Tell Git the result:
git bisect good   # or: git bisect bad

# Repeat ~4-5 times until Git says "first bad commit"
git bisect reset   # go back to HEAD when done
```

> **Math:** log₂(commits) = steps. 16 commits = 4 steps.  
> **計算:** log₂(コミット数) = ステップ数。16コミット = 4ステップ。

---

## SLIDE 14 — Cherry-Pick / Cherry-Pick

**The instructor pushed a useful helper commit. Grab just that.**  
**講師が便利なコミットをプッシュした。それだけを取ってくる。**

```bash
git log --oneline upstream/main   # find the instructor's commit SHA

git checkout rebase-practice/<your-name>
git cherry-pick <instructor-sha>

git log --oneline   # your branch now has that one commit
```

**Now try cherry-picking from a classmate's branch:**  
**クラスメートのブランチからもcherry-pickしてみる:**

```bash
git fetch upstream
git log --oneline upstream/<classmate-branch>   # find their commit
git cherry-pick <their-sha>
```

---

## LAB — Clean History PR / きれいな履歴のPR
### (~20 min)

```bash
# Push your clean rebased branch
git push origin rebase-practice/<your-name>
# Open a PR — teacher reviews the clean commit message
```

**Everyone then runs:** / **全員実行:**
```bash
git pull upstream main
git log --oneline --graph --all
```

→ Class 1 history + Class 2 clean commits, all in one graph.  
→ クラス1の履歴 + クラス2のきれいなコミット、全て1つのグラフに。

**See you in Class 3 — we'll add automation and recover from disasters.**  
**クラス3で会いましょう — 自動化と障害復旧をやります。**
