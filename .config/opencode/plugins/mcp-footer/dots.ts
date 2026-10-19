/** What the footer shows for each MCP server: its name and a dot coloured the way the sidebar colours it. */
import type { McpServer } from "@opencode/client";

export type Tone = "success" | "error" | "warning" | "muted";

const tones: Record<McpServer["status"]["status"], Tone> = {
  connected: "success",
  failed: "error",
  needs_auth: "warning",
  pending: "muted",
  disabled: "muted",
};

export function dots(servers: readonly McpServer[]): { name: string; tone: Tone }[] {
  return servers.map((server) => ({ name: server.name, tone: tones[server.status.status] }));
}
