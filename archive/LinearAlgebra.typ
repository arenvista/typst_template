// ============================================================================
//  MATH 221 — Linear Algebra
// ============================================================================

#set document(title: "MATH 221: A Linear Algebra Review", author: "MATH 221")

// --- Palette -----------------------------------------------------------------
//  Ported from ~/Documents/School/2026-Fall/.obsidian/snippets/linalg.css.

#let linGround   = rgb("#f6f8fb")   // --lin-ground   : the note's ground
#let linSurface  = rgb("#ffffff")   // --lin-surface
#let linSurface2 = rgb("#eef2f7")   // --lin-surface-2
#let ink         = rgb("#16202e")   // --lin-ink
#let inkSoft     = rgb("#3f4b5b")   // --lin-ink-soft
#let muted       = rgb("#6b7684")   // --lin-muted
#let linLine     = rgb("#dbe2ea")   // --lin-line
#let linLineSoft = rgb("#e8edf3")   // --lin-line-soft
#let linChip     = rgb("#f0f3f7")   // --lin-chip-bg

// The five semantic accents. The environment boxes keep the hues the front
// matter's colour key promises, each mapped onto the accent nearest it.
#let cDefn = rgb("#1a5fb4")   // --lin-core    (blue)   definitions
#let cThm  = rgb("#6c5b00")   // --lin-iter    (olive)  theorems
#let cEx   = rgb("#2e7d32")   // --lin-ops     (green)  examples
#let cWarn = rgb("#a51d2d")   // --lin-solve   (red)    pitfalls
#let cNote = rgb("#613583")   // --lin-decomp  (purple) commentary
#let accent = cDefn           // --lin-accent = var(--lin-core)

// --- Type stacks -------------------------------------------------------------
//  --lin-serif is Iowan Old Style / Charter / Palatino / Georgia / Cambria,
//  none of which is installed here; Libertinus Serif is the substitution and
//  is the closest book serif available. The sans and mono stacks resolve to
//  real members of the CSS lists.
#let fSerif = ("Libertinus Serif", "DejaVu Serif")
#let fSans  = ("Liberation Sans", "DejaVu Sans")
#let fMono  = ("JetBrainsMono NF", "DejaVu Sans Mono")

#set page(
  paper: "us-letter",
  // --file-line-width: 780px against an 18px body is a 43.3-character-em
  // measure; 1.09in margins reproduce it at this type size.
  margin: (x: 1.09in, y: 1.1in),
  fill: linGround,
  numbering: "1",
  number-align: center,
)

#set text(font: fSerif, size: 10.5pt, fill: ink, lang: "en")

// --line-height-normal: 1.62 / --p-spacing: 1.05em
#set par(justify: true, leading: 0.62em, spacing: 1.05em)
#set heading(numbering: "1.1")
#show link: set text(fill: accent)

// Rotated square bullets: --list-bullet-size 6px, --list-bullet-radius 2px,
// --list-marker-color var(--lin-accent), turned 45 degrees.
#set list(marker: box(inset: (top: 0.18em))[
  #rotate(45deg, rect(width: 4.2pt, height: 4.2pt, radius: 1.4pt, fill: accent))
])
// The theme specifies nothing for ordered lists; this carries the mono/accent
// numeral of the [OPT-NUM] heading marker over to them. Flat by design --
// nothing in this document nests an enum.
#set enum(numbering: n => text(fill: accent, font: fMono, size: 0.8em)[#n.])

// math.css: display blocks sit 1.5em off the surrounding prose.
#show math.equation.where(block: true): set block(above: 1.5em, below: 1.5em)

// The `---` rule: a 2px bar carrying the five accents left to right at 0.85
// opacity. It is the loudest thing in the design language, so it is reserved
// for chapter openers and the title page.
#let hrule(w: 100%) = block(width: w, height: 1.5pt, radius: 1.5pt, fill:
  gradient.linear(
    cDefn.transparentize(15%), cEx.transparentize(15%),
    cNote.transparentize(15%), cWarn.transparentize(15%),
    cThm.transparentize(15%)))

// h4-h6: sans, uppercase, 0.08em tracking, --lin-muted.
#let eyebrow(body, col: muted) = text(
  font: fSans, size: 7.6pt, weight: "bold", tracking: 0.08em, fill: col,
  upper(body))

// The counter marker the [OPT-NUM] block puts before a numbered heading:
// mono, 0.66em, weight 500, --lin-accent, 0.7em of air after it.
#let hnum(body, size: 0.66em) = {
  text(font: fMono, size: size, weight: "medium", fill: accent, tracking: 0pt,
       body)
  h(0.7em)
}

// --- Heading styling ---------------------------------------------------------
#let boxcount = counter("boxcount")
#let figcount = counter("figcount")
#let appendix = state("appendix", false)

#show heading.where(level: 1): it => {
  boxcount.update(0)
  figcount.update(0)
  let numbered = it.numbering != none
  if numbered { pagebreak(weak: true) }
  block(above: 0.4em, below: 1.25em)[
    #if numbered [
      #context {
        if appendix.get() [#eyebrow[Appendix]] else [#eyebrow[Chapter]]
      }
      #v(0.35em)
    ]
    #hrule()
    #v(0.55em)
    #block(width: 100%)[
      #set text(size: 28pt, fill: ink, weight: 600, tracking: -0.56pt)
      #set par(leading: 0.18em, justify: false)
      #if numbered {
        context {
          let n = counter(heading).get().first()
          hnum(if appendix.get() { numbering("A", n) }
               else { numbering("01", n) })
        }
      }
      #it.body
    ]
  ]
}

// h2 --- 1.7rem, weight 600, -0.015em tracking, sitting under a hairline.
#show heading.where(level: 2): it => block(above: 1.95em, below: 0.7em, width: 100%)[
  #line(length: 100%, stroke: 0.5pt + linLineSoft)
  #v(0.95em)
  #set text(size: 15.9pt, fill: ink, weight: 600, tracking: -0.24pt)
  #set par(leading: 0.3em, justify: false)
  #hnum(counter(heading).display())#it.body
]

// h3 --- 1.16rem, weight 600, -0.01em tracking, 2.2rem of lead.
#show heading.where(level: 3): it => block(above: 1.95em, below: 0.6em)[
  #set text(size: 10.9pt, fill: ink, weight: 600, tracking: -0.11pt)
  #it.body
]

// --- Environment boxes -------------------------------------------------------
#let envnum() = context {
  let ch = counter(heading).get()
  let c = if ch.len() > 0 { ch.first() } else { 0 }
  [#c.#boxcount.display()]
}

#let calloutmark(col) = box(baseline: 0.4pt,
  rotate(45deg, rect(width: 4.2pt, height: 4.2pt, radius: 1.4pt, fill: col)))

#let calloutbox(col, head, body, breakable: true) = block(
  width: 100%,
  breakable: breakable,
  inset: (left: 12pt, right: 12pt, top: 10pt, bottom: 10pt),
  radius: 6pt,
  fill: col.transparentize(90%),
  stroke: 0.6pt + col.transparentize(60%),
  above: 1.15em, below: 1.15em,
)[
  #show math.equation.where(block: true): set block(above: 0.85em, below: 0.85em)
  #head#body
]

#let env(kind, col, title, body) = {
  boxcount.step()
  calloutbox(col, [
    #calloutmark(col)#h(0.42em)#text(fill: col, weight: "bold")[#kind #envnum()]#if title != none [#text(fill: col, weight: "bold")[ (#title)]]#text(fill: col, weight: "bold")[.]
    #h(0.4em)
  ], body)
}

#let defn(title: none, body)  = env("Definition", cDefn, title, body)
#let thm(title: none, body)   = env("Theorem",    cThm,  title, body)
#let exm(title: none, body)   = env("Example",    cEx,   title, body)

#let aside(col, label, body) = calloutbox(col, [
  #calloutmark(col)#h(0.42em)#eyebrow(label, col: col)#h(0.6em)
], body, breakable: false)

#let pitfall(body) = aside(cWarn, "Common pitfall", body)
#let idea(body)    = aside(cNote, "Why it works",   body)
#let recall(body)  = aside(cNote, "From the notes", body)

// --- Tables ------------------------------------------------------------------
// No verticals, no fills: 1px --lin-line under the header row and 1px
// --lin-line-soft under every body row. Cells are sans, top-aligned, flush
// left, with 14px of gutter on the right. Headers take the h4 eyebrow.
#set table(
  stroke: (x, y) => (
    bottom: if y == 0 { 0.7pt + linLine } else { 0.4pt + linLineSoft },
  ),
  inset: (left: 0pt, right: 11pt, top: 6.5pt, bottom: 6.5pt),
  align: left + top,
)
#show table: set text(font: fSans, size: 9.2pt, fill: inkSoft)
#show table.cell.where(y: 0): it => text(
  font: fSans, size: 7.4pt, weight: 600, tracking: 0.06em, fill: muted,
  upper(it))

// --- Math shorthands ---------------------------------------------------------
#let RR = $bb(R)$
#let vv(..a) = math.vec(delim: "[", ..a)
#let mm(..a) = math.mat(delim: "[", ..a)
#let Span = math.op("Span")
#let Nul  = math.op("Nul")
#let Col  = math.op("Col")
#let Row  = math.op("Row")
#let rank = math.op("rank")
#let proj = math.op("proj")
#let comp = math.op("comp")
#let dm   = math.op("dim")
#let tr   = math.op("tr")

#let dt = $dot.op$

// --- Figure primitives -------------------------------------------------------
// Everything below draws into a fixed-size block whose coordinates are plain
// numbers measured in points, x rightward and y downward from the top-left
// corner. This keeps the figures native Typst: no external packages, no image
// files, and they scale and re-colour with the rest of the document.

#let cFig  = cDefn    // --lin-core
#let cFig2 = cEx      // --lin-ops

#let fcanvas(w, h, body) = align(center, block(
  width: w * 1pt, height: h * 1pt,
  inset: 10pt, radius: 8pt, fill: none, stroke: none,
  body))

#let fignum() = context {
  let ch = counter(heading).get()
  let c = if ch.len() > 0 { ch.first() } else { 0 }
  [#c.#figcount.display()]
}

#let figframe(cap, body) = block(
  width: 100%, breakable: false, above: 1.3em, below: 1.3em,
)[
  #figcount.step()
  #body
  #v(0.45em)
  #align(center, block(width: 86%)[
    #set par(justify: false, leading: 0.52em)
    #set align(center)
    #eyebrow[Figure #fignum()]#h(0.55em)#text(font: fSans, size: 8.2pt,
      fill: muted, cap)
  ])
]

// A filled polygon given in canvas coordinates.
#let fpoly(pts, fill: none, stroke: none) = {
  let mx = calc.min(..pts.map(q => q.at(0)))
  let my = calc.min(..pts.map(q => q.at(1)))
  place(dx: mx * 1pt, dy: my * 1pt, polygon(
    fill: fill, stroke: stroke,
    ..pts.map(q => ((q.at(0) - mx) * 1pt, (q.at(1) - my) * 1pt))))
}

#let fseg(p, q, col: ink, th: 0.7pt, dash: none) = place(line(
  start: (p.at(0) * 1pt, p.at(1) * 1pt),
  end:   (q.at(0) * 1pt, q.at(1) * 1pt),
  stroke: (paint: col, thickness: th, dash: dash)))

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
  fseg(p, (q.at(0) - 0.8 * s * calc.cos(a), q.at(1) - 0.8 * s * calc.sin(a)),
       col: col, th: th)
  fhead(q.at(0), q.at(1), a, col: col, s: s)
}

#let fdot(p, col: cFig, r: 2.1) = place(
  dx: (p.at(0) - r) * 1pt, dy: (p.at(1) - r) * 1pt,
  circle(radius: r * 1pt, fill: col, stroke: none))

// Label centred on the point p.
#let flab(p, body, col: ink, sz: 9.5pt) = place(
  dx: p.at(0) * 1pt, dy: p.at(1) * 1pt,
  box(width: 0pt, height: 0pt,
    align(center + horizon, box(text(size: sz, fill: col, body)))))

// Right-angle tick at the corner c, along the unit directions d1 and d2.
#let frt(c, d1, d2, col: muted, r: 8.5) = {
  let p1 = (c.at(0) + r * d1.at(0), c.at(1) + r * d1.at(1))
  let p3 = (c.at(0) + r * d2.at(0), c.at(1) + r * d2.at(1))
  let p2 = (p1.at(0) + r * d2.at(0), p1.at(1) + r * d2.at(1))
  fseg(p1, p2, col: col, th: 0.6pt)
  fseg(p2, p3, col: col, th: 0.6pt)
}

// --- Figure 1: Span{v} is a line through the origin in R^3 -------------------
// Drawn for the actual vector of the worked example, v = (4/3, 0, 1): one unit
// along x_1 is the foreshortened step (-26, 20), one unit along x_3 is
// (0, -56), so v lands up and to the left and the line it spans meets the
// horizontal at about 40 degrees -- well clear of the x_2 axis.
#let figSpanLine = figframe(
  [The solution set $Span{bold(v)}$ is the line through the origin in the
   direction of $bold(v)$. Every solution is a scalar multiple of $bold(v)$;
   the scalar is the free variable $x_3$.],
  fcanvas(336, 214)[
  #fvec((172, 120), (172, 24))            // x_3
  #fvec((172, 120), (283.8, 148))         // x_2
  #fvec((172, 120), (101.8, 174))         // x_1
  #fseg((104.3, 62.9), (218.8, 159.6), col: cFig, th: 1.2pt)
  #fvec((172, 120), (137.3, 90.7), th: 1.1pt)
  #flab((172, 13))[$x_3$]
  #flab((293, 157))[$x_2$]
  #flab((92, 185))[$x_1$]
  #flab((76, 57))[$Span{bold(v)}$]
  #flab((128, 103))[$bold(v)$]
  #flab((188, 110))[$bold(0)$]
])

