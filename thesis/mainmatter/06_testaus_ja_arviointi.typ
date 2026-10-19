/** 06_testaus_ja_arviointi.typ
 *
 * This is an example introdution in a multi-file Typst project.
 *
***/

#pdf.attach(
  "06_testaus_ja_arviointi.typ",
  relationship: "source",
  mime-type: "text/vnd.typst",
  description: "The Typst source code for the testing and evaluation chapter 6 of this thesis.",
)

#import "../preamble.typ": *

= Testaus ja arviointi <testaus-kappale>

Tässä luvussa arvioidaan toteutetun videopuhelusovelluksen toimintaa ja sitä, kuinka hyvin toteutus vastaa sille asetettuja vaatimuksia. Sovellusta arvioidaan toiminnallisen testauksen, ei-toiminnallisten vaatimusten arvioinnin, selainyhteensopivuustestauksen ja saavutettavuustestauksen avulla. Lisäksi luvussa käsitellään testauksessa havaittuja puutteita ja niiden korjauksia sekä kootaan testauksen keskeiset tulokset.

== Toiminnallinen testaus <testaus-toiminnallisuus-kappale>

Toiminnallisella testauksella varmistettiin, että sovelluksen keskeiset käyttötapaukset toimivat määriteltyjen vaatimusten mukaisesti käytännön käyttötilanteissa. Testauksen kohteena olivat videohuoneen luominen ja siihen liittyminen, paikallisen äänen ja videon julkaiseminen, etäosallistujien mediavirtojen vastaanottaminen, ääni- ja videotoimintojen hallinta sekä hallittu poistuminen huoneesta.

Testaus suoritettiin useilla erillisillä tietokoneilla eri verkkoyhteyksien yli. Osallistujat liittyivät samaan videohuoneeseen eri verkkoyhteyksistä, jolloin sovelluksen toimintaa voitiin tarkastella tilanteessa, jossa osallistujat eivät olleet samassa paikallisverkossa. Näin testaus vastasi tavanomaista käyttötilannetta paremmin kuin yhden laitteen tai pelkän paikallisverkon sisällä tehty testaus.

@taulukko-toiminnallinen-testaus esittää testauksessa tarkastellut toiminnot. Testitapaukset yhdistettiin vaatimusmäärittelyssä esitettyihin toiminnallisiin vaatimuksiin F1–F10.

#figure(
  table(
    columns: (0.8fr, 2.3fr, 3.0fr, 3.7fr, 0.7fr),
    inset: 6pt,
    stroke: 0.5pt,

    align: (
      center + horizon,
      left + horizon,
      left + horizon,
      left + horizon,
      center + horizon,
    ),

    table.header(
      repeat: true,
      [*Vaatimus*],
      [*Testattava toiminto*],
      [*Testimenettely*],
      [*Odotettu tulos*],
      [*Tulos*],
    ),

    [F1],
    [Videohuoneen luominen],
    [Käyttäjä luo uuden videohuoneen.],
    [Sovellus luo videohuoneen ja käyttäjä siirtyy videoneuvottelunäkymään.],
    [OK],

    [F1, F2],
    [Huoneeseen liittyminen],
    [Käyttäjä syöttää huoneen tunnisteen ja näyttönimen.],
    [Käyttäjä liittyy oikeaan videohuoneeseen ja annettu näyttönimi liitetään osallistujaan.],
    [OK],

    [F3, F4],
    [Paikallisen kameran ja mikrofonin käyttö],
    [Selain pyytää käyttöoikeuden kameraan ja mikrofoniin.],
    [Paikallinen video näkyy käyttäjälle ja media voidaan julkaista huoneeseen.],
    [OK],

    [F5, F6],
    [Toisen osallistujan liittyminen],
    [Toinen laite liittyy samaan huoneeseen.],
    [Osallistujat näkevät ja kuulevat toisensa ilman erillistä päivitystä.],
    [OK],

    [F5, F6],
    [Usean osallistujan käsittely],
    [Huoneeseen liittyy useita osallistujia eri laitteilla.],
    [Jokaiselle etäosallistujalle näytetään oma videovirta.],
    [OK],

    [F9],
    [Kameran kytkeminen päälle ja pois],
    [Käyttäjä vaihtaa videon tilaa käyttöliittymästä.],
    [Käyttäjän videokuva ei välity muille osallistujille kameran ollessa pois käytöstä ja alkaa välittyä uudelleen, kun kamera otetaan käyttöön.],
    [OK],

    [F8],
    [Mikrofonin mykistäminen],
    [Käyttäjä vaihtaa mikrofonin tilaa käyttöliittymästä.],
    [Käyttäjän ääni ei välity muille osallistujille mikrofonin ollessa mykistettynä ja alkaa välittyä uudelleen, kun mikrofoni otetaan käyttöön.],
    [OK],

    [F7],
    [Osallistujan poistuminen],
    [Osallistuja poistuu videohuoneesta.],
    [Muut osallistujat eivät enää näe poistuneen käyttäjän videovirtaa.],
    [OK],

    [F10],
    [Huoneesta poistuminen ja uudelleen liittyminen],
    [Käyttäjä poistuu huoneesta ja liittyy siihen uudelleen.],
    [Paikallisen median käyttö päättyy, osallistuja poistuu muiden näkymistä ja käyttäjä voi liittyä huoneeseen uudelleen.],
    [OK],
  ),

  caption: [
    Videopuhelusovelluksen toiminnallisen testauksen testitapaukset ja tulokset.
  ],
) <taulukko-toiminnallinen-testaus>

