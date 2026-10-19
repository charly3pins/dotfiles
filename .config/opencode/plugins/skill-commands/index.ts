/**
 * OpenCode 2 plugin that adds a /<name> command for each skill in ~/.config/opencode/skills, the way the sh plugin
 * does for /sh:<name>. OpenCode already loads the skills themselves; it just doesn't give them slash commands.
 * Skills added later need an `opencode service restart` to get theirs.
 */
import type { Plugin } from "@opencode/plugin";
import { existsSync, readdirSync, readFileSync, realpathSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

// Real path: ~/.config/opencode is a symlink into the dotfiles.
const skillsDir = join(dirname(realpathSync(fileURLToPath(import.meta.url))), "..", "..", "skills");

// The frontmatter description, unquoted when it is a quoted YAML string.
function describe(file: string) {
  const value = readFileSync(file, "utf8").match(/^---\n[\s\S]*?^description:\s*(.*?)\s*$/m)?.[1];
  return value?.startsWith('"') ? JSON.parse(value) : value;
}

export default {
  id: "skill-commands",
  async setup(ctx) {
    const skills = readdirSync(skillsDir)
      .filter((id) => existsSync(join(skillsDir, id, "SKILL.md")))
      .map((id) => ({ id, description: describe(join(skillsDir, id, "SKILL.md")) }));

    await ctx.command.transform((editor) =>
      skills.forEach(({ id, description }) =>
        editor.add({
          name: id,
          description,
          execute: async ({ sessionID, prompt, delivery }) => {
            await ctx.session.prompt({
              ...prompt,
              sessionID,
              delivery,
              text: prompt.text || `/${id}`,
              skills: [...(prompt.skills ?? []), { id }],
            });
          },
        }),
      ),
    );
  },
} satisfies Plugin;
