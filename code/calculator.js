// Simple calculator — one function has a bug introduced in a later commit
// シンプルな電卓 — 後のコミットでバグが追加された関数がある
// Class 2: use `git bisect` to find which commit broke `multiply()`

function add(a, b) {
  return a + b;
}

function subtract(a, b) {
  return a - b;
}

function multiply(a, b) {
  return a * b;   // this line will be broken in a later commit
}

function divide(a, b) {
  if (b === 0) throw new Error("Cannot divide by zero");
  return a / b;
}

// Tests — all should print true
console.log("add(2,3) = 5       →", add(2, 3) === 5);
console.log("subtract(10,4) = 6 →", subtract(10, 4) === 6);
console.log("multiply(3,4) = 12 →", multiply(3, 4) === 12);
console.log("divide(10,2) = 5   →", divide(10, 2) === 5);

const allPass = [
  add(2, 3) === 5,
  subtract(10, 4) === 6,
  multiply(3, 4) === 12,
  divide(10, 2) === 5,
].every(Boolean);

console.log("\nAll tests pass:", allPass);
process.exit(allPass ? 0 : 1);   // exit 1 = broken  ← bisect uses this
