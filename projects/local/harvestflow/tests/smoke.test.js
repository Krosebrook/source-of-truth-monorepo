import { describe, it } from "node:test";
import assert from "node:assert";
import { readFileSync } from "fs";
import { join } from "path";

describe("HarvestFlow Pipeline", () => {
  it("should have a valid package.json", () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), "package.json"), "utf-8"));
    assert.strictEqual(pkg.name, "harvestflow-pipeline");
    assert.ok(pkg.version);
  });

  it("should have required scripts", () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), "package.json"), "utf-8"));
    const scripts = pkg.scripts;
    assert.ok(scripts.build, "Should have build script");
    assert.ok(scripts.dev, "Should have dev script");
    assert.ok(scripts.clean, "Should have clean script");
  });

  it("should have TypeScript configuration", () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), "package.json"), "utf-8"));
    assert.ok(pkg.dependencies.typescript, "Should have TypeScript as dependency");
  });

  it("should have required dependencies", () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), "package.json"), "utf-8"));
    assert.ok(pkg.dependencies["adm-zip"], "Should have adm-zip dependency");
    assert.ok(pkg.dependencies.zod, "Should have zod dependency");
    assert.ok(pkg.dependencies["js-yaml"], "Should have js-yaml dependency");
  });

  it("should be configured as ES module", () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), "package.json"), "utf-8"));
    assert.strictEqual(pkg.type, "module", "Should be configured as ES module");
  });

  it("should have workflow and drift management scripts", () => {
    const pkg = JSON.parse(readFileSync(join(process.cwd(), "package.json"), "utf-8"));
    const scripts = pkg.scripts;
    assert.ok(scripts["drift:check"], "Should have drift check script");
    assert.ok(scripts["drift:validate"], "Should have drift validate script");
  });
});
