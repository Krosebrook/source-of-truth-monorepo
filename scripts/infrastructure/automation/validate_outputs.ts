import fs from "fs";
import path from "path";
import { Validator } from "jsonschema";

const validator = new Validator();
const schema = JSON.parse(fs.readFileSync("schema/deliverable.schema.json", "utf8"));

function collect(dir: string): string[] {
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir).flatMap(name => {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) return collect(full);
    return full.endsWith(".json") ? [full] : [];
  });
}

const roots = [
  "agents/outputs/claude-run",
  "agents/outputs/codex-run",
  "agents/outputs/gemini-run"
];

const files = roots.flatMap(collect);
let failures = 0;

for (const file of files) {
  try {
    const data = JSON.parse(fs.readFileSync(file, "utf8"));
    const result = validator.validate(data, schema);
    if (!result.valid) {
      console.error(`❌ Schema invalid: ${file}\n${result.errors.map(err => err.stack).join("\n")}\n`);
      failures += 1;
    }
  } catch (error: any) {
    console.error(`❌ Bad JSON: ${file} → ${error.message}`);
    failures += 1;
  }
}

if (failures) process.exit(3);
console.log("✅ Output schema valid");
