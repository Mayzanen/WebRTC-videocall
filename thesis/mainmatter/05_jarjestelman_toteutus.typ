/** 05_jarjestelman_toteutus.typ
 *
 * This is an example introdution in a multi-file Typst project.
 *
***/

#pdf.attach(
  "05_jarjestelman_toteutus.typ",
  relationship: "source",
  mime-type: "text/vnd.typst",
  description: "The Typst source code for the introduction chapter 1 of this thesis.",
)

#import "../preamble.typ": *

= Järjestelmän toteutus <toteutus-kappale>

Tässä luvussa kuvataan videopuhelusovelluksen keskeinen toteutus sekä toteutuksessa tehdyt ratkaisut. Ensin käsitellään frontendin toteutusta, minkä jälkeen tarkastellaan WebRTC-yhteyksien ja Janus-integraation toteutusta. Tämän jälkeen kuvataan sovelluksen kontitus Dockerilla ja saavutettavuusratkaisut.

== Frontend-toteutus Reactilla <toteutus-react-kappale>

Sovelluksen frontend toteutettiin Reactilla ja TypeScriptillä. Käyttöliittymä on jaettu erillisiin komponentteihin, jotka vastaavat sovelluksen eri näkymistä ja toiminnoista. Komponenttirakenteen tavoitteena on pitää käyttöliittymän eri osat selkeästi rajattuina ja helpottaa niiden itsenäistä kehittämistä @react-components.

Sovelluksen keskeiset näkymät ovat aloitusnäkymä ja videopuhelunäkymä. Aloitusnäkymässä käsitellään käyttäjän näyttönimi ja huonetunniste sekä videopuheluun liittyminen. Videopuhelunäkymä puolestaan sisältää osallistujien videokuvat ja puhelun hallintaan tarvittavat toiminnot.

Videopuhelunäkymän keskeisiä komponentteja ovat käyttäjän omaa videokuvaa esittävä `LocalVideo`, muiden osallistujien videoista vastaava `RemoteVideo` sekä puhelun hallintaan käytettävä `Controls`. Osallistujien määrän muuttuessa videopuhelunäkymää päivitetään vastaavasti, jolloin liittyneiden osallistujien videokuvat lisätään ja poistuneiden osallistujien videokuvat poistetaan.

Käyttöliittymäkomponenttien lisäksi frontend sisältää sovelluksen toimintalogiikkaa käsitteleviä palveluluokkia. `JanusClient` vastaa Januksen kanssa tapahtuvasta viestinnästä ja `WebRTCManager` WebRTC-yhteyksien hallintaan liittyvästä toiminnallisuudesta. Komponenttien ja palveluluokkien välinen jako erottaa käyttöliittymän toteutuksen reaaliaikaiseen viestintään liittyvästä teknisestä logiikasta.

Reactin paikallista komponenttitilaa hyödynnetään käyttöliittymän kulloisenkin tilan esittämiseen. Tila, kuten osallistujien videovirrat sekä ääni- ja videotoimintojen käytössäolo, hallitaan videopuhelunäkymän komponentissa ja välitetään tarvittaessa alikomponenteille ominaisuuksina (props). Esimerkiksi puhelun aikana osallistujien ja ääni- sekä videotoimintojen tila vaikuttaa siihen, mitä käyttöliittymässä näytetään. Näin käyttöliittymä päivittyy sovelluksen toiminnan muuttuessa ilman, että komponenttien tarvitsee hallita suoraan kaikkia yhteyksien teknisiä yksityiskohtia.

TypeScriptin staattista tyypintarkistusta hyödynnetään erityisesti WebRTC- ja signalointilogiikassa käytettävien tietorakenteiden ja rajapintojen määrittelyssä @typescript.

== WebRTC-yhteyksien toteutus <toteutus-webrtc-kappale>

Videopuhelun reaaliaikainen ääni- ja videoliikenne toteutettiin selaimen WebRTC-rajapinnan avulla. WebRTC-yhteyksien hallintaan liittyvä toiminnallisuus keskitettiin `WebRTCManager`-palveluluokkaan, jolloin käyttöliittymäkomponenttien ei tarvitse käsitellä suoraan WebRTC-yhteyksien teknisiä yksityiskohtia.

