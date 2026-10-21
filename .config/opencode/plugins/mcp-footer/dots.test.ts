import assert from "node:assert/strict";
import { test } from "node:test";
import { dots } from "./dots.ts";

test("each MCP server is a dot and its name, in the order OpenCode lists them, green once connected", () => {
  const servers = [
    { name: "context7", status: { status: "connected" } },
    { name: "github", status: { status: "connected" } },
  ];
  assert.deepEqual(dots(servers as never), [
    { name: "context7", tone: "success" },
    { name: "github", tone: "success" },
  ]);
});

test("as in the sidebar, a failed server is red, one waiting for you to sign in yellow, connecting or disabled grey", () => {
  const servers = [
    { name: "github", status: { status: "failed", error: "connect ECONNREFUSED 127.0.0.1:3000" } },
    { name: "linear", status: { status: "needs_auth", error: "Sign in to continue" } },
    { name: "sentry", status: { status: "pending" } },
    { name: "playwright", status: { status: "disabled" } },
  ];
  assert.deepEqual(dots(servers as never), [
    { name: "github", tone: "error" },
    { name: "linear", tone: "warning" },
    { name: "sentry", tone: "muted" },
    { name: "playwright", tone: "muted" },
  ]);
});

test("a status OpenCode adds after this footer was written gets a grey dot", () => {
  const servers = [{ name: "github", status: { status: "reconnecting" } }];
  assert.deepEqual(dots(servers as never), [{ name: "github", tone: "muted" }]);
});