// --- Figure 2: Span{u, v} is a plane through the origin ----------------------
#let figSpanPlane = figframe(
  [Two vectors that are not multiples of one another span a plane through the
   origin: the shaded sheet is the set of all $x_2 bold(u) + x_3 bold(v)$.],
  fcanvas(318, 226)[
  #fvec((60, 176), (60, 28))              // x_1
  #fvec((60, 176), (210, 202))            // x_2
  #fvec((60, 176), (215, 61))             // x_3, pokes out through the plane
  #fpoly(((60, 176), (210, 168), (290, 76), (140, 84)),
         fill: rgb(150, 190, 214, 95), stroke: 0.7pt + cFig)
  #fdot((166, 152.8))
  #fdot((132.6, 109))
  #flab((48, 24))[$x_1$]
  #flab((221, 199))[$x_2$]
  #flab((226, 53))[$x_3$]
  #flab((179, 155))[$bold(u)$]
  #flab((114, 98))[$bold(v)$]
])

// --- Figure 3: orthogonal projection onto a line -----------------------------
#let figProj = figframe(
  [$bold(y) = hat(bold(y)) + bold(z)$: the shadow $hat(bold(y))$ lies along
   $bold(u)$, and the error $bold(z)$ meets it at a right angle. The green dot
   is the tip of $hat(bold(y)) = proj_bold(u) bold(y)$.],
  fcanvas(310, 194)[
  #fvec((32, 150), (272, 157), th: 1.0pt)                 // u
  #fvec((32, 150), (236, 32), th: 1.0pt)                  // y
  #frt((232.4, 155.8), (-0.99958, -0.02915), (0.02915, -0.99958))
  #fvec((232.4, 155.8), (236, 32), col: cFig, th: 1.3pt)  // z
  #fdot((232.4, 155.8), col: cFig2, r: 2.4)
  #flab((124, 84))[$bold(y)$]
  #flab((152, 171))[$bold(u)$]
  #flab((252, 96), col: cFig)[$bold(z)$]
  #flab((203, 139), col: cFig2)[$hat(bold(y))$]
])

// ============================================================================
//  TITLE PAGE
// ============================================================================
#page(numbering: none, margin: (x: 1.3in, y: 1.6in))[
  #v(1.2fr)
  #eyebrow[MATH 221]
  #v(0.7em)
  #hrule()
  #v(1.1em)
  #block(width: 100%)[
    #set par(justify: false, leading: 0.2em)
    #text(size: 40pt, weight: 600, tracking: -0.8pt, fill: ink)[Linear Algebra]
  ]
  #v(0.55em)
  #text(size: 13pt, fill: inkSoft)[A Complete Course Review]
  #v(1.6em)
  #block(width: 84%)[
    #set text(size: 10pt, fill: inkSoft)
    #set par(justify: false)
    From the geometry of a pair of intersecting lines through to orthogonal
    projection and least squares --- assembled from a semester of notes and
    written out in full for a reader meeting the subject for the first time.
  ]
  #v(2fr)
  #hrule(w: 34%)
  #v(0.7em)
  #eyebrow[Spring 2025]
]

// ============================================================================
//  PREFACE
// ============================================================================

#page(numbering: none)[
  #v(1.1fr)
  #align(center)[
    #eyebrow[Preface]
    #v(0.85em)
    #hrule(w: 30%)
    #v(1.7em)
    #block(width: 84%)[
      #set text(size: 11pt, style: "italic", fill: inkSoft)
      #set par(justify: true, leading: 0.78em, spacing: 1.25em)
      #set align(left)
      In my eyes, mathematical maturity develops along two fronts: the growth
      of intuition and the cultivation of rigor.

      Intuition is the feeling for why things work --- when to reach for a
      particular technique, and how to view a problem from a broader vantage
      point. It is the ability to recognize patterns, and it is often what
      gives me a sense of direction when navigating the mathematical
      landscape.

      Rigor is the formalization of that thought: precise definitions,
      carefully constructed proofs, and the logical structure underpinning
      every argument. It is the discipline that keeps our conclusions valid
      and our reasoning sound. It is what assures us the direction we are
      heading is not a mirage, but a well-founded path.

      My goal with these notes is to bridge the two, and in doing so build a
      better understanding of how things actually work. For many of us, this
      course is the first real chance to see intuition and rigor operating in
      tandem. For me, it is what made me fall in love with mathematics in the
      first place.
    ]
    #v(1.6em)
    #hrule(w: 30%)
  ]
  #v(1.3fr)
]

// ============================================================================
//  HOW TO USE THIS BOOK
// ============================================================================



#page(numbering: none)[
  #heading(level: 1, numbering: none, outlined: false)[How to Use This Book]

  This is a review, but it is written to be read *cold*. Nothing is assumed
  beyond high-school algebra: every term is defined before it is used, and
  every result that gets used later is stated as a numbered theorem you can
  point back to.

  The subject has a single organizing question, and it is worth holding onto
  from the first page:

  #align(center)[
    #block(width: 88%, inset: 12pt, radius: 6pt,
      fill: accent.transparentize(90%), stroke: 0.6pt + accent.transparentize(60%))[
      #set par(justify: false)
      #align(center)[
        Given a matrix $A$ and a vector $bold(b)$, \
        *what are all the vectors $bold(x)$ with $A bold(x) = bold(b)$?*
      ]
    ]
  ]

  Chapters 1--3 answer that question computationally: elimination, echelon
  form, and the parametric description of a solution set. Chapters 4--7 answer
  it structurally --- the answer turns out to be a *subspace*, and subspaces
  have bases, dimensions, and coordinates. Chapters 8--9 measure what a matrix
  does to space (determinants) and find the directions it merely stretches
  (eigenvectors). Chapter 10 adds the one extra ingredient geometry needs ---
  the dot product --- and uses it to answer the question when it has *no*
  answer, by finding the closest thing to one.

  #v(0.6em)
  *The boxes.* Each one is tinted and outlined in the colour of its type, and
  carries the same rotated square as its marker. Blue boxes are definitions;
  you must know these verbatim. Olive boxes are theorems; you must know what
  they say and when they apply. Green boxes are worked examples. Red boxes
  flag the mistakes that actually get made. Purple boxes explain why something
  is true when the "why" is more useful than the proof.

  #v(0.6em)
  *A note on notation.* Vectors are columns. $RR^n$ means the set of all
  columns of $n$ real numbers. An $m times n$ matrix has $m$ rows and $n$
  columns --- in that order, always, and mixing them up is the single most
  common source of avoidable error in this course.

  #v(1.4em)
  #hrule()
  #v(1.2em)
  #eyebrow[Contents]
  #v(0.7em)
  #show outline.entry.where(level: 1): it => {
    v(0.85em, weak: true)
    // Chapters carry the leading zero their opener shows; the appendices
    // keep the "Appendix A" prefix their own numbering builds.
    let pre = if it.element.numbering == "1.1" {
      context numbering("01", ..counter(heading).at(it.element.location()))
    } else { it.prefix() }
    link(it.element.location(), strong(it.indented(
      text(font: fMono, size: 0.72em, fill: accent, pre),
      it.inner(),
    )))
  }
  #show outline.entry.where(level: 2): it => link(
    it.element.location(),
    text(fill: inkSoft, it.indented(
      text(font: fMono, size: 0.72em, fill: muted, it.prefix()),
      it.inner(),
    )))
  #outline(title: none, depth: 2, indent: 1.1em)
]

// ============================================================================
#counter(page).update(1)
= The Geometry of Linear Equations

Everything in this course grows out of one object, so it is worth being
painfully precise about what it is.

#defn(title: "Linear equation")[
  A #emph[linear equation] in the variables $x_1, dots, x_n$ is an equation
  that can be written in the form
  $ a_1 x_1 + a_2 x_2 + dots.c + a_n x_n = b, $
  where $b$ and the #emph[coefficients] $a_1, dots, a_n$ are real numbers.
  The variables appear only to the first power, never multiplied together,
  and never inside a function.
]

So $3x_1 - 5x_2 = 7$ is linear; $x_1 x_2 = 7$, $sqrt(x_1) = 7$, and
$sin(x_1) = 7$ are not.

#defn(title: "System, solution set, consistency")[
  A #emph[system of linear equations] is a finite collection of linear
  equations in the same variables. A #emph[solution] is a list
  $(s_1, dots, s_n)$ that makes every equation true at once; the
  #emph[solution set] is the set of all such lists. A system is
  #emph[consistent] if its solution set is nonempty, and #emph[inconsistent]
  otherwise. Two systems are #emph[equivalent] when they have the same
  solution set.
]

== Two pictures of the same system

Consider
$ x_1 + 2 x_2 &= 3 \ 3 x_1 - x_2 &= 2 $

*The row picture.* Read the system one equation at a time. Each equation
describes a line in the plane, and a solution is a point lying on both lines.
Here the lines cross once, at $(1, 1)$.

In three variables each equation is a *plane* in $RR^3$, and a solution is a
point common to all the planes. That already tells you what answers are
possible, and it is a theorem:

#thm(title: "Trichotomy for linear systems")[
  A system of linear equations has either
  #box[(i) no solution], #box[(ii) exactly one solution], or
  #box[(iii) infinitely many solutions].
  There is no such thing as a linear system with exactly two solutions.
]

#idea[
  Two distinct solutions $bold(u) != bold(v)$ force infinitely many. If
  $A bold(u) = bold(b)$ and $A bold(v) = bold(b)$, then for every scalar $t$
  the vector $bold(u) + t(bold(v) - bold(u))$ is also a solution --- the whole
  line through $bold(u)$ and $bold(v)$ solves the system. Two forces the
  entire line; the count jumps from $1$ straight to $infinity$.
]

*The column picture.* Now read the system one *column* at a time. Rewriting
it as a single vector equation,
$ x_1 vv(1, 3) + x_2 vv(2, -1) = vv(3, 2), $
turns the question inside out. We are no longer intersecting lines; we are
asking whether the target vector $vv(3,2)$ can be built by scaling and adding
the two column vectors. This is the more powerful picture, and most of the
course lives inside it.

== Matrices, vectors, and $A bold(x)$

#defn(title: "Matrix, coefficient matrix, augmented matrix")[
  An $m times n$ #emph[matrix] is a rectangular array with $m$ rows and $n$
  columns. For a system with coefficients $a_(i j)$ and right-hand sides
  $b_i$, the #emph[coefficient matrix] is $A = [a_(i j)]$ and the
  #emph[augmented matrix] is $[A #h(0.2em) bold(b)]$ --- the coefficient
  matrix with $bold(b)$ attached as one extra column.
]

#pitfall[
  $m times n$ is *rows $times$ columns*, in that order. A $4 times 6$ matrix
  is short and wide: it has $4$ rows and $6$ columns, so it sends vectors from
  $RR^6$ into $RR^4$. Getting this backwards silently breaks every dimension
  count later in the course.
]

#defn(title: "The product " + $A bold(x)$)[
  If $A$ has columns $bold(a)_1, dots, bold(a)_n$ and
  $bold(x) = (x_1, dots, x_n)$ is in $RR^n$, then
  $ A bold(x) = x_1 bold(a)_1 + x_2 bold(a)_2 + dots.c + x_n bold(a)_n. $
  That is: #emph[$A bold(x)$ is the linear combination of the columns of $A$
  with weights taken from $bold(x)$.] It is defined only when the number of
  columns of $A$ equals the number of entries of $bold(x)$, and the result
  lives in $RR^m$.
]

With this, a system, a vector equation, and a matrix equation are three
spellings of one thing:
$
"system" quad <==> quad x_1 bold(a)_1 + dots.c + x_n bold(a)_n = bold(b)
quad <==> quad A bold(x) = bold(b).
$

#thm(title: "Existence")[
  $A bold(x) = bold(b)$ is consistent if and only if $bold(b)$ is a linear
  combination of the columns of $A$.
]

That single sentence is the bridge between computation and structure. The rest
of Chapter 1--3 is machinery for deciding it; Chapters 4--7 are the theory of
the set of all $bold(b)$ for which it holds.

// ============================================================================
= Elimination with Matrices

Solving a system means replacing it, step by step, with an equivalent system
that is easier to read. The moves that are allowed are exactly the moves that
do not change the solution set.

#defn(title: "Elementary row operations")[
  #enum(
    [*Replacement.* Add a multiple of one row to another row.],
    [*Interchange.* Swap two rows.],
    [*Scaling.* Multiply a row by a nonzero constant.],
  )
  Two matrices are #emph[row equivalent], written $A tilde B$, if some
  sequence of these operations turns one into the other.
]

Each operation is reversible --- replacement undoes with the opposite
multiple, interchange with itself, scaling with the reciprocal --- which is
why they preserve the solution set.

#thm[
  If the augmented matrices of two systems are row equivalent, the systems
  have the same solution set.
]

== Echelon forms

#defn(title: "Echelon form, REF")[
  A matrix is in #emph[echelon form] when
  #enum(
    [every all-zero row is below every nonzero row;],
    [the leading entry of each nonzero row is strictly to the right of the
     leading entry of the row above it;],
    [all entries below a leading entry are zero.],
  )
  The leading entry of a nonzero row is called a #emph[pivot].
]

#defn(title: "Reduced echelon form, RREF")[
  A matrix is in #emph[reduced echelon form] if, in addition,
  #enum(
    [every pivot is $1$;],
    [each pivot $1$ is the *only* nonzero entry in its column.],
  )
]

#thm(title: "Uniqueness of the RREF")[
  Every matrix is row equivalent to exactly one matrix in reduced echelon
  form. Echelon form is *not* unique --- different choices of row operations
  give different echelon forms --- but the *positions* of the pivots are the
  same in all of them.
]

That last clause matters more than it looks: it is what makes "pivot column"
a well-defined property of $A$ itself, and it is what licenses everything in
Chapter 4.

#defn(title: "Pivot position, pivot column")[
  A #emph[pivot position] of $A$ is a location that holds a leading $1$ in
  the RREF of $A$. A #emph[pivot column] is a column containing a pivot
  position.
]

== The algorithm

#block(inset: (left: 11.5pt, top: 2pt, bottom: 2pt), stroke: (left: 2.25pt + accent))[
  *Forward phase* --- produces an echelon form.
  #enum(
    [Start with the leftmost nonzero column; this is a pivot column.],
    [Pick a nonzero entry in it as pivot; interchange rows to move it to the
     top of the working block.],
    [Use replacement operations to create zeros in all positions *below* the
     pivot.],
    [Cover the pivot row and repeat on the submatrix that remains, until no
     nonzero rows are left.],
  )
  *Backward phase* --- produces the RREF.
  #enum(start: 5,
    [Beginning with the rightmost pivot and working up and left, scale each
     pivot row to make the pivot $1$, then create zeros *above* each pivot.],
  )
]

