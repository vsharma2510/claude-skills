---
name: personal-plot-style
description: Vivek's matplotlib style for physics figures. Use whenever the user asks for a plot, figure, histogram, heatmap, fit, error-bar plot, multi-panel figure or any data visualization made with code, for slides, a paper, an internal note or a poster, even if no style is named. Gives boxed plots with inward ticks, a light grid, centered bold titles, mono axis text, a fixed palette, three output sizes (slide, paper column, full width) and rules for keys, panel labels, colormaps and saved files. Takes precedence over generic data-visualization guidance for colors, fonts and styling. Native PowerPoint charts inside a deck follow personal-slide-style instead.
---

# Personal plot style

The look comes from decisions the user made one at a time while looking at test figures, so follow it exactly. It matches the slide style (same palette, same frame, same type), so a figure made here sits next to a native chart in a deck without clashing.

## Workflow

1. Decide the context from where the figure will be used: `slide` (image on a slide), `paper` (single column, 3.4 in), `wide` (full width, 7 in, also for multi-panel). Ask if it is unclear; assume `slide` when making slides and `paper` for notes and papers.
2. Write the module in the last section to `plotstyle.py` next to the plotting script (skip if it is already there and identical).
3. In the script: `import plotstyle as ps`, `ps.use(context)`, build figures with `ps.figure()`, style with `ps.style_axes`, then `ps.finalize` and `ps.save`. Use the example at the end.
4. Open every saved PNG and look at it before reporting. Check the list at the end.
5. Tell the user the file names and which context was used.

## Contexts

| Context | Figure size | Text (title / labels / ticks) | Ground | Files saved |
|---|---|---|---|---|
| slide | 6.2 x 3.3 in | 15 / 13 / 12 pt | slide ground `#F8F9F7` | PNG, 200 dpi |
| paper | 3.4 x 2.6 in | 9 / 8 / 7 pt | white | vector PDF plus PNG preview, 300 dpi |
| wide | 7.0 x 2.8 in | 9 / 8 / 7 pt | white | vector PDF plus PNG preview, 300 dpi |

Slide text is large on purpose: labels must be readable from the back of a room. Use `rasterized=True` on `pcolormesh` and `imshow` so PDFs stay small. Text in PDFs stays editable text.

## Frame and text

- Full ink box around every plot, inward ticks on all four sides, light grid on both axes behind the data.
- Title centered, bold, a topic label in sentence case (`Track frequency`), never a sentence or a claim.
- Axis labels in the mono face and muted grey, written `quantity (unit)` with the unit in parentheses: `t (ms)`, `f − f0 (MHz)`. Tick labels also mono and muted. Use a true minus sign.
- Fonts: Calibri for text and Consolas for numbers and axes. On Linux and clusters the module falls back to Carlito and DejaVu Sans Mono, which have the same metrics or close. Do not install other fonts.
- Notes inside a plot (for example a fit result) are mono, ink, and sit in the top-right. In a narrow panel that also has a panel label, drop the note to about 0.86 of the axes height (`transform=ax.transAxes`) so it clears the label.

## Color and marks

- Palette, in order: teal, coral, blue, violet, rose, grey (grey is for "other" or baseline). The cycle is already set by `ps.use`.
- Color is allowed whenever it carries information (series, category, state), even if the figure gets loud. Never use color only to decorate. Color is never the only channel: also vary line style, marker, or add a label.
- Data points: filled circles with capped error bars. Every plotted measurement has error bars or a stated uncertainty.
- Fits: dashed coral line, with a ±1σ band at about 16% opacity when an uncertainty is available.
- Histograms: filled coral bars with thin gaps in the ground color. Overlay a fit as a solid ink line.
- Series are identified by a small key inside the plot, upper left (`ps.legend`), never a legend outside the axes. Use `labeled=True` when the axes also has a panel label.

## Colormaps

- Default for 2D maps: `ps.cmap("sequential")` (viridis), a perceptually uniform multi-hue ramp. Never a rainbow or jet.
- Two-sided values (residuals around zero): `ps.cmap("diverging")`, blue to coral, with symmetric `vmin` and `vmax`.
- `ps.cmap("magnitude")` is a single-hue ramp for simple magnitude only, when the data has no structure worth showing.
- Always add a labeled colorbar with `ps.colorbar`.

## Multi-panel figures

- Use the `wide` context. Label panels `(a)`, `(b)`, `(c)` in bold Calibri inside the top-left corner of each frame (`ps.panel_label`).
- Plots that follow a flow get one caption or note per panel, not one block of text.

## Numbers and language

- Units in axis labels, uncertainty with every measured value in annotations (`1.12 ± 0.06 eV`), scientific notation for very small or large values.
- Spell out an abbreviation the first time it appears in a figure's text, then abbreviate.
- No hedges or filler in titles, labels or annotations.
- Never ship made-up numbers as if they were results. Demo data is for testing the style only.

## Checklist before reporting

- Title centered, axis labels have units, ticks inward, grid light.
- No overlap between tick labels at the lower-left corner (`ps.finalize` handles this; call it after limits and ticks are set).
- Colorbar label does not touch its tick labels.
- Panel label does not cover data or the key.
- Fonts rendered as expected (no boxes or fallbacks to a serif).
- Files saved in the sizes and formats of the chosen context.