Testauksen perusteella sovelluksen keskeiset toiminnot toimivat odotetusti. Käyttäjä pystyi luomaan videohuoneen ja liittymään siihen näyttönimellä, minkä jälkeen sovellus avasi videoneuvottelunäkymän. Paikallinen video näkyi käyttäjälle ja paikallinen ääni- ja videovirta voitiin julkaista huoneeseen. Käyttäjä pystyi lisäksi vastaanottamaan muiden osallistujien mediavirtoja eri verkkoyhteyksien yli.

Kun uusi osallistuja liittyi huoneeseen, tämän ääni- ja videovirrat tulivat muiden huoneessa olevien osallistujien saataville ilman erillistä sivun päivittämistä tai muuta käyttäjän toimenpidettä. Usean osallistujan testissä jokaiselle etäosallistujalle muodostettiin oma videonäkymä. Vastaavasti osallistujan poistuessa hänen videonäkymänsä poistui muiden osallistujien käyttöliittymästä. @kuva-toiminnallinen-testaus esittää videopuhelusovelluksen käyttöliittymän toiminnallisen testauksen aikana usean osallistujan videohuoneessa.

#figure(
  image("/images/KoneA_v1.png",
  width: 100%,
  alt: "Kuvakaappaus käynnissä olevasta videopuhelusta. Näytöllä näkyy huone 126A, muodostettu yhteystila, suuri paikallinen videonäkymä ja oikealla pienempi etäosallistujan videonäkymä. Alareunassa ovat mikrofonin, kameran ja puhelun lopettamisen hallintapainikkeet.",),
  caption: [Videopuhelusovelluksen käyttöliittymä toiminnallisen testauksen aikana.],

) <kuva-toiminnallinen-testaus>

Äänen ja videon hallintatoiminnot testattiin erikseen. Mikrofonin mykistämisen jälkeen käyttäjän ääni ei välittynyt muille osallistujille, ja mikrofonin uudelleen käyttöönoton jälkeen äänen välitys jatkui. Kameran poistaminen käytöstä lopetti käyttäjän videokuvan välittymisen muille osallistujille, ja videokuva palautui kameran uudelleen käyttöönoton jälkeen. Toiminnot eivät katkaisseet käyttäjän muuta yhteyttä videohuoneeseen, joten mikrofonia ja kameraa voitiin hallita ilman, että käyttäjän tarvitsi liittyä huoneeseen uudelleen.

Testauksessa tarkasteltiin myös huoneesta poistumista ja uudelleen liittymistä. Kun käyttäjä poistui huoneesta, paikallisen median käyttö päättyi ja poistuneen käyttäjän videonäkymä poistui muiden osallistujien käyttöliittymästä. Tämän jälkeen käyttäjä pystyi liittymään samaan videohuoneeseen uudelleen normaalisti.

Manuaalisen toiminnallisen testauksen lisäksi sovellukselle toteutettiin Playwright-pohjaisia @playwright automaattisia testejä. Testit kattavat etusivun lomakkeen toiminnan, syötteiden validoinnin, näppäimistökäytön, saavutettavuustarkistuksia sekä puhelun hallintapainikkeiden toiminnan. Puhelun hallintapainikkeiden integraatiotestit suoritettiin käynnissä olevaa Docker Compose -ympäristöä vasten. Testisarjassa kaikki 14 testiä suoritettiin onnistuneesti.

