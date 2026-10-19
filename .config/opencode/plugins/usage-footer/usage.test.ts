import assert from "node:assert/strict";
import { test } from "node:test";
import { usage } from "./usage.ts";

// Meridian's GET /v1/usage/quota reply, trimmed, as read on Monday 19 October at 21:25. Claude's usage page showed
// these two limits as "Resets Tue 1:20 AM" and "Resets Sunday 9:00 AM".
const options = { now: 1792437924281, timeZone: "Europe/Madrid" };
const reply = (session: object = {}, week: object = {}) => ({
  buckets: [
    { type: "five_hour", status: "allowed", utilization: 0.12, resetsAt: 1792451999909, ...session },
    { type: "seven_day", status: "allowed", utilization: 0.15, resetsAt: 1792915199909, ...week },
    { type: "seven_day_fable", status: "allowed", utilization: 0, resetsAt: 1792915200000 },
  ],
});

test("below 80% the footer shows the session and the week as percentages only", () => {
  assert.deepEqual(usage(reply(), options), [
    { text: "s 12%", tone: "normal" },
    { text: "w 15%", tone: "normal" },
  ]);
});

test("from 80% a limit turns yellow and shows when it resets, to the minute, as Claude's usage page does", () => {
  assert.deepEqual(usage(reply({ utilization: 0.85 }, { utilization: 0.8 }), options), [
    { text: "s 85% (resets Tue 01:20)", tone: "warning" },
    { text: "w 80% (resets Sun 09:00)", tone: "warning" },
  ]);
});

test("a limit that resets later today shows just the time", () => {
  const inTwoHours = options.now + 2 * 60 * 60 * 1000;
  assert.deepEqual(usage(reply({ utilization: 0.9, resetsAt: inTwoHours }), options)[0], {
    text: "s 90% (resets 23:25)",
    tone: "warning",
  });
});

test("at the limit it turns red, also when Meridian reports the limit hit just short of 100%", () => {
  assert.deepEqual(usage(reply({ utilization: 0.97, status: "rejected" }, { utilization: 1 }), options), [
    { text: "s 97% (resets Tue 01:20)", tone: "error" },
    { text: "w 100% (resets Sun 09:00)", tone: "error" },
  ]);
});

test("a limit past 80% that Meridian has no reset time for still turns yellow, without one", () => {
  assert.deepEqual(usage(reply({ utilization: 0.85, resetsAt: null }), options)[0], { text: "s 85%", tone: "warning" });
});

test("shows nothing for a limit Meridian has no figures for, or at all when Meridian can't be reached", () => {
  assert.deepEqual(usage(reply({ utilization: null }), options), [{ text: "w 15%", tone: "normal" }]);
  assert.deepEqual(usage({ buckets: [] }, options), []);
  assert.deepEqual(usage(null, options), []);
});
