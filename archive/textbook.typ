// =========================================================================
// Differential Equations — a first course in second-order linear equations,
// their applications, and the Laplace transform.
//
// Compile:  typst compile textbook.typ
//
// The font stacks below name several faces that may not be installed. Typst
// warns once per missing family and falls through to the next; the warnings
// are expected and the rendering is correct without them.
// =========================================================================

// ---- palette ------------------------------------------------------------
// A light, low-contrast paper palette. Five accent hues carry meaning: blue
// for the core thread, green for operations, purple for decompositions, red
// for solving, and a dark yellow for iteration.
#let lin-ground = rgb("#f6f8fb")
#let lin-surface = rgb("#ffffff")
#let lin-surface-2 = rgb("#eef2f7")
#let lin-ink = rgb("#16202e")
#let lin-ink-soft = rgb("#3f4b5b")
#let lin-muted = rgb("#6b7684")
#let lin-line = rgb("#dbe2ea")
#let lin-line-soft = rgb("#e8edf3")

#let lin-core = rgb("#1a5fb4")    // blue
#let lin-ops = rgb("#2e7d32")     // green
#let lin-decomp = rgb("#613583")  // purple
#let lin-solve = rgb("#a51d2d")   // red
#let lin-iter = rgb("#6c5b00")    // dark yellow
#let lin-accent = lin-core

#let lin-code-bg = rgb("#f4f6f9")
#let lin-code-ink = rgb("#24303f")

// ---- font stacks --------------------------------------------------------
// An old-style serif for the body, a neutral sans for eyebrow headings and
// tables, a mono for section numbers. Each stack names its preferred faces
// first and falls through to what a Typst install actually ships.
#let lin-serif = (
  "Iowan Old Style", "Charter", "Palatino Linotype", "Palatino",
  "Georgia", "Cambria", "Libertinus Serif", "New Computer Modern",
)
#let lin-sans = (
  "Inter", "Segoe UI", "Roboto", "Helvetica Neue", "Helvetica",
  "Arial", "DejaVu Sans",
)
#let lin-mono = (
  "SF Mono", "JetBrains Mono", "JetBrainsMono NFM", "Cascadia Code",
  "Menlo", "Consolas", "DejaVu Sans Mono",
)

// ---- the gradient rule --------------------------------------------------
// A 2pt rounded bar running through all five accent hues in order. Drawn as
// a filled rectangle, since a stroke cannot carry a gradient.
#let hr() = block(
  width: 100%,
  height: 2pt,
  above: 1.9em,
  below: 1.1em,
  radius: 1pt,
  fill: gradient.linear(lin-core, lin-ops, lin-decomp, lin-solve, lin-iter),
)

// ---- environments -------------------------------------------------------
// The boxed statement and commentary environments. Two axes of information:
// the hue names the family, the glyph names the specific environment.
#let cal-blue = rgb("#007aff")
#let cal-cyan = rgb("#30b0c7")
#let cal-purple = rgb("#af52de")
#let cal-indigo = rgb("#5856d6")
#let cal-green = rgb("#34c759")
#let cal-gray = rgb("#8e8e93")
#let cal-orange = rgb("#ff9500")
#let cal-red = rgb("#ff3b30")
#let cal-pink = rgb("#ff2d55")

#let _env-counter = counter("environment")

// Headings are numbered so that the built-in counter steps and the contents
// page can show chapter numbers; the show rules below print `it.body` alone,
// so no number appears inline in the text itself. `_chap-fmt` tells the
// environment boxes whether they are in chapter 3 or chapter C.
#let _chap-fmt = state("chap-fmt", "1")

// Counts sections within the current chapter, so the first section of a
// chapter can skip its top rule -- the chapter opener has just drawn one,
// and two rules a line apart read as an artefact.
#let _sec-in-chap = counter("section-in-chapter")

// The fill is the type's own hue at 10% over white, which is exactly
// `lighten(90%)`; the hairline border is the same hue at 45% alpha. The label
// is darkened 30% because these hues are tuned as fills, not as body-size
// text -- at full saturation the orange sits near 2:1 on its own tint.
#let _callout(kind, hue, glyph, title, body, counted: true, italic: false) = {
  if counted { _env-counter.step() }
  block(
    width: 100%,
    fill: hue.lighten(90%),
    stroke: 0.6pt + hue.transparentize(55%),
    inset: (x: 11pt, y: 9pt),
    radius: 3pt,
    above: 1.15em,
    below: 1.15em,
    breakable: true,
    context {
      let head = if counted {
        let c = counter(heading).get().first()
        let n = _env-counter.get().first()
        let f = _chap-fmt.get()
        if c > 0 [#kind #numbering(f + ".1", c, n)] else [#kind #n]
      } else { [#kind] }
      grid(
        columns: (1.15em, 1fr),
        column-gutter: 8pt,
        align: (center + top, left + top),
        text(fill: hue.darken(30%), size: 1.15em, glyph),
        {
          text(weight: "bold", fill: hue.darken(30%), head)
          if title != none { text(weight: "bold", fill: lin-ink)[ (#title)] }
          text(weight: "bold", fill: lin-ink)[.]
          h(0.45em)
          if italic { emph(body) } else { body }
        },
      )
    },
  )
}

// Statement environments: asserted, and either proved or definitional.
#let thm(title: none, body) = _callout("Theorem", cal-indigo, [★], title, body)
#let prop(title: none, body) = _callout("Proposition", cal-blue, [◆], title, body)
#let lem(title: none, body) = _callout("Lemma", cal-cyan, [◇], title, body)
#let cor(title: none, body) = _callout("Corollary", cal-blue, [↳], title, body)
#let def(title: none, body) = _callout("Definition", cal-purple, [≝], title, body)

// A formula worth keeping to hand.
#let form(title: none, body) = _callout("Formula", cal-green, [∮], title, body)

// Commentary: present but recessive, and never numbered.
#let hum(title: none, body) = _callout("Intuition", cal-green, [❋], title, body, counted: false)
#let case(title: none, body) = _callout("Case", cal-gray, [⊳], title, body, counted: false)
#let ques(title: none, body) = _callout("Question", cal-orange, [?], title, body, counted: false)

// A warning and a takeaway mean opposite things, so they are kept on
// separate hues; sharing a red made them read as one type.
#let imp(title: none, body) = _callout("Important", cal-red, [⚠], title, body, counted: false)
#let key(title: none, body) = _callout("Key", cal-pink, [✦], title, body, counted: false)

// Deliberately the quietest block on the page: a proof is long and read
// linearly, so it should not compete with the statement it follows. Italic
// body, closed by a tombstone.
#let pf(title: none, body) = _callout(
  "Proof", cal-gray, [✎], title, [#body #h(1fr) $qed$],
  counted: false, italic: true,
)

// Worked examples and solutions, in the same visual language.
#let example(title: none, body) = _callout("Example", cal-cyan, [▶], title, body)
#let soln(title: none, body) = _callout("Solution", cal-green, [✓], title, body, counted: false)
#let remark(title: none, body) = _callout("Remark", cal-gray, [※], title, body, counted: false)

// ---- native plotting helper, used for the figures --------------------
// Small enough not to need a package: each segment is sampled, clipped to the
// y-window, and drawn as one polyline. Colours come from the palette above so
// the figures sit in the same system as the prose.
#let plot(
  segments,
  xlim: (0, 5), ylim: (-1, 2),
  width: 10.5cm, height: 4.4cm,
  xticks: (), yticks: (),
  xlabel: none, ylabel: none,
  marks: (),
  samples: 200,
) = align(center, block(above: 1.1em, below: 1.1em, breakable: false, {
  let (x0, x1) = xlim
  let (y0, y1) = ylim
  let X = v => (v - x0) / (x1 - x0) * width
  let Y = v => height - (v - y0) / (y1 - y0) * height
  let tick = text.with(font: lin-sans, size: 6.5pt, fill: lin-muted)
  block(width: width, height: height, inset: 0pt, breakable: false, {
    if y0 <= 0 and 0 <= y1 {
      place(dy: Y(0), line(length: width, stroke: 0.5pt + lin-muted))
    }
    if x0 <= 0 and 0 <= x1 {
      place(dx: X(0), line(angle: 90deg, length: height, stroke: 0.5pt + lin-muted))
    }
    for t in xticks {
      place(dx: X(t), dy: Y(0), line(angle: 90deg, length: 3pt, stroke: 0.5pt + lin-muted))
      place(dx: X(t) - 8pt, dy: Y(0) + 4.5pt, box(width: 16pt, align(center, tick[#t])))
    }
    for t in yticks {
      place(dx: X(0), dy: Y(t), line(length: 3pt, stroke: 0.5pt + lin-muted))
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
          paint: seg.at("paint", default: lin-core), thickness: 1pt,
          dash: seg.at("dash", default: none),
        ),
        curve.move(pts.first()),
        ..pts.slice(1).map(p => curve.line(p)),
      ))
    }
    for m in marks {
      place(dx: X(m.x) - 1.7pt, dy: Y(m.y) - 1.7pt, circle(
        radius: 1.7pt,
        fill: if m.at("open", default: false) { white } else { lin-core },
        stroke: 0.7pt + lin-core,
      ))
    }
    if xlabel != none { place(dx: width - 8pt, dy: Y(0) + 5pt, tick[#xlabel]) }
    if ylabel != none { place(dx: X(0) + 5pt, dy: -3pt, tick[#ylabel]) }
  })
}))

// Front matter titles carry the chapter opener's look without stepping the
// chapter counter or entering the outline.
#let front-title(body) = block(above: 0pt, below: 1.4em, {
  set text(size: 25pt, weight: 600, fill: lin-ink, tracking: -0.02em)
  set par(justify: false, leading: 0.26em)
  body
  v(0.5em, weak: true)
  line(length: 100%, stroke: 1pt + lin-line)
})

// A legend row: the callout look with the label in place of the numbered
// head, for the key in the preface.
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
    text(fill: hue.darken(30%), size: 1.15em, glyph),
    [#text(weight: "bold", fill: hue.darken(30%), kind) #desc],
  ),
)

// ---- document shell -----------------------------------------------------
#let textbook(title: "", subtitle: none, author: none, term: none, body) = {
  set document(title: title, author: if author == none { () } else { author })
  set page(
    paper: "us-letter",
    margin: (x: 1.15in, top: 1in, bottom: 1.1in),
    fill: lin-surface,
    numbering: "1",
    number-align: center,
  )
  // Sized to the measure a 1.15in margin leaves on US Letter: roughly 65
  // characters a line, which is where long prose reads most comfortably.
  set text(font: lin-serif, size: 11pt, fill: lin-ink, lang: "en")
  set par(justify: true, leading: 0.68em, spacing: 1.05em)

  // Rotated square bullets in the accent colour, rather than discs.
  set list(marker: text(fill: lin-accent, size: 0.62em)[◆], indent: 0.6em, spacing: 0.75em)
  set enum(indent: 0.6em, spacing: 0.75em)

  // Display maths: centred, with its own vertical rhythm.
  set math.equation(numbering: none)
  show math.equation.where(block: true): set block(above: 1.15em, below: 1.15em)

  show link: set text(fill: lin-core)
  show raw.where(block: false): box.with(
    fill: lin-code-bg, inset: (x: 3pt, y: 0pt), outset: (y: 3pt), radius: 2pt,
  )
  show raw: set text(font: lin-mono, size: 0.86em, fill: lin-code-ink)
  show raw.where(block: true): block.with(
    fill: lin-code-bg, inset: 9pt, radius: 3pt, width: 100%,
  )

  // --- headings ---
  // Numbered so the counter steps (the contents page reads it); the show
  // rules render `it.body` only, so the number never appears inline.
  set heading(numbering: "1.1")

  // h1 == a part opener. `--h1-size: clamp(2.4rem, 6vw, 3.4rem)`, weight 600,
  // line-height 1.04, letter-spacing -0.02em, balanced.
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    _env-counter.update(0)
    _sec-in-chap.update(0)
    block(above: 0pt, below: 1.4em, {
      context {
        let n = counter(heading).get().first()
        let f = _chap-fmt.get()
        if n > 0 {
          // decimal-leading-zero: 01, 02, ... but A, B, C in the appendices
          let label = if f == "1" and n < 10 { "0" + str(n) } else { numbering(f, n) }
          text(font: lin-mono, size: 9pt, weight: "medium", fill: lin-accent,
               tracking: 0pt, label)
          v(0.35em, weak: true)
        }
      }
      set text(size: 25pt, weight: 600, fill: lin-ink, tracking: -0.02em)
      set par(justify: false, leading: 0.26em)
      it.body
      v(0.5em, weak: true)
      line(length: 100%, stroke: 1pt + lin-line)
    })
  }

  // Sections are separated by a hairline with breathing room above -- except
  // for the first section of a chapter, which already sits under the opener
  // rule, where a second line an inch below reads as an artefact.
  show heading.where(level: 2): it => block(above: 0.9em, below: 0.75em, {
    _sec-in-chap.step()
    context {
      if _sec-in-chap.get().first() > 1 {
        v(1.25em, weak: true)
        line(length: 100%, stroke: 0.5pt + lin-line-soft)
        v(0.9em, weak: true)
      }
    }
    set text(size: 15pt, weight: 600, fill: lin-ink, tracking: -0.015em)
    set par(justify: false, leading: 0.4em)
    it.body
  })

  show heading.where(level: 3): it => block(above: 1.5em, below: 0.55em, {
    set text(size: 12pt, weight: 600, fill: lin-ink, tracking: -0.01em)
    it.body
  })

  // h4-h6 become sans-serif uppercase eyebrows in the muted ink.
  show heading.where(level: 4): it => block(above: 1.3em, below: 0.45em, {
    set text(font: lin-sans, size: 8.5pt, weight: 700, fill: lin-muted, tracking: 0.08em)
    upper(it.body)
  })
  show heading.where(level: 5): it => block(above: 1.2em, below: 0.4em, {
    set text(font: lin-sans, size: 8pt, weight: 700, fill: lin-muted, tracking: 0.08em)
    upper(it.body)
  })

  // Borderless tables: sans, uppercase muted header over a rule, hairline
  // row separators, cell text in the soft ink. No vertical strokes at all.
  set table(
    stroke: (x, y) => (
      top: if y == 0 { none } else if y == 1 { 0.7pt + lin-line } else { 0.4pt + lin-line-soft },
      bottom: none, left: none, right: none,
    ),
    inset: (x: 7pt, y: 6pt),
    fill: none,
  )
  show table.cell.where(y: 0): it => text(
    font: lin-sans, size: 7.5pt, weight: 600, fill: lin-muted, tracking: 0.06em,
  )[#upper(it.body)]
  show table.cell: it => if it.y == 0 { it } else {
    text(size: 9.5pt, fill: lin-ink-soft, it)
  }

  // Blockquote: accent left border, soft ink.
  show quote.where(block: true): it => block(
    stroke: (left: 2.5pt + lin-accent), inset: (left: 12pt, y: 3pt),
    above: 1.1em, below: 1.1em,
    text(fill: lin-ink-soft, it.body),
  )

  // --- title page ---
  v(2.2in)
  block(width: 100%, {
    set par(justify: false, leading: 0.3em)
    text(size: 34pt, weight: 600, fill: lin-ink, tracking: -0.02em, title)
    if subtitle != none {
      v(0.55em)
      text(size: 14pt, weight: 400, fill: lin-ink-soft, tracking: -0.01em, subtitle)
    }
  })
  v(1.1em)
  hr()
  v(0.4em)
  block(width: 100%, {
    set par(justify: false)
    set text(font: lin-sans, size: 8.5pt, fill: lin-muted, tracking: 0.08em)
    upper[
      #if author != none [#author]
      #if author != none and term != none [ #h(0.6em) · #h(0.6em) ]
      #if term != none [#term]
    ]
  })

  pagebreak()
  body
}

#show: textbook.with(
  title: "Differential Equations",
  subtitle: "Lecture notes, worked examples and problem sets, collected",
  author: "Aren Vista",
  term: "MATH 225 · Fall 2025",
)

// =========================================================================
#front-title[Preface]

A differential equation is a sentence about change. It does not tell you what
a quantity *is*; it tells you how the quantity and its rates of change are
tied to one another, and leaves you to recover the quantity itself. That is
why the subject repays study: the laws governing springs, circuits,
populations and cooling coffee are all most naturally written as statements
about rates, and solving them is how those statements become predictions.

This book is about one family of such equations — *second-order linear*
equations — together with the transform method that handles them when the
forcing is switched on and off abruptly. The scope is deliberately narrow so
that the ideas can be developed properly rather than surveyed.

*What is assumed.* Single-variable calculus: differentiation, integration by
parts and by substitution, partial fractions, and Taylor series. A little
linear algebra appears in two places — determinants of $2 times 2$ matrices,
and Cramer's rule — and both are stated in full where they are needed, so no
prior course is required.

*How the book is arranged.* Chapter 1 fixes vocabulary: what a differential
equation is, what makes one linear, and why that matters more than anything
else about it.

Chapters 2 to 5 develop the *homogeneous* second-order equation, where almost
all the structure lives. Chapter 2 settles when a solution exists and when it
is unique. Chapter 3 shows that two independent solutions determine every
other one, and gives the Wronskian as the test for independence. Chapter 4
extracts a second solution from a first. Chapter 5 solves the
constant-coefficient case outright, by reducing it to a quadratic.

Chapters 6 to 8 add a forcing term. Chapter 6 shows how the answer splits
into two pieces; Chapters 7 and 8 give two methods for finding the second
piece — one quick and restricted, one slower and general.

Chapter 9 applies all of it to a mass on a spring, which is the physical
picture every symbol in Chapters 2 to 8 has been standing in for. Chapter 10
develops the Laplace transform, which solves initial value problems by
turning calculus into algebra, and copes with forcing that switches on and
off — which nothing earlier in the book can.

Three chapters of fully worked problems follow, with the reasoning set out at
the length a first reader needs rather than the length an examiner would
accept.

*How to read it.* Results are boxed and numbered by chapter, so
"Theorem 3.7" is the seventh numbered box in Chapter 3. The boxes are
colour-coded by what they claim:

#v(0.5em)
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.1em,
  [
    #legend("Definitions", cal-purple, [≝])[fix language and assert nothing.]
    #legend("Theorems", cal-indigo, [★])[are results that have been proved.]
    #legend("Formulas", cal-green, [∮])[are worth keeping to hand.]
  ],
  [
    #legend("Examples", cal-cyan, [▶])[pose a concrete instance, then solve it.]
    #legend("Key ideas", cal-pink, [✦])[are the takeaways worth memorising.]
    #legend("Warnings", cal-red, [⚠])[flag a trap worth avoiding.]
  ],
)

Solutions, intuitions, cases and remarks appear in the same style. A reader
in a hurry can take the shape of a chapter from its boxes alone; a reader
working through it will want the prose between them, which is where the
reasons live.

#pagebreak()
#front-title[Contents]
#outline(title: none, depth: 2, indent: 1.1em)

// =========================================================================
// FOUNDATIONS
// =========================================================================
= First Notions

== What is a differential equation?

#def(title: "Differential equation")[
  A differential equation is one that relates
  - _the derivatives of an unknown function_,
  - _the function itself_,
  - _the variables on which the function is defined_,
  - and the constants associated with them.
]

If the unknown function depends on a single real variable, the differential
equation is called an *ordinary* differential equation. If it depends on more
than one, and the equation involves partial derivatives with respect to more
than one of them, it is a *partial* differential equation. Everything in this
volume is ordinary.

== Ordinary differential equations

#def(title: "ODE")[
  An ordinary differential equation is a differential equation in which the
  unknown function depends on a single real variable.
]

For example,

$ (dif y)/(dif x) + y = y^2 $
$ (dif^2 y)/(dif x^2) = x y $
$ x^2 (dif^2 y)/(dif x^2) + x (dif y)/(dif x) + (x^2 - 4) y = 0 $
$ (dif^2 y)/(dif x^2) - (1 - y^2) (dif y)/(dif x) + y = 0 $

In each of these:

- the unknown quantity $y = y(x)$ is called the _dependent variable_;
- the real variable $x$ is called the _independent variable_.

== Partial differential equations

#def(title: "PDE")[
  A partial differential equation is one that contains partial derivatives
  with respect to more than one independent variable.
]

For example,

$ (partial u)/(partial x) + (partial u)/(partial y) = 0. $

Observe that in a PDE the equation contains *partial derivatives* with
respect to *more than one independent variable* — both halves of that
sentence matter.

== Linearity

Linear differential equations are those that do *not* contain _products,
powers, or quotients_ of the unknown function and its derivatives.

#def(title: "Linear ODE")[
  An $n$th-order ODE is *linear* when it can be written in the form
  $
  a_0(x) (dif^n y)/(dif x^n) + a_1(x) (dif^(n-1) y)/(dif x^(n-1))
    + dots.h + a_(n-1) (x) (dif y)/(dif x) + a_n (x) y = f(x),
  $
  with $a_0(x) != 0$.
]

Observe:

- The *functions* $a_0(x), dots.h, a_n (x)$ are called the *coefficients* of
  the differential equation.
- $f(x)$ is called the *non-homogeneous term*.

When the coefficients are *constant functions*, the equation is said to have
*constant coefficients*. The equation itself is said to be

- *homogeneous* if $f(x) equiv 0$;
- *non-homogeneous* if $f(x)$ is _not_ identically zero.

An ODE that cannot be written in the general form above is called a
*non-linear* ordinary differential equation.

== Why linearity is the dividing line

Non-linear equations are not merely harder versions of linear ones; they
behave differently in kind, and the difference is worth seeing early.

#def(title: "Non-linear ODE")[
  A non-linear ordinary differential equation is one that cannot be written
  in the form of the definition above — that is, one in which the unknown
  function or one of its derivatives appears inside a product, a power other
  than the first, a quotient, or a non-linear function such as $sin$, $ln$ or
  a square root.
]

