/** 07_pohdinta.typ
 *
 * This is an example introdution in a multi-file Typst project.
 *
***/

#pdf.attach(
  "07_pohdinta.typ",
  relationship: "source",
  mime-type: "text/vnd.typst",
  description: "The Typst source code for the discussion chapter 7 of this thesis.",
)

#import "../preamble.typ": *

= Pohdinta <pohdinta-kappale>

Tässä luvussa tarkastellaan työn tuloksia suhteessa sille asetettuihin tavoitteisiin sekä arvioidaan toteutetun videopuhelusovelluksen vahvuuksia ja rajoituksia. Lisäksi käsitellään työn aikana esiin nousseita jatkokehitysmahdollisuuksia. Pohdinnassa huomioidaan sekä teknisen toteutuksen että testauksen perusteella tehdyt havainnot.

== Tavoitteiden toteutuminen <pohdinta-tavoitteet-kappale>

Työn tavoitteena oli suunnitella ja toteuttaa selainpohjainen usean osallistujan videopuhelusovellus WebRTC-teknologialla sekä arvioida toteutuksen toimivuutta ja saavutettavuutta. Toteutuksessa tavoitteena oli hyödyntää Janus WebRTC Gatewayta mediavirtojen välitykseen, mahdollistaa yhteyksien muodostaminen eri verkkoympäristöissä STUN- ja TURN-palveluiden avulla sekä toteuttaa sovelluksen palvelut toistettavana konttiympäristönä. Lisäksi käyttöliittymälle asetettiin WCAG 2.1 -ohjeistukseen perustuvia saavutettavuusvaatimuksia.

Työn keskeinen tavoite toteutui, sillä työn tuloksena syntyi toimiva usean osallistujan videopuhelusovellus. Käyttäjä voi luoda videohuoneen tai liittyä olemassa olevaan huoneeseen, julkaista kameran ja mikrofonin mediavirrat sekä vastaanottaa muiden osallistujien ääni- ja videovirtoja. Mikrofonia ja kameraa voidaan hallita puhelun aikana, ja osallistujien liittyminen ja poistuminen päivittyvät muiden käyttäjien näkymiin automaattisesti. Toiminnallisessa testauksessa kaikki määritellyt toiminnalliset vaatimukset F1–F10 toteutuivat.

Myös järjestelmälle asetetut keskeiset ei-toiminnalliset tavoitteet toteutuivat. Janus VideoRoom -liitännäiseen perustuva SFU-arkkitehtuuri mahdollisti useamman kuin kahden osallistujan videohuoneet ilman muutoksia järjestelmän perusarkkitehtuuriin. STUN- ja TURN-palveluiden käyttö mahdollisti WebRTC-yhteyksien muodostamisen eri verkkoyhteyksien välillä, ja erillisessä testissä mediayhteyden todettiin toimivan myös pakotetusti Coturn-palvelimen kautta välitettynä. Sovelluksen selainliikenne toteutettiin HTTPS- ja WSS-yhteyksillä, ja palvelut koottiin Docker Compose -ympäristöön.

Signalointiyhteyden ylläpitoa koskeva N5-vaatimus toteutui. Janus-istunnon keep-alive-toiminto piti istunnon aktiivisena normaalissa käytössä. Erillisessä verkkokatkotestissä lyhyen katkoksen jälkeen ääni- ja videoyhteys palautui ilman käyttäjän toimenpiteitä. Pidemmän verkkokatkon jälkeen PeerConnection-yhteys kuitenkin päättyi eikä sovellus muodostanut media- ja signalointiyhteyksiä automaattisesti uudelleen. Tämä on toteutuksen erillinen rajoitus, jonka korjaaminen edellyttäisi uudelleenyhdistämis- ja uudelleenneuvottelulogiikkaa.

