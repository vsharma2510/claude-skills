---
name: personal-slide-style
description: Vivek's personal slide design system for physics talks. Use whenever the user asks for slides, a deck, a talk, a presentation or a poster-style summary, even if they never name a style or a format. Produces a .pptx with a quiet technical look (off-white ground, dark green title rule, Calibri text, Consolas numbers, boxed plots, booktabs-style tables, unoutlined grey flowchart boxes) and strict language rules for titles, bullets, numbers and references. Use it for every new deck, and also when restyling or extending a deck that already follows this style. Do not fall back to a generic Claude slide look, and do not substitute an artifact or another skill's default styling.
---

# Personal slide style

This skill replaces generic slide design. The look and the language rules below come from decisions the user made one at a time, so follow them exactly and do not "improve" them. Where this skill conflicts with the generic advice in the pptx skill (for example its ban on accent lines under titles), this skill wins, because the user chose these things explicitly.

## Output and process

1. Output is always a `.pptx`, built with `pptxgenjs` (see the pptx skill for tooling, validation and rendering commands). Read that skill's gotchas first.
2. Collect before building: audience (specialists, or mixed), talk title, organization, event, date. Author defaults to **Vivek Sharma**. If the user is not around to answer, assume specialists, use placeholders `Organization name` and `Event name`, and say so in one line.
3. Build from the reference script at the bottom of this file. Copy it, replace the content blocks, keep the tokens, masters and helpers unchanged.
4. Validate (`validate.py`), render to images, and inspect every slide against the checklist near the end.

## Tokens

Colors (hex without `#`):

| Role | Hex | Use |
|---|---|---|
| ground | F8F9F7 | slide background |
| ink | 1B201E | text, table rules, plot frames |
| muted | 6A726E | secondary text, axis labels, references, footer |
| green | 1F4A3C | title rule, main path in flowcharts, divider background |
| fill | E6EAE7 | flowchart boxes |
| rule | D6DBD8 | hairlines, grids, table inner rules |
| teal | 1F7A70 | data color 1 |
| coral | D35A3C | data color 2 |
| blue | 3F6FA8 | data color 3 |
| violet | 7D5AA6 | data color 4 |
| rose | B3476F | data color 5 |
| grey | 8B938F | "other" or baseline in data |

Fonts: **Calibri** for text, **Consolas** for numbers in tables, axis labels, captions, references, footer and flowchart edge labels. Only Office-safe fonts. Never use web fonts, Inter, or Aptos. Previews on Linux substitute Carlito and a mono face; trust the sizes with ten percent slack.

Sizes (pt) on a 10 x 5.625 in slide: title 28 (title slide 40, divider 43), bullets 16, sub-bullets 14, table body 14, table header 12 mono, plot title 13 bold, plot axis titles 12, tick labels 11, references and footer 10 mono. Never go below 10 pt.

Geometry: side margins 0.45 in, title baseline area y 0.32 to 0.90, green rule at y 0.95 (full content width, about 2 pt), content starts at y 1.1 to 1.2, footer hairline at y 5.2, footer text at y 5.25. Content is **top-aligned** under the title so every slide starts at the same height.

## Slide types

- **Title slide:** everything centered. Title (topic label, 40 pt), short green rule, then name (bold, 19 pt), organization (muted, 15 pt), event and date on one mono line. Two dashed logo placeholders at the bottom. No subtitle.
- **Section divider:** full-bleed green, no footer. Mono tag `SECTION n OF N` in a light tint, section name large in the ground color, centered.
- **Content slide:** title top-left, green rule below it, content top-aligned, footer.
- **Footer (content slides only):** hairline rule, then `Vivek Sharma · date` on the left in 10 pt mono muted and the slide number on the right in ink. Sources and references never go in the footer.

## References and citations

Place references directly under the table or figure they belong to, in 10 pt mono muted, numbered `[1]`, `[2]`. Several references on one slide is normal. Each figure carries its own reference line.

