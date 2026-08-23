#!/usr/bin/env node
// Reads students/*.json + git log → builds index.html from template

const fs   = require("fs");
const path = require("path");
const { execSync } = require("child_process");

const ROOT     = path.resolve(__dirname, "..");
const STUDENTS = path.join(ROOT, "students");
const TEMPLATE = path.join(__dirname, "template.html");
const OUT      = path.join(ROOT, "index.html");

// ── helpers ──────────────────────────────────────────────────────────────────
function esc(s) {
  return String(s)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function git(cmd) {
  try { return execSync(`git -C "${ROOT}" ${cmd}`, { encoding: "utf8" }).trim(); }
  catch { return ""; }
}

function initials(name) {
  return name.split(/\s+/).map(w => w[0] || "").join("").slice(0, 2).toUpperCase() || "?";
}

const ROLE_COLORS = ["role-0","role-1","role-2","role-3","role-4"];

// ── read students ────────────────────────────────────────────────────────────
const files = fs.readdirSync(STUDENTS)
  .filter(f => f.endsWith(".json") && f !== "example.json")
  .sort();

const students = files.map((f, i) => {
  try {
    const data = JSON.parse(fs.readFileSync(path.join(STUDENTS, f), "utf8"));
    // get the commit timestamp for this file
    const ts = git(`log --follow --format=%at -- students/${f}`).split("\n")[0];
    return { ...data, _file: f, _ts: ts ? Number(ts) : Date.now() / 1000, _idx: i };
  } catch {
    return null;
  }
}).filter(Boolean).sort((a, b) => a._ts - b._ts);

// ── git log ──────────────────────────────────────────────────────────────────
const rawLog = git("log --oneline -10");
const commitRows = rawLog.split("\n").filter(Boolean).map(line => {
  const sha  = line.slice(0, 7);
  const msg  = line.slice(8);
  return `<div class="commit-row">
    <span class="sha mono">${esc(sha)}</span>
    <span class="commit-msg">${esc(msg)}</span>
  </div>`;
}).join("\n");

// ── branch count ─────────────────────────────────────────────────────────────
const branchCount = git("branch -r").split("\n")
  .filter(b => b.includes("add-student/")).length || students.length;

// ── student cards ─────────────────────────────────────────────────────────────
const cards = students.map(s => {
  const colorClass = ROLE_COLORS[s._idx % ROLE_COLORS.length];
  const gh = esc(s.github || "");
  const avatarUrl = gh ? `https://github.com/${gh}.png?size=46` : "";
  const avatarInner = avatarUrl
    ? `<img src="${avatarUrl}" alt="${esc(s.name)}" onerror="this.style.display='none'">`
    : initials(s.name);

  return `<div class="card">
  <div class="card-top">
    <div class="avatar">${avatarInner}</div>
    <div>
      <div class="card-name">${esc(s.name)}</div>
      <div class="card-github"><a href="https://github.com/${gh}" target="_blank">@${gh}</a></div>
    </div>
  </div>
  <span class="card-role ${colorClass}">${esc(s.role || "Developer")}</span>
  <div class="card-fact">${esc(s.fact || "—")}</div>
  <div class="cmd-label">Favorite git command / お気に入りコマンド</div>
  <div class="card-cmd">${esc(s.favorite_git_command || "git status")}</div>
</div>`;
}).join("\n");

// ── repo slug ─────────────────────────────────────────────────────────────────
let repoSlug = git("remote get-url origin")
  .replace(/^https:\/\/github\.com\//, "")
  .replace(/^git@github\.com:/, "")
  .replace(/\.git$/, "") || "your-username/git-explorer";

// ── render ────────────────────────────────────────────────────────────────────
let html = fs.readFileSync(TEMPLATE, "utf8");
html = html
  .replace("{{STUDENT_COUNT}}", students.length)
  .replace("{{COMMIT_COUNT}}", git("rev-list --count HEAD") || "—")
  .replace("{{BRANCH_COUNT}}", branchCount)
  .replace("{{COMMIT_LOG}}", commitRows || '<div class="commit-row"><span class="sha mono">—</span><span class="commit-msg">no commits yet</span></div>')
  .replace("{{STUDENT_CARDS}}", cards)
  .replace(/{{REPO}}/g, repoSlug);

fs.writeFileSync(OUT, html);
console.log(`✓ Built index.html — ${students.length} student(s)`);
