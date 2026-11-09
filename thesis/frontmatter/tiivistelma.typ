/** tiivistelma.typ
 *
 * Fill in the Finnish abstract of your thesis in this file. The
 * preamble is imported, in case you wish to use commands defined
 * there.
 *
***/

#pdf.attach(
  "tiivistelma.typ",
  relationship: "source",
  mime-type: "text/vnd.typst",
  description: "Tämän työn suomenkielisen tiivistelmän Typst-lähdekoodi.",
)

#import "../preamble.typ": *

Tämän diplomityön tavoitteena oli suunnitella ja toteuttaa selainpohjainen usean osallistujan videopuhelusovellus Web Real-Time Communication (WebRTC) -teknologialla sekä arvioida sen toimivuutta ja saavutettavuutta. Työssä tarkasteltiin WebRTC-teknologian toimintaperiaatteita ja sen soveltuvuutta verrattuna muihin verkkoviestinnän ratkaisuihin, videopuhelujärjestelmien arkkitehtuureja, verkkoyhteyksien muodostamista sekä verkkosovellusten saavutettavuutta.

Sovelluksen käyttöliittymä toteutettiin Reactilla ja TypeScriptillä. Mediavirtojen välitykseen käytettiin Janus WebRTC Gatewayn VideoRoom-liitännäistä, joka perustuu Selective Forwarding Unit (SFU) -arkkitehtuuriin. Verkkoyhteyksien muodostamiseen käytettiin selaimessa julkista Session Traversal Utilities for NAT (STUN) -palvelua osoitetietojen selvittämiseen ja Coturnin Traversal Using Relays around NAT (TURN) -palvelua tarvittaessa median välittämiseen. Janus konfiguroitiin käyttämään Coturnin STUN- ja TURN-palveluita. NGINX vastasi suojatuista verkkosivu- ja signalointiyhteyksistä, ja järjestelmän palvelut koottiin Docker Compose -ympäristöön. Käyttöliittymän saavutettavuusvaatimukset määriteltiin Web Content Accessibility Guidelines (WCAG) 2.1 -ohjeistuksen perusteella.

Toteutuksen toimivuutta arvioitiin testaamalla videopuhelun keskeisiä toimintoja eri verkkoyhteyksissä sekä kahdella työpöytäselaimella. Saavutettavuutta arvioitiin automaattisilla tarkistuksilla ja manuaalisella näppäimistötestauksella. Testauksessa kaikki määritellyt toiminnalliset, ei-toiminnalliset ja saavutettavuusvaatimukset toteutuivat. Sovellus palautui lyhyestä verkkokatkosta ilman käyttäjän toimenpiteitä, mutta pidemmän katkoksen jälkeen yhteyksiä ei muodostettu automaattisesti uudelleen. Tämä tunnistettiin toteutuksen rajoitukseksi ja jatkokehityskohteeksi. Saavutettavuustestauksessa havaitut kontrasti- ja kuvakeongelmat korjattiin testauksen perusteella.

Työn tuloksena syntyi toimiva prototyyppi usean osallistujan videopuhelusovelluksesta. WebRTC:n keskeinen hyöty verrattuna esimerkiksi Hypertext Transfer Protocol (HTTP) -pohjaiseen videon suoratoistoon on sen soveltuvuus kaksisuuntaiseen ja vähäviiveiseen viestintään suoraan verkkoselaimessa. Toteutus osoitti valittujen teknologioiden soveltuvan tähän käyttötarkoitukseen. Jatkokehityskohteiksi tunnistettiin erityisesti automaattinen yhteyden palautuminen, suorituskyvyn arviointi sekä laajempi laite- ja saavutettavuustestaus.