## Tables

Booktabs style: ink rule 1.5 pt above the header and below the last row, 1 pt ink rule under the header, hairline `rule` between rows, **thin vertical dividers between columns** (also in the header). No fills, no colored header. First column left-aligned in Calibri, numeric columns right-aligned in Consolas. Units go in the column header, not in cells. Same decimal places down a column. Every measured value carries its uncertainty: `1.12 ± 0.06`. The row the text refers to is bold, not colored. In pptxgenjs, cell `margin` is in inches (`[0, 0.1, 0, 0.1]`); points make the text disappear.

## Plots

- Native charts when PowerPoint can draw them (scatter for stepped or fitted lines, bar for histograms).
- Full ink box around the plot area, inward ticks where the renderer allows, light grid on both axes.
- Titles centered, bold, 13 pt. Axis titles and tick labels large enough to read from the back of a room (12 and 11 pt minimum).
- Set the plot area explicitly with `layout: { x: 0.115, y: 0.2, w: 0.865, h: 0.5 }` so the chart does not collapse around its labels. Plots take as much of the slide as possible.
- Label series directly with a small key inside the plot (line swatch plus word), never a legend beside the plot.
- A second series differs in line style as well as color (dashed fit over solid data).
- pptxgenjs applies one dash style to all series. Do not pass `lineDash` as an array; set per-series dashes by editing the chart XML after writing (the script does this).
- Label every histogram bin sparsely using space strings for hidden labels; `catAxisLabelFrequency` is not honored everywhere.

## Flowcharts

Single horizontal row of up to five or six steps, boxes in `fill` with no outline, labels in two lines. Main path: bold green text and heavy green arrows (2.5 pt). Side branches: muted text, thin dashed grey arrow, edge label in mono. Draw with native shapes so the user can edit them.

## Color rules

- Base palette is ink, muted, green, fill, rule. Everything else is data color.
- **Color is allowed whenever it carries information** in plots and flowcharts (a series, category, state or outcome), even if the slide gets loud. Color used only to decorate is not allowed.
- Color is never the only channel: add a direct label, a line style or a marker.
- Gradients and heatmaps are not fixed to one hue. Choose the ramp by how rich the data is: a plain sequential ramp for simple magnitude, a perceptually uniform multi-hue ramp when the data has structure worth showing. Never a rainbow.
- Two-sided scales (residuals above and below zero) use blue against coral.
- Projectors wash out color, so the data colors above are slightly more saturated than they look on screen. Do not lighten them.

## Plot slides with several plots

When plots follow a flow, split the text into one note per plot and place each note beside the plot it explains, vertically centered on that plot, so the reader's eye associates each text with its figure. Use a single text column only when the plots share one message. Free-form text box placement is fine.

## Language rules

- **Titles:** topic labels in sentence case, never a full-sentence claim: "Trap depth and track length". No period. Never open with "Overview of", "Introduction to", "Summary of" or "Towards".
- **Bullets:** short fragments by default, quick to read, no period. A bullet that states a result is a full sentence with a period. If a point is complicated, split it with sub-bullets, generously. Up to 4 top-level bullets per slide, about 15 words each; sub-bullets are short and do not count toward the four.
- **Bullet markers:** filled squares for top-level, en dashes for sub-bullets.
- **Voice:** impersonal, present tense: "The classifier rejects noise tracks."
- **Casing:** sentence case everywhere, including table headers and chart titles.
- **Numbers:** unit once in the table header; uncertainty with every measured value (`1.12 ± 0.06 eV`); same decimals down a column; scientific notation for very small or large values (`2 × 10⁻³`). Join value, ±, and unit with non-breaking spaces (` `) so they never split across lines.
- **Abbreviations:** spell out on first use, then abbreviate. If the audience is mixed, also define field terms.
- **Avoid:** hedges and empty intensifiers (somewhat, quite, very, significantly without a number); marketing words (leverage, unlock, robust or cutting-edge as filler); em-dash asides, "not X but Y" framing, colon-then-reveal sentences, rhetorical-question titles.

