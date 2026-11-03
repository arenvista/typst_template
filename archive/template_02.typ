// Math notetaking template
// Usage in a note file:
//   #import "template.typ": *
//   #show: notes.with(title: "Topic", course: "MATH 302", date: "2026-07-30")
//
// Pass `numbered: true` to have the theorem-like environments number
// themselves ("Definition 1.2.") and reset at each level-1 heading.
// It defaults to off so existing notes render exactly as before.

// Shared counter for every `_labeled` environment. It always steps; whether
// the number is shown is decided by `_env-numbered`.
#let _env-counter = counter("environment")
#let _env-numbered = state("env-numbered", false)

#let ip(x, y) = $lr(chevron.l #x, #y chevron.r)$

#let notes(
  title: "Notes",
  course: none,
  author: none,
  date: none,
  numbered: false,
  body,
) = {
  _env-numbered.update(numbered)
  set document(title: title, author: if author == none { () } else { author })
  set page(
    paper: "us-letter",
    margin: (x: 1in, y: 1in),
    numbering: "1",
    number-align: center,
  )
  set text(font: "New Computer Modern", size: 11pt, lang: "en")
  set par(justify: true, leading: 0.65em)

  // Headings
  set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    _env-counter.update(0)
    set text(size: 15pt)
    block(above: 1.4em, below: 0.8em, it)
  }
  show heading.where(level: 2): it => {
    set text(size: 12.5pt)
    block(above: 1.1em, below: 0.6em, it)
  }

  // Equations numbered by section
  set math.equation(numbering: "(1.1)")

  // Nice links and inline code
  show link: set text(fill: rgb("#1a5fb4"))
  show raw.where(block: false): box.with(
    fill: luma(240),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // Title block
  block(
    width: 100%,
    {
      text(size: 20pt, weight: "bold", title)
      if course != none or date != none {
        v(0.3em)
        text(size: 10.5pt, fill: luma(90))[
          #if author != none [ #author ]
          #if author != none [ #h(0.5em) · #h(0.5em) ]
          #if course != none [ #course ]
          #if course != none and date != none [ #h(0.5em) · #h(0.5em) ]
          #if date != none [ #date ]
        ]
      }
    },
  )
  line(length: 100%, stroke: 0.5pt + luma(180))
  v(0.6em)

  body
}

// ---- Callout / theorem-like environments ----

#let _box(name, color, it) = block(
  width: 100%,
  fill: color.lighten(88%),
  stroke: (left: 2.5pt + color),
  inset: (x: 10pt, y: 8pt),
  radius: 2pt,
  above: 1em,
  below: 1em,
  it,
)