#exm(title: "Row reduction, start to finish")[
  Reduce the augmented matrix of
  $3x_1 + 5x_2 - 4x_3 = 0$, #h(0.3em) $-3x_1 - 2x_2 + 4x_3 = 0$, #h(0.3em)
  $6x_1 + x_2 - 8x_3 = 0$.

  $
  mm(3, 5, -4, 0; -3, -2, 4, 0; 6, 1, -8, 0)
  #h(0.6em) tilde #h(0.6em)
  mm(3, 5, -4, 0; 0, 3, 0, 0; 0, -9, 0, 0)
  #h(0.6em) tilde #h(0.6em)
  mm(3, 5, -4, 0; 0, 3, 0, 0; 0, 0, 0, 0)
  #h(0.6em) tilde #h(0.6em)
  mm(1, 0, -4/3, 0; 0, 1, 0, 0; 0, 0, 0, 0)
  $

  Step 1 added $R_1$ to $R_2$ and $-2R_1$ to $R_3$; step 2 added $3R_2$ to
  $R_3$; the backward phase scaled and cleared upward. Columns $1$ and $2$ are
  pivot columns; column $3$ is not. We finish this example in
  #link(<hom-ex1>)[the next chapter].
]

#pitfall[
  Row operations act on *rows*, never on columns. "Column reducing" a matrix
  changes its column space and destroys the answer. The one place columns get
  touched is when you *read off* which ones are pivot columns.
]

== A worked count: the echelon forms of a $2 times 2$ matrix

A useful exam question is "list all possible reduced echelon forms of a
$2 times 2$ matrix." Reason by pivot count. With two pivots the only option is
$mm(1,0;0,1)$. With one pivot, the pivot sits in column $1$ or column $2$,
giving $mm(1, *; 0, 0)$ (with $*$ any real number) or $mm(0,1;0,0)$. With no
pivots, the matrix is $mm(0,0;0,0)$. So there are four shapes:

$
mm(1,0;0,1) quad
mm(1,*;0,0) quad
mm(0,1;0,0) quad
mm(0,0;0,0).
$

// ============================================================================
= Solving $A bold(x) = bold(b)$

Row reduction gives an echelon form. Reading a solution set off that form is a
separate skill, and it is the one exams test hardest.

#defn(title: "Basic and free variables")[
  In a row-reduced system, a variable is #emph[basic] if its column is a pivot
  column, and #emph[free] otherwise. Free variables may take any value; each
  choice determines the basic variables completely.
]

#thm(title: "Existence and uniqueness")[
  A linear system is consistent if and only if the rightmost column of the
  augmented matrix is *not* a pivot column --- equivalently, no row of an
  echelon form reads $[0 #h(0.3em) 0 #h(0.3em) dots.c #h(0.3em) 0
  #h(0.3em) | #h(0.3em) b]$ with $b != 0$.

  If it is consistent, then the solution is *unique* when there are no free
  variables, and there are *infinitely many* solutions when at least one free
  variable exists.
]

#pitfall[
  The row $[0 #h(0.3em) 0 #h(0.3em) 0 #h(0.3em) | #h(0.3em) 5]$ says
  $0 = 5$: the system is inconsistent and you stop. The row
  $[0 #h(0.3em) 0 #h(0.3em) 0 #h(0.3em) | #h(0.3em) 0]$ says $0 = 0$: it is
  harmless and carries no information. These look nearly identical on paper
  and mean opposite things.
]

== Parametric vector form

Once you have the RREF, solve each basic variable in terms of the free ones,
write $bold(x)$ as a column, and split it into one vector per free variable.
The result expresses the solution set as a *span*, which is the form every
later chapter wants.

== Homogeneous systems

#defn(title: "Homogeneous system")[
  A system is #emph[homogeneous] if it can be written $A bold(x) = bold(0)$,
  where $A$ is $m times n$ and $bold(0)$ is the zero vector in $RR^m$.
]

Such a system *always* has at least one solution, namely $bold(x) = bold(0)$,
the #emph[trivial solution]. So existence is never the question. The question
is whether a *nontrivial* solution exists --- a nonzero $bold(x)$ with
$A bold(x) = bold(0)$.

#thm(title: "Nontrivial solutions")[
  $A bold(x) = bold(0)$ has a nontrivial solution if and only if the system
  has at least one free variable.
]

#exm(title: "A solution set that is a line")[
  Determine whether
  $3x_1 + 5x_2 - 4x_3 = 0$, $#h(0.3em) -3x_1 - 2x_2 + 4x_3 = 0$,
  $#h(0.3em) 6x_1 + x_2 - 8x_3 = 0$
  has a nontrivial solution, and describe the solution set.

  Row reducing $[A #h(0.2em) bold(0)]$ (Example 2.7) gives
  $mm(1, 0, -4/3, 0; 0, 1, 0, 0; 0, 0, 0, 0)$, so
  $ x_1 - 4/3 x_3 = 0, quad x_2 = 0. $
  Columns $1$ and $2$ are pivot columns, so $x_1$ and $x_2$ are basic and
  $x_3$ is free --- a free variable exists, so nontrivial solutions exist.
  Solving, $x_1 = 4/3 x_3$ and $x_2 = 0$ with $x_3$ free:

  $
  bold(x) = vv(x_1, x_2, x_3) = vv(4/3 x_3, 0, x_3)
  = x_3 vv(4/3, 0, 1) = x_3 bold(v),
  quad "where" bold(v) = vv(4/3, 0, 1).
  $

  The solution set is $Span{bold(v)}$: geometrically, a line through the
  origin in $RR^3$.

  #figSpanLine
] <hom-ex1>

#pitfall[
  A nontrivial solution may have some zero entries --- here $x_2 = 0$ in every
  solution. "Nontrivial" means the vector is not the zero vector, not that
  every entry is nonzero.
]

#exm(title: "A solution set that is a plane")[
  A single equation is a system too. Describe all solutions of
  $ 10 x_1 - 3 x_2 - 2 x_3 = 0. $

  No matrix notation is needed. Solve for the basic variable $x_1$ in terms of
  the free variables $x_2, x_3$: the general solution is
  $x_1 = 0.3 x_2 + 0.2 x_3$. As a vector,

  $
  bold(x) = vv(x_1, x_2, x_3) = vv(0.3 x_2 + 0.2 x_3, x_2, x_3)
  = x_2 vv(0.3, 1, 0) + x_3 vv(0.2, 0, 1)
  = x_2 bold(u) + x_3 bold(v).
  $

  Every solution is a linear combination of $bold(u)$ and $bold(v)$, so the
  solution set is $Span{bold(u), bold(v)}$. Neither vector is a scalar
  multiple of the other, so this is a plane through the origin.

  #figSpanPlane
]

Both examples illustrate a fact that will be promoted to a theorem in
Chapter 7: *the solution set of $A bold(x) = bold(0)$ can always be written
explicitly as $Span{bold(v)_1, dots, bold(v)_p$}* for suitable vectors
$bold(v)_i$ --- one vector per free variable.

== The inhomogeneous case: solution sets in parametric form

#thm(title: "Structure of solution sets")[
  Suppose $A bold(x) = bold(b)$ is consistent and $bold(p)$ is one particular
  solution. Then the solution set of $A bold(x) = bold(b)$ is exactly the set
  of all vectors
  $ bold(x) = bold(p) + bold(v)_h, $
  where $bold(v)_h$ ranges over all solutions of the homogeneous equation
  $A bold(x) = bold(0)$.
]

#idea[
  If $A bold(x) = bold(b)$ and $A bold(p) = bold(b)$, then
  $A(bold(x) - bold(p)) = bold(b) - bold(b) = bold(0)$, so
  $bold(x) - bold(p)$ solves the homogeneous system. Conversely, adding any
  homogeneous solution to $bold(p)$ keeps the right-hand side at $bold(b)$.

  Geometrically: the solution set of $A bold(x) = bold(b)$ is the solution set
  of $A bold(x) = bold(0)$ --- a line, plane, or higher-dimensional
  flat through the origin --- *translated* so that it passes through
  $bold(p)$. It is parallel to the homogeneous solution set, and it contains
  the origin only when $bold(b) = bold(0)$.
]

// ============================================================================
= Independence, Span, Basis, and Dimension

This chapter answers the question "how much of the space do these vectors
actually cover, and are any of them redundant?" Every later chapter uses its
vocabulary.

== Span

#defn(title: "Span")[
  Let $bold(v)_1, dots, bold(v)_k$ be vectors in a vector space $V$. Their
  #emph[span] is the set of *all* linear combinations of them:
  $
  Span{bold(v)_1, dots, bold(v)_k}
  = { c_1 bold(v)_1 + c_2 bold(v)_2 + dots.c + c_k bold(v)_k
      : c_1, dots, c_k in RR }.
  $
  If $Span{bold(v)_1, dots, bold(v)_k} = V$, the set is called a
  #emph[spanning set] for $V$.
]

The span is everything you can reach by scaling and adding. In $RR^3$: the
span of one nonzero vector is a line through the origin; the span of two
vectors that are not multiples of each other is a plane through the origin;
the span of three "genuinely different" vectors is all of $RR^3$.

We will prove in Chapter 7 that a span is always a subspace --- it is the
standard way subspaces get produced.

== Linear independence

#defn(title: "Linear independence")[
  A set ${bold(v)_1, dots, bold(v)_n}$ is #emph[linearly independent] if the
  only solution of
  $ c_1 bold(v)_1 + c_2 bold(v)_2 + dots.c + c_n bold(v)_n = bold(0) $
  is the trivial one, $c_1 = c_2 = dots.c = c_n = 0$.

  The set is #emph[linearly dependent] if there exist scalars
  $d_1, dots, d_n$, *not all zero*, with
  $d_1 bold(v)_1 + dots.c + d_n bold(v)_n = bold(0)$. Such an equation is
  called a #emph[linear dependence relation].
]

#idea[
  *Why set the combination equal to zero?* Because "is one of these vectors
  redundant?" and "can zero be built non-trivially?" are the same question.
  If, say, $bold(v)_3 = 2bold(v)_1 - 5bold(v)_2$, then moving everything to
  one side gives $2bold(v)_1 - 5bold(v)_2 - bold(v)_3 = bold(0)$ --- a
  nonzero combination hitting zero. Run the argument backwards and any nonzero
  combination hitting zero lets you solve for whichever $bold(v)_i$ had a
  nonzero coefficient. So:

  #align(center)[
    dependent $<==>$ some vector is a combination of the others $<==>$
    some vector is redundant.
  ]
  Setting the combination to $bold(0)$ is just the version of that question
  you can hand to row reduction.
]

#thm(title: "Independence via " + $A bold(x) = bold(0)$)[
  The columns of a matrix $A$ are linearly independent if and only if
  $A bold(x) = bold(0)$ has only the trivial solution --- equivalently, if and
  only if $A$ has *no free variables*, i.e. every column is a pivot column.
]

#thm(title: "Easy dependence tests")[
  #enum(
    [Any set containing the zero vector is linearly dependent.],
    [A set of two vectors is dependent exactly when one is a scalar multiple
     of the other.],
    [Any set of more than $n$ vectors in $RR^n$ is linearly dependent --- more
     columns than rows forces a free variable.],
  )
]

#exm(title: "Independence of a set of polynomials")[
  Is ${1, #h(0.2em) t + 2, #h(0.2em) t - 3, #h(0.2em) t^2}$ linearly
  independent in $P_2$?

  Polynomials are vectors here (see the box below), so the test is unchanged.
  Set a general combination equal to the zero polynomial:
  $ c_1 dot 1 + c_2 (t + 2) + c_3 (t - 3) + c_4 t^2 = 0. $
  Expand and collect by powers of $t$:
  $ (c_1 + 2c_2 - 3c_3) + (c_2 + c_3) t + c_4 t^2 = 0. $
  The zero polynomial is zero *for every* $t$, which forces each coefficient
  to vanish:
  $ c_1 + 2c_2 - 3c_3 = 0, quad c_2 + c_3 = 0, quad c_4 = 0. $
  From the third, $c_4 = 0$. From the second, $c_3 = -c_2$. Substituting into
  the first, $c_1 + 2c_2 + 3c_2 = c_1 + 5c_2 = 0$, so $c_1 = -5c_2$.

  Now $c_2$ is free. Taking $c_2 = 1$ gives the nonzero relation
  $ -5 dot 1 + 1 dot (t+2) - 1 dot (t - 3) + 0 dot t^2 = -5 + t + 2 - t + 3 = 0. $
  A nontrivial dependence exists, so the set is *linearly dependent*.

  #v(0.4em)
  #text(size: 9.5pt, style: "italic")[Sanity check on the count: $P_2$ has
  dimension $3$, and the set has $4$ elements. By Theorem 4.4(3) it had to be
  dependent --- the computation only located the relation.]
]

#idea[
  *Is a polynomial really a vector?* Yes. A vector is anything living in a set
  that is closed under addition and scalar multiplication with the usual
  arithmetic rules (Chapter 7). A polynomial
  $p(t) = a_0 + a_1 t + dots.c + a_n t^n$ is completely determined by its
  coefficient list $(a_0, a_1, dots, a_n)$, and adding polynomials adds those
  lists entry by entry. So $P_n$ behaves exactly like $RR^(n+1)$ in disguise,
  and every technique in this book applies to it verbatim.
]

== Basis

#defn(title: "Basis")[
  A set $cal(B) = {bold(b)_1, dots, bold(b)_p}$ is a #emph[basis] for a vector
  space (or subspace) $V$ if
  #enum(
    [$cal(B)$ is linearly independent, and],
    [$Span cal(B) = V$.],
  )
]

A basis is the Goldilocks set: independent means "no redundancy," spanning
means "nothing missing." That balance forces uniqueness of representation:

#thm(title: "Unique representation")[
  If $cal(B) = {bold(b)_1, dots, bold(b)_p}$ is a basis for $V$, then every
  $bold(v) in V$ can be written as
  $bold(v) = c_1 bold(b)_1 + dots.c + c_p bold(b)_p$ in *exactly one* way.
]

