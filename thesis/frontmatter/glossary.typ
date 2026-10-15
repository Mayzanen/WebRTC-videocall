/** glossary.typ
 *
 * Write the glossary (sanasto) of your work here, into the typst
 * [dictionary] glossary_words. Each entry in the dictionary
 * needs to contain the keys name and description. The glossary
 * will be sorted according to the entry keys.
 *
 * [dictionary]: https://typst.app/docs/reference/foundations/dictionary/
 *
***/

#import "../preamble.typ": *

#let glossary_words = (
 p2p: (
  name: "P2P",
  description: "Peer-to-peer, tietoliikennemalli, jossa osapuolet kommunikoivat suoraan keskenään ilman keskitettyä palvelinta median välittämiseen."
 ),
 mcu: (
  name: "MCU",
  description: "Multipoint Control Unit, keskitetty mediapalvelinarkkitehtuuri, jossa palvelin vastaanottaa, yhdistää ja uudelleenkoodaa osallistujien mediavirtoja."
 ),
 sfu: (
  name: "SFU",
  description: "Selective Forwarding Unit, mediapalvelinarkkitehtuuri, jossa palvelin välittää vastaanotettuja mediavirtoja valituille vastaanottajille ilman niiden dekoodaamista tai uudelleenkoodaamista."
 ),
 webrtc: (
  name: "WebRTC",
  description: "Web Real-Time Communication, avoimiin standardeihin perustuva teknologia, joka mahdollistaa reaaliaikaisen ääni-, video- ja tiedonsiirron verkkoselainten ja muiden sovellusten välillä."
 ),
 w3c: (
  name: "W3C",
  description: "World Wide Web Consortium, kansainvälinen organisaatio, joka kehittää ja ylläpitää World Wide Webin avoimia standardeja."
 ),
 ietf: (
  name: "IETF",
  description: "Internet Engineering Task Force, kansainvälinen organisaatio, joka kehittää ja standardoi Internetin protokollia ja muita Internet-teknologioita."
 ),
 ice: (
  name: "ICE",
  description: "Interactive Connectivity Establishment, mekanismi, jonka avulla WebRTC-päätelaitteet etsivät toimivan yhteysreitin NAT- ja palomuuriolosuhteista riippumatta."
),
nat: (
  name: "NAT",
  description: "Network Address Translation, verkkotekniikka, joka muuntaa yksityisten ja julkisten IP-osoitteiden välisiä yhteyksiä."
),
stun: (
  name: "STUN",
  description: "Session Traversal Utilities for NAT, protokolla, jonka avulla päätelaite voi selvittää NAT-laitteen kautta näkyvän julkisen IP-osoitteen ja portin."
),
turn: (
  name: "TURN",
  description: "Traversal Using Relays around NAT, protokolla, joka mahdollistaa liikenteen välittämisen palvelimen kautta, kun suoraa yhteyttä päätelaitteiden välillä ei voida muodostaa."
),
wcag: (
  name: "WCAG",
  description: "Web Content Accessibility Guidelines, verkkosisällön saavutettavuusohjeet."
),
)
