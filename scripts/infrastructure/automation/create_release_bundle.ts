import fs from "fs";
import path from "path";

const RELEASE_ROOT = path.join(process.cwd(), "releases");
const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
const targetDir = path.join(RELEASE_ROOT, `harvestflow-${timestamp}`);

const artefacts = [
  [path.join("out", "master.zip"), "master.zip"],
  [path.join("out", "manifest.json"), "manifest.json"],
  [path.join("out", "metrics.json"), "metrics.json"],
  [path.join("agents", "all-llm-outputs.zip"), "all-llm-outputs.zip"]
] as const;

fs.mkdirSync(targetDir, { recursive: true });

for (const [src, destName] of artefacts) {
  if (!fs.existsSync(src)) continue;
  fs.copyFileSync(src, path.join(targetDir, destName));
}

fs.writeFileSync(
  path.join(targetDir, "README.txt"),
  `HarvestFlow release bundle generated ${new Date().toISOString()}\n` +
    `Includes master.zip, manifest.json, metrics.json, and optional LLM outputs.`
);

console.log(`Release bundle staged at ${path.relative(process.cwd(), targetDir)}`);