Saavutettavuudelle asetetut tavoitteet toteutuivat työn rajatussa testauslaajuudessa. Lopullisessa versiossa saavutettavuusvaatimukset A1–A6 toteutuivat testatuissa näkymissä ja käyttötapauksissa. Testauksessa havaittu tekstin kontrastipuute korjattiin, ja puhelun hallintapainikkeiden Unicode-symbolit korvattiin SVG-kuvakkeilla niiden visuaalisen yhdenmukaisuuden ja erottuvuuden parantamiseksi. Sovelluksen keskeisiä toimintoja voitiin käyttää näppäimistöllä, ja käyttöliittymän interaktiivisille elementeille oli määritelty niitä kuvaavat saavutettavat nimet.

Saavutettavuustestauksen tuloksia on kuitenkin tarkasteltava työn rajauksen mukaisesti. Testaus kohdistui työssä määriteltyihin WCAG 2.1 -pohjaisiin vaatimuksiin, eikä tavoitteena ollut osoittaa sovelluksen täydellistä WCAG 2.1 -vaatimustenmukaisuutta. Testaukseen ei myöskään sisältynyt esimerkiksi ruudunlukijalla tehtävää testausta tai varsinaisia käyttäjätestejä.

Kokonaisuutena työn alkuperäinen tavoite voidaan katsoa saavutetuksi. Työssä toteutettiin selainpohjainen usean osallistujan videopuhelusovellus, joka toimii eri verkkoyhteyksien välillä, hyödyntää Janus-pohjaista SFU-arkkitehtuuria ja täyttää sille asetetut toiminnalliset, ei-toiminnalliset sekä rajatut saavutettavuusvaatimukset. Toteutuksen keskeinen tekninen rajoitus liittyi yhteyden automaattiseen palautumiseen pidemmän verkkokatkon jälkeen.

== Toteutuksen vahvuudet ja rajoitukset <pohdinta-vahvuudet-rajoitukset-kappale>

Toteutuksen keskeisenä vahvuutena voidaan pitää järjestelmän selkeää arkkitehtuuria. Selainasiakas muodostaa signalointiyhteyden suoraan Janus WebRTC Gatewayhin, eikä erillistä sovelluspalvelinta tarvita videopuhelun signalointia varten. Janus VideoRoom -liitännäiseen perustuva SFU-ratkaisu mahdollistaa usean osallistujan videohuoneet ilman, että jokaisen selaimen tarvitsee muodostaa erillistä mediayhteyttä kaikkiin muihin osallistujiin. Ratkaisu erottaa käyttöliittymän, WebRTC-yhteyksien hallinnan ja mediavirtojen välityksen toisistaan.

Toisena vahvuutena voidaan pitää verkkoyhteyksien muodostamiseen käytettyä ICE-, STUN- ja TURN-kokonaisuutta. Sovellus toimi testauksessa eri verkkoyhteyksien välillä, ja erillisessä kontrolloidussa testissä mediayhteys saatiin muodostettua myös pakotetusti Coturn-palvelimen kautta. Tämä osoittaa, että toteutus ei ole riippuvainen pelkästään suorasta WebRTC-yhteydestä, vaan sillä on käytettävissä TURN-rele tilanteisiin, joissa suora yhteys ei ole mahdollinen.

Docker Compose -pohjainen ympäristö on myös toteutuksen vahvuus. Sovelluksen keskeiset palvelut voidaan käynnistää samasta määrittelystä, mikä helpottaa ympäristön toistamista ja vähentää yksittäisiin manuaalisiin asennusvaiheisiin liittyviä eroja. NGINX-, Janus- ja Coturn-palveluiden erottaminen omiksi palveluikseen tekee järjestelmän rakenteesta myös helpommin hahmotettavan ja ylläpidettävän.

Toteutuksen vahvuutena voidaan pitää lisäksi sitä, että saavutettavuus huomioitiin osana käyttöliittymän toteutusta eikä ainoastaan työn lopussa tehtävänä tarkistuksena. Käyttöliittymän keskeiset toiminnot ovat käytettävissä näppäimistöllä, interaktiivisille elementeille on määritelty saavutettavat nimet ja käyttöliittymässä havaittuja kontrasti- ja kuvakeongelmia korjattiin testauksen perusteella. Automaattisen ja manuaalisen testauksen yhdistäminen mahdollisti myös sellaisten ongelmien havaitsemisen, joita pelkkä automaattinen tarkistus ei tuonut esiin.

