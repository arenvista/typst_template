# Archive

The source material `template_main.typ` was distilled from. Nothing here is
part of the package; it is kept for reference and for the two documents,
which are still worth compiling.

| File | What it is |
|---|---|
| `template_01.typ` | the earlier notes template — glyphs, environment palette, math shorthands |
| `template_02.typ` | its sibling — the homework heading scheme, `coord` |
| `textbook.typ` | a differential equations textbook: the box design, `plot`, the book shell |
| `LinearAlgebra.typ` | a linear algebra review: the figure primitives, table styling, chapter openers |

`textbook.typ` and `LinearAlgebra.typ` carry their own preambles and compile
standalone, unchanged:

```sh
typst compile archive/textbook.typ
```

Where each name ended up in the merged template is tabulated in the last
section of `../README.typ`.