#idea[
  Spanning gives at least one representation. If there were two, subtracting
  them would give a nonzero combination equal to $bold(0)$, contradicting
  independence. Uniqueness is precisely what independence buys you.
]

Two theorems say a basis can be reached from either direction --- by growing
an independent set, or by trimming a spanning set.

#thm(title: "Extension / maximal set theorem")[
  Let $V$ be a finite-dimensional vector space and let
  $S = {bold(v)_1, dots, bold(v)_k} subset.eq V$ be linearly independent.
  Then there exist $bold(w)_1, dots, bold(w)_m in V$ such that
  $ cal(B) = {bold(v)_1, dots, bold(v)_k, bold(w)_1, dots, bold(w)_m} $
  is a basis for $V$. In particular $S subset.eq cal(B)$, $Span cal(B) = V$,
  $cal(B)$ is independent, and adding any further vector of $V$ to $cal(B)$
  makes it dependent --- a basis is a *maximal* independent set.
]

#thm(title: "Spanning set / minimal set theorem")[
  Let $S = {bold(v)_1, dots, bold(v)_n}$ span $V$. Then some subset
  $cal(B) subset.eq S$ is a basis for $V$. Concretely: if some
  $bold(v)_i in S$ is a linear combination of the others, deleting it does not
  change the span; repeat until the remaining set is independent. A basis is a
  *minimal* spanning set.
]

== Dimension, rank, and nullity

#thm(title: "Well-definedness of dimension")[
  Any two bases of the same vector space contain the same number of vectors.
]

#defn(title: "Dimension")[
  The #emph[dimension] $dm V$ is the number of vectors in any basis of $V$.
  By convention $dm {bold(0)} = 0$. A space with a finite basis is
  #emph[finite-dimensional].
]

For reference: $dm RR^n = n$, $dm P_n = n + 1$ (the basis
${1, t, t^2, dots, t^n}$ has $n+1$ elements), and
$dm M_(m times n) = m n$.

#defn(title: "Rank and nullity")[
  For an $m times n$ matrix $A$,
  $ rank A = dm Col A = "the number of pivot columns of" A, $
  and the #emph[nullity] of $A$ is $dm Nul A$, the number of free variables.
]

#thm(title: "Rank–Nullity Theorem")[
  For any $m times n$ matrix $A$,
  $ rank A + dm Nul A = n. $
  Every column is either a pivot column or a free column; the pivot columns
  count the rank and the free columns count the nullity. Also
  $rank A = dm Row A = rank A^T$: the row rank and column rank of a matrix are
  always equal.
]

#pitfall[
  $n$ in rank--nullity is the number of *columns* of $A$ --- the dimension of
  the space $bold(x)$ lives in --- not the number of rows. $Nul A subset.eq
  RR^n$ but $Col A subset.eq RR^m$; these sit in different spaces and only
  coincide when $A$ is square.
]

#exm(title: "How many vectors can a basis for " + $Col A$ + " have?")[
  $A$ is $4 times 6$. What are the *possible* sizes of a basis for $Col A$?

  A basis for $Col A$ has $rank A$ vectors, and $rank A$ is the number of
  pivots. A matrix has at most one pivot per row and at most one per column,
  so $rank A <= min(4, 6) = 4$. It can also be as small as $0$, when $A$ is
  the zero matrix. So the answer is
  $ 0 <= rank A <= 4, $
  and every value in that range occurs. The number of *columns* ($6$) caps
  nothing here --- with only $4$ rows there is simply no room for a fifth
  pivot.
]

== Coordinates relative to a basis

Unique representation lets us give every vector an address.

#defn(title: "Coordinate vector")[
  Let $cal(B) = {bold(b)_1, dots, bold(b)_n}$ be a basis for $V$ and let
  $bold(v) in V$. The unique scalars with
  $ bold(v) = c_1 bold(b)_1 + c_2 bold(b)_2 + dots.c + c_n bold(b)_n $
  are the #emph[coordinates of $bold(v)$ relative to $cal(B)$], and the
  column
  $ [bold(v)]_cal(B) = vv(c_1, c_2, dots.v, c_n) in RR^n $
  is the #emph[coordinate vector] of $bold(v)$ relative to $cal(B)$.
]

To find coordinates in practice, solve the system
$[bold(b)_1 #h(0.3em) dots #h(0.3em) bold(b)_n #h(0.3em) | #h(0.3em)
bold(v)]$ by row reduction; the answer is unique because $cal(B)$ is a basis.

#exm(title: "Coordinates")[
  In $RR^2$ with the standard basis
  $cal(E) = { vv(1,0), vv(0,1) }$, the vector $bold(v) = vv(3,4)$ has
  $[bold(v)]_cal(E) = vv(3,4)$ --- coordinates and entries agree, which is
  exactly why the standard basis feels invisible.

  Change the basis to $cal(B) = { vv(1,1), vv(1,-1) }$ and the same vector
  gets a different address. Solving
  $c_1 vv(1,1) + c_2 vv(1,-1) = vv(3,4)$ gives $c_1 + c_2 = 3$ and
  $c_1 - c_2 = 4$, so $c_1 = 7/2$, $c_2 = -1/2$ and
  $ [bold(v)]_cal(B) = vv(7/2, -1/2). $
  The vector did not move. Only the language used to describe it did. This is
  the whole point of a basis: it is a choice of coordinate system, and a good
  choice can make a hard problem easy --- which is exactly what eigenvectors
  (Chapter 9) and orthogonal bases (Chapter 10) do for us.
]

// ============================================================================
= Invertibility

For square matrices there is a best possible case: the matrix can be undone.

#defn(title: "Invertible matrix")[
  An $n times n$ matrix $A$ is #emph[invertible] (or #emph[nonsingular]) if
  there exists an $n times n$ matrix $A^(-1)$ with
  $ A^(-1) A = I_n quad "and" quad A A^(-1) = I_n, $
  where $I_n$ is the $n times n$ identity matrix. A matrix that is not
  invertible is called #emph[singular]. The inverse, when it exists, is
  unique.
]

#pitfall[
  Only *square* matrices can be invertible. A $3 times 5$ matrix has no
  inverse, no matter how nice it looks; the two products above would not even
  have the same size.
]

If $A$ is invertible, then $A bold(x) = bold(b)$ has the unique solution
$bold(x) = A^(-1) bold(b)$, obtained by multiplying both sides on the left by
$A^(-1)$.

== Computing an inverse

For a $2 times 2$ matrix there is a formula (derived in Chapter 8):
$
A = mm(a, b; c, d) quad ==> quad
A^(-1) = 1/(a d - b c) mm(d, -b; -c, a),
$
valid exactly when $a d - b c != 0$.

For larger matrices, row reduce the augmented block $[A #h(0.3em) I]$. If $A$
is invertible, the reduction ends at $[I #h(0.3em) A^(-1)]$; if a full set of
$n$ pivots never appears, $A$ is singular and has no inverse.

== The Invertible Matrix Theorem

This is the central theorem of the first half of the course. It says a long
list of apparently unrelated conditions are all the same condition.

#thm(title: "Invertible Matrix Theorem (IMT)")[
  Let $A$ be an $n times n$ matrix. The following are *equivalent* --- if any
  one holds, all of them hold; if any one fails, all of them fail.

  #set enum(numbering: "(a)")
  #enum(
    [$A$ is invertible.],
    [$A$ is row equivalent to $I_n$.],
    [$A$ has $n$ pivot positions.],
    [$A bold(x) = bold(0)$ has only the trivial solution.],
    [The columns of $A$ are linearly independent.],
    [The linear transformation $bold(x) mapsto A bold(x)$ is one-to-one.],
    [$A bold(x) = bold(b)$ has at least one solution for every
     $bold(b) in RR^n$.],
    [$Col A = RR^n$ --- the columns of $A$ span $RR^n$.],
    [The linear transformation $bold(x) mapsto A bold(x)$,
     $T: RR^n -> RR^n$, is onto.],
    [$A bold(x) = bold(b)$ has a *unique* solution for every
     $bold(b) in RR^n$.],
    [There is an $n times n$ matrix $C$ with $C A = I_n$.],
    [There is an $n times n$ matrix $D$ with $A D = I_n$.],
    [$A^T$ is invertible.],
    [$det A != 0$ (Chapter 8).],
    [$0$ is *not* an eigenvalue of $A$ (Chapter 9).],
    [$Nul A = {bold(0)}$, equivalently $rank A = n$.],
  )
]

#pitfall[
  Three corrections to the version that circulates in most sets of notes:

  #enum(
    [It is $Col A = RR^n$, not "$Span(Col A) = RR^n$" --- $Col A$ is
     *already* a span, so spanning it again adds nothing.],
    [The transformation in (f) and (i) is $T: RR^n -> RR^n$, not
     $RR^n -> RR^m$. The IMT is a theorem about *square* matrices; $m = n$
     is a hypothesis, not a detail.],
    [Condition (g) says "at least one solution for every $bold(b)$" and (j)
     says "a unique solution for every $bold(b)$." For a square matrix these
     are equivalent --- that equivalence is the surprising content of the
     theorem, not an assumption.],
  )
]

#idea[
  *How to use the IMT.* Never verify invertibility by computing an inverse.
  Pick whichever equivalent condition is cheapest for the matrix in front of
  you: row reduce and count pivots; check for an obvious dependence among
  columns (a repeated column, a zero column, a column that is the sum of two
  others); or take a determinant if the matrix is $2 times 2$ or $3 times 3$.

  Also note what the theorem does *not* say. For non-square matrices the
  conditions split apart: a $3 times 5$ matrix can have columns that span
  $RR^3$ (onto) while being badly dependent (not one-to-one), and a
  $5 times 3$ matrix can have independent columns (one-to-one) that come
  nowhere near spanning $RR^5$. The collapse of "one-to-one" and "onto" into
  a single property is exactly the privilege of being square.
]

// ============================================================================
= Linear Transformations

So far a matrix has been a table of numbers. It is more useful to see it as a
*function* that moves vectors around.

#defn(title: "Transformation")[
  A #emph[transformation] (or #emph[map], or #emph[function])
  $T: RR^n -> RR^m$ assigns to each vector $bold(x) in RR^n$ a vector
  $T(bold(x)) in RR^m$. The set $RR^n$ is the #emph[domain], $RR^m$ the
  #emph[codomain], $T(bold(x))$ the #emph[image] of $bold(x)$, and the set of
  all images is the #emph[range].
]

#defn(title: "Linear transformation")[
  $T$ is #emph[linear] if
  $
  T(bold(u) + bold(v)) = T(bold(u)) + T(bold(v))
  quad "for all" bold(u), bold(v) in RR^n,
  $
  $
  T(c bold(u)) = c #h(0.15em) T(bold(u))
  quad "for all" c in RR, bold(u) in RR^n.
  $
  Equivalently, $T$ preserves linear combinations:
  $T(c bold(u) + d bold(v)) = c #h(0.15em) T(bold(u)) + d #h(0.15em)
  T(bold(v))$.
]

Two immediate consequences: $T(bold(0)) = bold(0)$ for any linear $T$ (take
$c = 0$), and a map that moves the origin cannot be linear. Translation
$bold(x) mapsto bold(x) + bold(p)$ with $bold(p) != bold(0)$ is the standard
example of a very simple map that is *not* linear.

== Every linear transformation is a matrix

#thm(title: "Standard matrix")[
  Let $T: RR^n -> RR^m$ be linear. Then there is a unique $m times n$ matrix
  $A$ with $T(bold(x)) = A bold(x)$ for all $bold(x)$, namely
  $ A = [T(bold(e)_1) #h(0.6em) T(bold(e)_2) #h(0.6em) dots.c
        #h(0.6em) T(bold(e)_n)], $
  where $bold(e)_j$ is the $j$-th column of $I_n$. $A$ is the
  #emph[standard matrix] of $T$.
]

#idea[
  Write $bold(x) = x_1 bold(e)_1 + dots.c + x_n bold(e)_n$ and push $T$
  through the combination:
  $T(bold(x)) = x_1 T(bold(e)_1) + dots.c + x_n T(bold(e)_n)$, which is
  exactly $A bold(x)$ for the $A$ above. In other words: *a linear map is
  completely determined by what it does to the basis vectors.* Everything
  else follows by linearity, which is why linear algebra is finite work.
]

#exm(title: "Rotation in the plane")[
  Let $T: RR^2 -> RR^2$ rotate every vector counterclockwise about the origin
  by the angle $theta$. Build the standard matrix by rotating the two basis
  vectors:
  $ T(bold(e)_1) = vv(cos theta, sin theta), quad
    T(bold(e)_2) = vv(-sin theta, cos theta), $
  so
  $ A = mm(cos theta, -sin theta; sin theta, cos theta). $
  Check $theta = 90 degree$: $A = mm(0, -1; 1, 0)$ sends $vv(1,0)$ to
  $vv(0,1)$, as it should.
]

Other standard matrices worth recognizing on sight: $mm(k, 0; 0, k)$ scales by
$k$; $mm(1, 0; 0, -1)$ reflects across the $x_1$-axis; $mm(1, k; 0, 1)$ is a
horizontal shear; $mm(1, 0; 0, 0)$ projects onto the $x_1$-axis.

== One-to-one, onto, and the two subspaces

#defn(title: "One-to-one and onto")[
  $T: RR^n -> RR^m$ is #emph[one-to-one] (injective) if each
  $bold(b) in RR^m$ is the image of *at most one* $bold(x)$. It is
  #emph[onto] (surjective) if each $bold(b) in RR^m$ is the image of
  *at least one* $bold(x)$ --- that is, if the range is all of $RR^m$.
]

#thm(title: "Both properties, read off the matrix")[
  Let $T(bold(x)) = A bold(x)$ with $A$ an $m times n$ matrix. Then
  #enum(
    [$T$ is one-to-one $<==>$ $A bold(x) = bold(0)$ has only the trivial
     solution $<==>$ $Nul A = {bold(0)}$ $<==>$ the columns of $A$ are
     linearly independent $<==>$ $A$ has a pivot in every *column*.],
    [$T$ is onto $<==>$ $Col A = RR^m$ $<==>$ the columns of $A$ span $RR^m$
     $<==>$ $A$ has a pivot in every *row*.],
  )
]