Toteutuksella on kuitenkin myös selkeitä rajoituksia. Merkittävin tekninen rajoitus liittyy yhteyden palautumiseen pidemmän verkkokatkon jälkeen. Lyhyen verkkokatkon jälkeen ääni- ja videoyhteys palautui ilman käyttäjän toimenpiteitä, mutta pidemmän katkoksen jälkeen PeerConnection-yhteys päättyi eikä sovellus muodostanut uusia yhteyksiä automaattisesti. Käytännössä pidemmän verkkohäiriön jälkeen yhteyden palauttaminen edellyttää käyttäjän toimenpidettä, kuten puhelusta poistumista ja siihen uudelleen liittymistä. Toteutuksesta puuttuu siten erillinen mekanismi Janus-istunnon uudelleenluontiin ja WebRTC-yhteyden uudelleenneuvotteluun yhteyden menettämisen jälkeen.

Toinen keskeinen rajoitus liittyy järjestelmän skaalautuvuuden arviointiin. SFU-arkkitehtuuri mahdollistaa useamman kuin kahden osallistujan videohuoneet, mutta työssä ei tehty varsinaista kuormitus- tai suorituskykytestausta. Tämän vuoksi tulosten perusteella ei voida arvioida, kuinka suuri osallistujamäärä käytetyllä palvelinympäristöllä voidaan käytännössä saavuttaa tai miten prosessori-, muisti- ja verkkokuorma kasvavat osallistujamäärän lisääntyessä.

Myös selain- ja käyttöjärjestelmätestaus oli rajattu. Sovellusta testattiin kahdella työpöytäselaimella ja kahdessa Windows-ympäristössä, mutta mobiiliselaimia, muita käyttöjärjestelmiä tai laajempaa selainvalikoimaa ei testattu. Selain- ja laitekohtaisia eroja voi esiintyä esimerkiksi medialaitteiden käsittelyssä, käyttöoikeuksissa ja käyttöliittymän esitystavassa. Tämän vuoksi testituloksia ei voida suoraan yleistää muihin selaimiin, käyttöjärjestelmiin tai päätelaitteisiin.

Saavutettavuuden arviointi oli lisäksi rajattu työssä määriteltyihin vaatimuksiin A1–A6. Automaattiset tarkistukset ja manuaalinen näppäimistötestaus antoivat tietoa näiden vaatimusten toteutumisesta, mutta testaukseen ei sisältynyt ruudunlukijalla tehtävää testausta tai käyttäjätestausta. Tämän vuoksi työn perusteella ei voida tehdä johtopäätöstä sovelluksen täydellisestä WCAG 2.1 -vaatimustenmukaisuudesta tai käytettävyydestä erilaisten apuvälineteknologioiden kanssa.

Nykyisessä toteutuksessa ei ole käyttäjien tunnistautumista tai huonekohtaisia käyttöoikeuksia. Huonetunnisteen tietävä käyttäjä voi liittyä huoneeseen valitsemallaan näyttönimellä. Tämä on prototyypin rajauksessa hyväksyttävää, mutta tuotantokäyttö edellyttäisi käyttöoikeuksien ja käyttäjähallinnan toteuttamista.

Rajoituksista huolimatta toteutus soveltuu hyvin työn tavoitteena olleeksi toimivaksi prototyypiksi. Se osoittaa, että valituilla teknologioilla voidaan toteuttaa selainpohjainen usean osallistujan videopuhelusovellus, joka toimii eri verkkoyhteyksien välillä ja jossa saavutettavuus voidaan ottaa huomioon osana käyttöliittymän suunnittelua ja testausta.

== Jatkokehitysmahdollisuudet <pohdinta-jatkokehitys-kappale>

Toteutettua videopuhelusovellusta voidaan jatkokehittää usealla tavalla. Keskeisin jatkokehityskohde liittyy yhteyden automaattiseen palauttamiseen pidemmän verkkokatkon jälkeen. Nykyisessä toteutuksessa lyhyestä yhteyskatkosta voidaan palautua ilman käyttäjän toimenpiteitä, mutta pidemmän katkoksen jälkeen Janus-istunto ja WebRTC-yhteys eivät muodostu uudelleen automaattisesti. Jatkokehityksessä sovellukseen voitaisiin toteuttaa mekanismi, joka tunnistaa yhteyden lopullisen katkeamisen, muodostaa tarvittaessa uuden Janus-istunnon ja neuvottelee WebRTC-mediayhteydet uudelleen ilman, että käyttäjän tarvitsee liittyä huoneeseen käsin uudelleen.

