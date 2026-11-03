// =========================================================================
//  template_main.typ — one Typst template for notes, homework, papers
//  and books.
//
//  Usage:
//    #import "template_main.typ": *
//    #show: notes.with(title: "Eigenvalues", course: "MATH 221")
//
//  Four document shells share one design language and one set of
//  environments, so a definition box looks the same whether it lands in a
//  lecture note or in a bound volume:
//
//    notes     — a titled banner, numbered sections, no title page.
//    homework  — notes, plus the settings every problem set wants.
//    paper     — centred title block, optional abstract, flat equation
//                numbering.
//    book      — a full title page, a contents page, and chapter openers.
//
//  Everything below is plain Typst: no packages, no external assets.
//  Compile with `typst compile <file>.typ`.
// =========================================================================

// =========================================================================
//  1. DESIGN TOKENS
// =========================================================================
// A light, low-contrast paper palette. Change these and the whole system
// follows — the boxes, rules, tables and figures all read from here.

#let ink = rgb("#16202e")
// body text
#let ink-soft = rgb("#3f4b5b")
// secondary text, table cells
#let muted = rgb("#6b7684")
// eyebrows, captions, tick labels
#let rule-line = rgb("#dbe2ea")
// hairlines that separate
#let rule-soft = rgb("#e8edf3")
// hairlines that only hint
#let ground = rgb("#f6f8fb")
// an optional tinted page
#let surface = rgb("#ffffff")
#let surface-2 = rgb("#eef2f7")
#let code-bg = rgb("#f4f6f9")
#let code-ink = rgb("#24303f")

// The five semantic accents. The gradient rule runs through them in this
// order, and `accent` is what links, markers and numerals take.
#let c-core = rgb("#1a5fb4")
// blue    — the core thread
#let c-ops = rgb("#2e7d32")
// green   — operations
#let c-decomp = rgb("#613583")
// purple  — decompositions
#let c-solve = rgb("#a51d2d")
// red     — solving
#let c-iter = rgb("#6c5b00")
// olive   — iteration
#let accent = c-core

// ---- environment hues ---------------------------------------------------
// Two axes of information: the hue names the family, the glyph names the
// specific environment. One hue per family, so a reader can tell a proved
// result from a definition from an aside without reading the label.
// Within-family tonal ramps were tried and rejected: the fill lightens the
// hue by 90%, which collapses near neighbours into identical pastels.
//
// All label colours clear WCAG AA (>= 5.3:1) against their own tinted fill.
#let c-result = rgb("#a51d2d")
// crimson — asserted and proved
#let c-define = rgb("#1a5fb4")
// blue    — fixes language, asserts nothing
#let c-argue = rgb("#2e7d32")
// green   — our own reasoning
#let c-illus = rgb("#136b6b")
// teal    — a concrete instance
#let c-prompt = rgb("#5b3a9e")
// violet  — what was asked of us
#let c-aside = rgb("#44506b")
// slate   — commentary and scaffolding
#let c-unsure = rgb("#9a6600")
// amber   — stated but not established
#let c-alert = rgb("#c64600")
// orange  — a trap worth flagging
#let c-formula = rgb("#8f3f71")
// magenta — worth keeping to hand

// ---- font stacks --------------------------------------------------------
// Kept short on purpose: every family Typst cannot find costs a warning,
// so these name only faces a normal Linux install ships. Put the faces you
// actually own at the front — see the note under the stacks — or pass
// `font:` to a shell for a one-document override.
#let font-serif = ("Libertinus Serif", "New Computer Modern", "DejaVu Serif")
#let font-cm = ("New Computer Modern", "Libertinus Serif", "DejaVu Serif")
#let font-sans = ("Open Sans", "Liberation Sans", "DejaVu Sans")
#let font-mono = ("JetBrainsMono NF", "Liberation Mono", "DejaVu Sans Mono")

// Add the faces you actually own to the front of a stack, e.g.
//   #let font-serif = ("Iowan Old Style", "Charter", ..font-serif)
// Typst warns once for every family it cannot find, so naming faces that
// are not installed is harmless but noisy.

// =========================================================================
//  2. COUNTERS AND STATE
// =========================================================================
// One counter serves every numbered environment, so "Theorem 3.7" is the
// seventh numbered box in section 3 whatever kind it is. It always steps
// when `counted: true`; whether the number is *shown* is `_env-numbered`.

#let _env-counter = counter("env")
#let _fig-counter = counter("tfigure")
#let _env-numbered = state("env-numbered", true)
// Tells the boxes whether they are in chapter 3 or in appendix C.
#let _chap-fmt = state("chap-fmt", "1")
#let _in-appendix = state("in-appendix", false)
// Counts sections within the current chapter, so the first section of a
// chapter can skip its top rule — the opener has just drawn one, and two
// rules a line apart read as an artefact.
#let _sec-in-chap = counter("section-in-chapter")

// =========================================================================
//  3. TYPOGRAPHIC PRIMITIVES
// =========================================================================