#example(title: "Spotting the non-linearity")[
  In each equation below, the offending term is the one that would have to go
  for the equation to become linear.

  - $y'' + y y' + y = x$ — the product $y y'$ pairs the unknown with its own
    derivative.
  - $y'' + x y' + y^2 = 0$ — the square $y^2$ is a power other than the
    first.
  - $y'' + y = sin(y)$ — the unknown sits inside a non-linear function. Note
    that $sin(x)$ on the right would be perfectly acceptable: what matters is
    whether $y$ is inside.

  By contrast $y'' + 3 y' + 2 y = 0$ and
  $(dif^4 y)\/(dif x^4) + 3 y = sin(x)$ are linear, however complicated they
  look. Coefficients may be any functions of $x$ whatever, and the forcing
  term may be anything at all.
]

#key(title: "What linearity buys")[
  If $y_1$ and $y_2$ both solve a linear homogeneous equation, so does
  $c_1 y_1 + c_2 y_2$ for any constants $c_1, c_2$. Solutions can be added
  and scaled.

  This one fact — the *superposition principle* of Chapter 3 — is what makes
  the rest of this book possible. It means the whole solution set is
  described by a couple of representative solutions, so finding two solutions
  is as good as finding all of them. For a non-linear equation it fails
  outright: the sum of two solutions is generally not a solution, and there
  is no route from a few solutions to the rest.
]

#hum[
  A quick test for linearity: replace $y$ by $c y$ in the equation with zero
  on the right, and ask whether the constant $c$ factors cleanly out of every
  term. For $y'' + p y' + q y$ it does, leaving $c(y'' + p y' + q y)$. For
  $y'' + y y'$ it does not, because the product picks up a $c^2$. That
  failure to factor is exactly what superposition needs and non-linear
  equations lack.
]

=== Linear against non-linear: a table

The four attributes that get read off an equation at a glance are its
linearity, its order, its homogeneity and whether its coefficients are
constant or variable.

#table(
  columns: (2.2fr, 1fr, 0.6fr, 1.3fr, 1.2fr),
  align: (center, left, center, left, left),
  table.header[Equation][Linearity][Order][Homogeneity][Coefficients],
  $ (dif y)/(dif x) = 1 $, [Linear], [1], [Non-homogeneous], [Variable],
  $ (dif^2 y)/(dif x^2) + y (dif y)/(dif x) + y = x $, [Non-linear], [2], [—], [—],
  $ (dif^2 y)/(dif x^2) + x (dif y)/(dif x) + y^2 = 0 $, [Non-linear], [2], [—], [—],
  $ (dif^2 y)/(dif x^2) + 3 (dif y)/(dif x) + 2 y = 0 $, [Linear], [2], [Homogeneous], [Constant],
  $ (dif^2 y)/(dif x^2) + y = sin(y) $, [Non-linear], [2], [—], [—],
  $ (dif^4 y)/(dif x^4) + 3 y = sin(x) $, [Linear], [4], [Non-homogeneous], [Constant],
)

Homogeneity and the constant/variable distinction are defined above only
for the linear form, so the non-linear rows are left blank rather than forced
into categories that do not apply to them.

// =========================================================================
// SECOND-ORDER LINEAR EQUATIONS
// =========================================================================
= Second-Order Linear Equations

== The general form

A second-order linear equation is written

$ a_0(x) y'' + a_1(x) y' + a_2(x) y = g(x), $

where $g(x)$ is assumed continuous on $I = [a, b]$. Dividing through by
$a_0(x)$ puts it in the *standard form* that the rest of this volume uses:

$ y'' + p(x) y' + q(x) y = f(x). $

When $f(x) equiv 0$ the equation is *homogeneous*:

$ y'' + p(x) y' + q(x) y = 0. $

Almost every technique that follows is a technique for the homogeneous
equation first, with the non-homogeneous case built on top of it.

== The initial value problem

An initial value problem for a second-order equation is the equation

$ F(x, y, y', y'') = 0, quad "or in standard form" quad y'' + p y' + q y = f(x), $

together with two *initial conditions*

$ y(x_0) = y_0, quad y'(x_0) = y_1, $

where $y_0$ and $y_1$ are given constants. Two conditions, because the
equation is of order two — a first-order equation needs one, an $n$th-order
equation needs $n$.

== Existence and uniqueness

#thm(title: "Existence and uniqueness")[
  Let $p(x)$, $q(x)$ and $f(x)$ be continuous on $(a, b)$, and let
  $x_0 in (a, b)$. Then for any two numbers $y_0, y_1$ there exists one and
  only one function satisfying

  $ y'' + p y' + q y = f(x) $

  on the interval $(a, b)$ which also satisfies the initial conditions
  $y(x_0) = y_0$ and $y'(x_0) = y_1$.
]

The theorem is worth reading twice, because it is what licenses everything
later: once two initial conditions are pinned down, the solution is *the*
solution. There is nothing left to find.

#example(title: "Largest interval of a unique solution")[
  Determine the largest interval containing a unique solution of
  $
  y'' + 1/(x - 1) y = e^(-x),
  $
  given the initial conditions $y(0) = 1$ and $y'(0) = 0$.
]

#soln[
  Read the coefficients off the standard form:

  $ p = 0, quad q = 1/(x - 1), quad f(x) = e^(-x). $

  Now $p$ and $f(x)$ are continuous on $(-infinity, infinity)$; $q$, however,
  is not continuous at $x = 1$. That leaves two candidate intervals:

  - $(-infinity, 1)$
  - $(1, infinity)$

  The point of interest is $x_0 = 0$, and only the first interval contains
  it. So $(-infinity, 1)$ is the answer.
]

#hum[
  The theorem never asks where the solution is *nice*; it asks where the
  three coefficient functions are *continuous*, and then where the initial
  point sits. Locating the discontinuities and then asking which side $x_0$
  falls on is the whole method.
]

= Fundamental Solutions of Homogeneous Equations

*Motivation.* The aim of this chapter is to show that every solution of the
homogeneous equation can be written as

$ y = c_1 y_1 + c_2 y_2, $

where $y_1$ and $y_2$ are two linearly independent solutions. Two solutions,
found any way at all, and the entire solution set follows.

== Linear dependence and independence

#def(title: "Linear dependence")[
  Two functions $f(x)$ and $g(x)$ are linearly *dependent* on $I = [a, b]$ if
  there exist constants $k_1, k_2$, not both zero, such that
  $
  k_1 f(x) + k_2 g(x) = 0 quad "for all" x in I.
  $
  They are linearly *independent* on $I$ if no such pair exists — that is, if
  $k_1 f(x) + k_2 g(x) = 0$ for all $x in I$ forces $k_1 = k_2 = 0$.
]

=== Examples of dependence

#example(title: "Exponential against linear")[
  $ f(x) = e^x, quad g(x) = x + 1. $
  Independent: no constant multiple of a linear function is an exponential.
]

