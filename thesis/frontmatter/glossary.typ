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
  css: (
    name: "CSS",
    description: "Cascading Style Sheets, tyylimäärittelykieli verkkosivujen ulkoasun määrittelyyn."
  ),
  dtls: (
    name: "DTLS",
    description: "Datagram Transport Layer Security, datagrammipohjaisten yhteyksien suojaamiseen tarkoitettu TLS-protokollan muunnelma."
  ),
  dtls_srtp: (
    name: "DTLS-SRTP",
    description: "Datagram Transport Layer Security–Secure Real-time Transport Protocol, menetelmä, jossa DTLS:n avulla muodostetaan SRTP-mediavirtojen suojaamiseen tarvittavat salausavaimet."
  ),
  html: (
    name: "HTML",
    description: "Hypertext Markup Language, verkkosivujen rakenteen määrittelyyn käytettävä merkintäkieli."
  ),
  http: (
    name: "HTTP",
    description: "Hypertext Transfer Protocol, verkkoselaimen ja palvelimen väliseen tiedonsiirtoon käytettävä sovelluskerroksen protokolla."
  ),
  https: (
    name: "HTTPS",
    description: "Hypertext Transfer Protocol Secure, TLS-suojattu HTTP-yhteys."
  ),
  ice: (
    name: "ICE",
    description: "Interactive Connectivity Establishment, yhteydenmuodostusmenetelmä, jonka avulla etsitään ja testataan mahdollisia yhteysreittejä myös NAT- ja palomuuriympäristöissä."
  ),
  ietf: (
    name: "IETF",
    description: "Internet Engineering Task Force, avoin kansainvälinen standardointiyhteisö, joka kehittää Internetin protokollia ja muita Internet-teknologioita."
  ),
  json: (
    name: "JSON",
    description: "JavaScript Object Notation, kevyt tekstimuotoinen tiedonsiirtoformaatti."
  ),
  mcu: (
    name: "MCU",
    description: "Multipoint Control Unit, keskitetty mediapalvelinarkkitehtuuri, jossa palvelin käsittelee ja yhdistää osallistujien mediavirtoja ennen niiden välittämistä vastaanottajille."
  ),
  nat: (
    name: "NAT",
    description: "Network Address Translation, verkkotekniikka, jossa osoitteita ja tarvittaessa porttinumeroita muunnetaan verkkoyhteyksien välityksessä."
  ),
  p2p: (
    name: "P2P",
    description: "Peer-to-peer, tietoliikennemalli, jossa osapuolet kommunikoivat suoraan keskenään ilman keskitettyä palvelinta median välittämiseen."
  ),
  rtp: (
    name: "RTP",
    description: "Real-time Transport Protocol, reaaliaikaisen ääni- ja videodatan välittämiseen käytettävä protokolla."
  ),
  sdp: (
    name: "SDP",
    description: "Session Description Protocol, istunnon media- ja yhteysasetusten kuvaamiseen käytettävä formaatti."
  ),
  sfu: (
    name: "SFU",
    description: "Selective Forwarding Unit, mediapalvelinarkkitehtuuri, jossa palvelin välittää vastaanotettuja mediavirtoja valituille vastaanottajille ilman niiden dekoodaamista tai uudelleenkoodaamista."
  ),
  stun: (
    name: "STUN",
    description: "Session Traversal Utilities for NAT, protokolla, jonka avulla päätelaite voi selvittää NAT-laitteen kautta näkyvän julkisen verkko-osoitteen ja portin."
  ),
  tls: (
    name: "TLS",
    description: "Transport Layer Security, tietoliikenteen salaamiseen, eheyden varmistamiseen ja yhteyden osapuolen todentamiseen käytettävä tietoturvaprotokolla."
  ),
  turn: (
    name: "TURN",
    description: "Traversal Using Relays around NAT, protokolla, joka mahdollistaa liikenteen välittämisen palvelimen kautta, kun suoraa yhteyttä päätelaitteiden välillä ei voida muodostaa."
  ),
  w3c: (
    name: "W3C",
    description: "World Wide Web Consortium, kansainvälinen organisaatio, joka kehittää ja ylläpitää World Wide Webin avoimia standardeja."
  ),
  wcag: (
    name: "WCAG",
    description: "Web Content Accessibility Guidelines, verkkosisällön saavutettavuusohjeet."
  ),
  webrtc: (
    name: "WebRTC",
    description: "Web Real-Time Communication, avoimiin standardeihin perustuva teknologia, joka mahdollistaa reaaliaikaisen ääni-, video- ja tiedonsiirron verkkoselainten ja muiden sovellusten välillä."
  ),
  wss: (
    name: "WSS",
    description: "WebSocket Secure, TLS-suojattu WebSocket-yhteys."
  ),
  ip: (
    name: "IP",
    description: "Internet Protocol, Internetissä pakettien osoittamiseen ja reitittämiseen käytettävä verkkokerroksen protokolla."
  ),
  svg: (
    name: "SVG",
    description: "Scalable Vector Graphics, XML-pohjainen vektorigrafiikkamuoto."
  ),
  sip: (
    name: "SIP",
    description: "Session Initiation Protocol, reaaliaikaisten viestintäistuntojen muodostamiseen ja hallintaan tarkoitettu signalointiprotokolla."
  ),
  srtp: (
    name: "SRTP",
    description: "Secure Real-time Transport Protocol, reaaliaikaisten RTP-mediavirtojen salaamiseen ja eheyden suojaamiseen käytettävä protokolla."
  ),
)