// The `---` rule: a 2pt bar carrying the five accents left to right. It is
// the loudest thing in the design language, so it is reserved for chapter
// openers and the title page.
// `above`/`below` are explicit because an adjacent `v()` overrides a block's
// own spacing in Typst; set the gap here rather than around the call.
#let hrule(w: 100%, above: 1.9em, below: 1.1em) = block(
  width: w,
  height: 2pt,
  radius: 1pt,
  above: above,
  below: below,
  fill: gradient.linear(
    c-core.transparentize(15%),
    c-ops.transparentize(15%),
    c-decomp.transparentize(15%),
    c-solve.transparentize(15%),
    c-iter.transparentize(15%),
  ),
)

// A plain hairline, for separating without announcing.
#let thinrule(w: 100%, col: rule-line) = line(length: w, stroke: 0.5pt + col)

// Small caps-ish label: sans, uppercase, letterspaced, muted. Used for
// course codes, figure numbers, table headers and section kickers.
#let eyebrow(body, col: muted, size: 7.6pt) = text(
  font: font-sans,
  size: size,
  weight: "bold",
  tracking: 0.08em,
  fill: col,
  upper(body),
)

// The mono numeral that sits before a heading.
#let hnum(body, size: 0.66em, col: accent) = {
  text(font: font-mono, size: size, weight: "medium", fill: col, tracking: 0pt, body)
  h(0.7em)
}

// A front-matter title (Preface, Contents, Index): it carries the chapter
// opener's look without stepping the chapter counter or entering the
// outline.
#let front-title(body) = block(above: 0pt, below: 1.4em, {
  set text(size: 25pt, weight: 600, fill: ink, tracking: -0.02em)
  set par(justify: false, leading: 0.26em)
  body
  v(0.5em, weak: true)
  line(length: 100%, stroke: 1pt + rule-line)
})

// =========================================================================
//  4. ENVIRONMENTS
// =========================================================================
// The generic box. Everything in section 4.1 is one call to this with a
// fixed kind, hue and glyph; build your own the same way.
//
//   #callout("Heuristic", hue: c-iter, glyph: [↯])[...]
//
// The fill is the hue at 10% over white (`lighten(90%)`) and the hairline
// border is the same hue at 45% alpha. The label is darkened 30% because
// these hues are tuned as fills, not as body-size text.

