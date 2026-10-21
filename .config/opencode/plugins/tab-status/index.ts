/**
 * OpenCode 2 plugin that titles each new session "<square> <ticket> <up to 5 words>", where the square is what the
 * session does, the first match winning: ⬜ the workbench, 🟥 something broken, 🟨 a change waiting on a go/no-go,
 * 🟩 writing a change, 🟦 reading or answering. It asks OpenCode's title model itself instead of letting OpenCode do
 * it, so it can clean up the reply.
 */
import type { Plugin } from "@opencode/plugin";

const squares: Record<string, string> = { gray: "⬜", grey: "⬜", red: "🟥", yellow: "🟨", green: "🟩", blue: "🟦" };

const instructions = `You title a coding session so the user can find it in a row of tabs. Reply with one line and nothing else:

<color> | <title>

Pick <color> from what the session does; the first match wins:
- gray: the subject is the workbench, not the product: OpenCode, Claude Code, the terminal, plugins and skills,
  git/gcloud/VDI trouble, team reports, Jira or ticket-tracker admin
- red: investigating or fixing something broken in the product: bugs, incidents, alerts, log triage, failing builds
  (a bug ticket is red from the first message)
- yellow: a finished change waits on a go/no-go: reviewing someone else's PR, QA in a team environment, "is it safe
  to ship", release order, deploy or release watch
- green: writing a change: features, scope changes, scripts, collections, side projects
- blue: reading or answering, with nothing broken and nothing being changed: PRDs, ticket summaries, "how does X
  work", feasibility, overviews and cheatsheets, audits, drafting tickets

The user's own fix or feature stays red or green through its PR and self-review, and turns yellow at QA or release.

<title> starts with the ticket key if the conversation mentions one (like ABC-123 or XY-42), followed by at most
5 plain words in the conversation's language. No markdown, no quotes, no full stop.

Examples:
red | ABC-123 Login redirect fix
green | Dark mode toggle
yellow | XY-42 Checkout PR review
blue | XY-42 PRD feasibility
gray | Terminal tab colors

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
      // Models like to wrap the reply in **…** or quotes, add a line before or after it, and may skip the color or
      // make one up. Blue is the color left when no other matches.
      const lines = text.replace(/[*`"]/g, "").split("\n").map((line) => line.trim()).filter(Boolean);
      const line = lines.find((candidate) => /^\w+\s*\|/.test(candidate)) ?? lines[0] ?? "";
      const [, color = "", title = line] = line.match(/^(\w+)\s*\|\s*(.+)$/) ?? [];
      event.result = `${squares[color.toLowerCase()] ?? squares.blue} ${title}`;
    });
  },
} satisfies Plugin;