## Known pptxgenjs and renderer issues

- Table cell margins are inches. Chart `lineDash` is global. `catAxisLabelFrequency` may be ignored.
- Chart text defaults to Arial: pass `*FontFace` options explicitly (the script does).
- Run `applyTheme` after `writeFile`; it writes the palette and fonts into the theme so new shapes the user adds pick up the style.
- `jszip` is reachable through pptxgenjs: `require(require.resolve("jszip", { paths: [require.resolve("pptxgenjs")] }))`.
- LibreOffice renders Consolas with a wider substitute and draws chart titles slightly tight to the plot. Real PowerPoint is more compact. Leave ten percent slack in mono columns.

## QA checklist

Render every slide and check: title and rule at the same position on every content slide; no overflow in mono columns; no value, ±, or unit split across lines; references sit under their figure and not in the footer; every measured value has an uncertainty; plot labels readable; direct key does not cover data; flowchart labels fit their boxes; footer has name and date left, number right; no leftover placeholder text unless the user was told it is a placeholder.

## Running in Claude Code or on a local machine

- Needs Node and `npm install pptxgenjs` (it brings `jszip`). Python is only needed for the optional checks below.
- `apply_theme.js` and the `/mnt/skills/public/pptx/...` scripts exist only in the claude.ai sandbox. Outside it the script still builds the deck; theme colors then stay at Office defaults, which does not change how the slides look.
- Check the result by rendering: `soffice --headless --convert-to pdf out.pptx` then `pdftoppm -jpeg -r 110 out.pdf slide`, and look at every image. Use the pptx skill's `validate.py` when it is available.

## Reference implementation

Tested script that builds a five-slide sample (title, divider, text plus table, flowchart, text plus plots). Copy it, then replace the content of each slide and delete slides you do not need. Run with `node build_deck.js out.pptx`, then `python3 /mnt/skills/public/pptx/scripts/office/validate.py out.pptx`.

