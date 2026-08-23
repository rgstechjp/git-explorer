#!/usr/bin/env bash
# ============================================================
# Git Explorer — Class 1 Workshop script
# Gitエクスプローラー — クラス1ワークショップスクリプト
#
# Run: bash explore.sh
# ============================================================

CYAN="\033[0;36m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BOLD="\033[1m"
RESET="\033[0m"

hr() { printf '%0.s─' {1..60}; echo; }
header() { echo; echo -e "${BOLD}${CYAN}▶ $1${RESET}"; hr; }
cmd() { echo -e "${YELLOW}\$ $1${RESET}"; eval "$1"; echo; }

echo
echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${GREEN}║   Git Explorer — Class 1 Workshop        ║${RESET}"
echo -e "${BOLD}${GREEN}║   Gitエクスプローラー — クラス1          ║${RESET}"
echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════╝${RESET}"
echo

# ── 1. WHERE IS HEAD? ─────────────────────────────────────────────────────────
header "1. Where is HEAD? / HEADはどこを指している？"
echo -e "  HEAD is a file. Let's read it directly."
echo -e "  HEADはただのファイル。直接読んでみよう。"
echo
cmd "cat .git/HEAD"

BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "DETACHED")
echo -e "  → You are on branch: ${GREEN}${BRANCH}${RESET}"
echo -e "  → 現在のブランチ: ${GREEN}${BRANCH}${RESET}"

if [ "$BRANCH" != "DETACHED" ]; then
  REF_FILE=".git/refs/heads/$BRANCH"
  if [ -f "$REF_FILE" ]; then
    echo
    echo -e "  The branch is also just a file:"
    echo -e "  ブランチもただのファイル："
    cmd "cat $REF_FILE"
  fi
fi

# ── 2. INSPECT THE COMMIT ────────────────────────────────────────────────────
header "2. Inspect your latest commit / 最新コミットを確認"
SHA=$(git rev-parse HEAD 2>/dev/null)
if [ -z "$SHA" ]; then
  echo -e "  ${RED}No commits yet! Make a commit first.${RESET}"
else
  echo -e "  SHA: ${CYAN}${SHA}${RESET}"
  echo -e "  (Full SHA-1 hash — name of the object in .git/objects/)"
  echo -e "  （フルSHA-1ハッシュ — .git/objects/内のオブジェクト名）"
  echo
  echo -e "  Reading the commit object / コミットオブジェクトを読む:"
  cmd "git cat-file -p $SHA"
fi

# ── 3. INSPECT THE TREE ──────────────────────────────────────────────────────
header "3. Inspect the tree (directory snapshot) / ツリーを確認（ディレクトリスナップショット）"
TREE=$(git rev-parse HEAD^{tree} 2>/dev/null)
if [ -n "$TREE" ]; then
  echo -e "  Tree SHA: ${CYAN}${TREE}${RESET}"
  echo
  cmd "git cat-file -p $TREE"
fi

# ── 4. FIND YOUR STUDENT FILE BLOB ───────────────────────────────────────────
header "4. Your student JSON as a blob / あなたのJSONはblobオブジェクト"
GITHUB_USER=$(git config user.name 2>/dev/null | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
STUDENT_FILE="students/${GITHUB_USER}.json"

if [ -f "$STUDENT_FILE" ]; then
  BLOB=$(git rev-parse "HEAD:$STUDENT_FILE" 2>/dev/null)
  echo -e "  File: ${GREEN}${STUDENT_FILE}${RESET}"
  echo -e "  Blob SHA: ${CYAN}${BLOB}${RESET}"
  echo
  echo -e "  The blob stores ONLY the raw file bytes — no filename, no path:"
  echo -e "  blobはファイルのバイト列のみ保存 — ファイル名もパスもない："
  cmd "git cat-file -p $BLOB"
  echo -e "  Note: rename the file and the blob SHA stays the same!"
  echo -e "  注意：ファイル名を変えてもblobのSHAは同じ！"
else
  SAMPLE=$(ls students/*.json 2>/dev/null | grep -v example | head -1)
  if [ -n "$SAMPLE" ]; then
    FNAME=$(basename "$SAMPLE")
    BLOB=$(git rev-parse "HEAD:students/$FNAME" 2>/dev/null)
    echo -e "  (Your file not found — using ${GREEN}${FNAME}${RESET} as example)"
    echo -e "  （あなたのファイルが見つからないため ${GREEN}${FNAME}${RESET} を例として使用）"
    echo
    cmd "git cat-file -p $BLOB"
  else
    echo -e "  ${YELLOW}Add your students/<username>.json first, then re-run this script.${RESET}"
    echo -e "  ${YELLOW}先に students/<username>.json を追加してからこのスクリプトを再実行してください。${RESET}"
  fi
fi

# ── 5. OBJECT COUNT ──────────────────────────────────────────────────────────
header "5. How many objects in your repo? / リポジトリ内のオブジェクト数は？"
cmd "git count-objects -v"
echo -e "  Every commit, tree, blob, and tag is one object."
echo -e "  すべてのcommit、tree、blob、tagが1つのオブジェクト。"

# ── 6. GRAPH ─────────────────────────────────────────────────────────────────
header "6. The commit graph / コミットグラフ"
cmd "git log --oneline --graph --all --decorate -15"

# ── 7. SUMMARY ────────────────────────────────────────────────────────────────
header "7. Key insight / ポイントまとめ"
echo -e "  ${BOLD}A git commit is just 3 pointers:${RESET}"
echo -e "  ${BOLD}gitコミットは3つのポインタの集合体：${RESET}"
echo
echo -e "    ${GREEN}Commit${RESET} → tree SHA   (directory snapshot)"
echo -e "    ${GREEN}Commit${RESET} → parent SHA (previous commit)"
echo -e "    ${GREEN}Commit${RESET} → author + message"
echo
echo -e "  ${BOLD}A branch is ONE SHA in ONE file.  That's it.${RESET}"
echo -e "  ${BOLD}ブランチは1つのファイルに1つのSHA。それだけ。${RESET}"
echo
echo -e "  ${CYAN}Nothing is ever truly deleted.  git reflog is your safety net.${RESET}"
echo -e "  ${CYAN}何も本当には削除されない。git reflogが安全網。${RESET}"
echo
