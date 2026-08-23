# Class 1 Workshop Sheet
# クラス1 ワークショップシート

> Follow along with each slide. Every time the teacher moves to a new topic, you have a command to run.
> スライドに合わせて進める。先生がトピックを変えるたびに、実行するコマンドがある。

---

## Before We Start — Setup / 開始前の準備
### (Before Slide 3)

Fork and clone the repo. This is your workspace for today.  
リポジトリをForkしてcloneする。これが今日の作業場。

```bash
# 1. Go to https://github.com/rgstechjp/git-explorer and click Fork
# 2. Then clone YOUR fork:
git clone https://github.com/<YOUR-USERNAME>/git-explorer.git
cd git-explorer
```

Confirm it worked / 確認:
```bash
git log --oneline
```

You should see 2-3 commits. / 2〜3のコミットが見えればOK。

---

## Slide 5 — The 4 Git Objects / 4つのGitオブジェクト

> The teacher is showing Blob / Tree / Commit / Tag on screen.  
> 先生がBlob / Tree / Commit / Tagを説明している。

**Follow along — inspect a real commit object:**  
**一緒にやろう — 実際のコミットオブジェクトを確認する:**

```bash
# Get the SHA of the latest commit
git log --oneline -1

# Read the commit object (replace abc1234 with your SHA)
git cat-file -p abc1234
```

You will see: / こう表示される:
```
tree  xxxxxxx    ← points to a Tree object
parent xxxxxxx   ← points to previous commit
author ...
committer ...

commit message
```

Now inspect the **Tree** inside that commit: / コミット内の **Tree** を確認:
```bash
git cat-file -p $(git rev-parse HEAD^{tree})
```

You will see a list of files — each one a **Blob**. / ファイルの一覧が見える。それぞれが **Blob**。

```bash
# Pick any file SHA from the list above and read its raw content
git cat-file -p <file-sha>
```

> **Key point:** Blob = raw bytes only. No filename. No path.  
> **ポイント:** Blob = 生のバイト列のみ。ファイル名もパスもない。

---

## Slide 6 — Branches Are Just Files / ブランチはただのファイル

> The teacher is showing `.git/HEAD` and `.git/refs/`.  
> 先生が `.git/HEAD` と `.git/refs/` を説明している。

**Read HEAD directly:** / **HEADを直接読む:**
```bash
cat .git/HEAD
```
→ Shows: `ref: refs/heads/main`  
→ This is just text. A branch is just a file with one SHA inside.  
→ これはただのテキスト。ブランチは1つのSHAが入ったファイル。

**Read your branch file:** / **ブランチファイルを読む:**
```bash
cat .git/refs/heads/main
```
→ Shows a 40-character SHA. That's it. That's the entire branch.  
→ 40文字のSHAが表示される。それだけ。それがブランチの全て。

**Now create a branch and watch what happens:** / **ブランチを作って何が起きるか確認:**
```bash
git checkout -b test-branch
cat .git/refs/heads/test-branch
```
→ Same SHA as main. Creating a branch = Git wrote one new file.  
→ mainと同じSHA。ブランチ作成 = Gitが1つの新しいファイルを書いただけ。

```bash
# Clean up — go back to main
git checkout main
git branch -d test-branch
```

> **Key point:** Deleting a branch = Git deletes one file. Nothing else.  
> **ポイント:** ブランチ削除 = Gitが1つのファイルを削除するだけ。それ以外は何もない。

---

## Slide 7 & 8 — Branching Strategies / ブランチ戦略

> The teacher is comparing GitFlow / GitHub Flow / Trunk-Based.  
> 先生がGitFlow / GitHub Flow / Trunk-Basedを比較している。

**Quick discussion with the person next to you (2 min):**  
**隣の人と2分間話し合う:**

- What branching strategy does your current team / project use?  
  現在のチーム・プロジェクトはどのブランチ戦略を使っている？
- Which of the 3 fits it best?  
  3つの中でどれが一番近い？

**Draw your team's branch flow here (simple lines are fine):**  
**チームのブランチフローを書いてみる（簡単な線でOK）:**

```
main:     ──●──────────────────●──
              \                /
feature:       ●──●──●──●──●
```

---

## Lab — Put It All Together / まとめ実習
### (Slide 9)

Now do the full student flow: / 全員で本番フローを実行する:

**1. Create your branch:** / **ブランチを作成:**
```bash
git checkout -b add-student/<your-name>
```

**2. Add your file:** / **ファイルを追加:**
```bash
cp students/example.json students/<your-github-username>.json
```

Open the file and fill in: / ファイルを開いて入力:
```json
{
  "name": "Your Name / あなたの名前",
  "github": "your-github-username",
  "role": "Developer",
  "fact": "One thing about you / あなたについて一言",
  "favorite_git_command": "git log --oneline --graph"
}
```

**3. Commit & Push:** / **コミット＆プッシュ:**
```bash
git add students/<your-username>.json
git commit -m "feat: add <your name>"
git push origin add-student/<your-name>
```

**4. Open a Pull Request on GitHub** / **GitHubでPull Requestを作成**

**5. Run the explorer script:** / **探索スクリプトを実行:**
```bash
bash explore.sh
```

**6. After teacher merges all PRs, run:** / **先生が全PRをマージした後、実行:**
```bash
git pull
git log --oneline --graph --all
```

→ You will see every student's branch in one graph.  
→ 全員のブランチが1つのグラフに表示される。

---

## What You Just Proved / 今証明したこと

| Action / 操作 | Git Object Created / 作られたオブジェクト |
|---|---|
| You added a JSON file | 1 Blob |
| You committed | 1 Tree + 1 Commit |
| Teacher merged your PR | 1 Merge Commit (2 parents) |
| Your branch | 1 file in `.git/refs/heads/` |

**Total: ~3 objects for one file, from one student.**  
**合計：1人の学生、1ファイルで約3つのオブジェクト。**

If there are 15 students → ~45 objects + 15 merge commits.  
15人いれば → 約45オブジェクト + 15個のマージコミット。

All stored as content-addressed files under `.git/objects/`.  
全て `.git/objects/` 以下にコンテンツアドレス型で保存される。