```js
// Sample deck built from the personal slide-style recipe.
const pptxgen = require("pptxgenjs");
const fs = require("fs");
const JSZip = require(require.resolve("jszip", { paths: [require.resolve("pptxgenjs")] }));
// apply_theme.js ships with the claude.ai pptx skill; elsewhere the deck still builds, only the theme colors stay at Office defaults
let applyTheme = async () => console.warn("apply_theme.js not found: theme colors left at Office defaults");
try { ({ applyTheme } = require("/mnt/skills/public/pptx/scripts/apply_theme.js")); } catch (e) {}

// ---------- tokens ----------
const T = {
  bg: "F8F9F7", ink: "1B201E", muted: "6A726E", green: "1F4A3C", fill: "E6EAE7", rule: "D6DBD8",
  teal: "1F7A70", coral: "D35A3C", blue: "3F6FA8", violet: "7D5AA6", rose: "B3476F", grey: "8B938F",
};
const F = { text: "Calibri", mono: "Consolas" };
const AUTHOR = "Vivek Sharma";
const DATE = "15 Oct 2026";
const PX = 0.45;            // side margin (in)
const CW = 10 - 2 * PX;     // content width

const THEME = {
  name: "Quiet technical",
  headFontFace: F.text,
  bodyFontFace: F.text,
  colors: {
    dk1: T.ink, lt1: T.bg, dk2: T.green, lt2: T.fill,
    accent1: T.teal, accent2: T.coral, accent3: T.blue, accent4: T.violet, accent5: T.rose, accent6: T.grey,
    hlink: T.blue, folHlink: T.violet,
  },
};

const pres = new pptxgen();
pres.layout = "LAYOUT_16x9"; // 10 x 5.625 in
pres.author = AUTHOR;
pres.title = "Slide style sample";
pres.theme = { headFontFace: F.text, bodyFontFace: F.text };

// ---------- layouts ----------
pres.defineSlideMaster({
  title: "CONTENT",
  background: { color: T.bg },
  objects: [
    { placeholder: { options: { name: "title", type: "title", x: PX, y: 0.32, w: CW, h: 0.58, fontFace: F.text, fontSize: 28, bold: false, color: T.ink, align: "left", valign: "bottom", margin: 0 }, text: "" } },
    { rect: { x: PX, y: 0.95, w: CW, h: 0.03, fill: { color: T.green }, line: { color: T.green, width: 0 } } },
    { line: { x: PX, y: 5.2, w: CW, h: 0, line: { color: T.rule, width: 0.75 } } },
    { text: { text: `${AUTHOR} · ${DATE}`, options: { x: PX, y: 5.25, w: 4, h: 0.22, fontFace: F.mono, fontSize: 10, color: T.muted, align: "left", margin: 0, isTextBox: true } } },
  ],
  slideNumber: { x: 10 - PX - 0.5, y: 5.25, w: 0.5, h: 0.22, fontFace: F.mono, fontSize: 10, color: T.ink, align: "right" },
});
pres.defineSlideMaster({ title: "TITLE", background: { color: T.bg } });
pres.defineSlideMaster({ title: "DIVIDER", background: { color: T.green } });

const txt = (slide, text, o) => slide.addText(text, Object.assign({ isTextBox: true, margin: 0, fontFace: F.text, color: T.ink }, o));
const ref = (slide, lines, x, y, w) =>
  txt(slide, lines.map((t, i) => ({ text: t, options: { breakLine: i < lines.length - 1 } })), { x, y, w, h: 0.17 * lines.length + 0.05, fontFace: F.mono, fontSize: 10, color: T.muted, valign: "top" });

// bullets: [{t, sub:[...]}]; sentences carry a period, fragments do not
function bullets(slide, items, o) {
  const runs = [];
  items.forEach((it, i) => {
    runs.push({ text: it.t, options: { bullet: { characterCode: "25A0", indent: 18 }, fontSize: 16, paraSpaceAfter: it.sub ? 3 : 9, breakLine: true } });
    (it.sub || []).forEach((s, j) => {
      const last = i === items.length - 1 && j === it.sub.length - 1;
      runs.push({ text: s, options: { bullet: { characterCode: "2013", indent: 16 }, indentLevel: 1, fontSize: 14, paraSpaceAfter: j === it.sub.length - 1 ? 9 : 3, breakLine: !last } });
    });
  });
  runs[runs.length - 1].options.breakLine = false;
  txt(slide, runs, Object.assign({ valign: "top" }, o));
}

// ---------- slide 1: title ----------
{
  const s = pres.addSlide({ masterName: "TITLE" });
  txt(s, "Projecting neutrino mass sensitivity with CRES", { x: 1.1, y: 1.15, w: 7.8, h: 1.5, fontSize: 40, align: "center", valign: "middle" });
  s.addShape(pres.shapes.RECTANGLE, { x: 4.4, y: 2.85, w: 1.2, h: 0.03, fill: { color: T.green }, line: { color: T.green, width: 0 } });
  txt(s, AUTHOR, { x: 1.5, y: 3.05, w: 7, h: 0.35, fontSize: 19, bold: true, align: "center" });
  txt(s, "Organization name", { x: 1.5, y: 3.42, w: 7, h: 0.3, fontSize: 15, color: T.muted, align: "center" });
  txt(s, `Event name · ${DATE}`, { x: 1.5, y: 3.82, w: 7, h: 0.25, fontFace: F.mono, fontSize: 11, color: T.muted, align: "center" });
  [3.4, 5.1].forEach((x) =>
    s.addShape(pres.shapes.RECTANGLE, { x, y: 4.45, w: 1.5, h: 0.52, fill: { type: "none" }, line: { color: T.muted, width: 0.75, dashType: "dash" } })
  );
  [3.4, 5.1].forEach((x) => txt(s, "logo", { x, y: 4.45, w: 1.5, h: 0.52, fontFace: F.mono, fontSize: 10, color: T.muted, align: "center", valign: "middle" }));
}

// ---------- slide 2: section divider ----------
{
  const s = pres.addSlide({ masterName: "DIVIDER" });
  txt(s, "SECTION 2 OF 4", { x: 1, y: 2.0, w: 8, h: 0.3, fontFace: F.mono, fontSize: 12, color: "BBC8C3", align: "center" });
  txt(s, "Signal classification", { x: 1, y: 2.35, w: 8, h: 1.0, fontSize: 43, color: T.bg, align: "center", valign: "top" });
}

// ---------- slide 3: text + table ----------
{
  const s = pres.addSlide({ masterName: "CONTENT" });
  s.addText("Trap depth and track length", { placeholder: "title" });
  bullets(s, [
    { t: "Deeper traps hold electrons longer.", sub: ["More frequency steps per track", "Longer fit baseline"] },
    { t: "Config C gives the best resolution, 1.12\u00a0±\u00a00.06\u00a0eV." },
    { t: "Shallow traps: larger effective volume, coarser resolution" },
  ], { x: PX, y: 1.2, w: 3.9, h: 3.8 });

  const ink = { type: "solid", pt: 1.5, color: T.ink };
  const thin = { type: "solid", pt: 0.75, color: T.rule };
  const hair = { type: "solid", pt: 1, color: T.ink };
  const none = { type: "none" };
  const head = ["Config", "Depth (mT)", "Track (ms)", "σE (eV)"];
  const rows = [
    ["A", "2.0", "0.80 ± 0.05", "3.10 ± 0.12"],
    ["B", "3.5", "1.40 ± 0.06", "1.85 ± 0.08"],
    ["C", "5.0", "2.10 ± 0.07", "1.12 ± 0.06"],
    ["D", "7.5", "2.60 ± 0.09", "1.30 ± 0.07"],
  ];
  const cell = (text, c, r, isHead) => {
    const last = r === rows.length - 1;
    return {
      text,
      options: {
        fontFace: c === 0 ? F.text : F.mono,
        fontSize: isHead ? 12 : 14,
        color: isHead ? T.muted : T.ink,
        bold: !isHead && r === 2,
        align: c === 0 ? "left" : "right",
        valign: "middle",
        border: [isHead ? ink : none, none, isHead ? hair : last ? ink : thin, c === 0 ? none : thin],
        margin: [0, 0.1, 0, 0.1],
      },
    };
  };
  const tbl = [head.map((h, c) => cell(h, c, -1, true))].concat(rows.map((r, ri) => r.map((v, c) => cell(v, c, ri, false))));
  s.addTable(tbl, { x: 4.5, y: 1.3, w: 5.05, colW: [0.8, 1.25, 1.5, 1.5], rowH: 0.46 });
  ref(s, ["[1] Placeholder reference A, 2026", "[2] Placeholder reference B, 2025", "Placeholder numbers for layout testing."], 4.5, 3.75, 5.05);
}

// ---------- slide 4: flowchart ----------
{
  const s = pres.addSlide({ masterName: "CONTENT" });
  s.addText("Analysis workflow", { placeholder: "title" });
  const u = 0.0094; // inches per layout unit (968 units across the content width)
  const X = (v) => PX + (v + 4) * u - 0.0;
  const Y = (v) => 1.15 + v * u;
  const labels = [["Raw", "spectrogram"], ["Denoise", "and bin"], ["CNN", "classifier"], ["Fit track", "and energy"], ["Bayesian", "sensitivity"]];
  labels.forEach((l, i) => {
    const x = X(i * 205), y = Y(60), w = 140 * u, h = 100 * u;
    s.addShape(pres.shapes.RECTANGLE, { x, y, w, h, fill: { color: T.fill }, line: { color: T.fill, width: 0 } });
    txt(s, [{ text: l[0], options: { breakLine: true } }, { text: l[1] }], { x, y, w, h, fontSize: 18, bold: true, color: T.green, align: "center", valign: "middle" });
    if (i < 4) s.addShape(pres.shapes.LINE, { x: X(i * 205 + 145), y: Y(110), w: 56 * u, h: 0, line: { color: T.green, width: 2.5, endArrowType: "triangle" } });
  });
  txt(s, "track", { x: X(2 * 205 + 145), y: Y(110) - 0.27, w: 56 * u, h: 0.22, fontFace: F.mono, fontSize: 11, color: T.muted, align: "center" });
  s.addShape(pres.shapes.LINE, { x: X(410 + 70), y: Y(165), w: 0, h: 78 * u, line: { color: T.muted, width: 1.5, dashType: "dash", endArrowType: "triangle" } });
  txt(s, "no track", { x: X(410 + 70) + 0.1, y: Y(190), w: 1, h: 0.22, fontFace: F.mono, fontSize: 11, color: T.muted });
  s.addShape(pres.shapes.RECTANGLE, { x: X(410), y: Y(250), w: 140 * u, h: 100 * u, fill: { color: T.fill }, line: { color: T.fill, width: 0 } });
  txt(s, "Discard", { x: X(410), y: Y(250), w: 140 * u, h: 100 * u, fontSize: 18, color: T.muted, align: "center", valign: "middle" });
  ref(s, ["[1] Placeholder reference for the classifier, 2026"], PX, 4.8, CW);
}

// ---------- slide 5: text + plots ----------
{
  const s = pres.addSlide({ masterName: "CONTENT" });
  s.addText("Track frequency and energy residuals", { placeholder: "title" });
  const colX = 3.3, colW = 10 - PX - colX;
  const rowY = [1.1, 3.0], figH = 1.72;

  bullets(s, [{ t: "Each scatter steps the track frequency.", sub: ["Step size gives the energy lost", "Fitted slope gives the onset frequency"] }], { x: PX, y: rowY[0], w: 2.6, h: figH, valign: "middle" });
  bullets(s, [{ t: "Residuals are Gaussian, σ\u00a0=\u00a01.12\u00a0±\u00a00.06\u00a0eV.", sub: ["Keeps the likelihood simple"] }], { x: PX, y: rowY[1], w: 2.6, h: figH, valign: "middle" });

  // plot A: stepped data and linear fit (scatter)
  const pts = [[0, 1], [0.35, 1], [0.35, 4.5], [0.62, 4.5], [0.62, 8], [0.95, 8], [0.95, 11.5], [1.3, 11.5], [1.3, 16], [1.7, 16], [1.7, 18.5], [2.0, 18.5]];
  const xs = pts.map((p) => p[0]);
  const axisCommon = {
    catAxisLabelFontFace: F.mono, valAxisLabelFontFace: F.mono, catAxisLabelFontSize: 11, valAxisLabelFontSize: 11,
    catAxisLabelColor: T.muted, valAxisLabelColor: T.muted,
    showCatAxisTitle: true, showValAxisTitle: true,
    catAxisTitleFontFace: F.mono, valAxisTitleFontFace: F.mono, catAxisTitleFontSize: 12, valAxisTitleFontSize: 12,
    catAxisTitleColor: T.muted, valAxisTitleColor: T.muted,
    valGridLine: { color: T.rule, size: 0.75 }, catGridLine: { color: T.rule, size: 0.75 },
    showTitle: true, titleFontFace: F.text, titleFontSize: 13, titleColor: T.ink, titleBold: true,
    plotArea: { fill: { color: T.bg }, border: { pt: 1.5, color: T.ink } },
    showLegend: false, chartArea: { fill: { color: T.bg } },
    layout: { x: 0.115, y: 0.2, w: 0.865, h: 0.5 },
  };
  s.addChart(pres.charts.SCATTER, [
    { name: "t", values: xs },
    { name: "data", values: pts.map((p) => p[1]) },
    { name: "fit", values: xs.map((x) => 1.5 + 7.75 * x) },
  ], Object.assign({}, axisCommon, {
    x: colX, y: rowY[0], w: colW, h: figH, chartColors: [T.teal, T.coral], lineSize: 3, lineDataSymbol: "none",
    title: "Track frequency", catAxisTitle: "t (ms)", valAxisTitle: "f − f0 (MHz)",
    catAxisMinVal: 0, catAxisMaxVal: 2, catAxisMajorUnit: 0.5, valAxisMinVal: 0, valAxisMaxVal: 20, valAxisMajorUnit: 5,
  }));
  // direct key inside the plot
  const kx = colX + 0.115 * colW + 0.12, ky = rowY[0] + 0.2 * figH + 0.06;
  [["data", T.teal, "solid", 0], ["fit", T.coral, "dash", 1]].forEach(([n, c, d, i]) => {
    s.addShape(pres.shapes.LINE, { x: kx, y: ky + 0.1 + i * 0.2, w: 0.3, h: 0, line: { color: c, width: 2.5, dashType: d } });
    txt(s, n, { x: kx + 0.38, y: ky + i * 0.2, w: 0.6, h: 0.2, fontFace: F.mono, fontSize: 11, valign: "middle" });
  });
  ref(s, ["[1] Placeholder simulation, 2026"], colX, rowY[0] + figH + 0.02, colW);

  // plot B: residual histogram
  const n = 16;
  const labels = [], vals = [];
  for (let i = 0; i < n; i++) {
    const c = -2 + ((i + 0.5) * 4) / n;
    labels.push(i % 4 === 0 ? (-2 + (i * 4) / n).toFixed(0).replace("-", "\u2212") : " ");
    vals.push(Math.round(96 * Math.exp(-(c * c) / (2 * 0.62 * 0.62)) + (i % 3) * 2));
  }
  s.addChart(pres.charts.BAR, [{ name: "counts", labels, values: vals }], Object.assign({}, axisCommon, {
    x: colX, y: rowY[1], w: colW, h: figH, barDir: "col", chartColors: [T.coral], barGapWidthPct: 6,
    title: "Energy residuals", catAxisTitle: "ΔE (eV)", valAxisTitle: "counts", valAxisMinVal: 0, valAxisMaxVal: 100, valAxisMajorUnit: 50,
  }));
  ref(s, ["[2] Placeholder reference B, 2025"], colX, rowY[1] + figH + 0.02, colW);
}


// pptxgenjs applies one dash style to every series; set per-series dashes in the chart XML afterwards.
async function dashSeries(file, serIdx, dash) {
  const zip = await JSZip.loadAsync(fs.readFileSync(file));
  const name = Object.keys(zip.files).find((n) => /^ppt\/charts\/chart\d+\.xml$/.test(n));
  // scatter chart is the one with scatterChart
  const target = Object.keys(zip.files).filter((n) => /^ppt\/charts\/chart\d+\.xml$/.test(n));
  for (const n of target) {
    let xml = await zip.file(n).async("string");
    if (!xml.includes("<c:scatterChart>")) continue;
    const parts = xml.split("<c:ser>");
    parts[serIdx + 1] = parts[serIdx + 1].replace(/<a:prstDash val="[^"]*"\/>/, `<a:prstDash val="${dash}"/>`);
    zip.file(n, parts.join("<c:ser>"));
  }
  fs.writeFileSync(file, await zip.generateAsync({ type: "nodebuffer", compression: "DEFLATE" }));
}

(async () => {
  const out = process.argv[2] || "sample.pptx";
  await pres.writeFile({ fileName: out });
  await dashSeries(out, 1, "dash"); // second series (the fit) dashed
  await applyTheme(out, THEME);
  console.log("wrote", out);
})();
```
