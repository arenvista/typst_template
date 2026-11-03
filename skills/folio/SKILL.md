---
name: folio
description: Write or edit Typst documents with the folio template — lecture notes, problem sets, papers, or books. Use when a .typ file imports "@local/folio" or "template_main.typ", when starting a new Typst document for notes or coursework, or when working with folio's theorem environments, math shorthands, native figures, or its notes/homework/paper/book shells.
---

# folio

One Typst template, four document shells, one design language. No packages,
no external assets — figures are drawn natively, so a finished document is a
single `.typ` file.

## Starting a document

```typ
#import "@local/folio:0.1.0": *
#show: notes.with(title: "Orthogonality", course: "MATH 221",
                  author: "Aren Vista", date: "2026-09-12")
```

If the package is not installed, import by relative path instead
(`#import "../template_main.typ": *`) — nothing else changes.

Pick the shell by what the document is:

| Shell | Front matter | Sections | Equations |
|---|---|---|---|
| `notes` | masthead: title, then author · course · date | `1.1` | by section |
| `homework` | same masthead | `1.` `(a)` `(i)` | unnumbered |
| `paper` | centred title block, optional `abstract` | `1.1` | `(1)`, flat |
| `book` | title page + contents page | chapter openers | by chapter |

Every option works on every shell; they differ only in defaults:
`title` `subtitle` `author` `course` `date` `blurb` `abstract` `paper-size`
`margin` `font` `size` `page-fill` `justify` `numbered` `eq-numbering`
`head-numbering` `cover` `cover-rule` `toc` `chapters`.

`homework` adds `count-h1: true` (write `= Question`, the counter supplies
the number → "Question 2") and `h1-label: [Problem]` (replaces the heading
text entirely).

## Environments

Call one with an optional `title:` and a content block.

```typ
#definition(title: "Eigenvector")[A nonzero $bold(v)$ with $A bold(v) = lambda bold(v)$.]
#theorem[Every operator on $CC^n$ has an eigenvalue.]
#proof[Consider $I, T, dots, T^n$.]
```

| Numbered | Not numbered |
|---|---|
| `theorem` `proposition` `lemma` `corollary` `claim` | `proof` `solution` `intuition` |
| `definition` `axiom` `notation` | `question` `key` |
| `formula` `example` `exercise` `conjecture` | `remark` `aside` `observation` `case` `warning` `important` |

Short aliases: `thm` `prop` `lem` `cor` `defn` `def` `exm` `soln` `pf`
`ques` `conj` `warn` `imp`.

One counter serves them all, so "Theorem 3.7" is the seventh numbered box in
section 3 whatever kind it is; it restarts at each level-1 heading.
`proof` closes itself with a QED tombstone.

Label-only boxes: `pitfall`, `idea`, `recall`, and the generic
`notebox("Label", hue: c-iter)[...]`.

### Overriding one box

Each environment takes `kind`, `glyph`, `hue` and `counted`:

```typ
#question(kind: "Prompt")[...]              // relabelled
#question(glyph: none)[...]                 // no glyph
#question(kind: none)[...]                  // no label at all
#question(hue: c-iter)[...]                 // another hue
#theorem(counted: false)[...]               // skip the number
```

Document-wide, rebind once near the top:

```typ
#let question = question.with(kind: "Prompt", glyph: [✱])
```

`kind: none` hides the number but still *consumes* one — add
`counted: false` if it should not count.

Build a new kind with `callout`:

```typ
#let heuristic(title: none, body) = callout(
  "Heuristic", body, hue: c-iter, glyph: [↯], title: title, counted: false)
```

## Mathematics

Shorthands are math-mode functions — call them **inside** `$…$` without a
`#`, or in markup **with** one:

```typ
$ip(u, v)$        $norm(x)$      $abs(x)$     $card(S)$
$setb(x in RR, x > 0)$           $dv(y, x)$   $pdv(f, x)$
$restr(f, A)$     $evalat(F(x), a, b)$
$vv(1, 2, 3)$     $mm(1, 2; 3, 4)$           // ROWS SEPARATED BY ;
$RR$ $NN$ $ZZ$ $QQ$ $CC$ $FF$ $PP$ $EE$ $HH$ $KK$ $eps$ $dt$
```

