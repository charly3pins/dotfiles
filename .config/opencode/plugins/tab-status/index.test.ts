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

test("a session about something broken is titled 🟥 and its ticket, by OpenCode's title model reading the first message", async () => {
  const { title, requests } = await titleSession("red | ABC-123 Login redirect fix");
  assert.equal(title, "🟥 ABC-123 Login redirect fix");
  assert.deepEqual(requests[0].model, { providerID: "anthropic", id: "claude-haiku-4-5" });
  assert.match(requests[0].prompt, /why does login keep redirecting to itself\? ABC-123/);
});

test("the other colors get their squares: ⬜ gray, 🟨 yellow, 🟩 green, 🟦 blue", async () => {
  assert.equal((await titleSession("gray | Terminal tab colors")).title, "⬜ Terminal tab colors");
  assert.equal((await titleSession("yellow | XY-42 Checkout PR review")).title, "🟨 XY-42 Checkout PR review");
  assert.equal((await titleSession("green | Dark mode toggle")).title, "🟩 Dark mode toggle");
  assert.equal((await titleSession("blue | XY-42 PRD feasibility")).title, "🟦 XY-42 PRD feasibility");
});

test("the **…**, quotes and capitals the model adds don't reach the title", async () => {
  assert.equal((await titleSession("**Green | Dark mode toggle**\n")).title, "🟩 Dark mode toggle");
  assert.equal((await titleSession('"red | `auth-service` 500 errors"')).title, "🟥 auth-service 500 errors");
});

test("a reply without a known color still makes a title, with 🟦, the color left when no other matches", async () => {
  assert.equal((await titleSession("Release notes")).title, "🟦 Release notes");
  assert.equal((await titleSession("orange | Release notes")).title, "🟦 Release notes");
});
