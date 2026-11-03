#import "@local/folio:0.1.0": *

// One of: notes, homework, paper, book. See the README for what each does
// and every option they take.
#show: notes.with(
  title: "Title",
  course: "MATH 000",
  author: "Aren Vista",
  date: datetime.today().display("[year]-[month]-[day]"),
)

= First section

#definition(title: "Something")[
  The thing being defined.
]

#theorem[A statement worth proving.]
#proof[Because it follows.]

#example[A concrete instance.]