#idea[
  The two conditions are "pivot in every column" and "pivot in every row," and
  the shape of $A$ decides whether either is even possible.

  #v(0.4em)
  #table(
    columns: (auto, auto, auto),
    [Shape of $A$], [One-to-one?], [Onto?],
    [tall, $m > n$], [possible], [impossible],
    [wide, $m < n$], [impossible], [possible],
    [square, $m = n$], [possible], [possible --- and the two coincide],
  )
  #v(0.3em)
  A wide matrix has more columns than rows, hence a free variable, hence a
  nontrivial null space: it can never be one-to-one. A tall matrix has more
  rows than pivots available, so its columns can never span $RR^m$. The square
  case is the IMT.
]

The two subspaces named above are the transformation's own:
$Nul A$ is the *kernel* of $T$ (what gets crushed to zero) and $Col A$ is the
*range* of $T$ (what gets hit). Rank--nullity, restated:
$
underbrace(dm Nul A, "collapsed") + underbrace(dm Col A, "surviving") = n
= "dimension of the domain".
$

// ============================================================================
= Vector Spaces and Subspaces

Everything so far was done with columns of numbers. The pleasant surprise is
that the arguments never used the numbers --- only the fact that you can add
and scale. So the whole theory applies, unchanged, to polynomials, matrices,
and functions.

#quote(block: true, attribution: [the notes])[
  If it looks like a duck, quacks like a duck, and acts like a duck --- why
  not treat it like a duck?
]

== The definition

#defn(title: "Vector space")[
  A #emph[vector space] is a nonempty set $V$ together with an addition and a
  scalar multiplication, such that for all $bold(u), bold(v), bold(w) in V$
  and all scalars $c, d in RR$:

  #set enum(numbering: "1.")
  #columns(2)[
    #enum(
      [$bold(u) + bold(v) in V$ #h(0.3em) (closure under $+$)],
      [$bold(u) + bold(v) = bold(v) + bold(u)$],
      [$(bold(u) + bold(v)) + bold(w) = bold(u) + (bold(v) + bold(w))$],
      [there is $bold(0) in V$ with $bold(u) + bold(0) = bold(u)$],
      [there is $-bold(u) in V$ with $bold(u) + (-bold(u)) = bold(0)$],
    )
    #colbreak()
    #enum(start: 6,
      [$c bold(u) in V$ #h(0.3em) (closure under scaling)],
      [$c(bold(u) + bold(v)) = c bold(u) + c bold(v)$],
      [$(c + d) bold(u) = c bold(u) + d bold(u)$],
      [$c(d bold(u)) = (c d) bold(u)$],
      [$1 bold(u) = bold(u)$],
    )
  ]
]

Ten axioms is a lot to check. In practice you almost never check them,
because almost every space you meet sits inside one you already know --- and
then there is a three-line test.

#defn(title: "Subspace")[
  Let $V$ be a vector space. A subset $H subset.eq V$ is a #emph[subspace] of
  $V$ if
  #enum(
    [$bold(0) in H$ --- the zero vector of $V$ is in $H$;],
    [$H$ is closed under addition: $bold(u), bold(v) in H ==> bold(u) +
     bold(v) in H$;],
    [$H$ is closed under scalar multiplication: $c in RR$, $bold(u) in H
     ==> c bold(u) in H$.],
  )
]

#thm(title: "The subspace test")[
  A subspace of a vector space is itself a vector space, under the same
  operations. So to prove that some set is a vector space, it is enough to
  exhibit it as a subset of a known vector space and check the three
  conditions above.
]

#pitfall[
  These three conditions are the *subspace* test, not the definition of a
  vector space. They are a shortcut that works only because the ambient space
  $V$ is already known to satisfy axioms 2, 3, 7--10 --- properties like
  commutativity are inherited automatically by any subset. Conditions 1--3 are
  exactly the ones a subset can fail.

  Also, condition 1 is not redundant. Its real job is to rule out the empty
  set, and it doubles as the fastest disqualifier there is: *if $bold(0)$ is
  not in the set, stop --- it is not a subspace.*
]

== The classic examples

#block(inset: (left: 11.5pt, top: 2pt, bottom: 2pt), stroke: (left: 2.25pt + accent))[
  *Euclidean space $RR^n$.* All columns of $n$ real numbers, with the usual
  operations. Dimension $n$.

  *The zero space ${bold(0)}$.* The smallest vector space there is. It is a
  subspace of every vector space, and its dimension is $0$ (its basis is the
  empty set).

  *Polynomials of degree at most $n$, $P_n$.* Take
  $p(t) = a_0 + a_1 t + dots.c + a_n t^n$ and
  $q(t) = b_0 + b_1 t + dots.c + b_n t^n$. Then
  $
  (p + q)(t) &= (a_0 + b_0) + (a_1 + b_1) t + dots.c + (a_n + b_n) t^n, \
  (c #h(0.1em) p)(t) &= c a_0 + c a_1 t + dots.c + c a_n t^n, \
  bold(0)(t) &= 0 + 0 t + dots.c + 0 t^n = 0.
  $
  The coefficients define the polynomial: if you know the coefficients you
  know the polynomial. So $P_n$ is a vector space of dimension $n + 1$, with
  basis ${1, t, t^2, dots, t^n}$.

  *Matrix spaces $M_(m times n)$.* All $m times n$ matrices, with entrywise
  addition and scaling. Dimension $m n$. Note what is *not* part of the
  structure: as a vector space, $M_(m times n)$ offers addition and scaling
  only. Matrix multiplication is extra structure, not a vector-space
  operation.

  *Function spaces.* All functions $f: RR -> RR$, with pointwise operations
  $(f + g)(t) = f(t) + g(t)$ and $(c f)(t) = c dot f(t)$. This one is
  infinite-dimensional.
]

#pitfall[
  $P_n$ is *finite*-dimensional, with $dm P_n = n + 1$. It contains
  infinitely many polynomials, but that is a statement about how many vectors
  it has, not about its dimension --- $RR^2$ has infinitely many vectors too.
  It is the space of *all* polynomials, with no degree bound, that is
  infinite-dimensional.
]

== Subspaces of $RR^2$: what qualifies

The subspaces of $RR^2$ are exactly: ${bold(0)}$, every line through the
origin, and $RR^2$ itself. Nothing else.

#grid(columns: (1fr, 1fr), gutter: 14pt,
  aside(cWarn, "Not subspaces")[
    #set text(size: 9.8pt)
    - The unit circle $x^2 + y^2 = 1$. It misses $bold(0)$, and doubling a
      point on it leaves the circle.
    - The parabola $x^2 + y = 0$. It contains $bold(0)$, but
      $(1, -1)$ and $(2, -4)$ are on it while their sum $(3, -5)$ is not.
    - A line *not* through the origin. Misses $bold(0)$.
    - The first quadrant. Closed under addition, but
      $-1 dot (1,1) = (-1,-1)$ escapes.
  ],
  aside(cEx, "Subspaces")[
    #set text(size: 9.8pt)
    - ${bold(0)}$, the zero subspace.
    - Any line through the origin --- that is, $Span{bold(u)}$ for any
      $bold(u) != bold(0)$. Not just the axes: $Span{vv(2,3)}$ counts.
    - $RR^2$ itself. Every space is a subspace of itself.
  ]
)

The parabola is the instructive failure: containing $bold(0)$ is necessary but
nowhere near sufficient. All three conditions have to hold.

== Spans are subspaces

#thm(title: "A span is always a subspace")[
  Let $bold(v)_1, dots, bold(v)_k$ be vectors in a vector space $V$. Then
  $W = Span{bold(v)_1, dots, bold(v)_k}$ is a subspace of $V$ --- in fact the
  smallest subspace of $V$ containing all the $bold(v)_i$.
]

#idea[
  *Proof.* The zero vector is in $W$: take all coefficients zero.

  *Closed under addition.* Let $bold(u)_1, bold(u)_2 in W$, say
  $bold(u)_1 = c_1 bold(v)_1 + dots.c + c_k bold(v)_k$ and
  $bold(u)_2 = d_1 bold(v)_1 + dots.c + d_k bold(v)_k$. Then
  $
  bold(u)_1 + bold(u)_2 = (c_1 + d_1) bold(v)_1 + dots.c
  + (c_k + d_k) bold(v)_k,
  $
  which is again a linear combination of the $bold(v)_i$, so it lies in $W$.

  *Closed under scaling.* For any $q in RR$,
  $
  q bold(u)_1 = (q c_1) bold(v)_1 + dots.c + (q c_k) bold(v)_k in W.
  $
  All three conditions hold, so $W$ is a subspace. $qed$
]

This is why the parametric vector form of Chapter 3 mattered: writing a
solution set as a span *proves* it is a subspace, for free.

== The subspaces attached to a matrix

Let $A$ be $m times n$.

#defn(title: "Null space")[
  $ Nul A = { bold(x) in RR^n : A bold(x) = bold(0) } subset.eq RR^n. $
  It is a subspace of $RR^n$: $A bold(0) = bold(0)$; if
  $A bold(u) = A bold(v) = bold(0)$ then $A(bold(u) + bold(v)) = bold(0)$;
  and $A(c bold(u)) = c A bold(u) = bold(0)$.
]

#defn(title: "Column space")[
  $Col A$ is the span of the columns of $A$ --- equivalently, the set of all
  $bold(b) in RR^m$ for which $A bold(x) = bold(b)$ is consistent. It is a
  subspace of $RR^m$.
]

#defn(title: "Row space")[
  $Row A$ is the span of the rows of $A$, a subspace of $RR^n$. Row
  operations do not change it: if $A tilde B$ then $Row A = Row B$, since each
  row of $B$ is a combination of rows of $A$ and vice versa.
]

#block(inset: (left: 11.5pt, top: 2pt, bottom: 2pt), stroke: (left: 2.25pt + accent))[
  *Finding a basis for $Nul A$.*
  #enum(
    [Row reduce $A$ to reduced echelon form.],
    [Write the solution of $A bold(x) = bold(0)$ in parametric vector form.],
    [Solve each basic (pivot) variable in terms of the free variables.],
    [The vectors multiplying the free variables are the basis --- one basis
     vector per free variable.],
    [Check: each vector should satisfy $A bold(x) = bold(0)$.],
  )

  *Finding a basis for $Col A$.* Row reduce to find the pivot columns, then
  take *the corresponding columns of the original $A$*.

  *Finding a basis for $Row A$.* Row reduce, then take *the nonzero rows of
  the echelon form*.
]

#pitfall[
  For the column space you take pivot columns *of $A$*, not of its echelon
  form. Row operations preserve dependence relations among columns --- which
  is why the echelon form correctly identifies *which* columns to take --- but
  they change the columns themselves, so the echelon form's columns generally
  span a different space. For the *row* space it is the other way round: the
  echelon form's rows are the ones you want. Take rows from the reduced
  matrix, columns from the original.
]

$dm Nul A$ is the number of free variables; $dm Col A = dm Row A = rank A$ is
the number of pivots. Together, rank--nullity.

== More subspaces, and some non-examples

*Symmetric matrices.* The set of $n times n$ matrices with $A^T = A$ is a
subspace of $M_(n times n)$: the zero matrix is symmetric, and sums and scalar
multiples of symmetric matrices are symmetric. Its dimension is
$n(n+1)/2$.

*Upper triangular matrices.* The set of $n times n$ matrices with all entries
below the main diagonal equal to zero is a subspace of $M_(n times n)$, of
dimension $n(n+1)/2$. For example
$ mm(1, 1, 1; 0, 1, 1; 0, 0, 1) $
is upper triangular; adding two such matrices or scaling one keeps the zeros
where they are.

#exm(title: "Which of these are vector spaces?")[
  #set enum(numbering: "1.")
  #enum(
    [*All $3 times 3$ invertible matrices.* #text(fill: cWarn)[No.] The zero
     matrix is not invertible, so the set misses $bold(0)$. Worse, the sum of
     two invertible matrices need not be invertible: $I + (-I) = 0$.],
    [*All polynomials of degree exactly $2$.* #text(fill: cWarn)[No.] The zero
     polynomial has no degree $2$, so $bold(0)$ is missing; and
     $(t^2 + t) + (-t^2 + 1) = t + 1$ has degree $1$, so the set is not closed
     under addition. "Degree *at most* $2$" is a vector space; "exactly" is
     not.],
    [*All solutions of $x_1 + 2x_2 + 3x_3 = 0$ in $RR^3$.*
     #text(fill: cEx)[Yes.] It is $Nul A$ for the $1 times 3$ matrix
     $A = mm(1, 2, 3)$ --- a plane through the origin, of dimension $2$.],
    [*All continuous functions on $[0,1]$.* #text(fill: cEx)[Yes.] A subspace
     of the space of all functions on $[0,1]$: the zero function is
     continuous, and sums and scalar multiples of continuous functions are
     continuous.],
  )

  #v(0.3em)
  #text(size: 9.5pt, style: "italic")[The pattern: sets defined by an
  *equation set equal to zero* tend to be subspaces; sets defined by a
  *condition that the zero object fails* ("invertible," "degree exactly $k$,"
  "positive," "unit length") never are.]
]

// ============================================================================
= Determinants

The determinant condenses an entire square matrix into a single number that
answers "is this matrix invertible?" --- and, geometrically, "by how much does
it stretch space?"

== What the number means

For a $2 times 2$ matrix, $abs(det A)$ is the *area* of the parallelogram
spanned by its two columns. For a $3 times 3$ matrix, it is the *volume* of
the parallelepiped spanned by its three columns. In general, if a region has
volume $V$, its image under $bold(x) mapsto A bold(x)$ has volume
$abs(det A) dot V$.

That makes the invertibility criterion obvious rather than magical:

#thm[
  A square matrix $A$ is invertible if and only if $det A != 0$.
]

#idea[
  $det A = 0$ means the columns span a region of zero volume --- they are
  squashed into a lower-dimensional flat, so they are linearly dependent, so
  the transformation collapses space and cannot be undone. The *sign* of the
  determinant records whether the transformation preserves or reverses
  orientation.
]

== Computing: Laplace cofactor expansion

