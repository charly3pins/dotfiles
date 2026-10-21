/**
 * OpenCode 2 plugin that stops OpenCode treating GITHUB_TOKEN as a GitHub Copilot login. OpenCode's catalog accepts any
 * GITHUB_TOKEN in its environment as one, so a token exported for gh, npm or other tools fills /models with Copilot
 * models the account can't use. Signing in to Copilot with /connect still works.
 */
import type { Plugin } from "@opencode/plugin";

export default {
  id: "copilot-oauth-only",
  async setup(ctx) {
    // method.list returns the live list, so pick the methods out before removing any.
    await ctx.integration.transform((editor) =>
      editor.method
        .list("github-copilot")
        .filter((method) => method.type === "env")
        .forEach((method) => editor.method.remove("github-copilot", method)),
    );
  },
} satisfies Plugin;