Testaus ei sisältänyt kuormitus- tai skaalautuvuustestausta suurilla osallistujamäärillä eikä sovelluksen toimintaa testattu mobiililaitteilla. Tämän vuoksi tulokset osoittavat sovelluksen toimivuuden pienissä, usean osallistujan videohuoneissa testatuilla tietokoneilla, mutta niiden perusteella ei voida määrittää järjestelmän käytännön enimmäisosallistujamäärää, suorituskykyä kuormitetussa tilanteessa tai toimivuutta mobiiliympäristössä.

== Ei-toiminnallisten vaatimusten arviointi <testaus-ei-toiminnalliset-kappale>

Ei-toiminnallisten vaatimusten arvioinnissa tarkasteltiin vaatimusmäärittelyssä asetettujen vaatimusten N1–N6 toteutumista. Osa vaatimuksista voitiin todentaa käytännön testauksella ja osa toteutuksen sekä järjestelmän konfiguraation perusteella. @taulukko-ei-toiminnalliset esittää arviointimenetelmät ja tulokset.

#figure(
  [
    #set par(justify: false)
    #set text(size: 9pt, hyphenate: true)
    #table(
    columns: (0.7fr, 1.7fr, 3.2fr, 3.5fr, 0.9fr),
    inset: 6pt,
    stroke: 0.5pt,

    align: (
      center + horizon,
      left + horizon,
      left + horizon,
      left + horizon,
      center + horizon,
    ),

    table.header(
      repeat: true,
      [*Vaatimus*],
      [*Arvioitava ominaisuus*],
      [*Arviointimenetelmä*],
      [*Odotettu tulos*],
      [*Tulos*],
    ),

    [N1],
    [Toiminta NAT- ja palomuuriympäristöissä],
    [Yhteyttä testataan eri verkkoyhteyksissä. Erillisessä testissä TURN-releen käyttö pakotetaan ja varmistetaan, että ääni- ja videoyhteys muodostuu Coturn-palvelimen välityksellä.],
    [Mediayhteys voidaan muodostaa myös silloin, kun suora yhteys ei ole mahdollinen ja TURN-relettä tarvitaan.],
    [OK],

    [N2],
    [Liikenteen salaus],
    [Sovelluksen HTTPS- ja WSS-yhteydet sekä WebRTC-mediayhteyden salaus tarkistetaan toteutuksesta ja palveluiden konfiguraatiosta.],
    [Selainliikenne käyttää suojattuja HTTPS- ja WSS-yhteyksiä ja WebRTC-media välitetään salattuna.],
    [OK],

    [N3],
    [Usean osallistujan tuki],
    [Samaan videohuoneeseen liitetään useita osallistujia ja tarkistetaan, että Janus VideoRoom välittää osallistujien mediavirrat ilman arkkitehtuurimuutoksia.],
    [Järjestelmän SFU-arkkitehtuuri mahdollistaa useamman kuin kahden osallistujan videohuoneen ilman muutoksia perusarkkitehtuuriin.],
    [OK],

    [N4],
    [Toistettava ympäristö],
    [Sovelluksen palvelut käynnistetään Docker Compose -määrittelyn avulla.],
    [Frontend, NGINX, Janus ja Coturn voidaan käynnistää määritellystä konttiympäristöstä yhtenä kokonaisuutena.],
    [OK],

    [N5],
    [Signalointiyhteyden ylläpito],
    [Janus-istunnon keep-alive-toiminto ja sen 30 sekunnin lähetysväli tarkistetaan toteutuksesta sekä signalointi-istunnon pysyminen aktiivisena normaalissa videopuhelussa.],
    [Signalointi-istunto pysyy aktiivisena normaalissa käytössä.],
    [OK],

    [N6],
    [Virhetilanteiden jäljitettävyys],
    [JanusClient-luokan lokitusta ja muodostettuja lokiviestejä tarkastellaan virhe- ja signalointitilanteissa.],
    [Samaan tapahtumaketjuun liittyviä lokiviestejä voidaan yhdistää korrelaatiotunnisteen avulla.],
    [OK],
    )
  ],

  caption: [
    Videopuhelusovelluksen ei-toiminnallisten vaatimusten arviointi.
  ],
) <taulukko-ei-toiminnalliset>

Vaatimuksen N1 toteutumista arvioitiin muodostamalla videopuheluyhteyksiä eri verkkoyhteyksien välillä. Lisäksi erillisessä kontrolloidussa testissä TURN-releen käyttö pakotettiin. Testissä ääni- ja videoyhteys muodostui Coturn-palvelimen välityksellä, mikä osoitti järjestelmän pystyvän käyttämään välitettyä mediayhteyttä tilanteessa, jossa suoraa yhteyttä ei käytetä. TURN-releen käyttöä ei pakoteta sovelluksen normaalissa toiminnassa, vaan selaimen ICE-prosessi valitsee kulloiseenkin verkkotilanteeseen sopivan yhteystavan.