Videopuheluun liittyessä sovellus pyytää selaimelta käyttöoikeuden käyttäjän kameraan ja mikrofoniin `navigator.mediaDevices.getUserMedia()`-rajapinnan avulla. Rajapinta palauttaa paikallisen mediavirran, joka sisältää pyydetyt ääni- ja videoraidat. Mediavirtaa käytetään sekä paikallisen videokuvan esittämiseen että ääni- ja videodatan välittämiseen WebRTC-yhteyden kautta @mediacapture-streams.

WebRTC-yhteys muodostetaan `RTCPeerConnection`-rajapinnan avulla @webrtc. Koska sovellus perustuu SFU-arkkitehtuuriin, jokainen osallistuja muodostaa oman lähetysyhteytensä (publisher) Janukselle sekä erillisen vastaanottoyhteyden (subscriber) jokaista huoneessa olevaa muuta osallistujaa kohden. Yhteyden muodostamiseen liittyvässä signaloinnissa välitetään tarvittavat yhteysasetukset ja yhteysehdokkaat Janus-palvelimelle, joka toimii signaloinnin ja mediavälityksen keskipisteenä. Suoraa yhteyttä toisen osallistujan selaimeen ei muodosteta.

Yhteysehdokkaiden keräämisessä voidaan hyödyntää STUN-palvelua, jonka avulla selain saa tietoa julkisesta verkko-osoitteestaan. Mikäli suoraa yhteysreittiä Januksen ja selaimen välillä ei voida muodostaa, WebRTC-yhteys voi käyttää TURN-palvelinta mediadatan välittämiseen.

Usean osallistujan puhelussa jokaisen osallistujan vastaanottamat mediavirrat käsitellään erillisinä yhteyksinä, koska kutakin etäosallistujaa kohden on oma subscriber-yhteytensä. Vastaanotettu mediavirta liitetään sitä vastaavaan videokomponenttiin, jolloin osallistujien videokuvat voidaan esittää käyttöliittymässä samanaikaisesti. Osallistujan poistuessa kyseiseen mediavirtaan ja WebRTC-yhteyteen liittyvät resurssit vapautetaan.

Käyttäjän mikrofonin ja kameran tilaa hallitaan paikallisen mediavirran raitojen avulla. Mikrofonin mykistäminen ja kameran sulkeminen muuttavat vastaavan ääni- tai videoraidan käytössäoloa ilman, että koko WebRTC-yhteyttä tarvitsee muodostaa uudelleen. Puhelusta poistuttaessa yhteydet suljetaan ja paikallisen mediavirran sisältämät raidat vapautetaan.

== Janus-integraatio <toteutus-janus-kappale>

Sovelluksen reaaliaikainen viestintä toteutettiin hyödyntämällä Janus WebRTC Gatewayn VideoRoom-pluginia. VideoRoom on videoneuvotteluihin tarkoitettu SFU-plugin, joka perustuu publish/subscribe-malliin: osallistuja julkaisee oman mediavirtansa, ja muut huoneen osallistujat voivat tilata sen @janus-videoroom. Janus vastaa osallistujien mediavirtojen välittämisestä SFU-arkkitehtuurin mukaisesti.

Selain muodostaa Janukseen WebSocket-yhteyden, jonka kautta sovellus välittää Januksen istuntojen, plugin-yhteyksien ja videopuheluhuoneen hallintaan liittyviä viestejä. Januksen WebSocket-rajapinnassa samaa yhteyttä käytetään pyyntöjen lähettämiseen ja palvelimelta tulevien ilmoitusten vastaanottamiseen @janus-websockets.

Januksen kanssa tapahtuva viestintä on keskitetty `JanusClient`-palveluluokkaan. Luokka vastaa WebSocket-yhteyden muodostamisesta, Januksen viestien lähettämisestä ja vastaanottamisesta sekä Januksen istunnon ja plugin-yhteyksien hallintaan liittyvästä toiminnallisuudesta. Käyttöliittymä ja muu sovelluslogiikka voivat siten käyttää Januksen toimintoja ilman, että niiden tarvitsee käsitellä suoraan WebSocket-yhteyden tai Januksen viestiprotokollan yksityiskohtia.

