#!/usr/bin/env node
import { route } from "../skills/coldbrew/router.js";

const utterance = process.argv.slice(2).join(" ").trim();
if (!utterance) {
  console.error("用法: node tuning/scripts/skill-route.mjs <原句>");
  process.exit(1);
}
const hit = route(utterance);
console.log(JSON.stringify(hit, null, 2));
