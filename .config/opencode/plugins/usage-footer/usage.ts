/** What the prompt footer shows for your Claude plan's usage limits, from Meridian's GET /v1/usage/quota reply. */
export type Tone = "normal" | "warning" | "error";

interface Bucket {
  type: string;
  status: string;
  utilization: number | null;
  resetsAt: number | null;
}

export interface QuotaReply {
  buckets: Bucket[];
}

const labels = { five_hour: "s", seven_day: "w" };

// A null reply means Meridian couldn't be reached.
export function usage(
  reply: QuotaReply | null,
  options: { now: number; timeZone?: string },
): { text: string; tone: Tone }[] {
  return Object.entries(labels).flatMap(([type, label]) => {
    const bucket = reply?.buckets?.find((candidate) => candidate.type === type);
    if (bucket?.utilization == null) return [];
    const percent = Math.round(bucket.utilization * 100);
    const tone = bucket.status === "rejected" || percent >= 100 ? "error" : percent >= 80 ? "warning" : "normal";
    if (tone === "normal" || bucket.resetsAt == null) return [{ text: `${label} ${percent}%`, tone }];
    return [{ text: `${label} ${percent}% (resets ${resets(bucket.resetsAt, options)})`, tone }];
  });
}

// Meridian reports a reset a few milliseconds before the minute, e.g. 01:19:59.909 for 01:20.
function resets(at: number, { now, timeZone }: { now: number; timeZone?: string }) {
  const minute = new Date(Math.round(at / 60_000) * 60_000);
  const time = minute.toLocaleTimeString("en-GB", { timeZone, hour: "2-digit", minute: "2-digit" });
  const date = (value: Date) => value.toLocaleDateString("en-GB", { timeZone });
  if (date(minute) === date(new Date(now))) return time;
  return `${minute.toLocaleDateString("en-GB", { timeZone, weekday: "short" })} ${time}`;
}
