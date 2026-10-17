/**
 * OpenCode 2 plugin that titles each new session "<square> <ticket> <up to 5 words>", where the square is the kind
 * of work: 🟥 debugging, 🟩 a feature, 🟦 docs, PRDs or tickets, 🟨 anything else. It asks OpenCode's title model
 * itself instead of letting OpenCode do it, so it can clean up the reply.
 */
import type { Plugin } from "@opencode/plugin";

const squares: Record<string, string> = { debug: "🟥", feature: "🟩", docs: "🟦", other: "🟨" };

const instructions = `You title a coding session so the user can find it in a row of tabs. Reply with one line and nothing else:

<kind> | <title>

<kind> is one of these words:
- debug: troubleshooting an error or debugging, including the fix that follows
- feature: implementing a feature
- docs: reading docs to assess a PRD, or validating tickets
- other: anything else

<title> starts with the ticket key if the conversation mentions one (like ABC-123 or XY-42), followed by at most
5 plain words in the conversation's language. No markdown, no quotes, no full stop.

Examples:
debug | ABC-123 Login redirect fix
feature | Dark mode toggle
docs | XY-42 Review the PRD
other | Release notes

The conversation so far:
`;

export default {
  id: "tab-status",
  async setup(ctx) {
    await ctx.session.hook("title", async (event) => {
      const said = event.messages
        .filter((message) => message.role === "user")
        .flatMap((message) => message.content)
        .flatMap((part) => (part.type === "text" ? [part.text] : []))
        .join("\n\n");
      const { text } = await ctx.generate.text({ model: event.model, prompt: instructions + said });
      // Models like to wrap the reply in **…** or quotes, and may skip the kind or make one up.
      const reply = text.replace(/[*`"]/g, "").trim();
      const [, kind = "", title = reply] = reply.match(/^(\w+)\s*\|\s*(.+)$/) ?? [];
      event.result = `${squares[kind.toLowerCase()] ?? squares.other} ${title}`;
    });
  },
} satisfies Plugin;