Liikenteen suojaamista koskeva vaatimus N2 toteutettiin käyttämällä sovelluksen selainliikenteessä HTTPS- ja WSS-yhteyksiä. TLS-yhteyksien terminoinnista vastasi NGINX. WebRTC-mediayhteyksissä media välitetään DTLS-SRTP-salauksella.

Vaatimuksen N3 mukainen usean osallistujan tuki toteutui käytetyssä testiympäristössä. Janus VideoRoom toimii SFU-periaatteella, joten uuden osallistujan lisääminen ei edellyttänyt muutoksia järjestelmän perusarkkitehtuuriin. Testauksessa samaan videohuoneeseen voitiin liittää useita osallistujia ja heidän mediavirtansa välittyivät muille osallistujille. Tulos ei kuitenkaan osoita järjestelmän suorituskykyä suurella osallistujamäärällä, koska varsinaista kuormitustestausta ei tehty.

Ympäristön toistettavuutta koskevaa vaatimusta N4 arvioitiin Docker Compose -kokonaisuuden avulla. Sovelluksen tarvitsemat palvelut voitiin käynnistää määritellyistä konttipalveluista, mikä mahdollistaa saman palvelurakenteen muodostamisen uudelleen käytetyn konfiguraation perusteella.

Signalointiyhteyden ylläpitoa varten Janus-istunnolle toteutettiin 30 sekunnin välein lähetettävä keep-alive-viesti. Keep-alive-liikenteen havaittiin toimivan oikein Janus-palvelimen ja selaimen välillä, ja se esti aktiivisen istunnon vanhenemisen normaalin käytön aikana.

Yhteyden palautumista testattiin myös katkaisemalla internetyhteys tilapäisesti. Lyhyen verkkokatkon jälkeen ääni- ja videoyhteys palautui toimivaksi ilman, että käyttäjän tarvitsi liittyä huoneeseen uudelleen. Tämä osoittaa, että selain ja WebRTC-yhteys sietävät lyhyitä verkkohäiriöitä käytetyssä testiympäristössä.

Pidempään kestävän verkkokatkon jälkeen PeerConnection-yhteys päättyi DTLS-virheeseen. Tämän jälkeen sovellus ei muodostanut uutta Janus-istuntoa eikä neuvotellut mediayhteyttä uudelleen internetyhteyden palauduttua. Havainto ei vaikuta N5-vaatimuksen toteutumiseen, koska vaatimus koskee aktiivisen signalointi-istunnon ylläpitoa normaalin videopuhelun aikana. Se tunnistettiin kuitenkin toteutuksen rajoitukseksi ja jatkokehityskohteeksi.

Virhetilanteiden jäljitettävyyttä koskeva vaatimus N6 toteutettiin lisäämällä JanusClient-luokan lokiviesteihin korrelaatiotunniste. Sen avulla samaan signalointi- tai virhetilanteeseen liittyviä lokimerkintöjä voidaan yhdistää toisiinsa, mikä helpottaa tapahtumaketjun seuraamista sovelluksen lokista.

Arvioinnin perusteella vaatimukset N1–N6 toteutuivat käytetyssä testiympäristössä. N5-vaatimuksen mukainen keep-alive-toiminto piti signalointi-istunnon aktiivisena normaalin videopuhelun aikana. Pidemmän verkkokatkon jälkeen yhteyksien automaattista palautumista ei kuitenkaan vielä toteutettu, mikä tunnistettiin erilliseksi tekniseksi rajoitukseksi ja jatkokehityskohteeksi.

== Selainyhteensopivuus <testaus-selainyhteensopivuus-kappale>

Selainyhteensopivuustestauksessa tarkasteltiin sovelluksen toimintaa kahdella eri työpöytäselaimella. Testauksessa käytettiin Google Chrome -selaimen versiota 155.0.8059.40 (64-bittinen) ja Mozilla Firefox -selaimen versiota 158.0 (64-bittinen). Tavoitteena oli selvittää, toimivatko sovelluksen keskeiset videopuhelutoiminnot yhdenmukaisesti testatuissa selainympäristöissä.

