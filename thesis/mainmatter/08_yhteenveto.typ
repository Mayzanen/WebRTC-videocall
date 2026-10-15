/** 08_yhteenveto.typ
 *
 * This is an example introdution in a multi-file Typst project.
 *
***/

#pdf.attach(
  "08_yhteenveto.typ",
  relationship: "source",
  mime-type: "text/vnd.typst",
  description: "The Typst source code for the introduction chapter 1 of this thesis.",
)

#import "../preamble.typ": *

= Yhteenveto <yhteenveto-kappale>

Tässä työssä suunniteltiin ja toteutettiin selainpohjainen usean osallistujan videopuhelusovellus WebRTC-teknologialla. Tavoitteena oli toteuttaa toimiva videopuheluratkaisu, jossa mediavirtojen välitykseen käytetään Janus WebRTC Gatewayta, verkkoyhteyksien muodostamista tuetaan STUN- ja TURN-palveluilla ja sovelluksen palvelut voidaan käynnistää toistettavana konttiympäristönä. Lisäksi käyttöliittymän suunnittelussa ja arvioinnissa huomioitiin WCAG 2.1 -ohjeistukseen perustuvia saavutettavuusvaatimuksia.

Toteutetussa järjestelmässä selainasiakas muodostaa signalointiyhteyden suoraan Janus WebRTC Gatewayhin ja Janus VideoRoom -liitännäinen toimii mediavirtojen välityksestä vastaavana SFU:na. NAT-läpäisyä varten käytettiin STUN- ja TURN-palveluita, joista TURN-palvelu toteutettiin Coturnilla. NGINX vastasi HTTPS- ja WSS-yhteyksistä, ja sovelluksen palvelut koottiin Docker Compose -ympäristöön. Käyttöliittymä toteutettiin Reactilla ja TypeScriptillä.

Toiminnallisessa testauksessa kaikki määritellyt toiminnalliset vaatimukset F1–F10 toteutuivat. Sovelluksella voitiin luoda usean osallistujan videohuoneita, välittää ääni- ja videovirtoja eri verkkoyhteyksien välillä sekä hallita mikrofonia ja kameraa puhelun aikana. Myös TURN-releen toiminta varmistettiin erillisessä kontrolloidussa testissä. Ei-toiminnallisista vaatimuksista N1–N4 ja N6 toteutuivat, kun taas signalointiyhteyden ylläpitoa koskeva vaatimus N5 toteutui osittain. Lyhyestä verkkokatkosta ääni- ja videoyhteys palautui ilman käyttäjän toimenpiteitä, mutta pidemmän katkoksen jälkeen Janus-istuntoa ja WebRTC-mediayhteyksiä ei muodostettu automaattisesti uudelleen.

Saavutettavuustestauksessa yhdistettiin automaattisia tarkistuksia ja manuaalista testausta. Testauksessa havaittu tekstin kontrastipuute korjattiin, ja käyttöjärjestelmäkohtaisesti vaihtelevat Unicode-symbolit korvattiin SVG-kuvakkeilla. Lopullisessa testatussa versiossa työssä määritellyt saavutettavuusvaatimukset A1–A6 toteutuivat. Tulokset koskevat kuitenkin rajattua testausympäristöä eivätkä osoita sovelluksen täydellistä WCAG 2.1 -vaatimustenmukaisuutta.

Työn tuloksena syntyi toimiva prototyyppi selainpohjaisesta usean osallistujan videopuhelusovelluksesta. Toteutus osoitti, että Janus-pohjaisella SFU-arkkitehtuurilla, WebRTC-teknologialla ja erillisillä STUN- ja TURN-palveluilla voidaan toteuttaa testatussa ympäristössä toimiva kokonaisuus usean osallistujan videopuheluihin. Jatkokehityksessä keskeisiä kohteita ovat erityisesti automaattinen palautuminen pidemmistä verkkokatkoksista, järjestelmän kuormitus- ja suorituskykytestaus, laajempi selain- ja laitetestaus sekä saavutettavuuden arviointi apuvälineillä ja käyttäjätestauksella.