#import "@preview/hydra:0.6.2": hydra

// 设置页面参数
#set page(
  paper: "a4",
  margin: 1.5cm,
  header: context {
    if calc.odd(here().page()) {
      align(right, "Cheet Sheet   " + hydra(1))
    } else {
      align(left, "Cheet Sheet   " + hydra(1))
    }
  },
  numbering: "1",
)
#set text(
  lang: "zh",
  region: "CN",
  size: 11pt,
  font: (
    "Source Han Serif",
  )
)
#set heading(
  numbering: "1."
)
#set raw(
  theme: "MonoCode.tmTheme", 
)
#show raw.where(block: true): it => {
  set text(font: "JetBrainsMono NF", size: 10pt) 
  it
}

// 封面与目录
#align(center, text(24pt)[
  XCPC Cheat Sheet 
])
#align(center, text(12pt)[
  brofea 
])
#align(center, text(12pt)[
  2026.3.20 Update
])
#outline()
#pagebreak()

// 正文内容

#include ("./1Tricks.typ")
#include ("./2Basic.typ")
#include ("./4DP.typ")
#include ("./5String.typ")
#include ("./6Math.typ")
#include ("./7DS.typ")
#include ("./8Graph.typ")