#defn(title: "Minor and cofactor")[
  For an $n times n$ matrix $A$, the #emph[minor] $M_(i j)$ is the determinant
  of the $(n-1) times (n-1)$ matrix obtained by deleting row $i$ and column
  $j$. The #emph[cofactor] is
  $ C_(i j) = (-1)^(i + j) M_(i j). $
]

The sign factor $(-1)^(i+j)$ follows the checkerboard pattern
$
mm(+, -, +, -; -, +, -, +; +, -, +, -; -, +, -, +)
$
which starts with $+$ in the top-left corner and alternates in both
directions.

#thm(title: "Cofactor expansion")[
  For any $n times n$ matrix $A$, the determinant may be computed by expanding
  along any row $i$,
  $ det A = a_(i 1) C_(i 1) + a_(i 2) C_(i 2) + dots.c + a_(i n) C_(i n), $
  or along any column $j$,
  $ det A = a_(1 j) C_(1 j) + a_(2 j) C_(2 j) + dots.c + a_(n j) C_(n j). $
  Every choice gives the same answer.
]

#block(inset: (left: 11.5pt, top: 2pt, bottom: 2pt), stroke: (left: 2.25pt + accent))[
  *The procedure.*
  #enum(
    [Choose a row or column --- pick the one with the most zeros.],
    [For each entry in it, form the cofactor: read off the sign
     $(-1)^(i+j)$ and delete that entry's row and column.],
    [Compute the determinant of each resulting submatrix (recursively, or by
     the $2 times 2$ formula).],
    [Sum entry $times$ cofactor across the chosen row or column.],
  )
]

The base case is $2 times 2$:
$ det mm(a, b; c, d) = a d - b c. $

#exm(title: "A " + $3 times 3$ + " determinant")[
  Expand $A = mm(1, 2, 0; 3, -1, 4; 0, 5, 2)$ along the *first row*, which
  contains a zero:
  $
  det A &= 1 dot (+1) det mm(-1, 4; 5, 2)
         + 2 dot (-1) det mm(3, 4; 0, 2)
         + 0 dot (+1) det mm(3, -1; 0, 5) \
        &= 1(-2 - 20) - 2(6 - 0) + 0 = -22 - 12 = -34.
  $
  Expanding along the *third row* instead must give the same value:
  $
  det A = 0 dot (+1) det mm(2,0;-1,4) - 5 det mm(1, 0; 3, 4)
        + 2 det mm(1, 2; 3, -1) = -5(4) + 2(-7) = -34. quad checkmark
  $
]

== Triangular matrices

#defn(title: "Triangular matrix")[
  A square matrix is #emph[upper triangular] if every entry below the main
  diagonal is zero, and #emph[lower triangular] if every entry above it is
  zero. #emph[Diagonal] means both.
  $
  mm(n_1, n_2, n_3; 0, n_4, n_5; 0, 0, n_6)
  quad "upper triangular"
  $
]

#thm(title: "Determinant of a triangular matrix")[
  If $A$ is triangular, then $det A$ is the product of its diagonal entries:
  $ det A = a_(1 1) a_(2 2) dots.c a_(n n). $
]

#idea[
  Expand along the first column. Every entry below the diagonal is zero, so
  only the $a_(1 1)$ term survives, leaving $a_(1 1)$ times the determinant of
  a smaller triangular matrix. Repeat. Each step peels off one diagonal entry,
  and the product is what remains.

  Example: $det mm(a, b, c; 0, d, e; 0, 0, f) = a d f$, regardless of what
  $b, c, e$ are.
]

This is why row reduction is the fast way to compute a large determinant: get
to echelon form (which is triangular), multiply the diagonal, and correct for
the row operations you used.

== Properties worth memorizing

#table(
  columns: (auto, 1fr),
  [Operation / fact], [Effect on the determinant],
  [Replacement: $R_i <- R_i + k R_j$], [unchanged],
  [Interchange: $R_i <-> R_j$], [multiplied by $-1$],
  [Scaling: $R_i <- k R_i$], [multiplied by $k$],
  [Transpose], [$det A^T = det A$],
  [Product], [$det(A B) = (det A)(det B)$],
  [Inverse], [$det(A^(-1)) = 1 slash det A$],
  [Scalar multiple of the whole matrix], [$det(k A) = k^n det A$ for
   $A$ of size $n times n$],
  [A zero row or column, or two equal rows], [$det A = 0$],
)

#pitfall[
  $det(A + B) != det A + det B$ in general. The determinant is multiplicative,
  never additive. Try $A = B = I_2$: the left side is $det mm(2,0;0,2) = 4$,
  the right side is $1 + 1 = 2$.
]

== Application: the $2 times 2$ inverse

Determinants give the $2 times 2$ inverse formula promised in Chapter 5. For
$A = mm(a, b; c, d)$,
$
A^(-1) = 1/(det A) mm(d, -b; -c, a) = 1/(a d - b c) mm(d, -b; -c, a).
$
Verify by multiplying: $mm(a,b;c,d) mm(d,-b;-c,a) = mm(a d - b c, 0;
0, a d - b c) = (a d - b c) I$.

The determinant $a d - b c$ must be nonzero for the inverse to exist, which is
the $2 times 2$ case of the theorem above. The recipe is easy to remember:
*swap the diagonal, negate the off-diagonal, divide by the determinant.* It
computes an inverse with no row operations at all.

// ============================================================================
= Eigenvalues and Eigenvectors

Most vectors change direction when a matrix acts on them. A few do not --- they
only get stretched. Those few describe the matrix better than all the others
put together.

#defn(title: "Eigenvector and eigenvalue")[
  Let $A$ be an $n times n$ matrix. A *nonzero* vector $bold(x) in RR^n$ is an
  #emph[eigenvector] of $A$ if
  $ A bold(x) = lambda bold(x) $
  for some scalar $lambda$. That scalar is the #emph[eigenvalue] of $A$
  corresponding to $bold(x)$.
]

The eigenvalue records how much the eigenvector is stretched ($abs(lambda) >
1$), shrunk ($abs(lambda) < 1$), or flipped ($lambda < 0$) by the
transformation.

#pitfall[
  The eigen*vector* must be nonzero --- otherwise $A bold(0) = lambda bold(0)$
  would hold for every $lambda$ and the notion would be empty. The
  eigen*value*, on the other hand, is perfectly allowed to be $0$; and
  $lambda = 0$ is an eigenvalue precisely when $Nul A != {bold(0)}$, i.e.
  when $A$ is *not* invertible. That is the last line of the IMT.
]

== Finding them

The definition rearranges into a null-space problem, which is why the whole
first half of the course was worth doing:
$
A bold(x) = lambda bold(x)
quad <==> quad A bold(x) - lambda I bold(x) = bold(0)
quad <==> quad (A - lambda I) bold(x) = bold(0).
$
A nonzero solution $bold(x)$ exists exactly when $A - lambda I$ is *not*
invertible, i.e. when its determinant vanishes.

#defn(title: "Characteristic equation")[
  The #emph[characteristic polynomial] of $A$ is $det(A - lambda I)$, a
  polynomial of degree $n$ in $lambda$. The #emph[characteristic equation] is
  $ det(A - lambda I) = 0, $
  and its roots are exactly the eigenvalues of $A$.
]

#block(inset: (left: 11.5pt, top: 2pt, bottom: 2pt), stroke: (left: 2.25pt + accent))[
  *The procedure.*
  #enum(
    [*Eigenvalues.* Form $A - lambda I$, take its determinant, and solve
     $det(A - lambda I) = 0$ for $lambda$.],
    [*Eigenvectors.* For each eigenvalue $lambda$, solve the homogeneous
     system $(A - lambda I) bold(v) = bold(0)$ by row reduction. The nonzero
     solutions are the eigenvectors for that $lambda$.],
  )
]

#pitfall[
  Do *not* row reduce $A$ before finding eigenvalues. Row operations change
  the eigenvalues completely. Row reduction enters only at step 2, applied to
  $A - lambda I$ with a specific numerical $lambda$ already substituted in.
]

#exm(title: "A " + $2 times 2$ + " example, end to end")[
  Let $A = mm(4, 1; 2, 3)$.

  *Eigenvalues.*
  $
  det(A - lambda I) = det mm(4 - lambda, 1; 2, 3 - lambda)
  = (4 - lambda)(3 - lambda) - 2 = lambda^2 - 7 lambda + 10
  = (lambda - 2)(lambda - 5),
  $
  so $lambda_1 = 5$ and $lambda_2 = 2$.

  *Eigenvector for $lambda = 5$.* Solve $(A - 5I) bold(v) = bold(0)$:
  $
  mm(-1, 1; 2, -2) tilde mm(1, -1; 0, 0)
  quad ==> quad v_1 = v_2,
  quad bold(v) = v_2 vv(1, 1).
  $
  Take $bold(v)_1 = vv(1,1)$. Check: $A vv(1,1) = vv(5,5) = 5 vv(1,1)$.
  #h(0.3em) $checkmark$

  *Eigenvector for $lambda = 2$.* Solve $(A - 2I) bold(v) = bold(0)$:
  $
  mm(2, 1; 2, 1) tilde mm(2, 1; 0, 0)
  quad ==> quad 2 v_1 + v_2 = 0,
  quad bold(v) = v_1 vv(1, -2).
  $
  Take $bold(v)_2 = vv(1,-2)$. Check:
  $A vv(1,-2) = vv(2,-4) = 2 vv(1,-2)$. #h(0.3em) $checkmark$
]

== Eigenspaces

#defn(title: "Eigenspace")[
  For an eigenvalue $lambda$ of $A$, the #emph[eigenspace] of $lambda$ is
  $ E_lambda = Nul(A - lambda I) = {bold(x) in RR^n : A bold(x) = lambda
    bold(x)}, $
  the set of all eigenvectors for $lambda$ *together with the zero vector*.
  It is a subspace of $RR^n$, being a null space.
]

To find a basis for an eigenspace, find a basis for $Nul(A - lambda I)$ by the
Chapter 7 recipe --- nothing new is needed.

#defn(title: "Multiplicities")[
  The #emph[algebraic multiplicity] of $lambda$ is its multiplicity as a root
  of the characteristic polynomial. The #emph[geometric multiplicity] is
  $dm E_lambda$. Always
  $ 1 <= "geometric multiplicity" <= "algebraic multiplicity". $
]

#pitfall[
  Adding the zero vector is not a technicality --- it is what makes $E_lambda$
  a subspace, since $bold(0)$ is never an eigenvector. So: "the eigenspace
  contains $bold(0)$; the set of eigenvectors does not."
]

== Two shortcuts

#thm(title: "Eigenvalues of a triangular matrix")[
  If $A$ is triangular, its eigenvalues are exactly the entries on its main
  diagonal.
]

#idea[
  $A - lambda I$ is triangular too, with diagonal entries
  $a_(1 1) - lambda, dots, a_(n n) - lambda$. By Chapter 8 its determinant is
  the product of those, so
  $det(A - lambda I) = (a_(1 1) - lambda) dots.c (a_(n n) - lambda)$, which
  vanishes exactly at the diagonal entries.
]

#thm(title: "Independence of eigenvectors")[
  Eigenvectors corresponding to *distinct* eigenvalues are linearly
  independent. In particular, if an $n times n$ matrix has $n$ distinct
  eigenvalues, its eigenvectors form a basis for $RR^n$.
]

That last statement is the payoff. In the basis of eigenvectors, the matrix
acts by simple scaling along each axis --- multiplication becomes
multiplication of numbers. Choosing the right basis is the recurring theme of
this course, and it returns one more time in Chapter 10.

// ============================================================================
= Orthogonality

Until now the only structure available was addition and scaling. That is
enough for "which vectors can I reach?" but not for "how long is this vector?"
or "how close are these two?" One extra operation supplies both.

== The dot product

#defn(title: "Dot product, length, distance")[
  For $bold(u), bold(v) in RR^n$,
  $
  bold(u) dt bold(v) = bold(u)^T bold(v)
  = u_1 v_1 + u_2 v_2 + dots.c + u_n v_n in RR.
  $
  The #emph[length] (or #emph[norm]) of $bold(v)$ is
  $norm(bold(v)) = sqrt(bold(v) dt bold(v))$, so
  $norm(bold(v))^2 = bold(v) dt bold(v)$. The #emph[distance] between
  $bold(u)$ and $bold(v)$ is $norm(bold(u) - bold(v))$. A vector of length $1$
  is a #emph[unit vector]; #emph[normalizing] $bold(v) != bold(0)$ means
  replacing it by $bold(v) slash norm(bold(v))$.
]

The dot product of two vectors is a *number*, not a vector --- the single most
common notational slip in this chapter.

#defn(title: "Orthogonality")[
  Vectors $bold(u)$ and $bold(v)$ in $RR^n$ are #emph[orthogonal], written
  $bold(u) perp bold(v)$, if
  $ bold(u) dt bold(v) = 0. $
  In $RR^2$ and $RR^3$ this says the angle between them is $90 degree$
  ($pi slash 2$ radians); in higher dimensions it is taken as the
  *definition* of perpendicularity.
]

The zero vector is orthogonal to everything, including itself.

#thm(title: "Pythagorean Theorem")[
  $bold(u) perp bold(v)$ if and only if
  $ norm(bold(u) + bold(v))^2 = norm(bold(u))^2 + norm(bold(v))^2. $
]

#idea[
  Expand: $norm(bold(u)+bold(v))^2 = (bold(u)+bold(v)) dt
  (bold(u)+bold(v)) = norm(bold(u))^2 + 2 bold(u) dt bold(v) +
  norm(bold(v))^2$. The cross term vanishes exactly when
  $bold(u) dt bold(v) = 0$. The familiar geometry theorem *is* the algebraic
  identity.
]

== Orthogonal sets and orthogonal bases

#defn(title: "Orthogonal set")[
  A set ${bold(u)_1, bold(u)_2, dots, bold(u)_p}$ in $RR^n$ is an
  #emph[orthogonal set] if every pair of *distinct* vectors in it is
  orthogonal:
  $ bold(u)_i dt bold(u)_j = 0 quad "whenever" i != j. $
]

#thm(title: "Orthogonal implies independent")[
  Any orthogonal set of *nonzero* vectors is linearly independent.
]