#example(title: "A double-angle identity in disguise")[
  $ f(x) = sin(2x), quad g(x) = sin(x) cos(x). $
  Since $f(x) = 2 sin(x) cos(x) = 2 g(x)$, the two are linearly *dependent* —
  $f$ is a constant multiple of $g$.
]

#example(title: "Same function, and a near miss")[
  Clearly
  $ f(x) = sin(x), quad g(x) = sin(x) $
  are linearly dependent. But
  $ f(x) = e^x sin(x), quad g(x) = e^(-x) sin(x) $
  are linearly independent: there is no constant taking $f$ to $g$, because
  the ratio $e^(2x)$ is not constant.
]

#example(title: "The zero function")[
  $ f(x) = 0, quad g(x) = "any function". $
  Always linearly dependent: take $g$ and multiply its output by $0$ to get
  $f$, which is identically zero.
]

What if the dependence relation is not obvious? Then the identity has to be
detected rather than spotted, and the tool for that is the Wronskian.

== The Wronskian

#def(title: "Wronskian")[
  Given two differentiable functions $y_1$ and $y_2$, the function
  $
  W(y_1, y_2) = mat(delim: "|", y_1, y_2; y'_1, y'_2) = y_1 y'_2 - y'_1 y_2
  $
  is called the *Wronskian* of $y_1$ and $y_2$.
]

Notice this is really the determinant of the matrix
$A = mat(delim: "[", y_1, y_2; y'_1, y'_2)$, so that
$det(A) = |A| = W(y_1, y_2)$.

#remark[
  The Wronskian is a *determinant*, not a matrix: at each value of $x$ it is
  a single number, not an array. Vertical bars are used here rather than
  square brackets to keep that visible. The distinction matters because the
  next two theorems turn on whether the Wronskian is zero, and only a number
  can be.
]

#thm(title: "Wronskian test for independence")[
  Assume $p(x)$ and $q(x)$ are continuous on $[a, b]$ in
  $y'' + p y' + q y = 0$, and let $y_1, y_2$ be given functions. Then the
  following are equivalent.

  + $y_1, y_2$ are linearly independent solutions on $(a, b)$.
  + $W(y_1, y_2) != 0$ for all $x in (a, b)$.
  + There exists $x in (a, b)$ at which $W(y_1, y_2) != 0$.
]

#hum[
  Statements 2 and 3 look as though one must be much stronger than the other,
  and for arbitrary functions it would be. For *solutions of the same
  homogeneous equation* the Wronskian is either nowhere zero on the interval
  or identically zero on it — it cannot vanish at one point and not another.
  That is why checking a single convenient value of $x$ suffices.
]

#thm(title: "Fundamental sets and the general solution")[
  If $y_1, y_2$ are linearly independent solutions of $y'' + p y' + q y = 0$,
  then any solution can be expressed uniquely as
  $
  y = c_1 y_1 + c_2 y_2 quad "for some" c_1, c_2 in bb(R).
  $
]

We call

- ${y_1, y_2}$ a *fundamental set of solutions*;
- $y = c_1 y_1 + c_2 y_2$ the *general solution*.

== Superposition

#thm(title: "Principle of superposition, homogeneous case")[
  If $y_1$ and $y_2$ solve the homogeneous equation, then so does every
  linear combination $y = c_1 y_1 + c_2 y_2$.
]

Superposition alone is not enough: it produces solutions, but a combination
of two *dependent* solutions collapses to a single one and cannot meet two
independent initial conditions. So the question after superposition is always
the same one.

#ques[
  Are $y_1$ and $y_2$ linearly independent?
]

#key[
  The Wronskian $W(y_1, y_2)$ is the determinant $y_1 y'_2 - y'_1 y_2$, and
  if $W(y_1, y_2) != 0$ then $y_1$ and $y_2$ are linearly independent. If
  ${y_1, y_2}$ are linearly independent, they form the general solution of
  the homogeneous equation.
]

== A worked example

#example(title: "A fundamental set for " + $y'' + y' - 2y = 0$)[
  Show that $y_1 = e^x$ and $y_2 = e^(-2x)$ constitute a fundamental set of
  solutions for $y'' + p y' + q y = 0$ with $p = 1$ and $q = -2$, and solve
  for the general solution.

  Three things must be shown:
  + that each function solves the equation;
  + that they are linearly independent, by the Wronskian;
  + the resulting general solution.
]

#soln[
  *1. Verify that $y_1, y_2$ solve $y'' + y' - 2y = 0$.*

  For $y_1$: $y_1 = e^x$, $y'_1 = e^x$, $y''_1 = e^x$. Substituting,

  $ y''_1 + y'_1 - 2 y_1 = e^x + e^x - 2 e^x = 0, $

  so $y_1$ solves the equation. For $y_2 = e^(-2x)$: $y'_2 = -2 e^(-2x)$ and
  $y''_2 = 4 e^(-2x)$, so

  $ y''_2 + y'_2 - 2 y_2 = 4 e^(-2x) - 2 e^(-2x) - 2 e^(-2x) = 0. $

  *2. Compute the Wronskian.*

  $ W(y_1, y_2) = y_1 y'_2 - y'_1 y_2
    = e^x (-2 e^(-2x)) - e^x e^(-2x)
    = -3 e^(-x) != 0. $

  This implies $y_1, y_2$ are linearly independent on the interval.

  *3. General solution.*

  Since $y_1, y_2$ are linearly independent and both solve the given
  equation, the general solution is

  $ y = c_1 y_1 + c_2 y_2 = c_1 e^x + c_2 e^(-2x). $
]

// =========================================================================
// REDUCTION OF ORDER AND CONSTANT COEFFICIENTS
// =========================================================================
= Reduction of Order

== When it applies

If $y_1$ is a solution of the homogeneous equation, _can it help us find
$y_2$?_

#remark[
  Recall the analogous move from algebra: if $x = 1$ is a root of
  $x^3 - 7x + 6 = 0$, then polynomial division by $(x - 1)$ simplifies the
  problem. Knowing one root cheapens the search for the rest.
]

In differential equations we look for a second solution of the form
$y_2 = v(x) y_1$. Note that $v(x)$ *must not be a constant*, or linear
independence fails and $y_2$ is no new information. So the question is how to
find $v(x)$, and the answer is *reduction of order* — a method that takes a
second-order equation down to a first-order one.

== The derivation

We wish to solve the homogeneous second-order equation

$ y'' + p(x) y' + q(x) y = 0 $

using $y = v(x) y_1$, where $y_1$ already solves it. Differentiating,

$ y' = v' y_1 + v y'_1, $
$ y'' = v'' y_1 + v' y'_1 + v' y'_1 + v y''_1 = v'' y_1 + 2 v' y'_1 + v y''_1. $

Substituting into the homogeneous equation gives

$ underbrace((v'' y_1 + 2 v' y'_1 + v y''_1), y'')
  + p underbrace([v' y_1 + v y'_1], y') + q v y_1 = 0. $

Rearrange, collecting $v$, $v'$ and $v''$:

$ v (y''_1 + p y'_1 + q y_1) + v' (2 y'_1 + p y_1) + v'' y_1 = 0. $

Observe that $(y''_1 + p y'_1 + q y_1)$ is the left-hand side of the
homogeneous equation evaluated at $y_1$ — which is zero, since $y_1$ solves
it. Therefore

$ v (0) + v' (2 y'_1 + p y_1) + v'' y_1 = 0,
  quad "so" quad v' (2 y'_1 + p y_1) + v'' y_1 = 0. $

Dividing through by $y_1$,

$ v'' + v' (p + 2 y'_1/y_1) = 0. $

This is a first-order equation in $v'$. Setting $w = v'$,

#form(title: "Reduction of order")[
  $ w' + (p + 2 y'_1/y_1) w = 0, quad w = v'. $
  Solve for $w$, integrate once to recover $v$, and take
  $y_2 = v(x) y_1$.
]

== Worked examples

#example(title: "Constant coefficients")[
  Given a solution $y_1 = e^(3x)$ of $y'' - 6 y' + 9 y = 0$, find a second
  linearly independent solution and the general solution.
]

#soln[
  Suppose $y = v(x) y_1$; write $v$ for $v(x)$ throughout. Then

  $ y' = v' e^(3x) + 3 v e^(3x), $
  $ y'' = v'' e^(3x) + 3 v' e^(3x) + 3 v' e^(3x) + 9 v e^(3x)
        = v'' e^(3x) + 6 v' e^(3x) + 9 v e^(3x). $

  Substituting into $y'' - 6 y' + 9 y = 0$,

  $ (v'' e^(3x) + 6 v' e^(3x) + 9 v e^(3x))
    - 6 (v' e^(3x) + 3 v e^(3x)) + 9 v e^(3x) = 0 $
  $ v'' e^(3x) + 6 v' e^(3x) + 9 v e^(3x)
    - 6 v' e^(3x) - 18 v e^(3x) + 9 v e^(3x) = 0 $
  $ v'' e^(3x) = 0. $

  Dividing both sides by $e^(3x)$ leaves $v'' = 0$. Let $w = v'$, so
  $w' = 0$; then $w$ is some constant, $v' = c$, and

  $ v = integral c dif x = c x + d. $

  We want only one solution, as simple as possible. Set $d = 0$ and keep
  $c = 1$, so $v = x$ and

  $ y_2 = v(x) y_1 = x e^(3x). $

  The general solution is therefore

  $ y = c_1 y_1 + c_2 y_2 = c_1 e^(3x) + c_2 x e^(3x). $
]

#key[
  A repeated root $r$ produces the pair $e^(r x)$ and $x e^(r x)$. Reduction
  of order is *why* the extra factor of $x$ appears — it is not a rule to
  memorise but the output of $v'' = 0$.
]

#example(title: "Non-constant coefficients")[
  Given the solution $y_1 = e^x$ of $x y'' - (2x + 1) y' + (x + 1) y = 0$ on
  any interval not containing the origin, find $y_2$ and the general
  solution.
]

#soln[
  Let $y = v y_1 = v e^x$. Then

  $ y = v e^x, quad y' = v' e^x + v e^x, $
  $ y'' = v'' e^x + v' e^x + v' e^x + v e^x = v'' e^x + 2 v' e^x + v e^x. $

  Substituting,

  $ x [v'' e^x + 2 v' e^x + v e^x] - (2x + 1) [v' e^x + v e^x]
    + (x + 1) v e^x = 0. $

  Simplifying so that the $v$ terms drop out leaves

  $ x v'' e^x - v' e^x = 0, quad "so" quad v'' - 1/x v' = 0. $

  Rewriting as a first-order equation with $w = v'$,

  $ w' - 1/x w = 0
    quad ==> quad w' = 1/x w
    quad ==> quad (dif w)/(dif x) = 1/x w $

  and separating,

  $ 1/w dif w = 1/x dif x $
  $ integral 1/w dif w = integral 1/x dif x $
  $ ln|w| = ln|x| + C $
  $ e^(ln|w|) = e^(ln|x| + C) $
  $ |w| = |x| e^C $
  $ w = C x. $

  Subsequently $v' = w = C x$, so

  $ v = integral C x dif x = C x^2/2 + d. $

  Set $C = 2$ and $d = 0$, giving $v = x^2$. Therefore

  $ y_2 = v y_1 = x^2 e^x, $

  and the general solution, on any interval not containing the origin, is

  $ y = c_1 e^x + c_2 x^2 e^x. $
]

#hum[
  Notice where the restriction "not containing the origin" came from. It was
  not imposed for convenience: dividing by $x$ to reach $v'' - v'/x = 0$
  requires $x != 0$, and the original equation has $x y''$ as its leading
  term, so at $x = 0$ it stops being second-order at all. Chapter 2's
  existence theorem predicted this before any calculation was done.
]

= Constant Coefficients: the Characteristic Equation

== Setting up

We wish to solve

$ a y'' + b y' + c y = 0. $

A good candidate for a solution is $y(x) = e^(r x)$ with $r in bb(R)$. To see
why, take

$ y' = r e^(r x), quad y'' = r^2 e^(r x), $

and substitute:

$ e^(r x) [a r^2 + b r + c] = 0. $

Since $e^(r x) != 0$ for every $x$, the bracket must vanish.

#def(title: "Characteristic equation")[
  The *characteristic equation* of $a y'' + b y' + c y = 0$ is the quadratic
  $
  a r^2 + b r + c = 0,
  $
  with roots
  $
  r_(1,2) = (-b plus.minus sqrt(b^2 - 4 a c))/(2 a),
  quad D = b^2 - 4 a c.
  $
]

#key[
  The discriminant $D$ decides the shape of the answer.
  - If $D > 0$: two distinct real roots.
  - If $D = 0$: one real root of multiplicity $2$.
  - If $D < 0$: two complex conjugate roots.
]

== Case 1: two distinct real roots

When $D > 0$ the two roots $r_1 != r_2$ are real and $e^(r_1 x)$, $e^(r_2 x)$
are independent, so

$ y = c_1 y_1 + c_2 y_2 = c_1 e^(r_1 x) + c_2 e^(r_2 x). $

#example(title: "An initial value problem")[
  Solve $y'' - y = 0$ with $y(0) = 1$ and $y'(0) = 0$.
]

#soln[
  Here $a = 1$, $b = 0$, $c = -1$, so the characteristic equation is

  $ r^2 - 1 = 0 quad ==> quad r_(1,2) = plus.minus 1, $

  giving

  $ y = c_1 e^(-x) + c_2 e^(x), quad y' = -c_1 e^(-x) + c_2 e^(x). $

  Substituting the initial conditions,

  $ y(0) = c_1 + c_2 = 1, $
  $ y'(0) = -c_1 + c_2 = 0. $

  Adding the two equations gives $2 c_2 = 1$, so
  $c_2 = 1/2 = c_1$, and

  $ y = 1/2 e^(-x) + 1/2 e^(x). $
]

== Case 2: a repeated real root

When $D = 0$ the characteristic equation has one real root of multiplicity
$2$, and the naive answer

$ y = c_1 e^(r x) + c_2 e^(r x) $

is useless — the two pieces are the same function, and collapse to one
constant. Applying reduction of order (Chapter 4) removes the dependence and
supplies the missing factor of $x$:

$ y = c_1 e^(r x) + c_2 x e^(r x). $

#example(title: "A repeated root")[
  Find the general solution of $y'' + 4 y' + 4 y = 0$.
]

