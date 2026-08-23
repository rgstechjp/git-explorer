# Class 1 Workshop — Git Explorer 🔍
# クラス1 ワークショップ — Git エクスプローラー

> Live at: **https://`<your-username>`.github.io/git-explorer/**  
> ライブURL: **https://`<あなたのユーザー名>`.github.io/git-explorer/**

---

## What You'll Do / やること

1. **Fork** this repo on GitHub → clone it locally  
   このリポジトリをForkしてローカルにcloneする

2. **Add yourself** to `students/` — one JSON file per student  
   `students/`フォルダに自分のJSONファイルを追加する

3. **Push** → GitHub Actions deploys your change **live in ~30 seconds**  
   プッシュ → GitHub Actionsが約30秒でライブ反映する

4. **Explore** the `.git/` objects behind your commit  
   コミット裏の`.git/`オブジェクトを探索する

5. **Create a feature branch** → PR → merge → see the history  
   フィーチャーブランチを作成 → PR → マージ → 履歴を確認する

---

## Step-by-Step / ステップバイステップ

### Step 1 — Fork & Clone

```bash
# On GitHub: click "Fork" (top right)
# GitHubで右上の「Fork」をクリック

git clone https://github.com/<YOUR-USERNAME>/git-explorer.git
cd git-explorer
```

### Step 2 — Add Yourself / 自分を追加

Create a file at `students/<your-github-username>.json`:  
`students/<あなたのGitHubユーザー名>.json` を作成する:

```json
{
  "name": "Your Name",
  "github": "your-username",
  "role": "Developer",
  "fact": "One fun thing about you",
  "favorite_git_command": "git log --oneline --graph"
}
```

Japanese version / 日本語版:
```json
{
  "name": "あなたの名前",
  "github": "your-username",
  "role": "エンジニア",
  "fact": "あなたについての面白い一言",
  "favorite_git_command": "git log --oneline --graph"
}
```

### Step 3 — Commit & Push on a Feature Branch / フィーチャーブランチでコミット＆プッシュ

```bash
# Create a branch — name it after yourself
# 自分の名前のブランチを作る
git checkout -b add-student/<your-name>

git add students/<your-username>.json
git commit -m "feat: add <your name> to student roster"

git push origin add-student/<your-name>
```

Then open a Pull Request on GitHub.  
GitHubでPull Requestを作成する。

### Step 4 — Explore the Objects / オブジェクトを探索

Run the included script to see what Git stored:  
付属スクリプトでGitが保存したものを確認する:

```bash
bash explore.sh
```

Or explore manually / 手動で探索:

```bash
# What is HEAD pointing at?
cat .git/HEAD

# What SHA does your branch point at?
cat .git/refs/heads/add-student/<your-name>

# Inspect your commit
git cat-file -p $(git rev-parse HEAD)

# Inspect the tree inside your commit
git cat-file -p $(git rev-parse HEAD^{tree})

# Inspect your JSON file as a blob
git cat-file -p $(git rev-parse HEAD:students/<your-username>.json)
```

---

## How GitHub Actions Works Here / GitHub Actionsの仕組み

Every push to `main` triggers `.github/workflows/deploy.yml`:

```
push to main
    ↓
GitHub Actions reads students/*.json
    ↓
Builds index.html from template + student data
    ↓
Deploys to GitHub Pages (gh-pages branch)
    ↓
Live at https://<username>.github.io/git-explorer/
```

You can watch it run: **GitHub → Actions tab**  
実行状況を確認：**GitHub → Actionsタブ**

---

## Discussion Questions / 討論テーマ

After you've all pushed and can see the live page, discuss:  
全員がプッシュしてライブページを確認したら討論する:

1. Open `git log --oneline --graph --all` — what shape is the history?  
   履歴の形はどうなっている？

2. How many git objects were created for your one JSON file?  
   JSONファイル1つで何個のgitオブジェクトが作られた？

3. Two people edited the same file — what happened? How did Git detect it?  
   2人が同じファイルを編集したら何が起きる？Gitはどう検知する？

4. If you delete your local repo and re-clone, is anything lost?  
   ローカルリポジトリを削除して再クローンしたら何か失われる？

---

## Repo Structure / リポジトリ構成

```
git-explorer/
├── .github/
│   └── workflows/
│       └── deploy.yml      ← GitHub Actions pipeline
├── students/
│   └── example.json        ← Template — copy and fill in yours
├── src/
│   ├── build.js            ← Reads students/*.json → builds index.html
│   └── template.html       ← Page template
├── explore.sh              ← Script to inspect git objects
└── README.md               ← This file
```