#let callout(
  kind,
  body,
  hue: c-aside,
  glyph: none,
  title: none,
  counted: true,
  italic: false,
  breakable: true,
) = {
  // Step first, then read: a `context` block sees the document state at its
  // own position, so stepping inside it would read the pre-step value.
  if counted { _env-counter.step() }
  block(
    width: 100%,
    fill: hue.lighten(90%),
    stroke: 0.6pt + hue.transparentize(55%),
    inset: (x: 11pt, y: 9pt),
    radius: 3pt,
    above: 1.15em,
    below: 1.15em,
    breakable: breakable,
    context {
      // `kind: none` drops the label outright — no word, no number, no full
      // stop. A title given on its own then becomes the label.
      let head = if kind == none {
        none
      } else if counted and _env-numbered.get() {
        let sec = counter(heading).get()
        let n = _env-counter.get().first()
        let fmt = _chap-fmt.get()
        if sec.len() > 0 and sec.first() > 0 {
          [#kind #numbering(fmt + ".1", sec.first(), n)]
        } else {
          [#kind #n]
        }
      } else {
        [#kind]
      }
      // Display maths inside a box sits tighter than it does in prose.
      show math.equation.where(block: true): set block(above: 0.85em, below: 0.85em)
      let stated = {
        if head != none { text(weight: "bold", fill: hue.darken(30%), head) }
        if title != none {
          text(weight: "bold", fill: ink, if head == none [#title] else [ (#title)])
        }
        // No full stop after the label: the weight and colour already
        // separate it from the body, and a period makes "Question ?" read
        // as an abbreviation.
        if head != none or title != none { h(0.5em) }
        if italic { emph(body) } else { body }
      }
      // The glyph sits in its own gutter rather than inline before the
      // label, so the body text of every box starts on the same left edge.
      if glyph == none {
        stated
      } else {
        grid(
          columns: (1.15em, 1fr),
          column-gutter: 8pt,
          align: (center + top, left + top),
          text(fill: hue.darken(30%), size: 1.15em, glyph), stated,
        )
      }
    },
  )
}

// ---- 4.1 the standard environments --------------------------------------
// Each one is `callout` with its defaults filled in, and each takes `kind`,
// `glyph`, `hue` and `counted` as named arguments — so any single box can be
// renamed, re-lettered, recoloured or stripped back at the point of use:
//
//   #question(kind: "Prompt")[...]            rename just this one
//   #question(glyph: none)[...]               drop the glyph, keep the label
//   #question(kind: none, glyph: none)[...]   neither: a plain tinted box
//   #question(hue: c-iter)[...]               another hue for this one box
//
// To change one for a whole document, rebind it once near the top:
//
//   #let question = question.with(kind: "Prompt", glyph: [✱])
//
// A box with `kind: none` shows no number either, but still consumes one;
// pass `counted: false` as well if it should not.

#let _env(d-kind, d-hue, d-glyph, d-counted: true, italic: false) = (
  title: none,
  kind: d-kind,
  glyph: d-glyph,
  hue: d-hue,
  counted: d-counted,
  body,
) => callout(
  kind,
  body,
  hue: hue,
  glyph: glyph,
  title: title,
  counted: counted,
  italic: italic,
)

// Results: proved, or offered for proof. Filled shapes outrank hollow ones,
// mirroring how much weight the result carries.
#let theorem = _env("Theorem", c-result, [★])
#let proposition = _env("Proposition", c-result, [◆])
#let lemma = _env("Lemma", c-result, [◇])
#let corollary = _env("Corollary", c-result, [↳])
#let claim = _env("Claim", c-result, [‣])

// Language: definitional, so deliberately not the colour of a result.
#let definition = _env("Definition", c-define, [≝])
#let axiom = _env("Axiom", c-define, [⊢])
#let notation = _env("Notation", c-define, [§])

// Keepsakes: a formula to have to hand, a takeaway worth memorising.
#let formula = _env("Formula", c-formula, [∮])
#let key = _env("Key idea", c-formula, [✦], d-counted: false)

// A concrete instance.
#let example = _env("Example", c-illus, [▶])

// Our own work. Solutions and proofs are read linearly and at length, so
// they are never numbered — they belong to the thing above them.
#let solution = _env("Solution", c-argue, [✓], d-counted: false)
#let intuition = _env("Intuition", c-argue, [❋], d-counted: false)
// Hand-written rather than an `_env`, because it closes itself with a
// tombstone; it takes the same overrides as the rest.
#let proof(
  title: none,
  kind: "Proof",
  glyph: [∴],
  hue: c-argue,
  counted: false,
  body,
) = callout(
  kind,
  [#body #h(1fr) $qed$],
  hue: hue,
  glyph: glyph,
  title: title,
  counted: counted,
)

// Prompts. Kept off the result colour so a question never reads as a
// theorem.
#let question = _env("Question", c-prompt, [?], d-counted: false)
#let exercise = _env("Exercise", c-prompt, [✎])

// Asides and scaffolding: present but recessive, and never numbered.
#let remark = _env("Remark", c-aside, [※], d-counted: false)
#let aside = _env("Aside", c-aside, [˥], d-counted: false)
#let observation = _env("Observation", c-aside, [⊙], d-counted: false)
#let case = _env("Case", c-aside, [⊳], d-counted: false)

// Not established — amber and a questioned equals, rather than the crimson
// and confident star of a proved result.
#let conjecture = _env("Conjecture", c-unsure, [≟])
#let warning = _env("Warning", c-alert, [⚠], d-counted: false)
#let important = _env("Important", c-alert, [!], d-counted: false)

// ---- 4.2 short aliases --------------------------------------------------
// The long names read better in prose-heavy notes; these read better when
// the page is mostly boxes.
#let thm = theorem
// #let prop = proposition
#let lem = lemma
#let cor = corollary
#let defn = definition
#let def = definition
#let exm = example
#let soln = solution
#let pf = proof
#let ques = question
#let conj = conjecture
#let warn = warning
#let imp = important

// ---- 4.3 unnumbered labelled boxes --------------------------------------
// For commentary that wants a name rather than a number. The marker is the
// rotated square the lists use, so these read as a quieter family than the
// glyph-led boxes above.

#let sqmark(col) = box(baseline: 0.4pt, rotate(45deg, rect(
  width: 4.2pt,
  height: 4.2pt,
  radius: 1.4pt,
  fill: col,
)))

#let notebox(label, body, hue: accent, breakable: false) = block(
  width: 100%,
  breakable: breakable,
  inset: (x: 12pt, y: 10pt),
  radius: 6pt,
  fill: hue.transparentize(90%),
  stroke: 0.6pt + hue.transparentize(60%),
  above: 1.15em,
  below: 1.15em,
)[
  #show math.equation.where(block: true): set block(above: 0.85em, below: 0.85em)
  #sqmark(hue)#h(0.42em)#eyebrow(label, col: hue)#h(0.6em)#body
]

#let pitfall(body) = notebox("Common pitfall", body, hue: c-solve)
#let idea(body) = notebox("Why it works", body, hue: c-decomp)
#let recall(body) = notebox("From the notes", body, hue: c-decomp)

// A legend row: the callout look with a label in place of the numbered
// head, for the colour key in a preface.
#let legend(kind, hue, glyph, desc) = block(
  width: 100%,
  fill: hue.lighten(90%),
  stroke: 0.6pt + hue.transparentize(55%),
  inset: (x: 10pt, y: 8pt),
  radius: 3pt,
  above: 0.45em,
  below: 0.45em,
  grid(
    columns: (1.15em, 1fr),
    column-gutter: 8pt,
    align: (center + top, left + top),
    text(fill: hue.darken(30%), size: 1.15em, glyph), [#text(weight: "bold", fill: hue.darken(30%), kind) #desc],
  ),
)

// =========================================================================
//  5. MATH SHORTHANDS
// =========================================================================

#let RR = math.bb("R")
#let NN = math.bb("N")
#let ZZ = math.bb("Z")
#let QQ = math.bb("Q")
#let CC = math.bb("C")
#let FF = math.bb("F")
#let PP = math.bb("P")
#let EE = math.bb("E")
#let HH = math.bb("H")
#let KK = math.bb("K")
#let eps = math.epsilon

