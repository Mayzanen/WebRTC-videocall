//
// This file is where you should include the files
// belonging to your main matter, or the actual main
// contents of the thesis that come after the front matter.
// In other words, chapters from introduction to conclusion
// go here.
//
// Appendices have their own index file appendices/index.typ.
// Include appendix-specific chapters there.
//

#let mainMatterFiles = (
  "01_johdanto.typ",
  "02_webrtc.typ",
  "03_kaytettavyys.typ",
  "04_jarjestelman_suunnittelu.typ",
  "05_jarjestelman_toteutus.typ",
  "06_testaus_ja_arviointi.typ",
  "07_pohdinta.typ",
  "08_yhteenveto.typ",
)

#for file in mainMatterFiles {
  include file
}