Toinen jatkokehityskohde on järjestelmän suorituskyvyn ja skaalautuvuuden tarkempi arviointi. Tässä työssä sovelluksen toiminta varmistettiin pienissä usean osallistujan videohuoneissa, mutta varsinaista kuormitustestausta ei tehty. Jatkossa järjestelmää voitaisiin testata kasvavilla osallistujamäärillä ja samalla mitata esimerkiksi Janus-palvelimen prosessori- ja muistikuormaa, verkkoliikenteen määrää sekä yhteyksien laatua. Näin voitaisiin arvioida käytännössä, millaisia osallistujamääriä nykyinen palvelinympäristö tukee ja missä vaiheessa järjestelmän resursseja tai arkkitehtuuria olisi tarpeen kasvattaa.

Sovelluksen selain- ja laitetukea voitaisiin laajentaa testaamalla toteutusta useammilla käyttöjärjestelmillä, selaimilla ja mobiililaitteilla. Erityisesti mobiililaitteilla olisi tarpeen tarkastella kameran ja mikrofonin käyttöä, käyttöoikeuksien käsittelyä, käyttöliittymän responsiivisuutta sekä verkkoyhteyksien vaihtumista. Laajempi laitetestaus auttaisi tunnistamaan ympäristökohtaisia ongelmia ja parantamaan sovelluksen yleistä yhteensopivuutta.

Saavutettavuuden osalta jatkokehityksessä olisi hyödyllistä laajentaa testausta apuvälineteknologioihin ja käyttäjätestaukseen. Esimerkiksi ruudunlukijan avulla voitaisiin arvioida tarkemmin videopuhelun tilamuutosten, osallistujien liittymisen ja poistumisen sekä mikrofonin ja kameran tilojen välittymistä käyttäjälle. Käyttäjätestauksella voitaisiin puolestaan havaita sellaisia käytettävyys- ja saavutettavuusongelmia, joita automaattiset tarkistukset tai tekninen manuaalinen testaus eivät välttämättä tuo esiin.

Nykyistä käyttöliittymää voitaisiin lisäksi laajentaa videopuhelun käytettävyyttä parantavilla ominaisuuksilla. Mahdollisia jatkokehityskohteita ovat esimerkiksi osallistujaluettelo, aktiivisen puhujan korostaminen, näytön jakaminen sekä käyttäjälle näytettävä tieto yhteyden tilasta. Erityisesti yhteyden tilan näkyvä esittäminen voisi auttaa käyttäjää ymmärtämään tilanteet, joissa verkkoyhteys on hetkellisesti katkennut tai sovellus yrittää palauttaa yhteyttä.

Tuotantokäyttöä varten järjestelmään tarvittaisiin myös nykyistä laajempi käyttäjien ja videohuoneiden hallinta. Nykyinen toteutus perustuu huonetunnisteeseen ja käyttäjän antamaan näyttönimeen, eikä siinä ole varsinaista käyttäjien tunnistautumista tai käyttöoikeuksien hallintaa. Jatkokehityksessä järjestelmään voitaisiin lisätä autentikointi ja huonekohtaiset käyttöoikeudet, jolloin huoneisiin liittymistä ja niiden hallintaa voitaisiin rajoittaa tarkoituksenmukaisesti.

Näiden jatkokehitystoimenpiteiden avulla nykyisestä prototyypistä voitaisiin edetä kohti laajemmin eri käyttöympäristöihin soveltuvaa ja tuotantokäyttöön valmiimpaa videopuhelupalvelua. Erityisesti automaattinen yhteyden palautuminen, laajempi suorituskyky- ja laitetestaus sekä saavutettavuuden arviointi todellisilla käyttäjillä olisivat luontevia seuraavia kehitysvaiheita.