Molemmissa selaimissa videohuoneeseen liittyminen, paikallisen ääni- ja videovirran julkaiseminen sekä muiden osallistujien mediavirtojen vastaanottaminen toimivat odotetusti. Myös mikrofonin ja kameran hallintatoiminnot sekä videohuoneesta poistuminen toimivat samalla tavalla kummassakin selainympäristössä.

Chrome- ja Firefox-selainten välillä ei havaittu testauksen aikana sellaisia eroja, jotka olisivat vaikuttaneet sovelluksen keskeisten toimintojen käyttöön. Eri Windows-versioilla havaittiin kuitenkin visuaalisia eroja käyttöliittymässä käytettyjen Unicode-symbolien esitystavassa. Testatut käyttöjärjestelmät olivat Windows 11 Pro 25H2 (OS Build 26200.9457) ja Windows 10 Pro 22H2 (koontiversio 19045.6466). Erot eivät estäneet sovelluksen toimintojen käyttöä, mutta erityisesti puhelun lopettamiseen käytetyn symbolin havaittiin erottuvan joissakin ympäristöissä heikosti. Havaintoa ja sen perusteella tehtyä muutosta käsitellään tarkemmin saavutettavuustestauksen yhteydessä.

@kuva-symboli-vertailu esittää käyttöliittymässä käytetyt symbolit rinnakkain Windows 11- ja Windows 10 -ympäristöissä.

#figure(
  image("/images/symboli-vertailu.png",
  width: 100%,
  alt: "Rinnakkainen vertailu mikrofonin, videokameran ja puhelun lopettamisen Unicode-symboleista kahdessa Windows-ympäristössä. Symbolien värit ja yksityiskohdat eroavat ympäristöjen välillä, erityisesti punaisessa lopetuspainikkeessa käytettävä puhelinkuvake."),
  caption: [
    Käyttöliittymän Unicode-symbolien esitystapa Windows 11 Pro 25H2- ja Windows 10 Pro 22H2 -ympäristöissä.
  ],
) <kuva-symboli-vertailu>

Selainyhteensopivuustestaus rajattiin näihin kahteen työpöytäselaimeen ja kahteen Windows-ympäristöön. Sovellusta ei testattu mobiiliselaimilla tai muilla työpöytäselaimilla. Tämän vuoksi tuloksia ei voida yleistää kaikkiin WebRTC:tä tukeviin selaimiin, selainversioihin tai käyttöjärjestelmäympäristöihin.

== Saavutettavuustestaus <testaus-saavutettavuus-kappale>

Saavutettavuustestauksen tavoitteena oli arvioida, täyttääkö toteutettu videopuhelusovellus vaatimusmäärittelyssä asetetut saavutettavuusvaatimukset A1–A6. Testaus perustui WCAG 2.1 -ohjeistuksen onnistumiskriteereihin, jotka koskevat näppäimistökäyttöä, käyttöliittymäkomponenttien saavutettavia nimiä, lomakekenttien tunnisteita, tekstin kontrastia, sisällön ja rakenteen ohjelmallista määriteltävyyttä sekä sitä, ettei informaatiota välitetä ainoastaan värin avulla.

Testauksessa yhdistettiin automaattinen ja manuaalinen arviointi. Automaattiset tarkistukset toteutettiin Playwright-testikehyksellä @playwright ja axe-core-tarkistuksella @playwright-accessibility, joka käyttää samaa sääntömoottoria kuin axe DevTools @axe-devtools. Lisäksi käyttöliittymää tarkasteltiin manuaalisesti axe DevTools -työkalulla sekä näppäimistöä käyttäen. Automaattiset testit suoritettiin Chromium-selaimella.

@taulukko-saavutettavuustestaus esittää vaatimusmäärittelyn saavutettavuusvaatimukset, niiden testimenetelmät ja lopulliset testitulokset.