## Module source: plotstyle.py

```python
"""Personal matplotlib style: boxed frame, inward ticks, light grid, centered bold titles,
mono axis text, one palette, three output contexts (slide, paper, wide).

    import plotstyle as ps
    ps.use("slide")                      # or "paper" (3.4 in column) or "wide" (7 in full width)
    fig, ax = ps.figure()
    ax.plot(...)
    ps.style_axes(ax, "Title", "t (ms)", "f (MHz)")
    ps.finalize(fig, ax)
    ps.save(fig, "track_frequency")      # slide: PNG; paper and wide: PDF plus PNG preview
"""
import logging

import matplotlib
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap

logging.getLogger("matplotlib.font_manager").setLevel(logging.ERROR)  # silence missing-font notices

COLORS = dict(bg="#F8F9F7", ink="#1B201E", muted="#6A726E", green="#1F4A3C", fill="#E6EAE7", rule="#D6DBD8",
              teal="#1F7A70", coral="#D35A3C", blue="#3F6FA8", violet="#7D5AA6", rose="#B3476F", grey="#8B938F")
CYCLE = [COLORS[k] for k in ("teal", "coral", "blue", "violet", "rose", "grey")]
TEXT_FONTS = ["Calibri", "Carlito", "DejaVu Sans"]
MONO_FONTS = ["Consolas", "Inconsolata", "DejaVu Sans Mono"]

# fig = inches; title/label/tick/note = pt; lw = data line width; ms = marker size; frame/grid = line widths; tickl/pad in pt
CONTEXTS = {
    "slide": dict(fig=(6.2, 3.3), title=15, label=13, tick=12, note=12, lw=1.8, ms=6.5, frame=1.4, grid=0.9, tickl=6, pad=7, dpi=200, bg=COLORS["bg"]),
    "paper": dict(fig=(3.4, 2.6), title=9, label=8, tick=7, note=7, lw=0.85, ms=3.6, frame=0.8, grid=0.5, tickl=3.5, pad=3, dpi=300, bg="#FFFFFF"),
    "wide": dict(fig=(7.0, 2.8), title=9, label=8, tick=7, note=7, lw=0.85, ms=3.6, frame=0.8, grid=0.5, tickl=3.5, pad=3, dpi=300, bg="#FFFFFF"),
}
_state = {"name": "slide", "c": CONTEXTS["slide"]}


def ctx():
    """Current context settings (dict)."""
    return _state["c"]


def use(context="slide"):
    """Apply the style globally. Call once before creating figures. Resets other rcParams."""
    c = CONTEXTS[context]
    _state.update(name=context, c=c)
    plt.rcdefaults()
    plt.rcParams.update({
        "figure.facecolor": c["bg"], "savefig.facecolor": c["bg"], "axes.facecolor": c["bg"],
        "font.family": TEXT_FONTS, "font.size": c["tick"], "text.color": COLORS["ink"],
        "axes.edgecolor": COLORS["ink"], "axes.linewidth": c["frame"],
        "axes.titlesize": c["title"], "axes.titleweight": "bold", "axes.titlepad": c["pad"],
        "axes.labelsize": c["label"], "axes.labelcolor": COLORS["muted"], "axes.labelpad": c["pad"] - 1,
        "axes.grid": True, "grid.color": COLORS["rule"], "grid.linewidth": c["grid"], "axes.axisbelow": True,
        "axes.prop_cycle": matplotlib.cycler(color=CYCLE),
        "xtick.direction": "in", "ytick.direction": "in", "xtick.top": True, "ytick.right": True,
        "xtick.major.size": c["tickl"], "ytick.major.size": c["tickl"],
        "xtick.major.width": c["frame"], "ytick.major.width": c["frame"],
        "xtick.labelsize": c["tick"], "ytick.labelsize": c["tick"],
        "xtick.color": COLORS["ink"], "ytick.color": COLORS["ink"],
        "xtick.labelcolor": COLORS["muted"], "ytick.labelcolor": COLORS["muted"],
        "lines.linewidth": c["lw"], "legend.frameon": False, "legend.fontsize": c["note"],
        "axes.unicode_minus": True, "mathtext.default": "regular", "pdf.fonttype": 42,
    })


def figure(nrows=1, ncols=1, figsize=None, **kw):
    """Figure with constrained layout at the context's default size. Returns (fig, ax) or (fig, axes)."""
    return plt.subplots(nrows, ncols, figsize=figsize or ctx()["fig"], constrained_layout=True, **kw)


def style_axes(ax, title, xlabel, ylabel):
    """Centered bold title, mono axis labels and tick labels."""
    ax.set_title(title, loc="center", color=COLORS["ink"], family=TEXT_FONTS)
    ax.set_xlabel(xlabel, family=MONO_FONTS)
    ax.set_ylabel(ylabel, family=MONO_FONTS)
    for lab in ax.get_xticklabels() + ax.get_yticklabels():
        lab.set_family(MONO_FONTS)


def legend(ax, labeled=False, **kw):
    """Small key inside the plot, upper left. Pass labeled=True when the axes carries a panel label."""
    kw.setdefault("loc", "upper left")
    kw.setdefault("bbox_to_anchor", (0.0, 0.84 if labeled else 1.0))
    return ax.legend(prop={"family": MONO_FONTS, "size": ctx()["note"]}, handlelength=1.8, borderaxespad=0.5, **kw)


def panel_label(ax, letter):
    """(a), (b), (c) inside the top-left corner of the frame."""
    ax.text(0.025, 0.965, f"({letter})", transform=ax.transAxes, ha="left", va="top", family=TEXT_FONTS,
            weight="bold", size=ctx()["title"], color=COLORS["ink"], zorder=10,
            bbox=dict(facecolor=ctx()["bg"], edgecolor="none", alpha=0.85, pad=1.5))


def finalize(fig, *axes):
    """Call after limits and ticks are set. Inward ticks put the first x and y labels on top of each other
    at the lower-left corner; this nudges them apart."""
    fig.canvas.draw()
    for ax in axes:
        xl, yl = ax.get_xlim(), ax.get_ylim()
        xt = [t for t in ax.get_xticks() if xl[0] - 1e-9 <= t <= xl[1] + 1e-9]
        yt = [t for t in ax.get_yticks() if yl[0] - 1e-9 <= t <= yl[1] + 1e-9]
        if xt and yt and abs(xt[0] - xl[0]) < 1e-9 and abs(yt[0] - yl[0]) < 1e-9:
            for lab in ax.get_xticklabels():
                if lab.get_text() and abs(lab.get_position()[0] - xl[0]) < 1e-9:
                    lab.set_ha("left")
            for lab in ax.get_yticklabels():
                if lab.get_text() and abs(lab.get_position()[1] - yl[0]) < 1e-9:
                    lab.set_va("bottom")


def cmap(kind="sequential"):
    """sequential: viridis (default for 2D maps). diverging: blue to coral for two-sided values.
    magnitude: single-hue ramp for simple magnitude only."""
    if kind == "sequential":
        return "viridis"
    if kind == "diverging":
        return LinearSegmentedColormap.from_list("blue_coral", [COLORS["blue"], "#F2F2EF", COLORS["coral"]])
    if kind == "magnitude":
        return LinearSegmentedColormap.from_list("ground_teal", [ctx()["bg"], COLORS["teal"], COLORS["green"]])
    raise ValueError(kind)


def colorbar(fig, ax, mappable, label):
    cb = fig.colorbar(mappable, ax=ax, pad=0.02, aspect=18)
    cb.set_label(label, family=MONO_FONTS, color=COLORS["muted"], size=ctx()["label"], labelpad=ctx()["pad"] + 5)
    cb.outline.set_linewidth(ctx()["frame"])
    cb.outline.set_edgecolor(COLORS["ink"])
    cb.ax.tick_params(direction="in", length=ctx()["tickl"], width=ctx()["frame"], labelsize=ctx()["tick"],
                      labelcolor=COLORS["muted"], color=COLORS["ink"])
    for lab in cb.ax.get_yticklabels():
        lab.set_family(MONO_FONTS)
    return cb


def save(fig, stem):
    """slide: <stem>.png at 200 dpi. paper and wide: vector <stem>.pdf plus <stem>.png preview at 300 dpi.
    Use rasterized=True on pcolormesh/imshow so the PDF stays small. Returns the list of files written."""
    c = ctx()
    paths = []
    if _state["name"] != "slide":
        fig.savefig(f"{stem}.pdf")
        paths.append(f"{stem}.pdf")
    fig.savefig(f"{stem}.png", dpi=c["dpi"])
    paths.append(f"{stem}.png")
    return paths
```