Videopuheluun liittyessä sovellus muodostaa Janukseen istunnon ja liittää siihen VideoRoom-pluginin. Käyttäjä liittyy haluamaansa videopuheluhuoneeseen, minkä jälkeen sovellus julkaisee käyttäjän oman mediavirran Janukselle publisher-yhteyden kautta. Samalla sovellus muodostaa subscriber-yhteydet muiden huoneessa olevien osallistujien julkaisemien mediavirtojen vastaanottamista varten. Janus välittää publisher-yhteyksien kautta vastaanottamansa mediavirrat subscriber-yhteyksille, jolloin osallistujien selainten välille ei tarvita suoria mediayhteyksiä.

Uusien osallistujien liittyminen ja olemassa olevien osallistujien poistuminen välitetään sovellukselle Januksen VideoRoom-tapahtumien `publishers`-listan sekä `unpublished`- ja `leaving`-kenttien avulla. Kun huoneeseen liittyy uusi publisher, sovellus käsittelee Januksen ilmoittamat osallistujan tiedot ja muodostaa tarvittavan subscriber-yhteyden. Osallistujan poistuessa vastaava vastaanottoyhteys ja mediavirta poistetaan. Näin videopuhelun käyttöliittymä pysyy ajan tasalla huoneen osallistujista.

Janus-yhteyttä ylläpidetään lähettämällä palvelimelle säännöllisesti keep-alive-viestejä. Lisäksi `JanusClient` tuottaa signalointiin liittyvään lokitukseen correlation ID -tunnisteen, jonka avulla yksittäiseen pyyntöön ja sen käsittelyyn liittyviä lokitapahtumia voidaan seurata. Tämä helpottaa erityisesti signalointiin liittyvien ongelmien jäljittämistä sovelluksen kehityksen ja vianmäärityksen aikana.

Puhelusta poistuttaessa sovellus lähettää publisher-yhteydelle pyynnön poistua videopuheluhuoneesta ja sulkee paikallisesti sekä publisher- että subscriber-yhteydet. Näkymästä poistuttaessa sovellus lähettää Janus-istunnolle `destroy`-pyynnön ja katkaisee tämän jälkeen WebSocket-yhteyden. Tämän seurauksena myös mahdollisesti avoimeksi jääneet plugin-yhteydet poistuvat palvelinpuolelta. Lopuksi myös WebRTC-yhteyksiin ja paikallisiin mediavirtoihin liittyvät resurssit vapautetaan.

== Kontitus Dockerilla <toteutus-docker-kappale>

Sovelluksen palvelinympäristö toteutettiin Docker-konteilla, joiden avulla frontend, Janus WebRTC Gateway, Coturn ja NGINX toimivat erillisinä palveluina. Palvelut määriteltiin Docker Compose -tiedostossa, joka huolehtii konttien käynnistämisestä ja niiden välisestä verkottamisesta. Kontit muodostavat yhteisen Docker-verkon, jonka kautta palvelut voivat kommunikoida keskenään. Ulkopuolisille asiakkaille julkaistaan vain palvelun toiminnan edellyttämät portit, kuten HTTPS-, WSS-, STUN/TURN- ja WebRTC-mediaportit.

Frontend suoritetaan kontissa Viten kehityspalvelimen avulla. NGINX välittää frontendin selaimelta tulevat pyynnöt Viten kehityspalvelimelle, joka tarjoilee React- ja TypeScript-sovelluksen. Erillistä tuotantobuildia, jossa sovellus rakennettaisiin staattiseksi tiedostokokonaisuudeksi, ei tässä työssä toteutettu osaksi konttiympäristöä. Ratkaisu soveltuu näin ollen ensisijaisesti kehitys- ja demonstraatiokäyttöön. Tuotantokäyttöön siirryttäessä frontend tulisi rakentaa erillisessä build-vaiheessa ja tarjoilla staattisena sisältönä, mikä on tunnistettu jatkokehityskohteeksi.

Janus suoritetaan omassa kontissaan, jossa sen WebSocket-rajapinta on sovelluksen käytettävissä. Coturn toimii erillisenä STUN- ja TURN-palveluna, ja NGINX vastaanottaa ulkoa tulevan HTTPS- ja WSS-liikenteen sekä välittää sen oikealle palvelulle.