// Delimited forms. `lr` keeps the fences the height of what they enclose.
#let ip(a, b) = $lr(chevron.l #a, #b chevron.r)$
#let coord(x, y) = $lr(chevron.l #x, #y chevron.r)$
#let norm(x) = $lr(bar.v.double #x bar.v.double)$
#let abs(x) = $lr(bar.v #x bar.v)$
#let card(x) = $lr(bar.v #x bar.v)$
// Set-builder: `#setb($x in RR$, $x > 0$)` -> { x in RR : x > 0 }
#let setb(x, cond) = $lr({ #x : #cond })$
// Restriction and evaluation bars: `#restr($f$, $A$)`, `#evalat($F(x)$, $a$, $b$)`
#let restr(f, a) = $lr(#f bar.v)_#a$
#let evalat(x, a, b) = $lr(#x bar.v)_#a^#b$
// Derivatives: `#dv($y$, $x$)` -> dy/dx, `#pdv($f$, $x$)` -> ∂f/∂x
#let dv(f, x) = $(dif #f) / (dif #x)$
#let pdv(f, x) = $(partial #f) / (partial #x)$
// Bracketed vectors and matrices, the convention linear algebra reads in.
#let vv(..a) = math.vec(delim: "[", ..a)
#let mm(..a) = math.mat(delim: "[", ..a)
#let dt = $dot.op$

// Operators Typst does not ship. `det`, `dim`, `ker`, `tr`, `im`, `id`,
// `hom`, `Pr`, `gcd`, `lcm`, `min`, `max`, `inf`, `sup`, `lim` already
// exist — do not redefine those.
#let rank = math.op("rank")
#let span = math.op("span")
#let Span = math.op("Span")
#let Nul = math.op("Nul")
#let Col = math.op("Col")
#let Row = math.op("Row")
#let sgn = math.op("sgn")
#let diag = math.op("diag")
#let adj = math.op("adj")
#let nullity = math.op("nullity")
#let proj = math.op("proj")
#let comp = math.op("comp")
#let argmin = math.op("argmin", limits: true)
#let argmax = math.op("argmax", limits: true)
#let grad = math.op("grad")
#let curl = math.op("curl")
#let divg = math.op("div")
#let st = math.op("s.t.")
#let Aut = math.op("Aut")
#let End = math.op("End")
#let Hom = math.op("Hom")
#let GL = math.op("GL")
#let SL = math.op("SL")

// =========================================================================
//  6. FIGURES
// =========================================================================
// Everything here draws into a fixed-size block whose coordinates are plain
// numbers measured in points, x rightward and y downward from the top-left
// corner. This keeps figures native Typst: no external packages, no image
// files, and they scale and re-colour with the rest of the document.

#let c-fig = c-core
#let c-fig2 = c-ops

// The drawing surface. `w` and `h` are numbers, in points.
#let fcanvas(w, h, body) = align(center, block(
  width: w * 1pt,
  height: h * 1pt,
  inset: 10pt,
  body,
))

// A captioned frame that steps the figure counter.
#let figframe(cap, body) = block(
  width: 100%,
  breakable: false,
  above: 1.3em,
  below: 1.3em,
)[
  #_fig-counter.step()
  #body
  #v(0.45em)
  #align(center, block(width: 86%)[
    #set par(justify: false, leading: 0.52em)
    #set align(center)
    #context {
      let ch = counter(heading).get()
      let c = if ch.len() > 0 { ch.first() } else { 0 }
      let n = _fig-counter.get().first()
      eyebrow(if c > 0 {
        [Figure #numbering(_chap-fmt.get() + ".1", c, n)]
      } else { [Figure #n] })
    }
    #h(0.55em)#text(font: font-sans, size: 8.2pt, fill: muted, cap)
  ])
]

// A filled polygon given in canvas coordinates.
#let fpoly(pts, fill: none, stroke: none) = {
  let mx = calc.min(..pts.map(q => q.at(0)))
  let my = calc.min(..pts.map(q => q.at(1)))
  place(dx: mx * 1pt, dy: my * 1pt, polygon(
    fill: fill,
    stroke: stroke,
    ..pts.map(q => ((q.at(0) - mx) * 1pt, (q.at(1) - my) * 1pt)),
  ))
}

#let fseg(p, q, col: ink, th: 0.7pt, dash: none) = place(line(
  start: (p.at(0) * 1pt, p.at(1) * 1pt),
  end: (q.at(0) * 1pt, q.at(1) * 1pt),
  stroke: (paint: col, thickness: th, dash: dash),
))

// Solid arrowhead with its tip at (x, y), pointing along the angle a.
#let fhead(x, y, a, col: ink, s: 7.0) = {
  let bx = x - s * calc.cos(a)
  let by = y - s * calc.sin(a)
  let px = -calc.sin(a) * s * 0.34
  let py = calc.cos(a) * s * 0.34
  fpoly(((x, y), (bx + px, by + py), (bx - px, by - py)), fill: col)
}

