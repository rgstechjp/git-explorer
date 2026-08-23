# Class 1 Workshop — Git Explorer
# クラス1 ワークショップ — Git エクスプローラー

**Goal:** Add your name to this repo and explore what Git actually stored.  
**目標：** このリポジトリに名前を追加して、Gitが実際に保存したものを探索する。

---

## What You Need / 必要なもの

- Git installed / Gitインストール済み
- A GitHub account / GitHubアカウント
- Any text editor / テキストエディタ

---

## Step 1 — Fork & Clone

On GitHub, click **Fork** (top right of this page).  
GitHubでこのページ右上の **Fork** をクリック。

```bash
git clone https://github.com/<YOUR-USERNAME>/git-explorer.git
cd git-explorer
```

---

## Step 2 — Create a Branch
## ステップ2 — ブランチを作成

```bash
git checkout -b add-student/<your-name>
```

Example / 例:
```bash
git checkout -b add-student/alok
```

---

## Step 3 — Add Your File
## ステップ3 — ファイルを追加

Copy the example file and fill in your info:  
サンプルファイルをコピーして自分の情報を入力：

```bash
cp students/example.json students/<your-github-username>.json
```

Open the file and edit it:  
ファイルを開いて編集する：

```json
{
  "name": "Your Name",
  "github": "your-github-username",
  "role": "Developer",
  "fact": "One fun thing about you",
  "favorite_git_command": "git log --oneline --graph"
}
```

---

## Step 4 — Commit & Push
## ステップ4 — コミット＆プッシュ

```bash
git add students/<your-username>.json
git commit -m "feat: add <your name> to student roster"
git push origin add-student/<your-name>
```

Then open a **Pull Request** on GitHub.  
GitHubで **Pull Request** を作成する。

---

## Step 5 — Explore What Git Stored
## ステップ5 — Gitが保存したものを探索

Run the explore script:  
探索スクリプトを実行：

```bash
bash explore.sh
```

Or try these manually / または手動で試す：

```bash
# What is HEAD?
cat .git/HEAD

# What SHA does your branch point at?
cat .git/refs/heads/add-student/<your-name>

# Read your commit object
git cat-file -p $(git rev-parse HEAD)

# Read the tree inside your commit
git cat-file -p $(git rev-parse HEAD^{tree})

# Read your JSON file as a blob
git cat-file -p $(git rev-parse HEAD:students/<your-username>.json)

# See the full graph
git log --oneline --graph --all
```

---

## Discussion / 討論

After everyone has pushed, discuss as a group:  
全員がプッシュしたら、グループで話し合う：

1. How many git objects were created for your one file?  
   ファイル1つで何個のgitオブジェクトが作られた？

2. Two people edited the same line — what happens?  
   2人が同じ行を編集したら何が起きる？

3. If you delete your local repo and re-clone, is anything lost?  
   ローカルを削除して再クローンしたら何か失われる？

4. What shape does `git log --graph` have? Why?  
   `git log --graph`の形はどうなっている？なぜ？

---

## Files in This Repo / このリポジトリのファイル

```
git-explorer/
├── students/
│   ├── example.json    ← Copy this and fill in your info
│   └── instructor.json ← Demo entry
├── explore.sh          ← Script to inspect git objects
└── README.md           ← This file
```