#soln[
  The characteristic equation is

  $ r^2 + 4 r + 4 = 0 quad ==> quad (r + 2)^2 = 0
    quad ==> quad r_(1,2) = -2. $

  Therefore $y_1 = e^(-2x)$ and $y_2 = x e^(-2x)$, and

  $ y = c_1 y_1 + c_2 y_2 = c_1 e^(-2x) + c_2 x e^(-2x). $
]

== Case 3: complex conjugate roots

When $D < 0$ the roots form a complex conjugate pair:

$ r_(1,2) = (-b plus.minus sqrt(b^2 - 4 a c))/(2 a)
  = (-b plus.minus i sqrt(4 a c - b^2))/(2 a)
  = -b/(2a) plus.minus i sqrt(4 a c - b^2)/(2a) = p plus.minus i q, $

writing

$ p = -b/(2a), quad q = sqrt(4 a c - b^2)/(2a). $

=== Euler's formula

#form(title: "Euler's formula")[
  For any number $x$,
  $ e^(i x) = cos(x) + i sin(x). $
  In particular $e^(i pi) + 1 = 0$ and $e^(2 pi i) = 1$.
]

#pf(title: "from the Taylor expansion")[
  Expand $f(x) = e^x$ about $x_0 = 0$:

  $ e^x = 1 + x + x^2/2! + x^3/3! + dots.h + x^n/n!
    + x^(n+1)/(n+1)! e^(xi_x), quad xi_x in [0, x]. $

  Substituting $i x$ for $x$ and splitting the series by whether the power of
  $i$ is real or imaginary,

  $ e^(i x) = (1 - x^2/2! + x^4/4! - x^6/6! + dots.h)
    + i (x - x^3/3! + x^5/5! - dots.h). $

  The first bracket is the Taylor series of $cos(x)$ and the second is that
  of $sin(x)$, so $e^(i x) = cos(x) + i sin(x)$.
]

A special case worth recording, since it is what makes the conjugate pair
collapse into real functions:

$ e^(-i x) = e^(i(-x)) = cos(-x) + i sin(-x) = cos(x) - i sin(x). $

=== The real general solution

Starting from $y = c_1 e^(r_1 x) + c_2 e^(r_2 x)$ with
$r_(1,2) = p plus.minus i q$,

$ y = c_1 e^((p + i q) x) + c_2 e^((p - i q) x) $
$ = c_1 e^(p x) e^(i q x) + c_2 e^(p x) e^(-i q x) $
$ = c_1 e^(p x) [cos(q x) + i sin(q x)] + c_2 e^(p x) [cos(q x) - i sin(q x)] $
$ = (c_1 + c_2) e^(p x) cos(q x) + i (c_1 - c_2) e^(p x) sin(q x) $
$ = C_1 e^(p x) cos(q x) + C_2 e^(p x) sin(q x). $

#form(title: "Complex conjugate roots")[
  If $r_(1,2) = p plus.minus i q$, the general solution is
  $ y = C_1 e^(p x) cos(q x) + C_2 e^(p x) sin(q x). $
]

#remark[
  In general the constants and the solutions may be complex, but if we are
  searching for real solutions we use real constants. The pairing
  $C_1 = c_1 + c_2$, $C_2 = i(c_1 - c_2)$ is exactly the change of basis that
  makes that possible.
]

#example(title: "Complex roots")[
  Find the general solution of $y'' + 2 y' + 4 y = 0$.
]

#soln[
  The characteristic equation is $r^2 + 2 r + 4 = 0$, so

  $ r_(1,2) = (-2 plus.minus sqrt(4 - 16))/2
    = (-2 plus.minus i sqrt(12))/2 = -1 plus.minus i sqrt(3). $

  Reading off $p = -1$ and $q = sqrt(3)$, the general solution is

  $ y = c_1 e^(-x) cos(sqrt(3) x) + c_2 e^(-x) sin(sqrt(3) x). $
]

#imp(title: "Keep track of the " + $i$)[
  Simplifying $(-2 plus.minus i sqrt(12))\/2$, it is easy to divide the $12$
  down to $3$ and lose the $i$ along the way, arriving at
  $-1 plus.minus sqrt(3)$. Those are real roots, and they belong to a
  completely different equation.

  It is equally tempting to carry the $i$ too far and write
  $cos(i sqrt(3) x)$. It does not belong there either. The rule is:

  $ r_(1,2) = p plus.minus i q
    quad ==> quad e^(p x) cos(q x), e^(p x) sin(q x). $

  The real part $p$ becomes the exponential rate; the imaginary part $q$ —
  the coefficient *without* its $i$ — becomes the frequency. No $i$ survives
  into a real solution.
]

#example(title: "An initial value problem with complex roots")[
  Solve $y'' + 4 y = 0$ with $y(0) = 1$ and $y'(0) = -1$.
]

#soln[
  The characteristic equation is $r^2 + 4 = 0$, so
  $r_(1,2) = plus.minus 2 i$. Here $p = 0$ and $q = 2$, giving the general
  solution

  $ y = c_1 cos(2x) + c_2 sin(2x),
    quad y' = -2 c_1 sin(2x) + 2 c_2 cos(2x). $

  Substituting the initial conditions,

  $ y(0) = c_1 (1) + c_2 (0) = 1 quad ==> quad c_1 = 1, $
  $ y'(0) = -2 c_1 (0) + 2 c_2 (1) = -1 quad ==> quad c_2 = -1/2. $

  Therefore $y = cos(2x) - 1/2 sin(2x)$.
]

// =========================================================================
// NON-HOMOGENEOUS EQUATIONS
// =========================================================================
= Non-Homogeneous Equations and Superposition

== The shape of the answer

Consider

$ a y'' + b p(x) y' + c q(x) y = f(x), quad a, b, c in bb(R). $

The solution splits into two pieces:

#form(title: "Structure of the general solution")[
  $ y = y_h + y_p, $
  where $y_h$ is the solution of the homogeneous equation and $y_p$ is a
  *particular solution* — any single solution for the given right-hand side
  $f(x)$.
]

Writing out $y_h$ in full,

$ y = underbrace([c_1 y_1 + c_2 y_2], y_h) + y_p,
  quad y_1 != z y_2 "for any" z in bb(R), $

the independence condition being the one from Chapter 3: without it $y_h$ is
not the full homogeneous solution and the two initial conditions cannot both
be met.

#imp(title: "What the sum equals")[
  The statement is $y = y_h + y_p$, never $y_h + y_p = f(x)$. Adding the two
  pieces gives the *solution*; $f(x)$ is what comes back out when the
  differential operator is applied to that solution. Confusing the two makes
  the superposition argument below unreadable, because there $f$ is split
  into pieces and the corresponding $y$s are summed — two different sums,
  going in opposite directions.
]

== Finding $y_p$ by educated guess

The simplest idea is to guess a form for $y_p$ that looks like $f(x)$, put it
into the equation, and solve for the constants. Chapter 7 turns this into a
system; here is the idea in one example.

#example(title: "A guess that works immediately")[
  Solve $y'' + y = 1$.
]

#soln[
  We need both $y_h$ and $y_p$.

  *Form the characteristic equation.*

  $ r^2 + 1 = 0 quad ==> quad r = plus.minus i, $

  so $p = 0$, $q = 1$ and

  $ y_h = c_1 e^(p x) cos(q x) + c_2 e^(p x) sin(q x)
        = c_1 cos(x) + c_2 sin(x). $

  *Guess $y_p$.* By inspection, $y_p = 1$ works: $y''_p = 0$ and
  $0 + 1 = 1$. Therefore

  $ y = y_h + y_p = c_1 cos(x) + c_2 sin(x) + 1. $
]

== The principle of superposition

#ques[
  What can we do if $f(x)$ is more general?
]

Superposition is useful whenever the forcing term decomposes,
$f(x) = f_1(x) + f_2(x) + dots.h + f_n (x)$. By finding the solution for each
$f_k (x)$ term separately we can sum them to get a solution for the whole of
$f(x)$. For example, $f(x) = 1 + cos(4x)$ splits into a constant and a
cosine, each of which has an obvious trial form.

#thm(title: "Superposition, non-homogeneous case")[
  *Scalar property.* If $y$ is a solution of $y'' + p y' + q y = f(x)$, then
  $k y$ is a solution of $y'' + p y' + q y = k f(x)$.

  *Additive property.* If $y_1$ solves $y'' + p y' + q y = f_1(x)$ and $y_2$
  solves $y'' + p y' + q y = f_2(x)$, then $y_1 + y_2$ solves
  $y'' + p y' + q y = f_1(x) + f_2(x)$.
]

#remark[
  Combining the two, $y_1$ and $y_2$ can be scaled and added to reach any
  $sum_k c_k f_k (x)$.
]

#hum(title: "Differential equations as input/output systems")[
  #v(0.3em)
  #align(center, grid(
    columns: (auto, 1.4em, auto, 1.4em, auto),
    align: horizon,
    rows: (auto,),
    box(inset: 7pt, radius: 3pt, stroke: 0.6pt + cal-green.transparentize(50%))[
      #set align(center)
      #text(font: lin-sans, size: 7pt, fill: lin-muted, tracking: 0.08em)[EXTERNAL FORCE] \
      #v(0.2em) $f(x)$
    ],
    text(fill: lin-muted)[$-->$],
    box(inset: 7pt, radius: 3pt, stroke: 0.6pt + cal-green.transparentize(50%))[
      #set align(center)
      #text(font: lin-sans, size: 7pt, fill: lin-muted, tracking: 0.08em)[SYSTEM] \
      #v(0.2em) $y'' + p y' + q y$
    ],
    text(fill: lin-muted)[$-->$],
    box(inset: 7pt, radius: 3pt, stroke: 0.6pt + cal-green.transparentize(50%))[
      #set align(center)
      #text(font: lin-sans, size: 7pt, fill: lin-muted, tracking: 0.08em)[RESPONSE] \
      #v(0.2em) $y$
    ],
  ))
  #v(0.4em)
  In other words, if we scale the input the output is scaled in the same way.
  If the input is $c_1 f_1 + c_2 f_2$, the output is $c_1 y_1 + c_2 y_2$.
  That is exactly what "linear" buys us.
]

#example(title: "Superposition in use")[
  Suppose $y'' + y' + 2y = x$ has a solution $y_1(x) = 0.5 x - 1$, and
  $y'' + y' + 2y = e^x$ has a solution $y_2(x) = 0.25 e^x$. Find a solution
  to
  $ y'' + y' + 2y = 5x + 3 e^x. $
]

#soln[
  The right-hand side is $5 f_1 + 3 f_2$, so the solution must be

  $ y = 5 y_1 + 3 y_2 = 5(0.5 x - 1) + 3(0.25) e^x
      = 2.5 x - 5 + 0.75 e^x. $
]

= The Method of Undetermined Coefficients

For constant-coefficient equations

$ a y'' + b y' + c y = f(x), quad y = y_h + y_p, $

the guess of Chapter 6 can be systematised. The procedure is always:

+ solve the homogeneous equation for $y_h$;
+ read a *trial solution* $y_p$ off the shape of $f(x)$;
+ multiply the trial solution by $x^s$ until no term of it is linearly
  dependent on a term of $y_h$;
+ substitute, match coefficients of like terms, and solve for the constants.

#key[
  Step 3 is the one that is easy to skip and fatal to skip. A trial solution
  sharing a term with $y_h$ is annihilated by the operator, and matching
  coefficients then produces a contradiction rather than an answer.
]

== A resonant example

#example(title: "Trial solution overlapping " + $y_h$)[
  Solve $y'' - 2 y' + y = e^x$.
]

#soln[
  *Solve the homogeneous equation.*

  $ r^2 - 2 r + 1 = 0 quad ==> quad (r - 1)^2 = 0
    quad ==> quad r_(1,2) = 1, $
  $ y_h = c_1 e^x + c_2 x e^x. $

  *Trial solution.* The natural guess $A e^x$ is a term of $y_h$; so is
  $A x e^x$. In general we keep adding factors of $x$ until the functions are
  linearly independent, which here takes two:

  $ y_p = A x^2 e^x. $

  *Differentiate.*

  $ y_p = A x^2 e^x, $
  $ y'_p = 2 A x e^x + A x^2 e^x, $
  $ y''_p = 2 A e^x + 4 A x e^x + A x^2 e^x. $

  *Substitute* into $y'' - 2 y' + y = e^x$ and divide through by
  $e^x != 0$:

  $ (2 A + 4 A x + A x^2) - 2(2 A x + A x^2) + A x^2
    = 1 + 0 x + 0 x^2. $

  Matching like powers,

  $ x^2: quad A - 2A + A = 0 quad checkmark $
  $ x^1: quad 4A - 4A = 0 quad checkmark $
  $ x^0: quad 2A = 1 quad ==> quad A = 1/2. $

  Therefore

  $ y = [c_1 e^x + c_2 x e^x] + 1/2 x^2 e^x. $
]

== A non-resonant example, and the sign that decides it

#example(title: "A non-resonant right-hand side")[
  Solve $y'' + 3 y' - 4 y = e^(-x)$.
]

#soln[
  *Solve the homogeneous equation.* The characteristic equation is

  $ r^2 + 3 r - 4 = 0 quad ==> quad (r + 4)(r - 1) = 0
    quad ==> quad r_(1,2) = 1, -4, $
  $ y_h = c_1 e^x + c_2 e^(-4x). $

  *Trial solution.* Neither $e^x$ nor $e^(-4x)$ is $e^(-x)$, so there is no
  resonance and $s = 0$:

  $ y_p = A e^(-x), quad y'_p = -A e^(-x), quad y''_p = A e^(-x). $

  *Substitute* and divide by $e^(-x)$:

  $ A + 3(-A) - 4A = 1 quad ==> quad -6A = 1
    quad ==> quad A = -1/6. $

  Therefore

  $ y = c_1 e^x + c_2 e^(-4x) - 1/6 e^(-x). $
]

== Reading trial solutions off $f(x)$

#example(title: "A catalogue of trial solutions")[
  For $y'' + 2 y' - 3 y = f(x)$, determine the form of $y_p$ for each of
  several right-hand sides $f(x)$.
]