// Arrow from p to q.
#let fvec(p, q, col: ink, th: 0.9pt, s: 7.0) = {
  let a = calc.atan2(q.at(0) - p.at(0), q.at(1) - p.at(1))
  fseg(p, (q.at(0) - 0.8 * s * calc.cos(a), q.at(1) - 0.8 * s * calc.sin(a)), col: col, th: th)
  fhead(q.at(0), q.at(1), a, col: col, s: s)
}

#let fdot(p, col: c-fig, r: 2.1) = place(
  dx: (p.at(0) - r) * 1pt,
  dy: (p.at(1) - r) * 1pt,
  circle(radius: r * 1pt, fill: col, stroke: none),
)

// Label centred on the point p.
#let flab(p, body, col: ink, sz: 9.5pt) = place(
  dx: p.at(0) * 1pt,
  dy: p.at(1) * 1pt,
  box(width: 0pt, height: 0pt, align(center + horizon, box(text(size: sz, fill: col, body)))),
)

// Right-angle tick at the corner c, along the unit directions d1 and d2.
#let frt(c, d1, d2, col: muted, r: 8.5) = {
  let p1 = (c.at(0) + r * d1.at(0), c.at(1) + r * d1.at(1))
  let p3 = (c.at(0) + r * d2.at(0), c.at(1) + r * d2.at(1))
  let p2 = (p1.at(0) + r * d2.at(0), p1.at(1) + r * d2.at(1))
  fseg(p1, p2, col: col, th: 0.6pt)
  fseg(p2, p3, col: col, th: 0.6pt)
}