#idea[
  Suppose $c_1 bold(u)_1 + dots.c + c_p bold(u)_p = bold(0)$. Dot both sides
  with $bold(u)_i$. Every cross term dies by orthogonality, leaving
  $c_i (bold(u)_i dt bold(u)_i) = 0$. Since $bold(u)_i != bold(0)$ we have
  $bold(u)_i dt bold(u)_i > 0$, so $c_i = 0$ --- for every $i$. Independence
  comes for free, with no row reduction at all.
]

#defn(title: "Orthogonal basis")[
  A set ${bold(u)_1, dots, bold(u)_p}$ is an #emph[orthogonal basis] for a
  subspace $W subset.eq RR^n$ if it is an orthogonal set and
  $W = Span{bold(u)_1, dots, bold(u)_p}$. If in addition every $bold(u)_i$ is
  a unit vector, the set is an #emph[orthonormal basis].
]

Why go to the trouble? Because coordinates become free:

#thm(title: "Coordinates in an orthogonal basis")[
  Let ${bold(u)_1, dots, bold(u)_p}$ be an orthogonal basis for $W$. Then
  every $bold(y) in W$ satisfies
  $
  bold(y) = c_1 bold(u)_1 + dots.c + c_p bold(u)_p,
  quad "where" quad
  c_i = (bold(y) dt bold(u)_i) / (bold(u)_i dt bold(u)_i).
  $
]

#idea[
  Compare with the general case. In an arbitrary basis, finding coordinates
  means row reducing an $n times p$ augmented system --- the coordinates are
  entangled, and changing one basis vector changes all of them. In an
  orthogonal basis, each coordinate is a single dot product, computed
  independently of the others. This is the entire reason orthogonal bases are
  worth constructing.
]

== Orthogonal complements

#defn(title: "Orthogonal complement")[
  Let $W$ be a subspace of $RR^n$. The #emph[orthogonal complement] of $W$ is
  $
  W^perp = { bold(v) in RR^n : bold(v) dt bold(w) = 0
             "for every" bold(w) in W }.
  $
  It is read "$W$ perp." It is itself a subspace of $RR^n$.
]

#thm(title: "Properties of the complement")[
  Let $W$ be a subspace of $RR^n$. Then
  #enum(
    [$(W^perp)^perp = W$;],
    [$W inter W^perp = {bold(0)}$ --- the only vector orthogonal to itself is
     $bold(0)$;],
    [$dm W + dm W^perp = n$;],
    [$bold(v) in W^perp$ as soon as $bold(v)$ is orthogonal to every vector of
     *some spanning set* for $W$ --- you never have to check infinitely many
     vectors.],
  )
]

=== The four fundamental subspaces

For an $m times n$ matrix $A$, the four subspaces attached to $A$ pair up into
two orthogonal complements:

$
Row A = (Nul A)^perp quad "inside" RR^n,
quad quad
Col A = (Nul A^T)^perp quad "inside" RR^m.
$

#idea[
  The first is a one-line computation. If $bold(x) in Nul A$ then
  $A bold(x) = bold(0)$, and the $i$-th entry of $A bold(x)$ is exactly
  (row $i$ of $A$) $dt bold(x)$. So $bold(x)$ is orthogonal to every row of
  $A$, hence to their span $Row A$. Thus $Row A perp Nul A$, and the dimension
  count $rank A + dm Nul A = n$ upgrades this to full complementarity.

  Applying the same fact to $A^T$ --- whose rows are the columns of $A$, and
  whose null space $Nul A^T$ is called the *left null space* --- gives the
  second identity.
]

#pitfall[
  Several sets of notes garble this pair into "$Col A = Nul(A)^T$" or
  "$Col A = Nul(A)^(T perp)$." Neither is meaningful: $Nul A$ is a *set*, and
  sets do not have transposes. The correct statement transposes the *matrix*
  first and then takes the complement of the resulting null space:
  $Col A = (Nul A^T)^perp$.
]

== Projection onto a line: component vs. projection

Given $bold(y)$ and a nonzero $bold(u)$, split $bold(y)$ into a piece along
$bold(u)$ and a piece perpendicular to it.

#figProj

#defn(title: "Component and projection")[
  For $bold(u) != bold(0)$,
  $
  comp_bold(u) bold(y) = (bold(y) dt bold(u)) / norm(bold(u))
  quad "(a" #h(0.2em) "scalar)",
  quad quad
  proj_bold(u) bold(y) = (bold(y) dt bold(u)) / (bold(u) dt bold(u)) bold(u)
  quad "(a" #h(0.2em) "vector)".
  $
]

#idea[
  *What is the difference between a component and a projection?* This is the
  question the notes ask in the margin, and the answer is short: a *component*
  is a signed length, a *projection* is a vector.

  $comp_bold(u) bold(y)$ tells you *how far* along the direction of $bold(u)$
  the shadow of $bold(y)$ reaches --- one number, positive if $bold(y)$ leans
  the same way as $bold(u)$, negative if it leans the other way.
  $proj_bold(u) bold(y)$ is that shadow itself, sitting in $RR^n$ pointing
  along $bold(u)$. They are related exactly as a length is to a vector:
  $
  proj_bold(u) bold(y)
  = (comp_bold(u) bold(y)) dot bold(u)/norm(bold(u))
  = "(signed length)" times "(unit vector in the" bold(u) "direction)".
  $
  Note that $norm(bold(u))$ appears once in the component formula and twice
  --- as $bold(u) dt bold(u) = norm(bold(u))^2$ --- in the projection formula.
  A formula with $bold(y) dt bold(y)$ anywhere in the numerator is a
  transcription error; the numerator is always $bold(y) dt bold(u)$.
]

== Projection onto a subspace

Now replace the line $Span{bold(u)}$ by a whole subspace $W$.

#thm(title: "Orthogonal Decomposition Theorem")[
  Let $W$ be a subspace of $RR^n$ and let $bold(y) in RR^n$. Then $bold(y)$
  can be written in exactly one way as
  $ bold(y) = hat(bold(y)) + bold(z), quad "where" quad
    hat(bold(y)) in W quad "and" quad bold(z) in W^perp. $
  Moreover, if ${bold(w)_1, dots, bold(w)_k}$ is *any orthogonal basis* for
  $W$, then
  $
  hat(bold(y)) = proj_W bold(y)
  = (bold(y) dt bold(w)_1)/(bold(w)_1 dt bold(w)_1) bold(w)_1
  + (bold(y) dt bold(w)_2)/(bold(w)_2 dt bold(w)_2) bold(w)_2
  + dots.c
  + (bold(y) dt bold(w)_k)/(bold(w)_k dt bold(w)_k) bold(w)_k,
  $
  and $bold(z) = bold(y) - hat(bold(y))$.
]

#pitfall[
  Three points that get lost in transcription.

  #enum(
    [It is $bold(y) = hat(bold(y)) + bold(z)$, with a *hat*. Writing
     "$bold(y) = bold(y) + bold(z)$" would force $bold(z) = bold(0)$ and say
     nothing.],
    [The formula requires the basis to be *orthogonal*. Applied to an
     arbitrary basis it produces a vector that is not the projection. If your
     basis is not orthogonal, run Gram--Schmidt first.],
    [Which means: on an exam, before using the formula, *show the basis is
     orthogonal* by computing $bold(w)_i dt bold(w)_j = 0$ for each pair.
     That verification is part of the answer, and it is where the marks are.],
  )
]

#exm(title: "Projection onto a plane in " + $RR^3$)[
  Let $bold(w)_1 = vv(3, -1, -2)$, $bold(w)_2 = vv(-1, 1, -2)$,
  $W = Span{bold(w)_1, bold(w)_2}$, and $bold(y) = vv(3, -9, -12)$. Find
  $proj_W bold(y)$.

  *Step 0 --- check orthogonality.* This is what makes the formula legal:
  $
  bold(w)_1 dt bold(w)_2 = (3)(-1) + (-1)(1) + (-2)(-2) = -3 - 1 + 4 = 0.
  quad checkmark
  $
  Neither vector is zero and they are not multiples of each other, so
  ${bold(w)_1, bold(w)_2}$ is an orthogonal basis for $W$.

  *Step 1 --- the four dot products.*
  $
  bold(y) dt bold(w)_1 &= (3)(3) + (-9)(-1) + (-12)(-2) = 9 + 9 + 24 = 42, \
  bold(w)_1 dt bold(w)_1 &= 9 + 1 + 4 = 14, \
  bold(y) dt bold(w)_2 &= (3)(-1) + (-9)(1) + (-12)(-2) = -3 - 9 + 24 = 12, \
  bold(w)_2 dt bold(w)_2 &= 1 + 1 + 4 = 6.
  $

  *Step 2 --- assemble.*
  $
  hat(bold(y)) = proj_W bold(y)
  = 42/14 vv(3, -1, -2) + 12/6 vv(-1, 1, -2)
  = 3 vv(3, -1, -2) + 2 vv(-1, 1, -2)
  = vv(9, -3, -6) + vv(-2, 2, -4)
  = vv(7, -1, -10).
  $

  *Step 3 --- the perpendicular piece, and the check.*
  $
  bold(z) = bold(y) - hat(bold(y)) = vv(3, -9, -12) - vv(7, -1, -10)
  = vv(-4, -8, -2).
  $
  Verify $bold(z) in W^perp$:
  $bold(z) dt bold(w)_1 = -12 + 8 + 4 = 0$ and
  $bold(z) dt bold(w)_2 = 4 - 8 + 4 = 0$. #h(0.3em) $checkmark$
  The distance from $bold(y)$ to $W$ is
  $norm(bold(z)) = sqrt(16 + 64 + 4) = sqrt(84) = 2 sqrt(21)$.
]

#thm(title: "Best Approximation Theorem")[
  Let $W$ be a subspace of $RR^n$, let $bold(y) in RR^n$, and let
  $hat(bold(y)) = proj_W bold(y)$. Then $hat(bold(y))$ is the vector of $W$
  *closest* to $bold(y)$: for every $bold(v) in W$ with
  $bold(v) != hat(bold(y))$,
  $ norm(bold(y) - hat(bold(y))) < norm(bold(y) - bold(v)). $
  Accordingly $hat(bold(y))$ is called the #emph[best approximation to
  $bold(y)$ by a vector in $W$], and the distance from $bold(y)$ to $W$ is
  $ "dist"(bold(y), W) = norm(bold(y) - hat(bold(y))). $
]

#idea[
  For any $bold(v) in W$, split
  $bold(y) - bold(v) = (bold(y) - hat(bold(y))) + (hat(bold(y)) - bold(v))$.
  The first piece is in $W^perp$ and the second is in $W$, so they are
  orthogonal and Pythagoras applies:
  $
  norm(bold(y) - bold(v))^2
  = norm(bold(y) - hat(bold(y)))^2 + norm(hat(bold(y)) - bold(v))^2
  >= norm(bold(y) - hat(bold(y)))^2,
  $
  with equality only when $bold(v) = hat(bold(y))$. Minimizing distance is
  Pythagoras with the error term set to zero.
]

Two consequences fall straight out:

#enum(
  [If $bold(y) in W$ already, then $proj_W bold(y) = bold(y)$ --- the closest
   vector in $W$ to something already in $W$ is itself.],
  [Projecting twice does nothing new:
   $proj_W (proj_W bold(y)) = proj_W hat(bold(y)) = hat(bold(y))$, since
   $hat(bold(y)) in W$ and consequence (1) applies. A projection is
   #emph[idempotent]: once the shadow is cast, casting it again changes
   nothing.],
)

#exm(title: "Closest vector and distance in " + $RR^4$)[
  Let $bold(u)_1 = vv(1, 2, -1, 2)$, $bold(u)_2 = vv(2, -1, 2, 1)$, and
  $W = Span{bold(u)_1, bold(u)_2}$. Show ${bold(u)_1, bold(u)_2}$ is an
  orthogonal basis for $W$; then for $bold(y) = vv(1, 2, 3, 4)$ find the
  closest vector to $bold(y)$ in $W$ and the distance from $bold(y)$ to $W$.

  *Orthogonality.*
  $bold(u)_1 dt bold(u)_2 = 2 - 2 - 2 + 2 = 0$. #h(0.3em) $checkmark$
  Both are nonzero, so the set is an orthogonal --- hence linearly independent
  --- basis for its span.

  *Projection.*
  $
  bold(y) dt bold(u)_1 = 1 + 4 - 3 + 8 = 10, quad
  bold(u)_1 dt bold(u)_1 = 1 + 4 + 1 + 4 = 10, \
  bold(y) dt bold(u)_2 = 2 - 2 + 6 + 4 = 10, quad
  bold(u)_2 dt bold(u)_2 = 4 + 1 + 4 + 1 = 10.
  $
  Both coefficients are $10 slash 10 = 1$, so
  $
  hat(bold(y)) = 1 dot vv(1,2,-1,2) + 1 dot vv(2,-1,2,1) = vv(3, 1, 1, 3).
  $

  *Distance.*
  $
  bold(z) = bold(y) - hat(bold(y)) = vv(1,2,3,4) - vv(3,1,1,3)
  = vv(-2, 1, 2, 1),
  quad
  "dist"(bold(y), W) = norm(bold(z)) = sqrt(4 + 1 + 4 + 1) = sqrt(10).
  $
  Check: $bold(z) dt bold(u)_1 = -2 + 2 - 2 + 2 = 0$ and
  $bold(z) dt bold(u)_2 = -4 - 1 + 4 + 1 = 0$, so $bold(z) in W^perp$ as the
  decomposition theorem requires. #h(0.3em) $checkmark$
]

== Orthogonal matrices

#defn(title: "Orthogonal matrix")[
  A square matrix $U$ is #emph[orthogonal] if its columns form an *orthonormal*
  set, equivalently if
  $ U^T U = I, quad "so" quad U^(-1) = U^T. $
]

Orthogonal matrices preserve dot products, lengths, and angles:
$(U bold(x)) dt (U bold(y)) = bold(x)^T U^T U bold(y) = bold(x) dt bold(y)$,
so $norm(U bold(x)) = norm(bold(x))$. They are exactly the rigid motions
fixing the origin --- rotations and reflections. The rotation matrix of
Chapter 6 is one.

