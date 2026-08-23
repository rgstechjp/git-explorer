# Class 1 Workshop — Git Internals & Branching
# クラス1 ワークショップ — Gitの内部構造とブランチ

> Open this file alongside the slides. Each section = one slide topic.
> スライドと一緒にこのファイルを開く。各セクション = 1つのスライドトピック。

---

## SETUP — Before Slide 3 / スライド3の前に

```bash
# Fork https://github.com/rgstechjp/git-explorer on GitHub, then:
git clone https://github.com/<YOUR-USERNAME>/git-explorer.git
cd git-explorer
git remote add upstream https://github.com/rgstechjp/git-explorer.git
git log --oneline
```

✅ You should see 3-4 commits. / 3〜4のコミットが見えればOK。

---

## SLIDE 5 — The 4 Git Objects / 4つのGitオブジェクト

**Step 1: Read a real Commit object / コミットオブジェクトを読む**
```bash
git log --oneline -1
git cat-file -p $(git rev-parse HEAD)
```
→ See: `tree`, `parent`, `author`, `committer`, message  
→ 確認: `tree`、`parent`、`author`、`committer`、メッセージ

**Step 2: Read the Tree inside / Treeを読む**
```bash
git cat-file -p $(git rev-parse HEAD^{tree})
```
→ See: a list of files, each with a blob SHA  
→ 確認: ファイルの一覧、それぞれにblob SHA

**Step 3: Read a Blob / Blobを読む**
```bash
# Copy any blob SHA from the list above
git cat-file -p <blob-sha>
```
→ Raw file bytes. No filename. No path. Just content.  
→ 生のファイルバイト列。ファイル名なし。パスなし。内容だけ。

> **Question:** Change one character in any file. Does the blob SHA change?  
> **質問:** ファイルの1文字を変えたらblob SHAは変わる？

```bash
echo "test" >> README.md
git hash-object README.md      # new SHA
git checkout -- README.md      # undo
```

---

## SLIDE 6 — Branches Are Just Files / ブランチはただのファイル

**Step 1: Read HEAD / HEADを読む**
```bash
cat .git/HEAD
```
→ `ref: refs/heads/main` — just text pointing to a branch  
→ ただのテキスト、ブランチへのポインタ

**Step 2: Read the branch file / ブランチファイルを読む**
```bash
cat .git/refs/heads/main
```
→ One 40-character SHA. That IS the branch. / 40文字のSHA。それがブランチの全て。

**Step 3: Create a branch and watch Git write a file / ブランチを作ってGitがファイルを書く様子を確認**
```bash
git checkout -b test-branch
cat .git/refs/heads/test-branch   # same SHA as main!
ls .git/refs/heads/               # see both branches as files
git checkout main
git branch -d test-branch
ls .git/refs/heads/               # test-branch file is gone
```

> **Key insight:** Branches cost nothing. Create them freely.  
> **ポイント:** ブランチのコストはゼロ。気軽に作っていい。

---

## SLIDE 7 & 8 — Branching Strategies / ブランチ戦略

**Discuss with the person next to you (2 min):**  
**隣の人と2分間話し合う:**

- What branching strategy does your team use?  
  チームはどのブランチ戦略を使っている？
- Which of GitFlow / GitHub Flow / Trunk-Based fits it best?  
  3つの中でどれが一番近い？

**Sketch your team's flow here:**  
**チームのフローを書いてみる:**

```
main:    ──●──────────────────●──
            \                /
feature:     ●──●──●──●──●
```

---

## LAB PART 1 — Add Your Profile / プロフィールを追加
### (Slide 9 — ~20 min)

```bash
# 1. Create your branch
git checkout -b add-student/<your-name>

# 2. Copy and fill in your profile
cp students/example.json students/<your-github-username>.json
# Edit the file with your info

# 3. Commit and push
git add students/<your-github-username>.json
git commit -m "feat: add <your name> to student roster"
git push origin add-student/<your-name>

# 4. Open a Pull Request on GitHub
# 5. Wait for teacher to merge, then:
git pull upstream main
git log --oneline --graph --all
```

```bash
# 6. Run the explorer — see your objects
bash explore.sh
```

---

## LAB PART 2 — Merge Conflict / マージコンフリクト
### (~25 min — pair exercise / ペア演習)

This is the most important skill. Every developer hits this.  
これが最も重要なスキル。すべての開発者がこれに遭遇する。

**Pair up with the person next to you. / 隣の人とペアになる。**

Call yourselves **Person A** and **Person B**.  
**Aさん** と **Bさん** と呼ぶ。

---

**BOTH — sync first:**
```bash
git checkout main
git pull upstream main
```

**BOTH — create a branch from main:**
```bash
# Person A:
git checkout -b conflict/<your-name>-a
# Person B:
git checkout -b conflict/<your-name>-b
```

**BOTH — open `TEAM.md` and edit the SAME line:**  
**両方とも `TEAM.md` を開いて同じ行を編集する:**

Find the section with your row number and replace `_____` with your name.  
自分の行番号のセクションを見つけて `_____` を自分の名前に変える。

**BOTH — commit and push:**
```bash
git add TEAM.md
git commit -m "feat: add my name to TEAM.md"
git push origin conflict/<your-name>-a   # or -b
```

**BOTH — open a Pull Request on GitHub.**

---

**Person A's PR merges first — no conflict.**  
**AさんのPRが先にマージ → コンフリクトなし。**

**Person B — your PR now has a conflict. Fix it:**  
**Bさん — あなたのPRにコンフリクトが発生。修正する:**

```bash
# Pull the latest main (which now has A's change)
git checkout main
git pull upstream main

# Go back to your branch
git checkout conflict/<your-name>-b

# Merge main into your branch — conflict appears here
git merge main
```

Git will mark the conflict in `TEAM.md`:  
Gitが `TEAM.md` にコンフリクトをマークする:

```
<<<<<<< HEAD  (your change)
Row 3: Yuki
=======
Row 3: Tanaka     (A's change already merged)
>>>>>>> main
```

**Edit the file to keep BOTH names:**  
**両方の名前を残すようにファイルを編集する:**

```
Row 3: Yuki & Tanaka
```

```bash
# Mark as resolved and push
git add TEAM.md
git commit -m "fix: resolve conflict — keep both names"
git push origin conflict/<your-name>-b
```

**Your PR is now mergeable. Teacher merges. Everyone pulls.**

---

**After all conflicts resolved — everyone runs:**  
**全コンフリクト解決後 — 全員実行:**

```bash
git pull upstream main
git log --oneline --graph --all
```

→ See the full class history: profiles + conflicts, all in one graph.  
→ クラス全体の履歴が見える：プロフィール＋コンフリクト、すべて1つのグラフに。

---

## What You Proved Today / 今日証明したこと

| Concept / 概念 | Proof / 証拠 |
|---|---|
| Commits store trees, not diffs | You read the raw objects with `cat-file` |
| Branches are files | You `ls .git/refs/heads/` |
| Merges create 2-parent commits | You saw it in `git log --graph` |
| Conflicts are just text markers | You edited the markers out by hand |
| Nothing is lost | Every commit is still in the graph |

**See you in Class 2 — we'll clean up that messy commit history.**  
**クラス2で会いましょう — 汚いコミット履歴をきれいにします。**
