import assert from "node:assert/strict";
import { test } from "node:test";
import plugin from "./index.ts";

// Plays OpenCode's plugin host: runs setup() and keeps the commands the plugin adds and the prompts they send.
async function load() {
  const commands = new Map();
  const prompts = [];
  await plugin.setup({
    command: { transform: async (edit) => edit({ add: (command) => commands.set(command.name, command) }) },
    session: { prompt: async (input) => prompts.push(input) },
  } as never);
  return { commands, prompts };
}

test("each of your skills gets a /<name> command described like the skill", async () => {
  const { commands } = await load();
  assert.match(commands.get("tdd")?.description, /^Test-driven development\./);
  assert.match(commands.get("code-review")?.description, /asks to "review since X"\.$/);
  assert.ok(commands.has("grill-me"));
});

test("/<name> sends the prompt with that skill attached", async () => {
  const { commands, prompts } = await load();
  await commands.get("tdd").execute({ sessionID: "ses_1", prompt: { text: "add a login form" }, delivery: "steer" });
  await commands.get("retro").execute({ sessionID: "ses_1", prompt: { text: "" }, delivery: "queue" });
  assert.deepEqual(prompts, [
    { sessionID: "ses_1", delivery: "steer", text: "add a login form", skills: [{ id: "tdd" }] },
    { sessionID: "ses_1", delivery: "queue", text: "/retro", skills: [{ id: "retro" }] },
  ]);
});