#figure(
  [
    #set par(justify: false)
    #set text(hyphenate: true)
    #table(
    columns: (0.8fr, 2.5fr, 3.2fr, 3.5fr, 0.9fr),
    inset: 6pt,
    stroke: 0.5pt,

    align: (
      center + horizon,
      left + horizon,
      left + horizon,
      left + horizon,
      center + horizon,
    ),

    table.header(
      repeat: true,
      [*Vaatimus*],
      [*Testattava ominaisuus*],
      [*Testimenettely*],
      [*Odotettu tulos*],
      [*Tulos*],
    ),

    [A1],
    [Näppäimistökäyttö],
    [Sovelluksen keskeiset interaktiiviset toiminnot käydään läpi pelkkää näppäimistöä käyttäen.],
    [Kaikki keskeiset interaktiiviset toiminnot ovat saavutettavissa ja käytettävissä näppäimistöllä.],
    [OK],

    [A2],
    [Interaktiivisten elementtien saavutettavat nimet],
    [Painikkeiden ja muiden interaktiivisten elementtien saavutettavat nimet tarkistetaan axe-core-tarkistuksella ja Playwright-testeillä.],
    [Interaktiivisilla elementeillä on niiden tarkoitusta kuvaavat saavutettavat nimet.],
    [OK],

    [A3],
    [Lomakekenttien tunnisteet ja ohjeet],
    [Näyttönimen ja huonetunnisteen syöttökenttien tunnisteet tarkistetaan automaattisesti.],
    [Lomakekentillä on näkyvät tunnisteet sekä niitä vastaavat ohjelmallisesti määriteltävät nimet tai ohjeet.],
    [OK],

    [A4],
    [Tekstin kontrasti],
    [Käyttöliittymän tekstien ja taustojen kontrastit tarkistetaan axe-core-työkalulla ennen ja jälkeen korjauksen.],
    [Tekstin kontrasti täyttää WCAG 2.1 -ohjeistuksen vähimmäisvaatimukset.],
    [OK],

    [A5],
    [Sisällön ja rakenteen ohjelmallinen määriteltävyys],
    [Otsikkorakenne, lista ja käyttöliittymäelementtien semanttisuus tarkistetaan automaattisesti.],
    [Sisältö, suhteet ja käyttöliittymän rakenne ovat ohjelmallisesti määriteltävissä.],
    [OK],

    [A6],
    [Tiedon välittäminen ilman pelkkää väriä],
    [Käyttöliittymä tarkastetaan manuaalisesti äänen, videon ja muiden tilojen osalta.],
    [Käyttäjälle olennainen tieto ei välity ainoastaan värin avulla.],
    [OK],
    )
  ],

  caption: [
    Videopuhelusovelluksen saavutettavuustestauksen testitapaukset ja lopulliset tulokset.
  ],
) <taulukko-saavutettavuustestaus>

Ensimmäisessä automaattisessa tarkistuksessa havaittiin yksi tekstin kontrastiin liittyvä puute. Etusivun alaotsikon kontrastisuhde oli 4,01:1, mikä alitti WCAG 2.1 -ohjeistuksen normaalikokoiselle tekstille asettaman vähimmäisvaatimuksen 4,5:1. Tämän vuoksi tekstin kontrastia koskeva vaatimus A4 ei toteutunut ensimmäisessä testatussa versiossa.

Muilta osin automaattisessa tarkistuksessa ei havaittu testattuihin vaatimuksiin liittyviä puutteita. Lomakekentillä oli niitä kuvaavat ohjelmalliset tunnisteet, ja käyttöliittymän interaktiivisilla painikkeilla oli niiden tarkoitusta kuvaavat saavutettavat nimet. Lisäksi käyttöliittymän otsikkorakenne ja ohjeistuksessa käytetty lista olivat ohjelmallisesti tunnistettavissa.

Näppäimistötestauksessa varmistettiin, että käyttäjä pystyi siirtymään näyttönimen ja huonetunnisteen syöttökenttiin sekä huoneen luomis- ja liittymispainikkeisiin sarkainnäppäimellä. Lomake voitiin täyttää ja lähettää ilman hiiren käyttöä. Videopuhelunäkymässä myös mikrofonin, kameran ja huoneesta poistumisen hallintapainikkeet olivat saavutettavissa sarkainnäppäimellä ja käytettävissä välilyönti- tai Enter-näppäimellä. Näin sovelluksen keskeiset interaktiiviset toiminnot voitiin suorittaa näppäimistöllä.

Käyttöliittymän äänen ja videon hallintatoiminnoissa tila ei välity ainoastaan värin avulla. Mikrofonin ja kameran tilan muuttuessa myös painikkeen kuvake ja saavutettava nimi muuttuvat. Näin esimerkiksi mykistetty mikrofoni voidaan erottaa käytössä olevasta mikrofonista myös muulla perusteella kuin painikkeen väristä.

Manuaalisessa tarkastelussa havaittiin lisäksi, että puhelun hallintapainikkeissa käytettyjen Unicode-symbolien visuaalinen esitystapa vaihteli käyttöjärjestelmän ja käytetyn fontin mukaan. Erityisesti puhelun lopettamista kuvaava symboli erottui joissakin ympäristöissä heikosti painikkeen taustasta. Vaikka painikkeella oli saavutettava nimi ja toiminto oli käytettävissä näppäimistöllä, symbolin heikko visuaalinen erottuvuus heikensi käyttöliittymän selkeyttä.

