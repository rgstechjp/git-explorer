# Git Explorer — 3-Class Workshop Repo
# Gitエクスプローラー — 3クラスワークショップリポジトリ

> One repo. Three classes. Each class builds on the last.
> 1つのリポジトリ。3クラス。各クラスが前のクラスの上に積み上がる。

---

## The Arc / 全体の流れ

| Class | Topic | What you do in THIS repo |
|-------|-------|--------------------------|
| **1** | Git Internals & Branching | Add your profile · explore objects · survive a merge conflict |
| **2** | Rewriting History | Clean up messy commits · bisect a bug · cherry-pick |
| **3** | Automation & Recovery | Add a hook · simulate a disaster · recover with reflog |

---

## Repo Structure / リポジトリ構成

```
git-explorer/
├── students/              ← Class 1: your profile JSON
├── TEAM.md                ← Class 1: merge conflict exercise  
├── code/
│   └── calculator.js      ← Class 2: git bisect target
├── hooks-examples/
│   ├── pre-commit         ← Class 3: copy to .git/hooks/
│   └── commit-msg         ← Class 3: copy to .git/hooks/
├── explore.sh             ← Class 1: inspect git objects
├── WORKSHOP_CLASS1.md     ← follow this in Class 1
├── WORKSHOP_CLASS2.md     ← follow this in Class 2
├── WORKSHOP_CLASS3.md     ← follow this in Class 3
└── README.md              ← this file
```

---

## Setup — Do This Once / セットアップ — 一度だけ実行

```bash
# Fork on GitHub, then:
git clone https://github.com/<YOUR-USERNAME>/git-explorer.git
cd git-explorer
git remote add upstream https://github.com/rgstechjp/git-explorer.git
```

The `upstream` remote lets you pull instructor changes between classes.  
`upstream`リモートでクラス間に講師の変更を取得できる。

```bash
# Start of each class — sync with instructor's latest:
git checkout main
git pull upstream main
```