Docker Compose mahdollistaa koko palvelinympäristön käynnistämisen yhtenä kokonaisuutena. Palveluiden väliset riippuvuudet, portit, verkot ja tarvittavat asetukset määritellään Compose-konfiguraatiossa. Näin kehitys- ja testausympäristö voidaan pystyttää samalla palvelurakenteella ilman, että yksittäisiä palveluita tarvitsee asentaa erikseen isäntäjärjestelmään @docker-compose.

Kontitus erottaa sovelluksen palvelut toisistaan myös niiden päivittämisen ja konfiguroinnin näkökulmasta. Frontendin, Januksen, Coturnin ja NGINX:n konfiguraatiot voidaan käsitellä omina kokonaisuuksinaan, vaikka ne muodostavat yhdessä videopuhelusovelluksen suoritusympäristön. Docker Composen avulla ympäristön rakenne voidaan lisäksi kuvata versionhallintaan tallennettavassa muodossa, mikä tukee ympäristön toistettavaa käyttöönottoa.

== Saavutettavuusratkaisut <toteutus-saavutettavuus-kappale>

Saavutettavuusvaatimukset huomioitiin käyttöliittymän toteutuksessa erityisesti näppäimistökäytön, elementtien ohjelmallisen nimeämisen, lomakkeiden sekä visuaalisen esitystavan osalta. Toteutuksessa pyrittiin hyödyntämään selaimen ja HTML:n natiiveja toiminnallisuuksia aina, kun se oli mahdollista, jotta käyttöliittymän perustoiminnot olisivat käytettävissä myös ilman hiirtä ja apuvälineitä.

Käyttöliittymän toiminnalliset elementit toteutettiin natiiveilla HTML-elementeillä. Esimerkiksi puhelun hallintaan käytettävät toiminnot toteutettiin painikkeina, jolloin selain huolehtii niiden perustason näppäimistökäytöstä ja semanttisesta roolista. Puhelun hallintaan käytettäville painikkeille määriteltiin myös visuaalinen fokusindikaattori, jotta näppäimistöllä liikuttaessa aktiivinen elementti voidaan tunnistaa.

Lomakkeiden syöttökentille toteutettiin ohjelmallisesti kytketyt nimilaput, joiden avulla kenttien käyttötarkoitus välittyy myös apuvälineille. Interaktiivisille painikkeille määriteltiin niiden toimintaa kuvaavat nimet, jotta niiden käyttötarkoitus voidaan tunnistaa ilman visuaalista kuvaketta. Mikrofonin ja kameran tilaa välitetään ohjelmallisesti `aria-pressed`-attribuutilla. Toimintonapit toteutetaan natiiveina painikkeina, jolloin niiden rooli on ohjelmallisesti määritettävissä. Ohjelmallisesti määritettävät nimet, roolit ja tilat liittyvät WCAG 2.1 -ohjeen onnistumiskriteeriin 4.1.2 @wcag-name-role-value.

Visuaalisessa toteutuksessa huomioitiin tekstin ja taustan välinen kontrasti sekä se, ettei toiminnon tai tilan tunnistaminen perustu yksinomaan väriin. Näin esimerkiksi mikrofonin ja kameran tilaa ei pyritä ilmaisemaan pelkällä värimuutoksella, vaan muutosta tuetaan myös kuvakkeen tai muun visuaalisen esityksen avulla.

Saavutettavuuden toteutumista arvioidaan työn myöhemmässä vaiheessa automatisoiduilla axe-pohjaisilla testeillä sekä Axe DevTools -tarkastuksella. `@axe-core/playwright`-kirjaston avulla saavutettavuustarkistuksia voidaan suorittaa osana Playwright-testien ajamista @playwright-accessibility. Ruudunlukijatestauksen kattavuus rajataan erikseen. Testauksen tavoitteena on tunnistaa erityisesti käyttöliittymän ohjelmalliseen saavutettavuuteen liittyviä puutteita ja verrata toteutusta vaatimusmäärittelyssä määriteltyihin WCAG 2.1 -kriteereihin. Saavutettavuustestauksen tuloksia ja mahdollisia korjaustoimenpiteitä käsitellään työn arviointivaiheessa.