#soln[
  First the homogeneous solution, which is what every case is checked
  against.

  $ r^2 + 2 r - 3 = 0 quad ==> quad
    r_(1,2) = (-2 plus.minus sqrt(4 + 12))/2 = (-2 plus.minus 4)/2 = 1, -3, $
  $ y_h = c_1 e^x + c_2 e^(-3x). $

  Now each right-hand side in turn. The exponent $s$ is the number of factors
  of $x$ needed to clear any overlap with $y_h$.

  #table(
    columns: (1.1fr, 2fr, 0.4fr, 1.5fr),
    align: (left, left, center, left),
    table.header[$f(x)$][Trial $y_p$][$s$][Why],
    $x^2 + x - 3$,
      $(A x^2 + B x + C) x^s$, [0],
      [A degree-2 polynomial needs all of $x^2, x, 1$; none is in $y_h$.],
    $e^(-x)$,
      $A e^(-x) dot.c x^s$, [0],
      [$e^(-x)$ matches neither $e^x$ nor $e^(-3x)$.],
    $x e^x$,
      $(A x + B) e^x dot.c x^s$, [1],
      [The $B e^x$ term is linearly dependent on $c_1 e^x$, so one factor of
       $x$ is required.],
    $2 x sin(3x) + cos(3x)$,
      $[(A x + B) sin(3x) + (C x + D) cos(3x)] x^s$, [0],
      [Both roots are real, so nothing trigonometric appears in $y_h$.],
    $x e^(-2x) sin(x)$,
      $e^(-2x) [(A x + B) sin(x) + (C x + D) cos(x)] x^s$, [0],
      [No overlap with $y_h$.],
  )
]

#key[
  Two habits make the table above unnecessary to memorise.

  *Close the family.* A trial solution must include every function that
  differentiation can produce from it. Guessing $A x e^x$ is not enough,
  because $(A x e^x)' = A x e^x + A e^x$ introduces a bare $e^x$ — hence
  $(A x + B) e^x$. Likewise $sin(3x)$ drags in $cos(3x)$, and $x^2$ drags in
  $x$ and $1$.

  *Then check against $y_h$.* Only after the family is closed does the
  comparison with $y_h$ make sense, because it is the individual terms of the
  closed family that can collide.
]

#remark[
  Case 4 can also be handled by superposition instead of in one piece: split
  $f_1(x) = 2 x sin(3x)$ from $f_2(x) = cos(3x)$, find a particular solution
  for each, and add them. That is the Chapter 6 route, and it arrives at the
  same trial form — which is a good sign, since the two methods are the same
  idea approached from different ends.
]

= Variation of Parameters

Undetermined coefficients requires constant coefficients and a right-hand
side of a recognisable shape. Variation of parameters gives up both
restrictions.

== The derivation

Consider

$ y'' + p(x) y' + q(x) y = f(x), $

with non-constant coefficients allowed. We search for

$ y_p = v_1(x) y_1 + v_2(x) y_2, $

where $y_1, y_2$ are given solutions of the homogeneous equation. (Recall
from Chapter 4 that $y_2$ can be recovered from $y_1$ by reduction of order,
so one homogeneous solution is enough to start.)

Differentiating,

$ y'_p = v'_1 y_1 + v_1 y'_1 + v'_2 y_2 + v_2 y'_2
  = underbrace((v'_1 y_1 + v'_2 y_2), "set to " 0) + v_1 y'_1 + v_2 y'_2. $

#hum[
  There are two unknown functions and only one equation to satisfy, so one
  constraint is ours to choose. Setting $v'_1 y_1 + v'_2 y_2 = 0$ is the
  choice that keeps $y''_p$ free of $v''_1$ and $v''_2$ — without it the
  substitution produces a second-order system in $v_1, v_2$ and nothing has
  been gained.
]

With that constraint,

$ y'_p = v_1 y'_1 + v_2 y'_2, $
$ y''_p = v'_1 y'_1 + v'_2 y'_2 + v_1 y''_1 + v_2 y''_2. $

Substituting into $y'' + p y' + q y = f(x)$,

$ [v'_1 y'_1 + v'_2 y'_2 + v_1 y''_1 + v_2 y''_2]
  + p [v_1 y'_1 + v_2 y'_2] + q [v_1 y_1 + v_2 y_2] = f(x). $

Now collect everything multiplied by $v_1$ and by $v_2$:

$ v_1 [y''_1 + p y'_1 + q y_1] + v_2 [y''_2 + p y'_2 + q y_2] = 0, $

since $y_1$ and $y_2$ each solve the homogeneous equation. All that survives
is $v'_1 y'_1 + v'_2 y'_2 = f(x)$.

#form(title: "The parameter conditions")[
  $ v'_1 y_1 + v'_2 y_2 = 0, $
  $ v'_1 y'_1 + v'_2 y'_2 = f(x), $
  or as a matrix equation
  $ mat(delim: "[", y_1, y_2; y'_1, y'_2) mat(delim: "[", v'_1; v'_2)
    = mat(delim: "[", 0; f). $
]

== Solving by Cramer's rule

#remark(title: "Cramer's rule")[
  For the $2 times 2$ system
  $ a_1 x + b_1 y = c_1, quad a_2 x + b_2 y = c_2, $
  form the three determinants
  $ D = mat(delim: "|", a_1, b_1; a_2, b_2) = a_1 b_2 - a_2 b_1, $
  $ D_x = mat(delim: "|", c_1, b_1; c_2, b_2) = c_1 b_2 - c_2 b_1, $
  $ D_y = mat(delim: "|", a_1, c_1; a_2, c_2) = a_1 c_2 - a_2 c_1. $
  The solution of the system is $x = D_x\/D$ and $y = D_y\/D$.
]

In our context the coefficient determinant is precisely the Wronskian of
Chapter 3:

$ D = mat(delim: "|", y_1, y_2; y'_1, y'_2) = W, $
$ D_(v'_1) = mat(delim: "|", 0, y_2; f, y'_2) = -y_2 f, $
$ D_(v'_2) = mat(delim: "|", y_1, 0; y'_1, f) = y_1 f. $

#form(title: "Variation of parameters")[
  $ v_1 = integral D_(v'_1)/W dif x = integral (-y_2 f)/W dif x, $
  $ v_2 = integral D_(v'_2)/W dif x = integral (y_1 f)/W dif x, $
  and then $y_p = v_1 y_1 + v_2 y_2$.
]

#imp(title: "The minus sign on " + $v_1$)[
  Expanding $D_(v'_1)$ it is easy to write $y_2 f$ and move on. Carry the
  determinant out in full:
  $0 dot.c y'_2 - y_2 dot.c f = -y_2 f$. The minus sign is real, it belongs
  to $v_1$ and not to $v_2$, and dropping it flips the sign of half of $y_p$.
  The asymmetry is not a typo in the formula — it comes from which column of
  the matrix the right-hand side replaces.
]

== Worked examples

#example(title: "Constant coefficients")[
  Find the general solution of $y'' - y = 5 e^x$.
]

#soln[
  *Homogeneous solution.* The characteristic equation $r^2 - 1 = 0$ gives
  $r_(1,2) = plus.minus 1$, so

  $ y_h = c_1 e^x + c_2 e^(-x), quad y_1 = e^x, quad y_2 = e^(-x). $

  *Wronskian.*

  $ W = mat(delim: "|", y_1, y_2; y'_1, y'_2)
      = mat(delim: "|", e^x, e^(-x); e^x, -e^(-x))
      = -e^x e^(-x) - e^x e^(-x) = -2. $

  *The two determinants.*

  $ D_(v'_1) = -y_2 f = -e^(-x) dot.c 5 e^x = -5, $
  $ D_(v'_2) = y_1 f = e^x dot.c 5 e^x = 5 e^(2x). $

  *Integrate.*

  $ v_1 = integral (-5)/(-2) dif x = 5/2 integral dif x = 5/2 x + C_1, $
  $ v_2 = integral (5 e^(2x))/(-2) dif x = -5/2 integral e^(2x) dif x
        = -5/4 e^(2x) + C_2. $

  *Assemble.*

  $ y_p = v_1 y_1 + v_2 y_2
    = 5/2 x e^x - 5/4 e^(2x) e^(-x)
    = 5/2 x e^x - 5/4 e^x, $

  and since $-5/4 e^x$ is absorbed by $c_1 e^x$,

  $ y = c_1 e^x + c_2 e^(-x) + 5/2 x e^x. $
]

#example(title: "Trigonometric homogeneous solutions")[
  Find the general solution of $y'' + y = 1$ by variation of parameters.
]

#soln[
  *Homogeneous solution.* $r^2 + 1 = 0$ gives $r_(1,2) = plus.minus i$, so

  $ y_h = c_1 cos(x) + c_2 sin(x), quad y_1 = cos(x), quad y_2 = sin(x). $

  *Wronskian.*

  $ W = mat(delim: "|", cos(x), sin(x); -sin(x), cos(x))
      = cos^2(x) + sin^2(x) = 1. $

  *The two determinants*, with $f(x) = 1$:

  $ D_(v'_1) = -y_2 f = -sin(x), quad D_(v'_2) = y_1 f = cos(x). $

  *Integrate.*

  $ v_1 = integral -sin(x) dif x = cos(x), quad
    v_2 = integral cos(x) dif x = sin(x). $

  *Assemble.*

  $ y_p = v_1 y_1 + v_2 y_2 = cos^2(x) + sin^2(x) = 1, $
  $ y = c_1 cos(x) + c_2 sin(x) + 1. $
]

#remark[
  The answer agrees with the educated guess $y_p = 1$ made for this same
  equation in Chapter 6. That is worth noticing: variation of parameters is
  more general than guessing, not different from it, and when a guess is
  available the two must agree.
]

// =========================================================================
// MECHANICAL SYSTEMS
= Mechanical Systems and Simple Harmonic Motion

== Deriving the equation of motion

Take a mass on a spring. Four forces act on it:

#table(
  columns: (auto, auto, 1fr),
  align: (left, left, left),
  table.header[Force][Symbol][Notes],
  [Gravity], $F_g = m g$, [Constant, downward.],
  [Spring], $F_s = -k(Delta L + u)$,
    [$Delta L$ is the static stretch, $u$ the displacement from equilibrium.],
  [External], $F_e (t)$, [The forcing term; may be zero.],
  [Dashpot], $F_d = -d u'$, [Damping, opposing the velocity.],
)

By Newton's second law,

$ m u'' = F_g + F_s + F_e + F_d
  = m g - k Delta L - k u + F_e (t) - d u'. $

Observe that at equilibrium $m g - k Delta L = 0$, so those two terms cancel:

$ m u'' = -k u + F_e (t) - d u'. $

Rearranging gives the equation that the rest of this chapter analyses.

#form(title: "Equation of motion")[
  $ m u'' + d u' + k u = F_e (t). $
  Everything from Chapters 2 to 8 applies to it directly: it is a second-order
  linear equation with constant coefficients.
]

== Simple harmonic motion

Take $d = 0$ and $F_e = 0$ — no damping, no forcing. Then

$ m u'' + k u = 0, quad "or" quad u'' + omega_0^2 u = 0,
  quad omega_0 = sqrt(k/m). $

The characteristic equation $r^2 + omega_0^2 = 0$ gives
$r_(1,2) = plus.minus i omega_0$, so by Case 3 of Chapter 5,

$ u(t) = c_1 cos(omega_0 t) + c_2 sin(omega_0 t). $

=== Amplitude–phase form

Set $R = sqrt(c_1^2 + c_2^2)$ and factor it out:

$ u(t) = R (c_1/R cos(omega_0 t) + c_2/R sin(omega_0 t)). $

Since $(c_1\/R)^2 + (c_2\/R)^2 = 1$, there is an angle $sigma$ with
$cos(sigma) = c_1\/R$ and $sin(sigma) = c_2\/R$. Then

$ u(t) = R [cos(sigma) cos(omega_0 t) + sin(sigma) sin(omega_0 t)]
       = R cos(omega_0 t - sigma) $

by the cosine subtraction identity.

#form(title: "Simple harmonic motion")[
  $ u(t) = R cos(omega_0 t - sigma), quad omega_0 = sqrt(k/m), $
  with *amplitude* $R = sqrt(c_1^2 + c_2^2)$ and *phase* $sigma$. Further,
  $ f = omega_0/(2 pi) quad "(oscillations per unit time)", $
  $ T = 1/f = (2 pi)/omega_0 = 2 pi sqrt(m/k) quad "(the period)". $
]

#hum[
  The two forms carry the same information in different currencies.
  $c_1, c_2$ are what the initial conditions hand you directly; $R$ and
  $sigma$ are what the motion looks like — how far it swings and where in the
  cycle it starts. Neither is more correct, and converting between them is
  one line of trigonometry.
]

== Unforced damped vibrations

Now restore the dashpot but keep $F_e = 0$:

$ m u'' + b u' + k u = 0, $

writing $b$ for the damping constant. The characteristic polynomial is
$m r^2 + b r + k = 0$, with

$ r_(1,2) = (-b plus.minus sqrt(b^2 - 4 m k))/(2m)
  = -b/(2m) plus.minus sqrt(b^2 - 4 m k)/(2m). $

#ques[
  How is the damping related to the motion? Everything turns on the sign of
  the discriminant $D = b^2 - 4 m k$.
]

#key[
  - $D < 0$, i.e. $b^2 < 4 m k$: *underdamped* — oscillation inside a
    decaying envelope.
  - $D = 0$, i.e. $b^2 = 4 m k$: *critically damped* — no oscillation.
  - $D > 0$, i.e. $b^2 > 4 m k$: *overdamped* — no oscillation, slower
    return.

  The last two are qualitatively similar; only the first oscillates.
]

#case(title: "Underdamped, " + $D < 0$)[
  Write the real quantity

  $ mu = sqrt(4 m k - b^2)/(2m), quad z = -b/(2m), $

  so that $r_(1,2) = z plus.minus i mu$. Here $mu$ is the component
  responsible for the oscillation and $z$ is the one responsible for the
  decay. By Case 3 of Chapter 5,

  $ u(t) = c_1 e^(z t) cos(mu t) + c_2 e^(z t) sin(mu t)
         = e^(z t) (c_1 cos(mu t) + c_2 sin(mu t))
         = R e^(z t) cos(mu t - sigma). $

  Since $z < 0$, the factor $e^(z t)$ is a decaying envelope around an
  oscillation of frequency $mu$:

  $ f_"damped" = mu/(2 pi), quad
    T_"damped" = 1/f_"damped" = (2 pi)/mu, $

  the *damped natural frequency* and the *quasi-period*.
]