=== Testauksessa havaitut puutteet ja korjaukset <testaus-saavutettavuus-korjaukset-kappale>

Saavutettavuustestauksessa havaittu etusivun alaotsikon kontrastipuute korjattiin muuttamalla tekstin väri arvosta `#718096` arvoon `#64748b`. Muutoksen seurauksena tekstin ja valkoisen taustan välinen kontrastisuhde parani arvosta 4,01:1 arvoon 4,76:1. Korjattu kontrastisuhde ylittää WCAG 2.1 -ohjeistuksen normaalikokoiselle tekstille asettaman vähimmäisvaatimuksen 4,5:1. Korjauksen jälkeen automaattinen saavutettavuustarkistus suoritettiin uudelleen, eikä alaotsikon kontrastista enää raportoitu puutetta. @kuva-etusivu-kontrastikorjauksen-jalkeen esittää korjatun etusivun.

#figure(
  image("/images/etusivu_v2.png",
  width: 100%,
  alt: "Videopuhelusovelluksen aloitusnäkymä. Keskellä on VideoRTC-otsikko, tummennettu alaotsikko Simple WebRTC Video Calls, nimelle ja huonetunnukselle tarkoitetut syötekentät, Generate- ja Join Call -painikkeet sekä nelivaiheinen käyttöohje.",
  ),
  caption: [
    Videopuhelusovelluksen etusivu kontrastikorjauksen jälkeen.
  ],
) <kuva-etusivu-kontrastikorjauksen-jalkeen>

Manuaalisessa tarkastelussa havaittujen symbolien esityserojen vuoksi puhelun hallintapainikkeissa käytetyt Unicode-symbolit korvattiin SVG-kuvakkeilla. Muutoksen tavoitteena oli parantaa käyttöliittymän yhdenmukaisuutta ja symbolien visuaalista erottuvuutta. Unicode-symbolien esitystapa riippui osittain käyttöjärjestelmän ja käytetyn fontin renderöinnistä, minkä vuoksi samat symbolit saattoivat näyttää erilaisilta eri Windows-versioissa. SVG-kuvakkeiden väri ja koko voidaan määritellä CSS-tyyleillä yhdenmukaisesti, mikä vähentää käyttöjärjestelmä- ja fonttikohtaisia esityseroja ja tekee kuvakkeiden ulkoasusta hallittavamman. Muutos paransi erityisesti puhelun lopettamista kuvaavan painikkeen kuvakkeen erottuvuutta.

@kuva-painikkeet-ennen-jalkeen esittää puhelun hallintapainikkeiden kuvakkeet ennen muutosta ja sen jälkeen. Vasemmalla ovat aiemmin käytetyt Unicode-symbolit ja oikealla niitä korvaavat SVG-kuvakkeet.

#figure(
  image("/images/nappula-paivitys-ero.png",
  width: 100%,
  alt: "Vertailu puhelun hallintapainikkeista ennen ja jälkeen kuvakepäivityksen. Vasemmalla mikrofonin, kameran ja puhelun lopettamisen painikkeissa käytetään värillisiä Unicode-symboleita. Oikealla vastaavissa painikkeissa käytetään yhdenmukaisia SVG-kuvakkeita: valkoisia mikrofonin ja kameran kuvakkeita sekä valkoista puhelinkuvaketta punaisella taustalla.",
  ),
  caption: [
    Puhelun hallintapainikkeiden Unicode-symbolit ennen muutosta ja SVG-kuvakkeet muutoksen jälkeen.
  ],
) <kuva-painikkeet-ennen-jalkeen>

Korjausten jälkeen saavutettavuustestit suoritettiin uudelleen. Uusintatestauksessa aiemmin havaittu etusivun kontrastipuute ei enää esiintynyt, ja myös päivitetyt hallintapainikkeet läpäisivät niihin kohdistetut automaattiset tarkistukset. Manuaalisessa tarkastelussa SVG-kuvakkeiden todettiin näkyvän yhdenmukaisemmin ja puhelun lopettamista kuvaavan kuvakkeen erottuvan aiempaa selvemmin. Näppäimistötestauksessa painikkeiden toiminnassa ei havaittu muutoksen jälkeen ongelmia.