// `counted: false` keeps an environment out of the numbering entirely -- it
// neither shows a number nor consumes one (proofs, conventionally).
#let _labeled(kind, color, title, body, counted: true) = _box(
  kind,
  color,
  {
    // Step first, then read: a `context` block sees the document state at its
    // own position, so stepping inside it would read the pre-step value.
    if counted { _env-counter.step() }
    context {
      let head = if counted and _env-numbered.get() {
        let sec = counter(heading).get()
        let n = _env-counter.get().first()
        let num = if sec.len() > 0 and sec.first() > 0 {
          numbering("1.1", sec.first(), n)
        } else {
          numbering("1", n)
        }
        [#kind #num]
      } else {
        [#kind]
      }
      text(weight: "bold", fill: color.darken(15%), head)
      if title != none [#text(weight: "bold")[ (#title)]]
      text(weight: "bold")[.]
      h(0.4em)
      body
    }
  },
)

#let definition(title: none, body) = _labeled("Definition", rgb("#1a5fb4"), title, body)
#let theorem(title: none, body) = _labeled("Theorem", rgb("#a51d2d"), title, body)
#let lemma(title: none, body) = _labeled("Lemma", rgb("#a51d2d"), title, body)
#let corollary(title: none, body) = _labeled("Corollary", rgb("#a51d2d"), title, body)
#let proposition(title: none, body) = _labeled("Proposition", rgb("#a51d2d"), title, body)
#let question(title: none, body) = _labeled("Question", rgb("#a51d2d"), title, body)
#let example(title: none, body) = _labeled("Example", rgb("#2e7d32"), title, body)
#let remark(title: none, body) = _labeled("Remark", rgb("#6c5b00"), title, body)
#let case(title: none, body) = _labeled("Case", rgb("#6c5b00"), title, body)
#let proof(title: none, body) = _labeled(
  "Proof",
  rgb("#2e7d32"),
  title,
  [#body #h(1fr) $qed$],
  counted: false,
)

#let claim(title: none, body) = _labeled("Claim", rgb("#a51d2d"), title, body)
#let conjecture(title: none, body) = _labeled("Conjecture", rgb("#a51d2d"), title, body)
#let axiom(title: none, body) = _labeled("Axiom", rgb("#1a5fb4"), title, body)
#let notation(title: none, body) = _labeled("Notation", rgb("#1a5fb4"), title, body)
#let exercise(title: none, body) = _labeled("Exercise", rgb("#1a5fb4"), title, body)
#let solution(title: none, body) = _labeled("Solution", rgb("#2e7d32"), title, body)
#let observation(title: none, body) = _labeled("Observation", rgb("#6c5b00"), title, body)
#let warning(title: none, body) = _labeled("Warning", rgb("#c64600"), title, body)

// Proof environment with a QED tombstone
// #let proof(body) = block(
//   above: 1em,
//   below: 1em,
//   stroke: 0.5pt,
//   inset: 1em,
//   radius: 3pt,
//   width: 100%,
// )[
//   #emph[Proof.] #h(0.3em) #body #h(1fr) $square$
// ]

// ---- Handy math shortcuts ----
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
#let ip(a, b) = $lr(⟨ #a, #b ⟩)$
// Coordinate pair: `coord(x, y)` -> ⟨x, y⟩
#let coord(x, y) = $lr(chevron.l #x, #y chevron.r)$
#let norm(x) = $lr(bar.v.double #x bar.v.double)$
#let abs(x) = $lr(bar.v #x bar.v)$
#let card(x) = $lr(bar.v #x bar.v)$

// Set-builder: `#setb($x in RR$, $x > 0$)` -> { x in RR : x > 0 }
#let setb(x, cond) = $lr({ #x : #cond })$
// Restriction and evaluation bars: `#restr($f$, $A$)`, `#evalat($F(x)$, $a$, $b$)`
#let restr(f, a) = $lr(#f bar.v)_#a$
#let evalat(x, a, b) = $lr(#x bar.v)_#a^#b$
// Derivatives: `#dv($y$, $x$)` -> dy/dx, `#pdv($f$, $x$)` -> partial f / partial x
#let dv(f, x) = $(dif #f) / (dif #x)$
#let pdv(f, x) = $(partial #f) / (partial #x)$

// Operators Typst does not ship. `det`, `dim`, `ker`, `tr`, `im`, `id`,
// `hom`, `Pr`, `gcd`, `lcm`, `min`, `max`, `inf`, `sup` already exist -- do
// not redefine those.
#let rank = math.op("rank")
#let span = math.op("span")
#let sgn = math.op("sgn")
#let diag = math.op("diag")
#let adj = math.op("adj")
#let nullity = math.op("nullity")
#let proj = math.op("proj")
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

// ---- Problem headings ----
// `#problem(1)[...]` or `#problem(2, title: "Cauchy sequences", newpage: true)[...]`
// Renders an unnumbered level-1 heading so it still lands in the outline.
#let problem(n, title: none, newpage: false, body) = {
  if newpage { pagebreak(weak: true) }
  heading(level: 1, numbering: none)[
    Problem #n#if title != none [: #title]
  ]
  body
}

// ---- Homework variant ----
// Same as `notes`, plus the settings every problem set wants:
// no equation numbers, roomier enums, and breathing space after ∃/∀.
#let homework(..args, body) = {
  show: notes.with(..args)
  set math.equation(numbering: none)
  set enum(spacing: 1.4em)

  // Heading numbering, one scheme per depth, each restarting under its
  // parent: `Question 2`, `(a)`, `(i)`, then nothing. A flat "1.1" pattern
  // repeats its last digit forever and turns a case heading into "2.1.1.1".
  set heading(numbering: (..n) => {
    let ns = n.pos()
    if ns.len() == 2 { numbering("(a)", ns.last()) }
    else if ns.len() == 3 { numbering("(i)", ns.last()) }
    else if ns.len() >= 4 { none }
    else { numbering("1.", ns.last()) }
  })
  // Level 1 reads "Question 2", not "2. Question": write `= Question` in the
  // source and let the counter supply the number. Re-states the level-1
  // styling from `notes` because the returned block is no longer a heading.
  show heading.where(level: 1): it => {
    _env-counter.update(0)
    block(
      above: 1.4em,
      below: 0.8em,
      text(size: 15pt, weight: "bold")[#it.body #context counter(heading).display("1")],
    )
  }
  show math.equation: it => {
    show sym.exists: e => e + h(0.17em)
    show sym.forall: f => f + h(0.17em)
    it
  }
  body
}