#imp(title: "Sign inside the radical")[
  In the underdamped case $b^2 < 4 m k$, so the radicand of
  $sqrt(b^2 - 4 m k)$ is *negative*. Writing
  $mu = sqrt(b^2 - 4 m k)\/(2m)$ and then $r = z plus.minus i mu$ counts the
  $i$ twice — once inside $mu$ and once outside it — and the frequency comes
  out imaginary.

  Swap the terms under the root before taking it:
  $mu = sqrt(4 m k - b^2)\/(2m)$, which is real and positive. This is the
  same swap made in Chapter 5 when $p plus.minus i q$ was extracted, for the
  same reason.
]

#case(title: "Critically damped, " + $D = 0$)[
  The root $r_(1,2) = -b\/(2m)$ is real with multiplicity $2$, so by Case 2
  of Chapter 5,

  $ u(t) = (c_1 + c_2 t) e^(-b/(2m) t). $

  Observe $lim_(t -> infinity) u(t) = 0$: the exponential decays faster than
  the linear factor grows.
]

#case(title: "Overdamped, " + $D > 0$)[
  $ r_(1,2) = -b/(2m) plus.minus sqrt(b^2 - 4 m k)/(2m),
    quad u(t) = c_1 e^(r_1 t) + c_2 e^(r_2 t). $

  Both roots are negative — the radical is smaller than $b\/(2m)$ because
  $4 m k > 0$ — so the solution again decays to zero as
  $t -> infinity$, without ever crossing it.
]

== Forced undamped vibrations

Finally, restore the forcing term and drop the damping. Taking $m = 1$ for
simplicity, so that $omega_0 = sqrt(k\/m) = sqrt(k)$:

$ u'' + k u = F_0 cos(omega t). $

The solution has the Chapter 6 shape $u = u_h + u_p$, with

$ u_h = c_1 cos(omega_0 t) + c_2 sin(omega_0 t), $

and a particular solution read off $f(t)$ by the method of Chapter 7:

$ u_p = A cos(omega t) + B sin(omega t). $

#remark[
  Two substitutions finish the job. Since $u''_p = -omega^2 (A cos(omega t) + B sin(omega t))$,

  $ u''_p + omega_0^2 u_p
    = (omega_0^2 - omega^2)(A cos(omega t) + B sin(omega t))
    = F_0 cos(omega t), $

  so matching coefficients gives $B = 0$ and

  $ A = F_0/(omega_0^2 - omega^2), quad
    u_p = F_0/(omega_0^2 - omega^2) cos(omega t)
    quad (omega != omega_0). $
]

#imp(title: "Resonance")[
  The trial solution above fails exactly when $omega = omega_0$ — the
  forcing frequency matching the system's natural frequency. Then
  $cos(omega t)$ is already a term of $u_h$, the step-3 rule of Chapter 7
  applies, and the trial solution must be multiplied by $t$:
  $u_p = t (A cos(omega_0 t) + B sin(omega_0 t))$. The factor of $t$ is
  *resonance*: an amplitude that grows without bound. It is the same
  algebraic fact as the repeated root of Chapter 4, in physical clothing.
]

// =========================================================================
// LAPLACE TRANSFORMS
// actually invoked across that note and the hw8 / hw10 problem sets.
// =========================================================================
= The Laplace Transform

The Laplace transform converts an initial value problem into an algebraic
equation: differentiation in $t$ becomes multiplication by $s$, the initial
conditions are absorbed into the algebra rather than applied at the end, and
discontinuous forcing terms become ordinary factors.

Every method before this chapter needed the forcing term to be smooth enough
to guess at, or at least to integrate. A switch that flips at $t = 2$ is
neither, and yet it is what most real forcing looks like. This chapter is how
such problems are solved.

== The definition

#def(title: "Laplace transform")[
  For a function $f(t)$ defined on $t >= 0$, the *Laplace transform* of $f$
  is the function
  $
  cal(L){f(t)} = F(s) = integral_0^infinity e^(-s t) f(t) dif t,
  $
  defined for every $s$ at which the improper integral converges.
]

Three points of notation, all standard and all used throughout. Lower case
$f, g, y$ denote functions of $t$; the matching capitals $F, G, Y$ denote
their transforms, which are functions of $s$. The variable $t$ is gone from
$F(s)$ entirely — it has been integrated away. And $cal(L)$ is an *operator*:
it eats a function and returns a function, in the way that $dif\/dif t$ does.

#example(title: "Two transforms from the definition")[
  Take $f(t) = 1$. Then
  $
  cal(L){1} = integral_0^infinity e^(-s t) dif t
    = lr([- e^(-s t)/s])_0^infinity
    = 0 - (- 1/s) = 1/s,
  $
  provided $s > 0$ — otherwise $e^(-s t)$ does not decay and the integral
  diverges.

  Take $f(t) = e^(a t)$. Then
  $
  cal(L){e^(a t)} = integral_0^infinity e^(-s t) e^(a t) dif t
    = integral_0^infinity e^(-(s - a) t) dif t
    = 1/(s - a),
  $
  provided $s > a$, by the same computation with $s$ replaced by $s - a$.
]

#hum[
  The factor $e^(-s t)$ is a weight that decays as $t$ grows, and $s$ controls
  how fast. Large $s$ weights the behaviour near $t = 0$ heavily and ignores
  the far future; small $s$ takes a longer view. So $F(s)$ is a whole family
  of weighted averages of $f$, one for each $s$ — and it turns out that
  family contains enough information to reconstruct $f$ exactly.

  This also explains why transforms come with a condition like $s > a$: if
  $f$ grows faster than the weight decays, the integral never settles down.
]

== When the transform exists

Two conditions together guarantee that the integral converges.

#def(title: "Exponential order")[
  A function $f$ is of *exponential order* $e^(a t)$ if there are constants
  $M > 0$ and $T >= 0$ with
  $
  |f(t)| <= M e^(a t) quad "for all" t >= T.
  $
  In words: past some point, $f$ grows no faster than some exponential.
]

#thm(title: "Existence of the transform")[
  If $f$ is piecewise continuous on $[0, infinity)$ and of exponential order
  $e^(a t)$, then $F(s) = cal(L){f(t)}$ exists for every $s > a$.
]

*Piecewise continuous* means: continuous except at isolated points, with a
finite jump at each. That is a deliberately generous condition — it is what
allows the switched forcing terms of this chapter, which are discontinuous by
design, to have transforms at all.

#example(title: "A function with no transform")[
  Every polynomial, every $e^(a t)$, every $sin$ and $cos$, and every product
  and sum of these is of exponential order. The standard counterexample is
  $
  f(t) = e^(t^2).
  $
  For any fixed $a$, the ratio $e^(t^2)\/e^(a t) = e^(t^2 - a t)$ grows
  without bound, so no $M$ and $T$ work. Since $e^(-s t) e^(t^2)$ diverges for
  every $s$, this function has no Laplace transform.
]

#key[
  The condition is on the *growth rate*, not the size. A function may be
  enormous — $10^100 e^(3t)$ — and still be of exponential order $e^(3t)$;
  the constant $M$ absorbs it. What matters is only whether some exponential
  eventually overtakes it.
]

== Properties

#form(title: "Operational properties")[
  $ cal(L){a f(t) + b g(t)} = a F(s) + b G(s) $
  $ cal(L){f'(t)} = s F(s) - f(0) $
  $ cal(L){f''(t)} = s^2 F(s) - s f(0) - f'(0) $
  $ cal(L){e^(a t) f(t)} = F(s - a) quad quad "(s-shift)" $
  $ cal(L){u(t - c) f(t - c)} = e^(-c s) F(s) quad quad "(t-shift)" $
  $ cal(L){t^n f(t)} = (-1)^n dif^n / (dif s^n) F(s) $
  $ cal(L){integral_0^t f(tau) dif tau} = F(s)/s $
]

#pf(title: "of the derivative rule")[
  Apply integration by parts to the definition, with $u = e^(-s t)$ and
  $dif v = f'(t) dif t$:

  $ cal(L){f'(t)} = integral_0^infinity e^(-s t) f'(t) dif t
    = lr([e^(-s t) f(t)])_0^infinity
      + s integral_0^infinity e^(-s t) f(t) dif t. $

  The boundary term vanishes at the upper limit, because $f$ is of
  exponential order and $e^(-s t)$ outruns it for $s$ large enough, and
  contributes $-f(0)$ at the lower limit. The remaining integral is
  $s F(s)$, so $cal(L){f'(t)} = s F(s) - f(0)$.
]

The second-derivative rule follows by applying the first one twice:

$ cal(L){f''(t)} = s cal(L){f'(t)} - f'(0)
  = s[s F(s) - f(0)] - f'(0) = s^2 F(s) - s f(0) - f'(0). $

#key(title: "Why any of this works")[
  Look at what the derivative rule does. Differentiation in $t$ becomes
  multiplication by $s$, and the initial value $f(0)$ falls out as an
  additive constant.

  Both halves matter. The first turns a differential equation into a
  polynomial equation, which can be solved by algebra. The second means the
  initial conditions are consumed *at the start*, rather than being imposed
  on a general solution at the end — so there are never any arbitrary
  constants to determine. The price is that the answer arrives in the
  $s$-domain and has to be brought back, which is what the rest of this
  chapter is about.
]

== A reference table

#table(
  columns: (1fr, 1fr, 1fr, 1fr),
  align: (left, left, left, left),
  table.header[Function][Transform][Function][Transform],
  $1$, $1/s$, $sin(a t)$, $a/(s^2 + a^2)$,
  $t^n$, $n!/s^(n+1)$, $cos(a t)$, $s/(s^2 + a^2)$,
  $e^(a t)$, $1/(s - a)$, $u(t - c)$, $e^(-c s)/s$,
  $t e^(a t)$, $1/(s - a)^2$, $e^(a t) sin(b t)$, $b/((s - a)^2 + b^2)$,
  $t cos(t)$, $(s^2 - 1)/(s^2 + 1)^2$, $e^(a t) cos(b t)$, $(s - a)/((s - a)^2 + b^2)$,
)

Two inverse transforms are worth having ready, since they arise whenever a
$1\/s$ or $1\/s^2$ meets an undamped oscillator:

$ cal(L)^(-1) {1/(s(s^2 + a^2))} = 1/a^2 [1 - cos(a t)], quad
  cal(L)^(-1) {1/(s^2 (s^2 + a^2))} = 1/a^3 [a t - sin(a t)]. $

== The unit step function

The transform's real advantage over everything earlier in this book is that
it handles forcing which switches on or off. The switch itself needs a name.

#def(title: "Unit step function")[
  For $c >= 0$, the *unit step* (or Heaviside) function is
  $
  u(t - c) = cases(
    0 quad &t < c,
    1 &t >= c.
  )
  $
]

#plot(
  (
    (fn: x => 0, from: -0.5, to: 2),
    (fn: x => 1, from: 2, to: 5.4),
  ),
  xlim: (-0.7, 5.6), ylim: (-0.35, 1.45),
  height: 2.6cm,
  xticks: (2,), yticks: (1,),
  xlabel: $t$, ylabel: $u(t - 2)$,
  marks: ((x: 2, y: 0, open: true), (x: 2, y: 1)),
)

Multiplying by $u(t - c)$ switches a function *on* at $t = c$; subtracting a
second step switches it off again. That is enough to write any piecewise
function as a single formula.

#example(title: "Piecewise functions in one line")[
  A function that is zero, then $g(t)$ between $a$ and $b$, then zero again:
  $
  f(t) = g(t) u(t - a) - g(t) u(t - b).
  $
  The first term switches $g$ on at $a$; the second cancels it from $b$
  onwards, since past $b$ both steps equal $1$ and the terms subtract to
  zero.
]

#form(title: "The two step rules")[
  $ cal(L){u(t - c)} = e^(-c s)/s, quad
    cal(L){u(t - c) f(t - c)} = e^(-c s) F(s). $
  Read in reverse, the second says
  $cal(L)^(-1){e^(-c s) F(s)} = u(t - c) f(t - c)$.
]

#imp(title: "The argument is shifted too")[
  The second rule transforms $u(t - c) f(t - c)$ — the step *and* the
  argument both shifted by the same $c$. It does not apply to
  $u(t - c) f(t)$.

  When what you have is $u(t - c) g(t)$, rewrite $g(t)$ as a function of
  $(t - c)$ first. For a polynomial, substitute $t = (t - c) + c$ and expand;
  for a sine or cosine, use an angle-sum identity. Both moves are carried out
  in Chapter C.

  The same applies in reverse when inverting: a factor $e^(-c s)$ produces
  $u(t - c)$ *and* shifts the argument of everything it multiplies. Omitting
  the argument shift is the single commonest error in this material, and it
  leaves no trace in the algebra — the answer simply comes out wrong.
]

== Inverting: partial fractions

Transforming an equation is mechanical. Getting back is where the work is,
and it is almost always partial fractions: split $Y(s)$ into pieces small
enough to recognise in the table. Three shapes come up.

#case(title: "Distinct linear factors")[
  $
  (s + 4)/((s + 1)(s + 2)) = A/(s + 1) + B/(s + 2).
  $
  Clear the denominators and substitute each root in turn: at $s = -1$ every
  term but $A$'s vanishes, and at $s = -2$ every term but $B$'s does. Each
  constant falls out on its own, with no simultaneous system to solve.
]

#case(title: "Repeated linear factors")[
  A factor repeated $k$ times needs $k$ terms, one for each power:
  $
  1/(s (s + 1)^2) = A/s + B/(s + 1) + C/(s + 1)^2.
  $
  Substituting roots gives $A$ and $C$ directly; $B$ needs one further step —
  comparing coefficients of a chosen power of $s$, or differentiating before
  substituting.
]

#case(title: "Irreducible quadratics")[
  A quadratic with no real roots does not factor further. Give it a linear
  numerator and *complete the square* in the denominator:
  $
  1/(s(s^2 + 2s + 5)) = A/s + (B s + C)/(s^2 + 2s + 5),
  quad s^2 + 2s + 5 = (s + 1)^2 + 2^2.
  $
  Completing the square is what makes the table entries usable: the pair
  $
  (s - a)/((s - a)^2 + b^2) -> e^(a t) cos(b t), quad
  b/((s - a)^2 + b^2) -> e^(a t) sin(b t)
  $
  requires the denominator in exactly that form, and the numerator split into
  a copy of $(s - a)$ plus a constant.
]

