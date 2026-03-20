#import "@preview/hydra:0.6.1": hydra

#set page(paper: "a7", margin: (y: 4em), numbering: "1", 
header: context {
  if calc.odd(here().page()) {
    align(right, emph(hydra(1)))
  } else {
    align(left, emph(hydra(2)))
  }
}
)
#set heading(numbering: "1.")
#show heading.where(level: 1): it => pagebreak(weak: true) + it

= Introduction
#lorem(50)

= Content
== First Section
#lorem(50)
== Second Section
#lorem(100)