Operators defined here: `rank` `span` `Span` `Nul` `Col` `Row` `sgn` `diag`
`adj` `nullity` `proj` `comp` `argmin` `argmax` `grad` `curl` `divg` `st`
`Aut` `End` `Hom` `GL` `SL`.

**Never redefine** these — Typst already ships them: `det` `dim` `ker` `tr`
`im` `id` `hom` `Pr` `gcd` `lcm` `min` `max` `inf` `sup` `lim`.

## Structure

```typ
#problem(1, title: "Cauchy sequences", newpage: true)[...]  // unnumbered h1
#show: appendix                    // everything after is lettered A, A.1, …
#front-title[Preface]              // front matter, outside the numbering
#contents(depth: 2)                // a contents listing anywhere
```

## Figures

Coordinates are plain numbers in points, x rightward and y **downward** from
the canvas top-left.

```typ
#figframe[Orthogonal projection onto a line.][
  #fcanvas(300, 130, {
    fseg((10, 110), (290, 110), col: rule-line)   // segment
    fvec((40, 110), (250, 40), col: c-fig)        // arrow
    fdot((40, 110), col: ink)                     // dot
    flab((262, 32), $bold(v)$, col: c-fig)        // label centred on point
    frt((250, 110), (-1, 0), (0, -1))             // right-angle tick
  })
]
```

Also `fpoly(pts, fill:, stroke:)` and `fhead(x, y, angle)`.

Function plots — each segment needs `fn`; `from` `to` `paint` `dash` are
optional:

```typ
#plot(
  ((fn: x => calc.sin(x), paint: c-core),),
  xlim: (0, 10), ylim: (-1.1, 1.1),
  xticks: (0, 2, 4), yticks: (-1, 1),
  xlabel: $t$, ylabel: $y$,
  marks: ((x: 2, y: 0.9), (x: 4, y: 0, open: true)),
)
```

## Design tokens

Text: `ink` `ink-soft` `muted`. Rules: `rule-line` `rule-soft`. Surfaces:
`ground` `surface` `surface-2` `code-bg`.

Accents: `c-core` (blue, = `accent`) `c-ops` (green) `c-decomp` (purple)
`c-solve` (red) `c-iter` (olive).

Environment hues: `c-result` `c-define` `c-argue` `c-illus` `c-prompt`
`c-aside` `c-unsure` `c-alert` `c-formula`.

Fonts: `font-serif` `font-sans` `font-mono` `font-cm`. Kept short on purpose
— Typst warns once per family it cannot find. Extend with
`("Iowan Old Style", ..font-serif)`.

Other helpers: `hrule()` (the gradient bar) `thinrule()` `eyebrow[]`
`hnum[]` `legend()` `sqmark()`.

## Custom masthead

`cover` takes a built-in name, a function, or ready-made content. The
function gets `title` `subtitle` `author` `course` `date` `blurb`
`abstract` `rule`:

```typ
cover: m => {
  grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
    { eyebrow(m.course); v(0.3em); text(size: 22pt, weight: 600, m.title) },
    text(size: 9.5pt, fill: muted)[#m.author \ #m.date])
  m.rule
}
```

## Compiling

```sh
typst compile notes.typ        # → notes.pdf
typst watch notes.typ          # recompile on save
typst init @local/folio name   # scaffold a new document
```

## Gotchas

These all cost real debugging time — check them first when something looks
wrong.

- **`mm` rows use `;`**: `$mm(1, 2; 3, 4)$`. Commas alone give one row.
- **Shorthands in math mode take no `#`**: `$ip(u, v)$`, not `$#ip(...)$`.
  In markup it is the reverse: `#ip($u$, $v$)`.
- **An explicit `v()` next to a block overrides that block's own
  `above`/`below`**, collapsing the gap to nothing. Pass spacing to the
  block instead — this is why `hrule` takes `above:` and `below:`.
- **A `table.cell` show rule must return the cell**, not `it.body`.
  Returning the body alone drops the cell and its inset, and header labels
  run into each other. Use `upper(it)`, never `upper(it.body)`.
- **Typst cannot call a dictionary key**: `m.rule` is content, not a
  function. `m.rule(...)` is an error.
- **`angle.l` / `angle.r` do not exist** — the chevrons are `chevron.l` and
  `chevron.r`.
- **Level-1 headings reset the environment counter**, so a document with no
  headings numbers every box from 1 in "section 0" (shown as a bare number).