#key[
  Completing the square is not an optional tidy-up; it is the step that makes
  a damped oscillation visible. The shift $s -> s + 1$ in the denominator is
  what becomes the decay factor $e^(-t)$, and the $2^2$ left over is what
  becomes the frequency. Read the exponential and the frequency straight off
  $(s + 1)^2 + 2^2$.
]

== Solving an initial value problem

#example(title: "A first-order forcing term")[
  Solve $y'' + 3 y' + 2 y = e^(-3t)$ with $y(0) = 0$ and $y'(0) = 1$.
]

#soln[
  *Transform both sides.* Applying $cal(L)$ term by term,

  $ cal(L){y''} = s^2 Y(s) - s y(0) - y'(0) = s^2 Y - 1, $
  $ cal(L){3 y'} = 3[s Y - y(0)] = 3 s Y, $
  $ cal(L){2 y} = 2 Y, $
  $ cal(L){e^(-3t)} = 1/(s + 3). $

  So

  $ s^2 Y - 1 + 3 s Y + 2 Y = 1/(s + 3). $

  *Solve for $Y$.*

  $ Y(s^2 + 3 s + 2) = 1/(s + 3) + 1 = (s + 4)/(s + 3), $
  $ Y = (s + 4)/(s + 3) dot.c 1/(s^2 + 3 s + 2)
      = (s + 4)/((s + 3)(s + 2)(s + 1)). $

  *Partial fraction decomposition.*

  $ (s + 4)/((s + 3)(s + 2)(s + 1))
    = A/(s + 3) + B/(s + 2) + C/(s + 1), $

  which after clearing denominators is

  $ A(s + 2)(s + 1) + B(s + 3)(s + 1) + C(s + 3)(s + 2) = s + 4. $

  Choosing convenient values of $s$ kills two terms at a time:

  - $s = -1$: $quad C(2)(1) = 3 quad ==> quad C = 3\/2$;
  - $s = -2$: $quad B(1)(-1) = 2 quad ==> quad B = -2$;
  - $s = -3$: $quad A(-1)(-2) = 1 quad ==> quad A = 1\/2$.

  *Invert.*

  $ Y = 0.5/(s + 3) - 2/(s + 2) + 1.5/(s + 1), $
  $ y(t) = 1/2 e^(-3t) - 2 e^(-2t) + 3/2 e^(-t). $
]

#hum[
  Notice what never happened: no homogeneous solution was found, no
  particular solution was guessed, and the initial conditions were never
  substituted into a general solution at the end. They entered at the
  transform step and were carried through the algebra. That is the whole
  attraction of the method.
]

#key[
  The choice-of-$s$ trick above is worth the habit. Substituting each root of
  the denominator in turn annihilates every term but one, so each constant
  falls out on its own instead of coming from a simultaneous system.
]


// =========================================================================
// WORKED PROBLEMS
// =========================================================================
#set heading(numbering: "A.1")
#counter(heading).update(0)
#_chap-fmt.update("A")
= Worked Problems I: Second-Order Equations

Three problems drawing on Chapters 2 and 3. Each is solved at length, with
the reasoning behind every step rather than only the step itself.

== Problem 1

#example[
  Show that $y(x) = c_1 e^(2x) + c_2 x e^(2x)$ solves the initial value
  problem with $y(0) = 0$ and $y'(0) = 2$.
]

#soln[
  $ y(x) = c_1 e^(2x) + c_2 x e^(2x), $
  $ y'(x) = 2 c_1 e^(2x) + c_2 e^(2x) + 2 c_2 x e^(2x). $

  Substituting the initial conditions:

  $ y(0) = c_1 e^0 + c_2 (0) e^0 = c_1 = 0, $
  $ y'(0) = 2 c_1 e^0 + c_2 e^0 + 2 c_2 (0) e^0 = 2 c_1 + c_2 = 2. $

  With $c_1 = 0$ the second gives $c_2 = 2$, so

  $ c_1 = 0, quad c_2 = 2, quad "and" quad y(x) = 2 x e^(2x). $
]

== Problem 2

#example[
  Determine the intervals on which
  $ x(x - 1) y'' + 2 x y' + y = 0 $
  has a unique solution.
]

#soln[
  Put the equation in standard form by dividing through by $x(x - 1)$:

  $ y'' + 2/(x - 1) y' + 1/(x(x - 1)) y = 0. $

  By the existence and uniqueness theorem of Chapter 2, a unique solution
  exists on any interval where both coefficient functions are continuous.
  That requires $x - 1 != 0$ and $x(x - 1) != 0$, so $x != 0$ and $x != 1$,
  leaving three intervals:

  $ (-infinity, 0), quad (0, 1), quad (1, infinity). $

  Which one applies is settled by whichever contains the initial point
  $x_0$.
]

== Problem 3

#example[
  Determine whether $f$ and $g$ are linearly independent on $(-1, 1)$, where
  $ f(x) = sin^2 x + cos^2 x, quad g(x) = 1. $
]

#soln[
  Two functions are linearly independent if and only if $f(x) != c g(x)$ for
  all $c != 0$. If the Wronskian is identically zero, such a $c$ exists.

  $ f(x) = sin^2 x + cos^2 x, quad f'(x) = 2 sin x cos x - 2 cos x sin x = 0, $
  $ g(x) = 1, quad g'(x) = 0. $

  Therefore

  $ W(f, g) = f g' - f' g = 0 - 0 = 0, $

  so there exists $c$ with $f(x) = c g(x)$ and the two are linearly
  *dependent*.
]

#hum[
  The Pythagorean identity makes $f(x) = 1$ identically, so $f$ and $g$ are
  the *same function* and $c = 1$. The Wronskian confirms it, but the
  identity settles it in one step — worth checking for before reaching for
  determinants.
]

= Worked Problems II: Laplace Transforms

Throughout, $cal(L)$ is the Laplace transform and the table of Chapter 10 is
used without further comment.

== Problem 1

#example[
  Transform $cal(L){3 + t + e^(-t) sin(2t)}$.
]

#soln[
  $ = cal(L){3} + cal(L){t} + cal(L){e^(-t) sin(2t)} $
  $ = 3 dot.c 1/s + 1/s^2 + 2/((s + 1)^2 + 4). $
]

== Problem 2

#example[
  Transform $cal(L){t e^(-3t) + 2 sin(t)}$.
]

#soln[
  $ = 1!/(s + 3)^2 + 2 dot.c 1/(s^2 + 1). $
]

== Problem 3

#example[
  Determine whether $f(t) = e^(-3t) e^(t^2)$ is of exponential order
  $e^(a t)$.
]

#soln[
  $ f(t) = e^(-3t) e^(t^2) = e^(-3t + t^2). $

  The exponent grows quadratically, so no linear $a t$ can dominate it:
  $f(t)$ is *not* of exponential order $e^(a t)$.
]

== Problem 4

#example[
  Find $cal(L){(t - 9)^2}$.
]

#soln[
  Expand first, then transform term by term:

  $ cal(L){(t - 9)^2} = cal(L){t^2 - 18 t + 81}
    = cal(L){t^2} - 18 cal(L){t} + 81 cal(L){1} $
  $ = 2!/s^3 - 18/s^2 + 81/s. $
]

#remark[
  Expanding is the right move here. The $t$-shift rule
  $cal(L){u(t-c) f(t-c)} = e^(-c s) F(s)$ does *not* apply — there is no unit
  step function multiplying this, so the argument shift alone buys nothing.
]

== Problem 5

#example[
  Find $cal(L){(1 + e^t)^2}$.
]

#soln[
  $ cal(L){(1 + e^t)^2} = cal(L){e^(2t) + 2 e^t + 1}
    = 1/(s - 2) + 2/(s - 1) + 1/s. $
]

== Problem 6

#example[
  Find $cal(L){t^2 e^t cos(t)}$.
]

#soln[
  Let $f(t) = t^2 cos(t)$. Then $cal(L){t^2 e^t cos(t)} = cal(L){f(t) e^t}$,
  which by the $s$-shift rule is $F(s)$ shifted by $-1$ in the $s$-domain.

  Taking $cal(L){t^2 cos(t)} = (s^2 - 2 s + 1)/(s^2 + 1)^2$ and accounting
  for the shift,

  $ ((s - 1)^2 - 2(s - 1) + 1)/(((s - 1)^2 + 1)^2). $
]

== Problem 7

#example[
  Find $cal(L){t sin^2(t)}$.
]

#soln[
  Use the power-reduction identity first:

  $ cal(L){t sin^2(t)} = cal(L){t (1 - cos(2t))/2}
    = 1/2 cal(L){t} - 1/2 cal(L){t cos(2t)} $
  $ = 1/2 dot.c 1/s^2 + 1/2 dot.c (s^2 + 4 - 2 s^2)/(s^2 + 4)^2. $
]

== Problem 8

#example[
  Find $cal(L){e^t integral_0^t tau e^(-2 tau) dif tau}$.
]

#soln[
  Work outwards from the innermost function.

  $ cal(L){tau e^(-2 tau)} = 1/(s + 2)^2 $

  by the $s$-shift applied to $cal(L){t} = 1\/s^2$. Then the integral rule
  $cal(L){integral_0^t f} = F(s)\/s$ gives

  $ cal(L){integral_0^t tau e^(-2 tau) dif tau} = 1/s dot.c 1/(s + 2)^2, $

  and accounting for the outer $e^t$ by shifting $s -> s - 1$,

  $ cal(L){e^t integral_0^t tau e^(-2 tau) dif tau}
    = 1/(s - 1) dot.c 1/((s - 1) + 2)^2. $
]

== Problem 9

#example[
  Find $cal(L){integral_0^t tau^2 e^(-tau) sin(tau) dif tau}$.
]

#soln[
  Again from the inside out:

  $ cal(L){sin(tau)} = 1/(s^2 + 1),
    quad cal(L){e^(-tau) sin(tau)} = 1/((s + 1)^2 + 1), $
  $ cal(L){tau^2 e^(-tau) sin(tau)}
    = dif^2/(dif s^2) 1/((s + 1)^2 + 1)
    = dif^2/(dif s^2) 1/(s^2 + 2 s + 2). $

  Differentiating once,

  $ dif/(dif s) ((s^2 + 2s + 2) dot.c 0 - (2s + 2) dot.c 1)/(s^2 + 2s + 2)^2
    = dif/(dif s) (-(2s + 2))/(s^2 + 2s + 2)^2, $

  and again,

  $ = (-2(s^2 + 2s + 2)^2 - (2s + 2)(4 s^3 + 12 s^2 + 12 s + 8))/(s^2 + 2s + 2)^4. $

  Finally the integral rule contributes a factor $1\/s$:

  $ cal(L){integral_0^t tau^2 e^(-tau) sin(tau) dif tau}
    = 1/s dot.c (-2(s^2 + 2s + 2)^2 - (2s + 2)(4 s^3 + 12 s^2 + 12 s + 8))/(s^2 + 2s + 2)^4. $
]

== Problem 10

#example[
  Find $cal(L){integral_0^t (integral_0^tau alpha e^(-alpha) dif alpha) dif tau}$.
]

#soln[
  $ cal(L){alpha e^(-alpha)} = 1/(s + 1)^2, $
  $ cal(L){integral_0^tau alpha e^(-alpha) dif alpha} = 1/(s (s + 1)^2), $

  and one more application of the integral rule for the outer integral:

  $ cal(L){integral_0^t (integral_0^tau alpha e^(-alpha) dif alpha) dif tau}
    = 1/(s^2 (s + 1)^2). $
]

#key[
  Each nested $integral_0^t$ contributes exactly one factor of $1\/s$. Two
  nested integrals, $1\/s^2$ — no new work beyond transforming the
  integrand.
]

= Worked Problems III: Step Functions and Forced Systems

Seven problems on forcing that switches on and off. Everything needed is in
Chapter 10: the unit step $u(t - c)$, the two step rules

$ cal(L){u(t - c)} = e^(-c s)/s, quad
  cal(L){u(t - c) f(t - c)} = e^(-c s) F(s), $

and partial fractions for the return journey. Every problem below is the same
three moves — write the forcing with steps, transform, invert — so it is
worth watching for the pattern rather than the particulars.

== Problem 1

#example[
  Write the following in terms of the unit step function and sketch its
  graph.
  $ f(t) = cases(
    0 &"if" 0 <= t < 1,
    sin pi t quad &"if" 1 <= t < 2,
    0 &"if" 2 <= t,
  ) $
]

#soln[
  $ f(t) = sin(pi t) u(t - 1) - sin(pi t) u(t - 2). $

  #plot(
    (
      (fn: x => 0, from: -0.3, to: 1, dash: "dashed"),
      (fn: x => calc.sin(calc.pi * x), from: 1, to: 2),
      (fn: x => 0, from: 2, to: 3.3, dash: "dashed"),
    ),
    xlim: (-0.4, 3.5), ylim: (-1.35, 1.35),
    height: 3.6cm,
    xticks: (1, 2, 3), yticks: (-1, 1),
    xlabel: $t$, ylabel: $f(t)$,
    marks: ((x: 1, y: 0, open: true), (x: 2, y: 0, open: true)),
  )

  The arch is the negative half of $sin(pi t)$, since $sin(pi t) <= 0$ for
  $1 <= t <= 2$.
]

== Problem 2

#example[
  Determine $cal(L){u(t - 2)(t - 2)^2}$.
]

#soln[
  This is already in the form $u(t - c) f(t - c)$ with $c = 2$ and
  $f(t) = t^2$. Since $cal(L){t^n} = n!\/s^(n+1)$,

  $ F(s) = cal(L){t^2} = 2!/s^3 = 2/s^3, $

  and therefore

  $ cal(L){u(t - 2)(t - 2)^2} = e^(-2s) dot.c 2/s^3 = (2 e^(-2s))/s^3. $
]

#imp(title: "There is no product rule")[
  A tempting first move is to write

  $ cal(L){u(t - 2)(t - 2)^2}
    = cal(L){u(t - 2)} times cal(L){(t - 2)^2}. $

  It is false. The Laplace transform of a product is *not* the product of the
  transforms — which is exactly why the $t$-shift rule is stated for the one
  specific combination $u(t-c) f(t-c)$ rather than for arbitrary products.
  (What a product of two transforms does correspond to is a *convolution* in
  $t$, a different and more involved operation.)
]

