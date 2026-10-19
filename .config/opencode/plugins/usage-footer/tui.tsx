/**
 * OpenCode 2 TUI plugin that shows your Claude plan's usage under the prompt: the 5-hour session and the week, as
 * Claude's usage page counts them. From 80% a limit turns yellow and says when it resets; at the limit it turns red.
 * The figures come from the Meridian proxy that opencode-with-claude runs on 127.0.0.1:3456. Meridian reads them with
 * your Claude Code login, so this plugin never touches it.
 */
import type { Plugin } from "@opencode/plugin/tui";
import { createMemo, createSignal, For, Show } from "solid-js";
import { usage, type QuotaReply, type Tone } from "./usage.ts";

const quotaURL = "http://127.0.0.1:3456/v1/usage/quota";

export default {
  id: "usage-footer",
  setup(context) {
    const [reply, setReply] = createSignal<QuotaReply | null>(null);
    // Meridian caches the figures for 30s and backs off when Anthropic rate-limits it, so once a minute is plenty.
    const refresh = () =>
      fetch(quotaURL, { signal: AbortSignal.timeout(5_000) })
        .then((response) => (response.ok ? (response.json() as Promise<QuotaReply>) : null))
        .catch(() => null)
        .then((value) => setReply(() => value));
    void refresh();
    const timer = setInterval(refresh, 60_000);

    const color = (tone: Tone) =>
      tone === "normal" ? context.theme.text.muted : context.theme.text.feedback[tone].base;

    context.ui.slot({
      append: "prompt.footer.status",
      render: (props) => {
        const items = createMemo(() => usage(reply(), { now: Date.now() }));
        return (
          <Show when={props.showDetails && items().length > 0}>
            <text fg={context.theme.text.muted} wrapMode="none" truncate flexShrink={1} minWidth={0}>
              <For each={items()}>
                {(item, index) => (
                  <>
                    <Show when={index() > 0}>{" · "}</Show>
                    <span style={{ fg: color(item.tone) }}>{item.text}</span>
                  </>
                )}
              </For>
              {/* Sits in the middle of the footer's two-space gap, before the context window section. */}
              {"  ·"}
            </text>
          </Show>
        );
      },
    });
    return () => clearInterval(timer);
  },
} satisfies Plugin.Definition;