## Example

```python
import numpy as np
import plotstyle as ps

ps.use("slide")                                  # "paper" or "wide" for papers
fig, ax = ps.figure()
t = np.linspace(0.1, 1.9, 12)
f = 1.5 + 7.75 * t + np.random.default_rng(1).normal(0, 0.9, t.size)
ax.errorbar(t, f, yerr=0.9, fmt="o", color=ps.COLORS["teal"], ms=ps.ctx()["ms"],
            elinewidth=ps.ctx()["lw"] * 0.55, capsize=ps.ctx()["ms"] * 0.5, capthick=ps.ctx()["lw"] * 0.55, label="data")
ax.plot([0, 2], [1.5, 17], color=ps.COLORS["coral"], ls=(0, (5, 3)), label="fit")
ax.set_xlim(0, 2); ax.set_ylim(0, 20)
ps.style_axes(ax, "Track frequency", "t (ms)", "f − f0 (MHz)")
ps.legend(ax)
ps.finalize(fig, ax)
print(ps.save(fig, "track_frequency"))           # slide: ['track_frequency.png']
```

For a multi-panel figure: `fig, axs = ps.figure(1, 3, figsize=(7.0, 2.6))`, draw into each axes, call `ps.panel_label(ax, "a")` and so on, then `ps.finalize(fig, *axs)`.