== Problem 3

#example[
  Determine the Laplace transform of one arch of a sine wave,
  $ f(t) = cases(
    sin t quad &(0 <= t < pi),
    0 &(pi <= t).
  ) $
]

#soln[
  *Write it with a step.* The function is $sin t$ everywhere, minus $sin t$
  from $t = pi$ onwards:

  $ f(t) = sin t - sin(t) u(t - pi). $

  *Put the second term in shifted form.* The rule needs $f(t - pi)$, not
  $f(t)$, so $sin t$ has to be re-expressed in terms of $(t - pi)$. Using the
  angle-sum identity,

  $ sin t = sin((t - pi) + pi) = -sin(t - pi), $

  since $sin(theta + pi) = -sin theta$. Therefore

  $ f(t) = sin t + sin(t - pi) u(t - pi), $

  and the minus sign in front of the step has turned into a plus.

  *Transform.* With $cal(L){sin t} = 1\/(s^2 + 1)$ and the $t$-shift rule
  applied to the second term with $c = pi$,

  $ cal(L){f(t)} = 1/(s^2 + 1) + e^(-pi s) dot.c 1/(s^2 + 1)
    = (1 + e^(-pi s))/(s^2 + 1). $

  #plot(
    (
      (fn: x => calc.sin(x), from: 0, to: calc.pi),
      (fn: x => 0, from: calc.pi, to: 6.6, dash: "dashed"),
    ),
    xlim: (-0.5, 6.9), ylim: (-0.3, 1.3),
    height: 3cm,
    xticks: (1, 2, 3, 4, 5, 6), yticks: (1,),
    xlabel: $t$, ylabel: $f(t)$,
    marks: ((x: calc.pi, y: 0),),
  )
]

#key(title: "Rewriting for the shift")[
  Step two above is the move that most often gets skipped, and it is worth
  isolating. The rule transforms $u(t - c) g(t - c)$; if what you have is
  $u(t - c) g(t)$, you must first rewrite $g(t)$ as a function of $(t - c)$.

  For a sine or cosine this is an angle-sum identity, as here. For a
  polynomial it is a substitution: $t = (t - c) + c$, expanded out. Problem 5
  below does exactly that with $t = (t - 1) + 1$. Skipping the rewrite and
  applying $e^(-c s)$ to the unshifted transform gives an answer that is
  simply wrong, with no warning sign in the algebra.
]

== Problem 4

#example[
  Find the inverse transform of $e^(-s)/(s(s + 1))$ and sketch its graph.
]

#soln[
  $ cal(L)^(-1) {e^(-(1) s) dot.c 1/(s(s + 1))}
    = u(t - 1) dot.c f(t - 1), quad "where" f = cal(L)^(-1){F(s)}. $

  Decompose $F(s)$ by partial fractions:

  $ 1/(s(s + 1)) = a/s + b/(s + 1)
    quad ==> quad 1 = s(a + b) + a
    quad ==> quad a = 1, b = -1, $
  $ 1/(s(s + 1)) = 1/s - 1/(s + 1). $

  Inverting,

  $ f(t) = cal(L)^(-1){1/s - 1/(s + 1)} = 1 - e^(-t), $

  and applying the shift to the *argument*,

  $ cal(L)^(-1) {e^(-s)/(s(s + 1))} = u(t - 1) (1 - e^(-(t - 1))). $

  #plot(
    (
      (fn: x => 0, from: -0.3, to: 1, dash: "dashed"),
      (fn: x => 1 - calc.exp(-(x - 1)), from: 1, to: 5.3),
    ),
    xlim: (-0.4, 5.5), ylim: (-0.18, 1.2),
    height: 3.4cm,
    xticks: (1, 2, 3, 4, 5), yticks: (1,),
    xlabel: $t$, ylabel: $y$,
    marks: ((x: 1, y: 0),),
  )
]

#imp(title: "Shift the argument, not just the switch")[
  The commonest error here is to stop at $u(t - 1)(1 - e^(-t))$, putting the
  step in front of $f(t)$ rather than $f(t - 1)$.

  The consequence is visible in the sketch. The correct answer leaves the
  axis at $t = 1$ from a value of zero and rises smoothly. The version
  without the argument shift jumps straight to
  $1 - e^(-1) approx 0.63$ at $t = 1$ — discontinuous exactly where it should
  be continuous. Evaluating at $t = c$ is a quick way to catch this.
]

== Problem 5

#example[
  Solve $y'' + y = t - u(t - 1) t$ with $y(0) = 0$, $y'(0) = 0$, and sketch
  both the forcing function and the solution.
]

#soln[
  *The forcing function.* $g(t) = t - u(t - 1) t$ ramps up and then switches
  off at $t = 1$.

  #plot(
    (
      (fn: x => x, from: -0.6, to: 1),
      (fn: x => 0, from: 1, to: 3.3),
    ),
    xlim: (-0.8, 3.5), ylim: (-1.1, 2.2),
    height: 3.4cm,
    xticks: (-1, 1, 2, 3), yticks: (-1, 1, 2),
    xlabel: $t$, ylabel: $g(t)$,
    marks: ((x: 1, y: 1, open: true), (x: 1, y: 0)),
  )

  *Rewrite the forcing in shifted form.* The $t$-shift rule needs
  $u(t - 1) f(t - 1)$, so express $t$ as $(t - 1) + 1$:

  $ g(t) = t - u(t - 1)[(t - 1) + 1]
         = t - [u(t - 1)(t - 1) + u(t - 1)]. $

  *Transform.*

  $ cal(L){g(t)} = 1/s^2 - e^(-s)/s^2 - e^(-s)/s
    = 1/s^2 - e^(-s) [1/s^2 + 1/s]. $

  On the left, with both initial conditions zero,

  $ cal(L){y''} + cal(L){y} = s^2 Y - s y(0) - y'(0) + Y = Y(s^2 + 1). $

  *Solve for $Y$.*

  $ Y (s^2 + 1) = 1/s^2 - e^(-s) [1/s^2 + 1/s], $
  $ Y = 1/(s^2 (s^2 + 1))
      - e^(-s) [1/(s^2 (s^2 + 1)) + 1/(s (s^2 + 1))]. $

  *Invert.* From the table of Chapter 10 with $a = 1$,

  $ cal(L)^(-1) {1/(s^2 (s^2 + 1))} = 1/a^3 [a t - sin(a t)] = t - sin(t), $
  $ cal(L)^(-1) {1/(s (s^2 + 1))} = 1/a^2 [1 - cos(a t)] = 1 - cos(t). $

  Accounting for the shift on the bracketed pair,

  $ y = (t - sin t) - u(t - 1)[(t - 1) - sin(t - 1) + 1 - cos(t - 1)]. $

  #plot(
    (
      (fn: x => x - calc.sin(x), from: 0, to: 1),
      (fn: x => calc.sin(x - 1) - calc.sin(x) + calc.cos(x - 1), from: 1, to: 8),
    ),
    xlim: (-0.5, 8.3), ylim: (-1.4, 2.3),
    height: 3.6cm,
    xticks: (1, 2, 4, 6, 8), yticks: (-1, 1, 2),
    xlabel: $t$, ylabel: $y$,
  )

  Before $t = 1$ the ramp drives the solution upward; once the forcing stops
  the equation is homogeneous and the response settles into the free
  oscillation $sin(t - 1) - sin(t) + cos(t - 1)$ of constant amplitude.
]

== Problem 6

#example[
  Solve $y'' + 3 y' + 3 y = u(t - 2)$ with $y(0) = 0$, $y'(0) = 1$, and
  sketch the solution.
]

#soln[
  *Transform.* Using $cal(L){u(t - 2)} = e^(-2s)\/s$,

  $ s^2 Y - s y(0) - y'(0) + 3[s Y - y(0)] + 3 Y = e^(-2s)/s, $
  $ s^2 Y - 1 + 3 s Y + 3 Y = e^(-2s)/s, $
  $ Y (s^2 + 3 s + 3) = e^(-2s)/s + 1, $
  $ Y = underbrace(1/(s^2 + 3 s + 3), Y_1)
      + underbrace(e^(-2s)/(s(s^2 + 3 s + 3)), Y_2). $

  *Complete the square.* The quadratic is irreducible, so

  $ s^2 + 3 s + 3 = (s + 3/2)^2 - 9/4 + 3 = (s + 3/2)^2 + 3/4, $

  giving the pair $a = 3\/2$ and $sqrt(3)\/2$ that appears throughout.

  *Invert $Y_1$.* With $b = sqrt(3)\/2$,

  $ y_1 (t) = cal(L)^(-1) {1/((s + 3/2)^2 + 3/4)}
    = 1/b e^(-3/2 t) sin(b t)
    = 2/sqrt(3) e^(-1.5 t) sin(sqrt(3)/2 t). $

  *Invert $Y_2$.* First decompose:

  $ 1/(s(s^2 + 3s + 3)) = A/s + (B s + C)/(s^2 + 3s + 3), $
  $ A(s^2 + 3s + 3) + (B s + C) s = 1
    quad ==> quad A = 1/3, B = -1/3, C = -1. $

  So

  $ 1/(s(s^2 + 3s + 3))
    = 1/3 [1/s - (s + 3)/(s^2 + 3s + 3)]
    = 1/3 [1/s - (s + 3/2)/((s + 3/2)^2 + 3/4)
           - (3/2)/((s + 3/2)^2 + 3/4)], $

  and inverting term by term,

  $ f(t) = 1/3 [1 - e^(-1.5 t) cos(sqrt(3)/2 t)
    - sqrt(3) e^(-1.5 t) sin(sqrt(3)/2 t)]. $

  *Apply the shift and assemble.*

  $ y = 2/sqrt(3) e^(-1.5 t) sin(sqrt(3)/2 t) + u(t - 2) f(t - 2). $

  #plot(
    (
      (fn: x => 2 / calc.sqrt(3) * calc.exp(-1.5 * x) * calc.sin(calc.sqrt(3) / 2 * x),
       from: 0, to: 2),
      (fn: x => 2 / calc.sqrt(3) * calc.exp(-1.5 * x) * calc.sin(calc.sqrt(3) / 2 * x)
        + 1 / 3 * (1 - calc.exp(-1.5 * (x - 2)) * calc.cos(calc.sqrt(3) / 2 * (x - 2))
          - calc.sqrt(3) * calc.exp(-1.5 * (x - 2)) * calc.sin(calc.sqrt(3) / 2 * (x - 2))),
       from: 2, to: 9),
    ),
    xlim: (-0.5, 9.3), ylim: (-0.25, 0.65),
    height: 3.4cm,
    xticks: (2, 4, 6, 8), yticks: (0.3,),
    xlabel: $t$, ylabel: $y$,
  )

  The initial kick $y'(0) = 1$ decays away; at $t = 2$ the step switches on
  and the solution climbs to its new equilibrium $1\/3$.
]

== Problem 7

#example[
  Solve $y'' + 2 y' + 5 y = 10 - 10 u(t - pi)$ with $y(0) = 0$,
  $y'(0) = 0$, and sketch the solution.
]

#soln[
  *Transform.*

  $ s^2 Y + 2 s Y + 5 Y = 10/s - 10 e^(-pi s)/s
    = (10 - 10 e^(-pi s))/s, $
  $ Y = (10 (1 - e^(-pi s)))/(s(s^2 + 2 s + 5)). $

  *Decompose.*

  $ 10/(s(s^2 + 2s + 5)) = A/s + (B s + C)/(s^2 + 2s + 5), $
  $ A(s^2 + 2s + 5) + (B s + C) s = 10
    quad ==> quad A = 2, B = -2, C = -4, $
  $ = 2/s - (2 s + 4)/(s^2 + 2s + 5). $

  *Complete the square* — $s^2 + 2s + 5 = (s + 1)^2 + 2^2$ — and split the
  numerator so each piece matches a table entry:

  $ = 2/s - (2(s + 1))/((s + 1)^2 + 2^2) - 2/((s + 1)^2 + 2^2). $

  *Invert.*

  $ h(t) = 2 - 2 e^(-t) cos(2t) - e^(-t) sin(2t), $

  the last term picking up a factor $1\/2$ because
  $cal(L){e^(-t) sin(2t)} = 2\/((s+1)^2 + 4)$.

  *Apply the shift.* Since $Y = (1 - e^(-pi s)) H(s)$,

  $ y(t) = h(t) - u(t - pi) h(t - pi). $

  #plot(
    (
      (fn: x => 2 - 2 * calc.exp(-x) * calc.cos(2 * x) - calc.exp(-x) * calc.sin(2 * x),
       from: 0, to: calc.pi),
      (fn: x => (2 - 2 * calc.exp(-x) * calc.cos(2 * x) - calc.exp(-x) * calc.sin(2 * x))
        - (2 - 2 * calc.exp(-(x - calc.pi)) * calc.cos(2 * (x - calc.pi))
           - calc.exp(-(x - calc.pi)) * calc.sin(2 * (x - calc.pi))),
       from: calc.pi, to: 9),
    ),
    xlim: (-0.5, 9.3), ylim: (-0.7, 3.1),
    height: 3.6cm,
    xticks: (2, 4, 6, 8), yticks: (1, 2, 3),
    xlabel: $t$, ylabel: $y$,
  )

  The constant forcing drives the system up towards $y = 2$ with a damped
  overshoot; at $t = pi$ it is removed and the solution decays back to zero.
]

#imp(title: "The " + $b$ + " is already in the numerator")[
  The table entry is
  $cal(L){e^(a t) sin(b t)} = b\/((s - a)^2 + b^2)$: the numerator is $b$,
  not $1$. So $2\/((s + 1)^2 + 4)$ inverts to $e^(-t) sin(2t)$ *exactly*,
  with no leading coefficient. Reading that $2$ as a separate factor and
  writing $2 e^(-t) sin(2t)$ doubles the term.

  A second trap in the same line: when a solution has the form
  $y = h(t) - u(t - c) h(t - c)$, the step multiplies the *whole* of
  $h(t - c)$. Dropping the brackets and attaching $u(t - c)$ to only the
  first term of $h$ leaves the remainder switched permanently on.
]

#key[
  Every problem in this set is the same three moves: write the forcing with
  unit steps, transform (initial conditions enter here, not later), and
  invert with the argument shifted by the same $c$ that appears in
  $e^(-c s)$. The algebra in between is partial fractions and completing the
  square — nothing that is specific to differential equations at all.
]