// ---- function plots -----------------------------------------------------
// Each segment is a dictionary `(fn: x => y, from: a, to: b, paint: …,
// dash: …)`; it is sampled, clipped to the y-window, and drawn as one
// polyline.
#let plot(
  segments,
  xlim: (0, 5),
  ylim: (-1, 2),
  width: 10.5cm,
  height: 4.4cm,
  xticks: (),
  yticks: (),
  xlabel: none,
  ylabel: none,
  marks: (),
  samples: 200,
) = align(center, block(above: 1.1em, below: 1.1em, breakable: false, {
  let (x0, x1) = xlim
  let (y0, y1) = ylim
  let X = v => (v - x0) / (x1 - x0) * width
  let Y = v => height - (v - y0) / (y1 - y0) * height
  let tick = text.with(font: font-sans, size: 6.5pt, fill: muted)
  block(width: width, height: height, inset: 0pt, breakable: false, {
    if y0 <= 0 and 0 <= y1 {
      place(dy: Y(0), line(length: width, stroke: 0.5pt + muted))
    }
    if x0 <= 0 and 0 <= x1 {
      place(dx: X(0), line(angle: 90deg, length: height, stroke: 0.5pt + muted))
    }
    for t in xticks {
      place(dx: X(t), dy: Y(0), line(angle: 90deg, length: 3pt, stroke: 0.5pt + muted))
      place(dx: X(t) - 8pt, dy: Y(0) + 4.5pt, box(width: 16pt, align(center, tick[#t])))
    }
    for t in yticks {
      place(dx: X(0), dy: Y(t), line(length: 3pt, stroke: 0.5pt + muted))
      place(dx: X(0) - 15pt, dy: Y(t) - 4pt, box(width: 12pt, align(right, tick[#t])))
    }
    for seg in segments {
      let a = seg.at("from", default: x0)
      let b = seg.at("to", default: x1)
      let f = seg.fn
      let pts = range(0, samples + 1).map(i => {
        let x = a + (b - a) * i / samples
        (X(x), Y(calc.max(y0, calc.min(y1, f(x)))))
      })
      place(curve(
        stroke: (
          paint: seg.at("paint", default: c-core),
          thickness: 1pt,
          dash: seg.at("dash", default: none),
        ),
        curve.move(pts.first()),
        ..pts.slice(1).map(p => curve.line(p)),
      ))
    }
    for m in marks {
      let paint = m.at("paint", default: c-core)
      place(dx: X(m.x) - 1.7pt, dy: Y(m.y) - 1.7pt, circle(
        radius: 1.7pt,
        fill: if m.at("open", default: false) { white } else { paint },
        stroke: 0.7pt + paint,
      ))
    }
    // Axis labels sit above the x-axis and right of the y-axis, on the side
    // the tick labels do not use — a label level with the ticks lands on top
    // of whichever one is nearest the end of the axis.
    if xlabel != none { place(dx: width - 9pt, dy: Y(0) - 13pt, tick[#xlabel]) }
    if ylabel != none { place(dx: X(0) + 6pt, dy: -2pt, tick[#ylabel]) }
  })
}))

// =========================================================================
//  7. STRUCTURE HELPERS
// =========================================================================

// A contents page with mono numerals in the accent colour. Chapters are
// bold and spaced; sections hang under them in the soft ink.
#let contents(depth: 2, title: none, indent: 1.1em) = {
  // The entries are links, so the global link colour has to be undone here:
  // a contents page in solid accent blue is unreadable as a list.
  show link: set text(fill: ink)
  show outline.entry.where(level: 1): it => {
    v(0.85em, weak: true)
    link(it.element.location(), strong(it.indented(
      text(font: font-mono, size: 0.72em, fill: accent, it.prefix()),
      text(fill: ink, it.inner()),
    )))
  }
  show outline.entry.where(level: 2): it => link(
    it.element.location(),
    it.indented(
      text(font: font-mono, size: 0.72em, fill: muted, it.prefix()),
      text(fill: ink-soft, it.inner()),
    ),
  )
  outline(title: title, depth: depth, indent: indent)
}

// `#problem(1)[...]`, or `#problem(2, title: "Cauchy sequences", newpage: true)[...]`.
// Renders an unnumbered level-1 heading, so it still lands in the outline
// and still resets the environment counter.
#let problem(n, title: none, newpage: false, body) = {
  if newpage { pagebreak(weak: true) }
  heading(level: 1, numbering: none)[
    Problem #n#if title != none [: #title]
  ]
  body
}

// Everything after `#show: appendix` is lettered: "Appendix A", section
// A.2, and the boxes inside it number as A.3 rather than 11.3.
#let appendix(body) = {
  counter(heading).update(0)
  _in-appendix.update(true)
  _chap-fmt.update("A")
  set heading(numbering: (..n) => {
    let v = n.pos()
    if v.len() == 1 { numbering("A", v.first()) } else { numbering("A.1", ..v) }
  })
  body
}

// =========================================================================
//  8. THE DOCUMENT SHELLS
// =========================================================================
// `_shell` holds every setting the four shells share; the shells themselves
// are thin wrappers that pick different defaults. Any named argument of
// `_shell` can be passed straight through to any of them.

#let _shell(
  title: none,
  subtitle: none,
  author: none,
  course: none,
  date: none,
  blurb: none,
  // a paragraph under the title, on a title page
  abstract: none,
  // a paper's abstract
  paper-size: "us-letter",
  margin: auto,
  font: font-serif,
  size: 11pt,
  page-fill: white,
  justify: true,
  numbered: true,
  // show numbers on the environment boxes
  eq-numbering: "section",
  // "section" | "flat" | none | a pattern
  head-numbering: "1.1",
  cover: "banner",
  // "banner" | "center" | "page" | none, or your own
  // function / content — see the README
  cover-rule: "gradient",
  // "gradient" | "hairline" | none
  toc: false,
  chapters: false,
  // level-1 headings open a page, book-style
  body,
) = {
  _env-numbered.update(numbered)

  set document(title: if title == none { "" } else { title }, author: if author == none { () } else { author })
  set page(
    paper: paper-size,
    margin: if margin != auto { margin }
    else if chapters { (x: 1.15in, top: 1in, bottom: 1.1in) }
    else { (x: 1in, y: 1in) },
    fill: page-fill,
    numbering: "1",
    number-align: center,
  )
  set text(font: font, size: size, fill: ink, lang: "en")
  set par(justify: justify, leading: 0.66em, spacing: 1.05em)

  // Rotated square bullets in the accent colour, rather than discs.
  set list(marker: box(inset: (top: 0.18em), sqmark(accent)), indent: 0.6em, spacing: 0.7em)
  set enum(indent: 0.6em, spacing: 0.7em)

  // ---- maths ----
  // Equations numbered by section restart at each chapter; "flat" counts
  // straight through the document.
  set math.equation(numbering: if eq-numbering == "section" {
    n => context {
      let ch = counter(heading).get()
      let c = if ch.len() > 0 { ch.first() } else { 0 }
      if c > 0 { numbering("(" + _chap-fmt.get() + ".1)", c, n) }
      else { numbering("(1)", n) }
    }
  } else if eq-numbering == "flat" { "(1)" } else { eq-numbering })
  show math.equation.where(block: true): set block(above: 1.2em, below: 1.2em)
  // ∃ and ∀ crowd whatever follows them.
  show math.equation: it => {
    show sym.exists: e => e + h(0.17em)
    show sym.forall: f => f + h(0.17em)
    it
  }

  // ---- links, code, quotes ----
  show link: set text(fill: accent)
  show raw: set text(font: font-mono, size: 0.86em, fill: code-ink)
  show raw.where(block: false): box.with(
    fill: code-bg,
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )
  show raw.where(block: true): block.with(
    fill: code-bg,
    inset: 9pt,
    radius: 3pt,
    width: 100%,
  )
  show quote.where(block: true): it => block(
    stroke: (left: 2.5pt + accent),
    inset: (left: 12pt, y: 3pt),
    above: 1.1em,
    below: 1.1em,
    text(fill: ink-soft, it.body),
  )

  // ---- tables ----
  // Borderless: a rule under the header, hairlines between rows, no
  // verticals and no fills. Headers take the eyebrow.
  set table(
    stroke: (x, y) => (
      top: if y == 0 { none } else if y == 1 { 0.7pt + rule-line }
      else { 0.4pt + rule-soft },
      bottom: none,
      left: none,
      right: none,
    ),
    inset: (x: 7pt, y: 6pt),
    align: left + top,
    fill: none,
  )
  // `upper(it)` rather than `upper(it.body)`: returning the cell's body
  // alone would drop the cell itself, and with it the inset that keeps the
  // header labels from running into one another.
  show table.cell: it => if it.y == 0 {
    set text(font: font-sans, size: 7.5pt, weight: 600, fill: muted, tracking: 0.06em)
    upper(it)
  } else {
    text(size: 0.88em, fill: ink-soft, it)
  }
  set figure.caption(separator: [ #h(0.2em) ])
  show figure.caption: it => text(font: font-sans, size: 8.2pt, fill: muted, it)

  // ---- headings ----
  set heading(numbering: head-numbering)

  show heading.where(level: 1): it => {
    _env-counter.update(0)
    _fig-counter.update(0)
    _sec-in-chap.update(0)
    if chapters {
      // A chapter opener: a mono numeral, the title at display size, and
      // the gradient rule under it.
      let is-numbered = it.numbering != none
      if is-numbered { pagebreak(weak: true) }
      block(above: 0pt, below: 1.4em, {
        if is-numbered {
          context {
            if _in-appendix.get() { eyebrow[Appendix] } else { eyebrow[Chapter] }
          }
        }
        hrule(above: if is-numbered { 0.6em } else { 0pt }, below: 0.8em)
        set text(size: 25pt, weight: 600, fill: ink, tracking: -0.02em)
        set par(justify: false, leading: 0.26em)
        if is-numbered {
          context {
            let n = counter(heading).get().first()
            let fmt = _chap-fmt.get()
            hnum(if fmt == "1" and n < 10 { "0" + str(n) } else { numbering(fmt, n) }, size: 0.42em)
          }
        }
        it.body
      })
    } else {
      block(above: 1.5em, below: 0.8em, {
        set text(size: 15.5pt, weight: 600, fill: ink, tracking: -0.015em)
        set par(justify: false, leading: 0.3em)
        if it.numbering != none {
          hnum(context counter(heading).display(it.numbering))
        }
        it.body
      })
    }
  }

  // Sections sit under a hairline — except the first of a chapter, which
  // already sits under the opener rule.
  show heading.where(level: 2): it => block(above: 1.6em, below: 0.65em, width: 100%, {
    _sec-in-chap.step()
    context {
      if not chapters or _sec-in-chap.get().first() > 1 {
        v(0.6em, weak: true)
        line(length: 100%, stroke: 0.5pt + rule-soft)
        v(0.75em, weak: true)
      }
    }
    set text(size: 13pt, weight: 600, fill: ink, tracking: -0.015em)
    set par(justify: false, leading: 0.3em)
    if it.numbering != none {
      hnum(context counter(heading).display(it.numbering))
    }
    it.body
  })

  show heading.where(level: 3): it => block(above: 1.4em, below: 0.5em, {
    set text(size: 11.2pt, weight: 600, fill: ink, tracking: -0.01em)
    if it.numbering != none {
      hnum(context counter(heading).display(it.numbering), size: 0.72em)
    }
    it.body
  })

  // Levels 4 and 5 become sans-serif uppercase eyebrows in the muted ink.
  show heading.where(level: 4): it => block(
    above: 1.3em,
    below: 0.45em,
    eyebrow(it.body, size: 8.5pt),
  )
  show heading.where(level: 5): it => block(
    above: 1.2em,
    below: 0.4em,
    eyebrow(it.body, size: 8pt),
  )

  // ---- cover ----
  // One bar, three ways: the five-accent gradient (the default, and what the
  // chapter openers carry), a quiet grey hairline, or nothing but the space
  // the bar would have taken.
  let cover-bar(w: 100%, above: 1.2em, below: 1.2em) = if cover-rule == "gradient" {
    hrule(w: w, above: above, below: below)
  } else if cover-rule == "hairline" {
    v(above)
    line(length: w, stroke: 0.5pt + rule-line)
    v(below)
  } else {
    v(above + below)
  }

  if type(cover) == function {
    // A masthead of your own. It is handed everything the built-in ones are
    // given, plus `rule` — the bar `cover-rule` selects, ready to place — so
    // a custom cover still sits in the same design language. It is content
    // rather than a function because Typst will not call a dictionary key
    // directly; reach for `hrule` if you want other spacing.
    cover((
      title: title,
      subtitle: subtitle,
      author: author,
      course: course,
      date: date,
      blurb: blurb,
      abstract: abstract,
      rule: cover-bar(above: 0.8em, below: 1em),
    ))
  } else if type(cover) == content {
    // Already-built content: used as it stands.
    cover
  } else if cover == "page" {
    // A full title page, on its own unnumbered sheet.
    page(numbering: none, margin: (x: 1.3in, y: 1.6in), {
      v(1.2fr)
      if course != none { eyebrow(course) }
      cover-bar(above: if course != none { 1.2em } else { 0pt }, below: 1.9em)
      block(width: 100%, {
        set par(justify: false, leading: 0.2em)
        text(size: 38pt, weight: 600, tracking: -0.8pt, fill: ink, title)
      })
      if subtitle != none {
        v(0.55em)
        text(size: 13pt, fill: ink-soft, subtitle)
      }
      if blurb != none {
        v(1.6em)
        block(width: 84%, {
          set text(size: 10pt, fill: ink-soft)
          set par(justify: false)
          blurb
        })
      }
      v(2fr)
      cover-bar(w: 34%, above: 0pt, below: 0.8em)
      if author != none { eyebrow(author) }
      if author != none and date != none { eyebrow[ · ] }
      if date != none { eyebrow(date) }
    })
  } else if cover == "center" {
    // A paper's title block: centred, with the abstract set narrow.
    block(width: 100%, above: 0pt, below: 0pt, {
      set align(center)
      set par(justify: false, leading: 0.3em)
      if course != none { eyebrow(course); v(0.5em) }
      text(size: 19pt, weight: 600, fill: ink, tracking: -0.015em, title)
      if subtitle != none {
        v(0.4em)
        text(size: 12pt, fill: ink-soft, subtitle)
      }
      if author != none {
        v(0.9em)
        text(size: 11pt, fill: ink, author)
      }
      if date != none {
        v(0.3em)
        text(size: 9.5pt, fill: muted, date)
      }
    })
    // Short and centred, so it reads as a title-block ornament rather than
    // as a section break.
    align(center, cover-bar(w: 26%, above: 1.3em, below: 1.3em))
    if abstract != none {
      align(center, block(width: 82%, {
        align(center, eyebrow[Abstract])
        v(0.5em)
        set text(size: 9.8pt, fill: ink-soft)
        set par(justify: true, leading: 0.6em)
        abstract
      }))
    }
    v(1.6em)
  } else if cover == "banner" {
    // A note's masthead: the title, then whichever of author, course and
    // date were given, on one line separated by middots. Filtering rather
    // than nesting `if`s is what keeps a document with only an author from
    // opening on a stray separator.
    block(width: 100%, above: 0pt, below: 0pt, {
      set par(justify: false, leading: 0.3em)
      text(size: 20pt, weight: 600, fill: ink, tracking: -0.015em, title)
      if subtitle != none {
        v(0.3em)
        text(size: 11.5pt, fill: ink-soft, subtitle)
      }
      let meta = (author, course, date).filter(part => part != none)
      if meta.len() > 0 {
        v(0.4em)
        text(size: 10pt, fill: muted, meta.join([#h(0.5em) · #h(0.5em)]))
      }
    })
    // The bar the book's title page and chapter openers carry, at the one
    // place a note has an opener.
    cover-bar(above: 0.8em, below: 1em)
  }

  // ---- contents ----
  if toc {
    if cover == "page" {
      page(numbering: none, {
        front-title[Contents]
        v(0.4em)
        contents()
      })
    } else {
      contents()
      v(0.8em)
    }
  }
  if cover == "page" { counter(page).update(1) }

  body
}

// ---- 8.1 notes ----------------------------------------------------------
// A lecture note or a reading note: masthead, numbered sections, equations
// numbered by section.
#let notes(..args, body) = _shell(
  ..((cover: "banner", chapters: false, numbered: true) + args.named()),
  body,
)

// ---- 8.2 homework -------------------------------------------------------
// A problem set. No equation numbers (nothing refers back to them), roomier
// enums, and one numbering scheme per heading depth — `1.`, then `(a)`,
// then `(i)` — each restarting under its parent. A flat "1.1" pattern
// repeats its last digit forever and turns a sub-case into "2.1.1.1".
//
// Pass `count-h1: true` to write `= Question` and have the counter supply
// the number, giving "Question 2" rather than "2. Question".
#let homework(..args, body) = {
  let named = args.named()
  let count-h1 = named.at("count-h1", default: false)
  let label = named.at("h1-label", default: none)
  let passed = named
  let _ = passed.remove("count-h1", default: none)
  let _ = passed.remove("h1-label", default: none)

  show: _shell.with(..((
    cover: "banner",
    chapters: false,
    numbered: false,
    eq-numbering: none,
    head-numbering: (..n) => {
      let v = n.pos()
      if v.len() == 1 { numbering("1.", v.last()) }
      else if v.len() == 2 { numbering("(a)", v.last()) }
      else if v.len() == 3 { numbering("(i)", v.last()) }
      else { none }
    },
  ) + passed))

  set enum(spacing: 1.2em)

  // Level 1 reads "Question 2", not "2. Question": the counter supplies the
  // number after the words. Re-states the level-1 styling, because what the
  // rule returns is a block and no longer a heading.
  show heading.where(level: 1): it => if count-h1 {
    _env-counter.update(0)
    block(above: 1.5em, below: 0.8em, {
      set text(size: 15.5pt, weight: 600, fill: ink, tracking: -0.015em)
      if label != none { label } else { it.body }
      if it.numbering != none {
        [ ]
        context counter(heading).display("1")
      }
    })
  } else { it }

  body
}

// ---- 8.3 paper ----------------------------------------------------------
// An essay, a report or a write-up: centred title block, an abstract if you
// want one, equations numbered straight through.
#let paper(..args, body) = _shell(
  ..((cover: "center", chapters: false, numbered: true, eq-numbering: "flat", justify: true) + args.named()),
  body,
)

// ---- 8.4 book -----------------------------------------------------------
// A bound volume: a title page, a contents page, and level-1 headings that
// open a new page under the gradient rule.
#let book(..args, body) = _shell(
  ..((cover: "page", chapters: true, toc: true, numbered: true, eq-numbering: "section") + args.named()),
  body,
)
