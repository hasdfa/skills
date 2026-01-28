#!/usr/bin/env node
// csb-download.mjs
import fs from "node:fs/promises";
import path from "node:path";

const arg = process.argv[2];
const base = process.argv[3] ?? ".context/csb";

if (!arg) {
  console.error("Usage: csb-download <sandbox-id|codesandbox-url> [dest-base]");
  process.exit(1);
}

let id = arg;
if (arg.includes("codesandbox.io")) {
  const m = arg.match(/codesandbox\.io\/(?:s|embed)\/([^/?#]+)/);
  if (!m) {
    console.error(`Could not extract sandbox id from: ${arg}`);
    process.exit(1);
  }
  id = m[1];
}

const outDir = path.join(base, id);
await fs.mkdir(outDir, { recursive: true });

const url = `https://codesandbox.io/api/v1/sandboxes/${id}`;
const res = await fetch(url);
if (!res.ok) {
  console.error(`Fetch failed: ${res.status} ${res.statusText}`);
  process.exit(1);
}

const { data } = await res.json();

const dirMap = new Map((data.directories ?? []).map(d => [d.shortid, d]));
const dirPath = (sid) => {
  if (!sid) return "";
  const d = dirMap.get(sid);
  if (!d) return "";
  return path.join(dirPath(d.directory_shortid), d.title);
};

let written = 0, skippedBinary = 0;

for (const m of data.modules ?? []) {
  if (m.is_binary) { skippedBinary++; continue; }
  const rel = path.join(dirPath(m.directory_shortid), m.title);
  const abs = path.join(outDir, rel);
  await fs.mkdir(path.dirname(abs), { recursive: true });
  await fs.writeFile(abs, m.code ?? "", "utf8");
  written++;
}

await fs.writeFile(
  path.join(outDir, ".csb-manifest.json"),
  JSON.stringify({ id, pulledAt: new Date().toISOString(), written, skippedBinary }, null, 2),
  "utf8"
);

console.log(outDir);

