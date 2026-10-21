import assert from "node:assert/strict";
import { test } from "node:test";
import plugin from "./index.ts";

type Method = { type: string; id?: string; [key: string]: unknown };

// Plays OpenCode's plugin host: runs setup(), then applies the plugin's integration transform to `integrations`. Like
// OpenCode's editor, method.list returns an integration's live list, and method.remove drops the first method of the
// same type (and id, for an OAuth login).
async function transform(integrations: Record<string, Method[]>) {
  const edits = [];
  await plugin.setup({ integration: { transform: async (edit) => edits.push(edit) } } as never);
  const editor = {
    method: {
      list: (id: string) => integrations[id] ?? [],
      remove: (id: string, method: Method) => {
        const methods = integrations[id] ?? [];
        const index = methods.findIndex((candidate) => candidate.type === method.type && candidate.id === method.id);
        if (index !== -1) methods.splice(index, 1);
      },
    },
  };
  for (const edit of edits) edit(editor);
  return integrations;
}

test("GITHUB_TOKEN no longer signs in to Copilot, while /connect's Copilot login and other providers' keys stay", async () => {
  const integrations = await transform({
    "github-copilot": [
      { type: "env", names: ["GITHUB_TOKEN"] },
      { type: "oauth", id: "device", label: "Login with GitHub Copilot" },
    ],
    anthropic: [{ type: "env", names: ["ANTHROPIC_API_KEY"] }],
  });
  assert.deepEqual(integrations, {
    "github-copilot": [{ type: "oauth", id: "device", label: "Login with GitHub Copilot" }],
    anthropic: [{ type: "env", names: ["ANTHROPIC_API_KEY"] }],
  });
});
