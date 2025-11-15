import fs from "fs";
import path from "path";
import AdmZip from "adm-zip";

const OUTPUT_DIR = path.join("agents", "outputs");
const TARGET = path.join("agents", "all-llm-outputs.zip");

if (!fs.existsSync(OUTPUT_DIR)) {
  console.error("⚠️  No agents/outputs directory found. Skipping bundle.");
  process.exit(0);
}

const zip = new AdmZip();
const addDirectory = (dir: string, base = "") => {
  const entries = fs.readdirSync(dir);
  for (const entry of entries) {
    const full = path.join(dir, entry);
    const rel = path.join(base, entry);
    if (fs.statSync(full).isDirectory()) {
      addDirectory(full, rel);
    } else {
      zip.addLocalFile(full, path.dirname(rel) === "." ? "" : path.dirname(rel), path.basename(rel));
    }
  }
};

addDirectory(OUTPUT_DIR);
zip.writeZip(TARGET);
console.log(`Bundled LLM outputs → ${TARGET}`);