#pitfall[
  The naming is unfortunate but standard: an "orthogonal matrix" needs
  columns that are orthonormal, not merely orthogonal. A matrix whose columns
  are orthogonal but not unit length is *not* an orthogonal matrix.
]

If $U$ has orthonormal columns spanning $W$, the projection formula
collapses, because every denominator $bold(u)_i dt bold(u)_i$ equals $1$:
$
proj_W bold(y) = (bold(y) dt bold(u)_1) bold(u)_1 + dots.c
+ (bold(y) dt bold(u)_k) bold(u)_k = U U^T bold(y).
$

== The Gram–Schmidt process

Orthogonal bases make everything easy, so we need a way to manufacture one
from a basis we already have.

#thm(title: "Gram–Schmidt")[
  Given a basis ${bold(x)_1, dots, bold(x)_p}$ for a subspace $W$ of $RR^n$,
  define
  $
  bold(v)_1 &= bold(x)_1, \
  bold(v)_2 &= bold(x)_2
    - (bold(x)_2 dt bold(v)_1)/(bold(v)_1 dt bold(v)_1) bold(v)_1, \
  bold(v)_3 &= bold(x)_3
    - (bold(x)_3 dt bold(v)_1)/(bold(v)_1 dt bold(v)_1) bold(v)_1
    - (bold(x)_3 dt bold(v)_2)/(bold(v)_2 dt bold(v)_2) bold(v)_2, \
  & #h(0.5em) dots.v \
  bold(v)_p &= bold(x)_p - sum_(j=1)^(p-1)
    (bold(x)_p dt bold(v)_j)/(bold(v)_j dt bold(v)_j) bold(v)_j.
  $
  Then ${bold(v)_1, dots, bold(v)_p}$ is an orthogonal basis for $W$, and at
  every stage $Span{bold(v)_1, dots, bold(v)_k} = Span{bold(x)_1, dots,
  bold(x)_k}$. Normalizing each $bold(v)_i$ gives an orthonormal basis.
]

#idea[
  Each step is one sentence: *take the next vector and subtract off its
  projection onto everything built so far.* What is left over is, by the
  Orthogonal Decomposition Theorem, perpendicular to all of it. The process is
  just repeated application of $bold(z) = bold(y) - proj_W bold(y)$.
]

#exm(title: "Gram–Schmidt in " + $RR^3$)[
  Orthogonalize $bold(x)_1 = vv(1,1,1)$, $bold(x)_2 = vv(0,1,1)$,
  $bold(x)_3 = vv(0,0,1)$.

  $bold(v)_1 = vv(1,1,1)$.

  $bold(x)_2 dt bold(v)_1 = 2$ and $bold(v)_1 dt bold(v)_1 = 3$, so
  $
  bold(v)_2 = vv(0,1,1) - 2/3 vv(1,1,1) = vv(-2/3, 1/3, 1/3).
  $

  $bold(x)_3 dt bold(v)_1 = 1$, and
  $bold(x)_3 dt bold(v)_2 = 1/3$ with
  $bold(v)_2 dt bold(v)_2 = 4/9 + 1/9 + 1/9 = 2/3$, so
  $
  bold(v)_3 = vv(0,0,1) - 1/3 vv(1,1,1) - 1/2 vv(-2/3, 1/3, 1/3)
  = vv(0, -1/2, 1/2).
  $

  Scaling away the fractions (any nonzero multiple of an orthogonal vector is
  still orthogonal) gives the tidy orthogonal basis
  $
  vv(1,1,1), quad vv(-2, 1, 1), quad vv(0, -1, 1).
  $
  Check all three pairs:
  $(1)(-2)+(1)(1)+(1)(1) = 0$, #h(0.4em)
  $(1)(0)+(1)(-1)+(1)(1) = 0$, #h(0.4em)
  $(-2)(0)+(1)(-1)+(1)(1) = 0$. #h(0.3em) $checkmark$
]

== Least squares

Real data gives inconsistent systems: $A bold(x) = bold(b)$ with $bold(b) in.not
Col A$. There is no solution. The best approximation theorem tells us what to
do instead --- replace $bold(b)$ by the nearest thing we *can* hit.

#defn(title: "Least-squares solution")[
  A #emph[least-squares solution] of $A bold(x) = bold(b)$ is a vector
  $hat(bold(x))$ minimizing $norm(bold(b) - A bold(x))$ over all
  $bold(x) in RR^n$.
]

#thm(title: "The normal equations")[
  The least-squares solutions of $A bold(x) = bold(b)$ are exactly the
  solutions of the #emph[normal equations]
  $ A^T A #h(0.1em) hat(bold(x)) = A^T bold(b). $
  If the columns of $A$ are linearly independent, $A^T A$ is invertible and
  the solution is unique:
  $hat(bold(x)) = (A^T A)^(-1) A^T bold(b)$.
]

#idea[
  $A bold(x)$ ranges over exactly $Col A$ as $bold(x)$ ranges over $RR^n$. So
  minimizing $norm(bold(b) - A bold(x))$ means finding the point of $Col A$
  closest to $bold(b)$ --- which, by the Best Approximation Theorem, is
  $proj_(Col A) bold(b)$. We then solve $A hat(bold(x)) =
  proj_(Col A) bold(b)$, which *is* consistent.

  The normal equations are a shortcut that skips computing the projection.
  The residual $bold(b) - A hat(bold(x))$ must lie in
  $(Col A)^perp = Nul A^T$, so $A^T (bold(b) - A hat(bold(x))) = bold(0)$,
  which rearranges to $A^T A hat(bold(x)) = A^T bold(b)$.
]

#exm(title: "Fitting a line to data")[
  Fit $y = c + d x$ to the points $(1,1)$, $(2,2)$, $(3,4)$. The three
  equations $c + d = 1$, $c + 2d = 2$, $c + 3d = 4$ have no common solution,
  so set
  $
  A = mm(1, 1; 1, 2; 1, 3), quad bold(b) = vv(1, 2, 4),
  quad bold(x) = vv(c, d).
  $
  Form the normal equations:
  $
  A^T A = mm(3, 6; 6, 14), quad
  A^T bold(b) = vv(1 + 2 + 4, 1 + 4 + 12) = vv(7, 17),
  $
  so $3c + 6d = 7$ and $6c + 14d = 17$. Doubling the first and subtracting
  gives $2d = 3$, so $d = 3/2$ and then $3c = 7 - 9 = -2$, i.e. $c = -2/3$.
  The least-squares line is
  $ y = -2/3 + 3/2 x. $

  *Check.* The fitted values are $5/6, #h(0.2em) 7/3, #h(0.2em) 23/6$, so the
  residual is $bold(b) - A hat(bold(x)) = vv(1/6, -1/3, 1/6)$. It must be
  orthogonal to both columns of $A$:
  $1/6 - 1/3 + 1/6 = 0$ and $1/6 - 2/3 + 1/2 = 0$. #h(0.3em) $checkmark$
]

Least squares is where this course pays for itself outside of mathematics: it
is the engine behind linear regression, curve fitting, and most of applied
statistics. And it is nothing more than the Best Approximation Theorem applied
to $Col A$.

// ============================================================================
#counter(heading).update(0)
#appendix.update(true)
#set heading(numbering: (..n) => {
  let v = n.pos()
  if v.len() == 1 { "Appendix " + numbering("A", v.first()) }
  else { numbering("A.1", ..v) }
})

= Quick Reference

== The four fundamental subspaces

Let $A$ be $m times n$ with $rank A = r$.

#table(
  columns: (auto, auto, auto, 1fr),
  [Subspace], [Lives in], [Dimension], [Basis: how to find it],
  [$Col A$],   [$RR^m$], [$r$],     [pivot columns *of the original $A$*],
  [$Row A$],   [$RR^n$], [$r$],     [nonzero rows *of an echelon form*],
  [$Nul A$],   [$RR^n$], [$n - r$], [vectors in the parametric form of
                                     $A bold(x) = bold(0)$, one per free
                                     variable],
  [$Nul A^T$], [$RR^m$], [$m - r$], [same recipe applied to $A^T$],
)

The pairings: $Row A = (Nul A)^perp$ in $RR^n$, and
$Col A = (Nul A^T)^perp$ in $RR^m$.

== Deciding what a question is really asking

#table(
  columns: (auto, 1fr),
  [If asked...], [Do this],
  [Is $A bold(x) = bold(b)$ consistent?],
    [Row reduce $[A #h(0.2em) bold(b)]$; look for a row
     $[0 dots 0 | b]$, $b != 0$.],
  [Are these vectors independent?],
    [Row reduce; independent $<==>$ a pivot in every column.],
  [Do these vectors span $RR^m$?],
    [Row reduce; spanning $<==>$ a pivot in every row.],
  [Is this set a subspace?],
    [Check $bold(0) in H$ first --- it usually fails. Then closure under
     $+$ and scaling.],
  [Basis for $Nul A$?],
    [RREF, parametric vector form, one vector per free variable.],
  [Basis for $Col A$?],
    [RREF to locate pivots, then take those columns *from $A$*.],
  [Is $A$ invertible?],
    [Count pivots, or take $det A$. Never compute $A^(-1)$ to find out.],
  [Is $T$ one-to-one / onto?],
    [Pivot in every column / pivot in every row.],
  [Eigenvalues?],
    [Solve $det(A - lambda I) = 0$. Do *not* row reduce $A$ first.],
  [Eigenvectors for $lambda$?],
    [Basis for $Nul(A - lambda I)$.],
  [Closest vector in $W$ to $bold(y)$?],
    [Verify the basis is orthogonal, then $proj_W bold(y)$.],
  [Distance from $bold(y)$ to $W$?],
    [$norm(bold(y) - proj_W bold(y))$.],
  [$A bold(x) = bold(b)$ has no solution --- now what?],
    [Least squares: solve $A^T A hat(bold(x)) = A^T bold(b)$.],
)

#pagebreak(weak: true)
== Formulas

#grid(columns: (1fr, 1fr), gutter: 16pt,
  [
    *Dot product and length*
    $ bold(u) dt bold(v) = u_1 v_1 + dots.c + u_n v_n $
    $ norm(bold(v)) = sqrt(bold(v) dt bold(v)) $
    $ "dist"(bold(u), bold(v)) = norm(bold(u) - bold(v)) $

    *Projection onto a line*
    $ comp_bold(u) bold(y) = (bold(y) dt bold(u))/norm(bold(u)) $
    $ proj_bold(u) bold(y)
      = (bold(y) dt bold(u))/(bold(u) dt bold(u)) bold(u) $

    *$2 times 2$ inverse*
    $ mm(a,b;c,d)^(-1) = 1/(a d - b c) mm(d, -b; -c, a) $
  ],
  [
    *Projection onto a subspace* \
    (orthogonal basis $bold(w)_1, dots, bold(w)_k$ of $W$)
    $ proj_W bold(y) = sum_(i=1)^k
      (bold(y) dt bold(w)_i)/(bold(w)_i dt bold(w)_i) bold(w)_i $

    *Rank–nullity*
    $ rank A + dm Nul A = n $

    *Characteristic equation*
    $ det(A - lambda I) = 0 $

    *Normal equations*
    $ A^T A hat(bold(x)) = A^T bold(b) $
  ]
)

= Exam Checklist

Things worth being able to do cold, drawn from the semester's review sessions.

#block(inset: (left: 11.5pt, top: 2pt, bottom: 2pt), stroke: (left: 2.25pt + accent))[
  *Structural questions.* These recur every term and are pure bookkeeping once
  you see the pattern.

  #enum(
    [*"List all reduced echelon forms of size $k times k$."* Reason by pivot
     count and pivot position, not by trial and error. For $2 times 2$ the
     answer is the four matrices in §2.3.],
    [*"What are the possible dimensions of $Col A$ / $Nul A$ for an
     $m times n$ matrix?"* $0 <= rank A <= min(m, n)$, and then
     $dm Nul A = n - rank A$ fills in the rest.],
    [*"Put this matrix in standard form."* Identify which form is being asked
     for --- echelon, *reduced* echelon, or a specific factorization --- and
     say which one you produced. Echelon form is not unique; the RREF is.],
  )
]

#v(0.5em)

#grid(columns: (1fr, 1fr), gutter: 14pt,
  aside(cDefn, "Know verbatim")[
    #set text(size: 9.8pt)
    - Linear independence and span
    - Basis, dimension, rank
    - Subspace (all three conditions)
    - $Nul A$, $Col A$, $Row A$
    - Invertible matrix
    - Linear transformation
    - Eigenvalue and eigenvector
    - Orthogonal set, orthogonal basis
    - $W^perp$
  ],
  aside(cThm, "Know when they apply")[
    #set text(size: 9.8pt)
    - Existence and uniqueness (Ch. 3)
    - Structure of solution sets (Ch. 3)
    - Rank–nullity (Ch. 4)
    - The IMT --- *square matrices only* (Ch. 5)
    - One-to-one / onto criteria (Ch. 6)
    - $det A != 0 <==> A$ invertible (Ch. 8)
    - Orthogonal decomposition (Ch. 10)
    - Best approximation (Ch. 10)
    - Normal equations (Ch. 10)
  ]
)

#v(0.5em)

#pitfall[
  *The mistakes that cost the most marks.*
  #enum(
    [Taking pivot columns from the echelon form instead of from $A$.],
    [Using the projection formula on a basis you never checked was
     orthogonal.],
    [Applying the IMT to a non-square matrix.],
    [Row reducing $A$ before finding its eigenvalues.],
    [Confusing $m$ and $n$ in rank--nullity --- it is the number of
     *columns*.],
    [Forgetting that $bold(0)$ belongs to $Nul A$ and to every eigenspace,
     but is never itself an eigenvector.],
    [Writing $bold(y) dt bold(y)$ where the projection formula wants
     $bold(y) dt bold(u)$.],
  )
]

#v(0.8em)

#align(center)[
  #block(width: 88%)[
    #set par(justify: true)
    #set align(left)
    #calloutbox(cNote, [#calloutmark(cNote)#h(0.42em)], [*One last thing.* Almost every computation in this course reduces to one
    of three moves: *row reduce something*, *take a dot product*, or *take a
    determinant*. When a problem looks unfamiliar, the useful question is not
    "what formula is this?" but "which of those three am I being asked to do,
    and to which matrix?" The formula usually follows from the answer.])
  ]
]
