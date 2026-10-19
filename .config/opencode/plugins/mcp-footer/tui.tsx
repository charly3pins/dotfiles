/**
 * OpenCode 2 TUI plugin that shows every MCP server in the prompt footer, as a dot coloured by its state and its name,
 * so the sidebar can stay hidden. Only in sessions: the home screen already counts MCP servers.
 */
import type { Plugin } from "@opencode/plugin/tui";
import { createMemo, For, Show } from "solid-js";
import { dots, type Tone } from "./dots.ts";

export default {
  id: "mcp-footer",
  setup(context) {
    const color = (tone: Tone) =>
      tone === "muted" ? context.theme.text.muted : context.theme.text.feedback[tone].base;

    context.ui.slot({
      append: "prompt.footer.status",
      render: (props) => {
        const servers = createMemo(() => {
          if (!props.sessionID) return [];
          const session = context.data.session.get(props.sessionID);
          return dots(context.data.location.mcp.server.list(session?.location) ?? []);
        });
        // showDetails is off when the footer is short of room, and the built-in details give way too.
        return (
          <Show when={props.showDetails && servers().length > 0}>
            <text fg={context.theme.text.muted} wrapMode="none" truncate flexShrink={1} minWidth={0} marginRight={-1}>
              <For each={servers()}>
                {(server, index) => (
                  <>
                    <Show when={index() > 0}>{" "}</Show>
                    <span style={{ fg: color(server.tone) }}>●</span>
                    {` ${server.name}`}
                  </>
                )}
              </For>
              {/* The -1 right margin shrinks the footer's two-space gap to one, so sections read "a · b". */}
              {" ·"}
            </text>
          </Show>
        );
      },
    });
  },
} satisfies Plugin.Definition;
