import assert from "node:assert/strict";
import { test } from "node:test";
import plugin from "./index.ts";

// Plays OpenCode's plugin host: runs setup(), then has the plugin's title hook title a session whose first message
// is `said`, with a title model that replies `reply`.
async function titleSession(reply: string, said = "why does login keep redirecting to itself? ABC-123") {
  const hooks = new Map();
  const requests = [];
  await plugin.setup({
    session: { hook: async (name, hook) => hooks.set(name, hook) },
    generate: {
      text: async (input) => {
        requests.push(input);
        return { text: reply };
      },
    },
  } as never);
  const event: Record<string, unknown> = {
    sessionID: "ses_1",
    model: { providerID: "anthropic", id: "claude-haiku-4-5" },
    system: [{ type: "text", text: "You are a title generator." }],
    messages: [{ role: "user", content: [{ type: "text", text: said }] }],
    options: {},
  };
  await hooks.get("title")(event);
  return { title: event.result, requests };
}

test("a debugging session is titled 🟥 and its ticket, by OpenCode's title model reading the first message", async () => {
  const { title, requests } = await titleSession("debug | ABC-123 Login redirect fix");
  assert.equal(title, "🟥 ABC-123 Login redirect fix");
  assert.deepEqual(requests[0].model, { providerID: "anthropic", id: "claude-haiku-4-5" });
  assert.match(requests[0].prompt, /why does login keep redirecting to itself\? ABC-123/);
});

test("the other kinds of work get 🟩 for a feature, 🟦 for docs, PRDs or tickets, 🟨 for anything else", async () => {
  assert.equal((await titleSession("feature | Dark mode toggle")).title, "🟩 Dark mode toggle");
  assert.equal((await titleSession("docs | XY-42 Review the PRD")).title, "🟦 XY-42 Review the PRD");
  assert.equal((await titleSession("other | Release notes")).title, "🟨 Release notes");
});

test("the **…**, quotes and capitals the model adds don't reach the title", async () => {
  assert.equal((await titleSession("**Feature | Dark mode toggle**\n")).title, "🟩 Dark mode toggle");
  assert.equal((await titleSession('"debug | `auth-service` 500 errors"')).title, "🟥 auth-service 500 errors");
});

test("a reply without a known kind of work still makes a title, with 🟨", async () => {
  assert.equal((await titleSession("Release notes")).title, "🟨 Release notes");
  assert.equal((await titleSession("bugfix | Login redirect fix")).title, "🟨 Login redirect fix");
});