Lopullisen testauksen perusteella saavutettavuusvaatimukset A1–A6 toteutuivat testatuissa näkymissä ja käyttötapauksissa. Tulokset koskevat kuitenkin tässä työssä määriteltyjä saavutettavuusvaatimuksia ja testattuja käyttöliittymän osia, eivätkä ne yksin osoita sovelluksen täydellistä WCAG 2.1 -vaatimustenmukaisuutta. Laajempi saavutettavuuden arviointi edellyttäisi muun muassa testausta apuvälineteknologioilla, useammilla selaimilla sekä käyttäjätestausta.

== Tulokset <tulokset-kappale>

Testauksen perusteella toteutettu videopuhelusovellus täytti sille asetetut keskeiset toiminnalliset ja saavutettavuuteen liittyvät vaatimukset testatussa ympäristössä. Toiminnallisessa testauksessa vaatimusmäärittelyn vaatimukset F1–F10 toteutuivat. Käyttäjät pystyivät luomaan videohuoneen ja liittymään siihen näyttönimellä, julkaisemaan paikallisen ääni- ja videovirran, vastaanottamaan muiden osallistujien mediavirtoja sekä hallitsemaan mikrofonia ja kameraa puhelun aikana. Uuden osallistujan mediavirta tuli näkyviin automaattisesti ja poistuneen osallistujan videonäkymä poistui muiden osallistujien käyttöliittymästä.

Kaikki ei-toiminnalliset vaatimukset N1–N6 toteutuivat käytetyssä testiympäristössä. Sovellus pystyi muodostamaan mediayhteyksiä eri verkkoyhteyksien välillä, ja erillisessä testissä myös Coturn-palvelimen välittämä mediayhteys todettiin toimivaksi. Selainliikenne toteutettiin suojatuilla yhteyksillä. Januksen SFU-arkkitehtuuri mahdollisti usean osallistujan videohuoneen ilman muutoksia järjestelmän perusrakenteeseen, ja Docker Compose mahdollisti palvelukokonaisuuden käynnistämisen määritellystä ympäristöstä. Lokiviestien korrelaatiotunniste mahdollisti samaan tapahtumaketjuun kuuluvien tapahtumien yhdistämisen. N5-vaatimuksen mukainen keep-alive-toiminto piti signalointi-istunnon aktiivisena normaalin videopuhelun aikana. Pidemmän verkkokatkon jälkeen yhteyksiä ei kuitenkaan muodostettu automaattisesti uudelleen, mikä tunnistettiin toteutuksen rajoitukseksi ja jatkokehityskohteeksi.

Selainyhteensopivuustestauksessa sovelluksen keskeiset toiminnot toimivat samalla tavalla testatuissa Google Chrome- ja Mozilla Firefox -selaimissa. Selainten välillä ei havaittu toiminnallisuuteen vaikuttavia eroja. Windows 10- ja Windows 11 -ympäristöjen välillä havaittiin kuitenkin visuaalisia eroja puhelun hallintapainikkeissa käytetyissä Unicode-symboleissa. Havainto johti symbolien korvaamiseen SVG-kuvakkeilla, minkä jälkeen hallintapainikkeiden ulkoasu oli yhdenmukaisempi eri käyttöjärjestelmäympäristöissä.

Saavutettavuustestauksessa vaatimukset A1–A6 toteutuivat lopullisessa testatussa versiossa. Ensimmäisessä automaattisessa tarkistuksessa havaittiin etusivun alaotsikon tekstikontrastiin liittyvä puute, jossa kontrastisuhde oli 4,01:1. Tekstin värin muuttamisen jälkeen kontrastisuhde nousi arvoon 4,76:1 ja ylitti WCAG 2.1 -ohjeistuksen normaalikokoiselle tekstille asettaman vähimmäisvaatimuksen 4,5:1. Lisäksi puhelun hallintapainikkeiden Unicode-symbolit korvattiin SVG-kuvakkeilla niiden visuaalisen erottuvuuden ja yhdenmukaisuuden parantamiseksi.

Manuaalisessa näppäimistötestauksessa sovelluksen keskeiset interaktiiviset toiminnot olivat käytettävissä ilman hiirtä. Käyttäjä pystyi siirtymään lomakekenttiin ja painikkeisiin sarkainnäppäimellä sekä käyttämään toimintoja näppäimistön avulla. Korjausten jälkeen suoritetuissa automaattisissa ja manuaalisissa uusintatesteissä ei havaittu vaatimusmäärittelyn A1–A6-vaatimuksiin liittyviä puutteita.

Testauksen tuloksena voitiin todeta, että sovelluksen keskeiset videopuhelutoiminnot toimivat pienissä usean osallistujan videohuoneissa eri verkkoyhteyksien välillä ja testatuissa selainympäristöissä.
