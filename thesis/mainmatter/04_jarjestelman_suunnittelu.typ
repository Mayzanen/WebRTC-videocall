/** 04_jarjestelman_suunnittelu.typ
 *
 * This is an example introdution in a multi-file Typst project.
 *
***/

#pdf.attach(
  "04_jarjestelman_suunnittelu.typ",
  relationship: "source",
  mime-type: "text/vnd.typst",
  description: "The Typst source code for the system design chapter 4 of this thesis.",
)

#import "../preamble.typ": *
#import "@preview/cetz:0.5.1"

= Järjestelmän suunnittelu <suunnittelu-kappale>

Tässä luvussa tarkastellaan videopuhelusovelluksen suunnittelua. Aluksi käsitellään sovellukselle asetettuja vaatimuksia, minkä jälkeen tarkastellaan kokonaisarkkitehtuuria ja käyttöliittymän suunnittelua. Lopuksi perustellaan keskeiset teknologiavalinnat.

== Vaatimusmäärittely <suunnittelu-maarittely-kappale>

ISO/IEC/IEEE 29148 -standardin mukaan vaatimus on järjestelmään kohdistuvaa tarvetta tai siihen liittyviä rajoitteita kuvaava määrittely, joka tulee esittää riittävän täsmällisesti ja yksiselitteisesti. Standardi käsittelee vaatimusten suunnittelua, määrittelyä, dokumentointia ja hallintaa sekä määrittelee vaatimuksiin liittyviä tietosisältöjä ja niiden ominaisuuksia. @iso29148

Tässä työssä vaatimusmäärittelyn tavoitteena on kuvata toteutettavalle videopuhelusovellukselle asetetut keskeiset toiminnalliset, ei-toiminnalliset ja saavutettavuutta koskevat vaatimukset. Vaatimukset on muotoiltu siten, että niiden toteutumista voidaan arvioida toteutuksen yhteydessä. Vaatimukset on jaettu kolmeen kokonaisuuteen niiden luonteen perusteella.

Toiminnalliset vaatimukset kuvaavat sovelluksen käyttäjälle tarjoamat keskeiset toiminnot. Näihin kuuluvat muun muassa videopuheluhuoneen luominen ja siihen liittyminen, osallistujien videoiden näyttäminen sekä kameran ja mikrofonin hallinta. @vaatimukset-toiminnalliset esittää toiminnalliset vaatimukset ja niiden suunnitellut toteutustavat.

Ei-toiminnalliset vaatimukset kuvaavat puolestaan järjestelmän toiminnalle asetettuja teknisiä ominaisuuksia ja reunaehtoja. Näissä huomioidaan esimerkiksi yhteyksien toiminta erilaisissa verkkoympäristöissä, liikenteen suojaaminen, usean osallistujan tukeminen sekä palvelinympäristön toistettava käyttöönotto. @vaatimukset-eitoiminnalliset esittää ei-toiminnalliset vaatimukset ja niiden suunnitellut toteutustavat.

Saavutettavuusvaatimukset kohdistuvat erityisesti sovelluksen käyttöliittymään ja perustuvat verkkosisällön saavutettavuusohjeisiin (WCAG 2.1). Vaatimuksissa huomioidaan muun muassa näppäimistökäyttö, interaktiivisten elementtien ohjelmallinen saavutettavuus, lomakkeiden saavutettavuus, kontrastit sekä värin käyttö informaation välittämisessä. @vaatimukset-saavutettavuus esittää saavutettavuusvaatimukset ja niitä vastaavat WCAG 2.1 -onnistumiskriteerit.

Käytettävyyttä ei tässä työssä arvioida erillisillä käyttäjätesteillä. Arviointi kohdistuu järjestelmälle asetettujen toiminnallisten, ei-toiminnallisten ja saavutettavuusvaatimusten toteutumiseen.

#figure(
  table(
    columns: (0.5fr, 3.2fr, 4fr),
    inset: 6pt,
    align: left + horizon,

    table.header(
      [*ID*],
      [*Toiminnallinen vaatimus*],
      [*Toteutustapa*],
    ),

    [F1],
    [Käyttäjän tulee voida luoda uusi huone tai liittyä olemassa olevaan huoneeseen huonetunnisteen perusteella.],
    [Home-sivu ja satunnaisen huonetunnisteen generointi.],

    [F2],
    [Käyttäjän tulee voida määrittää näyttönimi ennen puheluun liittymistä.],
    [Lomake Home-sivulla.],

    [F3],
    [Sovelluksen tulee pyytää käyttäjältä lupa kameran ja mikrofonin käyttöön.],
    [`navigator.mediaDevices.getUserMedia`-rajapinta.],

    [F4],
    [Käyttäjän oman videokuvan tulee näkyä erillisenä esikatseluna.],
    [`LocalVideo`-komponentti.],

    [F5],
    [Muiden osallistujien videokuvien tulee näkyä reaaliaikaisesti.],
    [`RemoteVideo`-komponentti ja dynaaminen `Map<feedId, { stream, display }>` -rakenne.],

    [F6],
    [Uuden osallistujan liittyessä kesken puhelun hänen videokuvansa tulee ilmestyä automaattisesti muille osallistujille.],
    [Januksen tapahtumaviestien `publishers`-listan käsittely.],

    [F7],
    [Osallistujan poistuessa puhelusta hänen videokuvansa tulee poistua automaattisesti muiden osallistujien näkymästä.],
    [`unpublished`- ja `leaving`-tapahtumien käsittely.],

    [F8],
    [Käyttäjän tulee voida mykistää mikrofoninsa ja palauttaa se käyttöön.],
    [`Controls`-komponentin `toggleAudio()`-toiminto.],

    [F9],
    [Käyttäjän tulee voida sulkea kameransa ja avata se uudelleen.],
    [`Controls`-komponentin `toggleVideo()`-toiminto.],

    [F10],
    [Käyttäjän tulee voida poistua puhelusta hallitusti.],
    [`leaveRoom()`-toiminto ja resurssien vapautus.],
  ),
  caption: [Videopuhelusovellukselle määritellyt toiminnalliset vaatimukset.],
) <vaatimukset-toiminnalliset>

#figure(
  table(
    columns: (0.5fr, 3.2fr, 4fr),
    inset: 6pt,
    align: left + horizon,

    table.header(
      [*ID*],
      [*Ei-toiminnallinen vaatimus*],
      [*Perustelu / toteutus*],
    ),

    [N1],
    [Yhteyden tulee toimia NAT:in ja palomuurien takaa.],
    [Coturn STUN/TURN-palvelin.],

    [N2],
    [Sovelluksen käyttöliittymä- ja signalointiliikenne selaimen ja palvelinympäristön välillä tulee salata. WebRTC-mediavirran tulee hyödyntää WebRTC:n DTLS-SRTP-suojausta.],
    [HTTPS/WSS, NGINX:n TLS-terminointi sekä WebRTC:n DTLS-SRTP-suojaus.],

    [N3],
    [Sovelluksen tulee skaalautua useampaan kuin kahteen osallistujaan ilman arkkitehtuurimuutoksia.],
    [SFU-malli (Janus VideoRoom) ja publisher/subscriber-erottelu.],

    [N4],
    [Palvelinympäristön tulee olla toistettavasti pystytettävissä.],
    [Docker Compose -orkestrointi.],

    [N5],
    [Signalointiyhteyden aktiivisuutta tulee ylläpitää videopuhelun aikana.],
    [Keep-alive-mekanismi 30 sekunnin välein.],

    [N6],
    [Virhetilanteet tulee raportoida jäljitettävästi.],
    [Correlation ID -pohjainen lokitus (`JanusClient`).],
  ),
  caption: [Videopuhelusovellukselle määritellyt ei-toiminnalliset vaatimukset.],
) <vaatimukset-eitoiminnalliset>

#figure(
  table(
    columns: (auto, auto, auto),
    inset: 6pt,
    align: left + horizon,

    table.header(
      [*ID*],
      [*Saavutettavuusvaatimus*],
      [*WCAG 2.1*],
    ),

    [A1],
    [Kaikkien käyttöliittymän toimintojen tulee olla käytettävissä näppäimistöllä.],
    [2.1.1],

    [A2],
    [Käyttöliittymän interaktiivisilla elementeillä tulee olla niiden tarkoituksen ilmaisevat ohjelmallisesti määritettävät nimet.],
    [4.1.2],

    [A3],
    [Lomakekentillä tulee olla käyttäjälle näkyvät ja ohjelmallisesti määritettävät nimet tai ohjeet.],
    [3.3.2],

    [A4],
    [Käyttöliittymän tekstin ja taustan välisen kontrastin tulee täyttää vähimmäisvaatimukset.],
    [1.4.3],

    [A5],
    [Käyttöliittymän sisältö ja rakenne tulee olla ohjelmallisesti tulkittavissa.],
    [1.3.1],

    [A6],
    [Käyttöliittymän toiminnallisuudesta ja tilasta ei saa välittää tietoa ainoastaan värin avulla.],
    [1.4.1],
  ),
  caption: [Videopuhelusovellukselle määritellyt saavutettavuusvaatimukset.],
) <vaatimukset-saavutettavuus>

== Kokonaisarkkitehtuuri <suunnittelu-arkkitehtuuri-kappale>

Sovelluksen kokonaisarkkitehtuuri muodostuu selaimessa suoritettavasta React-käyttöliittymästä sekä palvelinympäristössä toimivista WebRTC-yhteyksien muodostamiseen ja hallintaan liittyvistä palveluista. Arkkitehtuurin suunnittelussa keskeisenä tavoitteena oli erottaa käyttöliittymä, signalointi ja reaaliaikaisen median välitys toisistaan. Tällä rakenteella käyttöliittymän toiminnallisuus voidaan pitää erillään WebRTC-yhteyksien teknisestä käsittelystä ja mediavirtojen välityksestä.

Selain toimii sovelluksen käyttöliittymänä ja vastaa käyttäjän kameran ja mikrofonin hallinnasta sekä videokuvien esittämisestä. Sovelluksessa ei ole erillistä sovelluspalvelinta, joka välittäisi signalointiviestejä eteenpäin — selaimessa suoritettava React-sovellus muodostaa signalointiyhteyden suoraan Janukseen WebSocket-yhteyden yli ja käyttää WebRTC-yhteyttä reaaliaikaisen ääni- ja videodatan välittämiseen. Käyttöliittymä toteutettiin Reactilla, ja videopuhelun hallintaan liittyvät toiminnot on jaettu erillisiin komponentteihin sekä palveluluokkiin, jotka vastaavat signaloinnista (`JanusClient`) ja WebRTC-yhteyksien hallinnasta (`WebRTCManager`).

Janus WebRTC Gateway toimii arkkitehtuurin keskeisenä reaaliaikaisen viestinnän palveluna. Se vastaa WebRTC-yhteyksien hallinnasta ja osallistujien mediavirtojen välittämisestä. Sovelluksessa hyödynnetään Januksen VideoRoom-pluginia, joka mahdollistaa SFU-arkkitehtuurin mukaisen mediavirtojen välityksen. Tällöin osallistujien selaimet lähettävät omat mediavirtansa Janukselle, joka välittää ne edelleen muille huoneen osallistujille.

NAT-läpäisyssä hyödynnetään STUN- ja TURN-palvelua. STUN mahdollistaa selaimelle julkisen verkko-osoitteen selvittämisen ja suoran WebRTC-yhteyden muodostamisen silloin, kun verkkoympäristö sen sallii. Mikäli suoraa yhteyttä ei voida muodostaa, mediavirta voidaan välittää TURN-palvelimen kautta. TURN-palveluna käytetään Coturnia. STUN- ja TURN-palvelun käyttö on siis ehdollista — Coturnia hyödynnetään vain tilanteissa, joissa suora RTP-yhteys Januksen ja selaimen välillä ei onnistu.

NGINX toimii palvelinympäristön edessä liikenteen välittäjänä ja vastaa HTTPS- ja WSS-yhteyksien TLS-terminoinnista. NGINX reitittää saapuvan liikenteen kahteen kohteeseen: frontend-käyttöliittymäpalveluun sekä Januksen WebSocket-rajapintaan, jota käytetään signalointiin. Sovelluksen palvelut suoritetaan kontteina, ja niiden käynnistämisestä sekä keskinäisestä verkottamisesta huolehditaan Docker Composen avulla. @kokonaisarkkitehtuuri esittää kokonaisarkkitehtuurin.

#figure(
  cetz.canvas({
    import cetz.draw: *

    let box-width = 4.2

    content(
      (0, 5),
      [
        *Käyttäjän selain* \
        React-käyttöliittymä \
        `JanusClient` · `WebRTCManager`
      ],
      name: "browser",
      anchor: "center",
      frame: "rect",
      padding: 0.25,
      width: box-width,
    )

    content(
      (0, 2.2),
      [
        *NGINX* \
        Reverse proxy
      ],
      name: "nginx",
      anchor: "center",
      frame: "rect",
      padding: 0.25,
      width: box-width,
    )

    content(
      (-3.2, -0.8),
      [
        *Frontend* \
        React / Vite \
        käyttöliittymäpalvelu
      ],
      name: "frontend",
      anchor: "center",
      frame: "rect",
      padding: 0.25,
      width: box-width,
    )

    content(
      (3.2, -0.8),
      [
        *Janus WebRTC Gateway* \
        VideoRoom-plugin \
        SFU
      ],
      name: "janus",
      anchor: "center",
      frame: "rect",
      padding: 0.25,
      width: box-width,
    )

    content(
      (3.2, -4.0),
      [
        *Coturn* \
        STUN / TURN
      ],
      name: "coturn",
      anchor: "center",
      frame: "rect",
      padding: 0.25,
      width: box-width,
    )

    line(
      "browser.south",
      "nginx.north",
      mark: (end: ">"),
    )

    content(
      (0.55, 3.6),
      [HTTPS / WSS],
      anchor: "west",
    )

    line(
      "nginx.south-west",
      "frontend.north",
      mark: (end: ">"),
    )

    content(
      (-1.45, 0.7),
      [HTTP],
      anchor: "south",
    )

    line(
      "nginx.south-east",
      "janus.north",
      mark: (end: ">"),
    )

    content(
      (3.6, 0.7),
      [WebSocket],
      anchor: "south",
    )

    line(
      "browser.east",
      "janus.north-east",
      name: "webrtc",
    )

    content(
      (6.8, 2.0),
      [WebRTC-mediayhteys],
      anchor: "north",
    )

    line(
      "janus.south",
      "coturn.north",
      name: "turn",
      stroke: (
        dash: "dashed",
      ),
    )

    content(
      (3.9, -2.35),
      [Tarvittaessa: selain ↔ Coturn ↔ Janus],
      anchor: "west",
    )

    content(
      (3.9, -2.8),
      [TURN-välitys],
      anchor: "west",
    )
  }),
  alt: "Kokonaisarkkitehtuuri: selain käyttää NGINXiä HTTPS- ja WSS-yhteyksillä. NGINX reitittää liikenteen frontendille ja Janus WebRTC Gatewaylle. WebRTC-media kulkee selaimen ja Januksen välillä suoraan tai tarvittaessa Coturnin kautta.",
  caption: [Videopuhelusovelluksen kokonaisarkkitehtuuri.],
) <kokonaisarkkitehtuuri>

== Käyttöliittymän suunnittelu <suunnittelu-kayttoliittyma-kappale>

Käyttöliittymän suunnittelun tavoitteena oli toteuttaa videopuhelusovellukselle selkeä ja tarkoituksenmukainen käyttöliittymä, jonka avulla käyttäjä voi liittyä videopuheluun ja hallita puhelun aikana käytettäviä ääni- ja videotoimintoja. Käyttöliittymä suunniteltiin sovelluksen keskeisten käyttötapausten ympärille siten, että videopuheluun liittyminen ja puhelun hallinta muodostavat toisistaan selkeästi erottuvat kokonaisuudet.

Käyttöliittymä koostuu pääasiassa kahdesta näkymästä. Aloitusnäkymässä käyttäjä voi määrittää näyttönimensä sekä luoda uuden videopuheluhuoneen tai liittyä olemassa olevaan huoneeseen huonetunnisteen avulla. Videopuhelunäkymässä käyttäjälle esitetään oman videokuvan lisäksi muiden osallistujien videokuvat sekä puhelun hallintaan tarvittavat toiminnot.

Käyttöliittymän suunnittelussa huomioitiin myös sovellukselle asetetut saavutettavuustavoitteet. Interaktiiviset toiminnot suunniteltiin toteutettaviksi natiiveilla HTML-elementeillä, jotta niitä voidaan käyttää myös näppäimistöllä. Lisäksi suunnittelussa huomioitiin tekstin ja taustan välinen kontrasti sekä se, ettei toimintojen tilaa ilmaista ainoastaan värin avulla. Saavutettavuuden suunnittelussa hyödynnettiin vaatimusmäärittelyssä esitettyjä WCAG 2.1 -onnistumiskriteereitä. Saavutettavuuden systemaattinen arviointi toteutetaan työn arviointivaiheessa automatisoiduilla axe-pohjaisilla testeillä ja Axe DevTools -tarkastuksella. Ruudunlukijatestauksen kattavuus rajataan erikseen.

=== Käyttöliittymän rakenne

Sovelluksen aloitusnäkymän tehtävänä on ohjata käyttäjä videopuheluun liittymiseen. Näkymässä käyttäjä määrittää näyttönimensä ja huonetunnisteen. Käyttäjä voi joko luoda uuden huoneen tai liittyä olemassa olevaan huoneeseen. Uutta huonetta luotaessa sovellus muodostaa huoneelle tunnisteen, jonka avulla muut käyttäjät voivat liittyä samaan puheluun.

Aloitusnäkymä suunniteltiin rakenteeltaan yksinkertaiseksi, jotta videopuheluun liittymisen kannalta keskeiset toiminnot ovat helposti löydettävissä. Lomakkeen syöttökentät ja puhelun käynnistävä toiminto erotettiin toisistaan selkeästi, mikä jäsentää käyttäjälle puheluun liittymisen etenemisen.

Videopuhelunäkymä muodostaa sovelluksen pääasiallisen käyttöliittymän. Sen keskeinen tehtävä on esittää osallistujien videokuvat ja mahdollistaa puhelun aikainen hallinta. Videokuville varataan suurin osa käytettävissä olevasta tilasta, kun taas puhelun hallintaan liittyvät toiminnot sijoitetaan erilliseen ohjausalueeseen näkymän alaosaan.

=== Videopuhelunäkymä

Videopuhelunäkymässä käyttäjän oma videokuva esitetään erillisenä videokuvana muiden osallistujien videoista. Muiden osallistujien videokuvat muodostavat dynaamisen kokonaisuuden, jossa puheluun liittyvien osallistujien määrän muutokset huomioidaan. Uuden osallistujan liittyessä hänen videokuvansa lisätään näkymään ja osallistujan poistuessa vastaava videokuva poistetaan.

Videokuvien asettelussa lähtökohtana oli säilyttää osallistujien videokuvat käyttöliittymän keskeisenä sisältönä myös useamman osallistujan puhelussa. Nykyinen asettelu on kuitenkin suunniteltu ensisijaisesti pienelle osallistujajoukolle eikä mukaudu täysin dynaamisesti osallistujamäärän kasvaessa. Asettelun optimointi suuremmille osallistujamäärille rajattiin tämän työn ulkopuolelle ja tunnistettiin jatkokehityskohteeksi.

Videopuhelun hallintaan liittyvät toiminnot muodostavat näkymän alaosaan sijoitetun ohjausalueen. Sen avulla käyttäjä voi mykistää mikrofonin ja ottaa sen uudelleen käyttöön, sulkea kameran ja avata sen uudelleen sekä poistua videopuhelusta. Toimintojen tilat ilmaistaan käyttöliittymässä visuaalisesti esimerkiksi kuvakkeen ja värin avulla. Lisäksi toiminnoille suunniteltiin ohjelmallisesti määritettävät nimet ja tilat, jotta niiden käyttötarkoitus ja tila olisivat havaittavissa myös ilman visuaalista esitystapaa.

Käyttöliittymän rakenne suunniteltiin tukemaan sovelluksen SFU-arkkitehtuuria, jossa usean osallistujan mediavirrat voidaan välittää Januksen kautta. Osallistujakohtaisten videokuvien lisääminen ja poistaminen mahdollistaa osallistujamäärän muuttumisen ilman, että videopuhelunäkymän perusrakennetta tarvitsee muuttaa.

=== Käyttöliittymän saavutettavuus

Saavutettavuus huomioitiin käyttöliittymän suunnittelussa osana käyttöliittymän rakennetta ja komponenttien toteutusta. Keskeisiä suunnitteluperiaatteita olivat näppäimistökäytön mahdollistaminen natiiveilla interaktiivisilla elementeillä, elementtien tarkoituksen ja tilan ohjelmallinen välittäminen sekä käyttöliittymän toiminnallisuuden riippumattomuus pelkästä väristä. Lomakkeissa kenttien yhteydessä käytetään niiden tarkoitusta kuvaavia ohjelmallisesti kytkettyjä nimiä, ja fokusoitaville elementeille suunniteltiin selkeä visuaalinen fokusindikaattori.

Toimintonapit suunniteltiin toteutettaviksi natiiveina painikkeina. Niiden tarkoitus ja tila välitetään ohjelmallisesti esimerkiksi `aria-label`- ja `aria-pressed`-attribuuteilla. Saavutettavuuden vaatimusten toteutuminen arvioidaan työn arviointivaiheessa automatisoiduilla axe-pohjaisilla testeillä ja Axe DevTools -tarkastuksella. Ruudunlukijatestauksen kattavuus rajataan erikseen.

== Teknologiavalinnat <suunnittelu-teknologiavalinnat-kappale>

Sovelluksen teknologiavalinnat tehtiin toteutuksen tavoitteiden ja asetettujen vaatimusten perusteella. Keskeisiä valintaperusteita olivat WebRTC-teknologian hyödyntäminen reaaliaikaisessa viestinnässä, usean osallistujan videopuhelun mahdollistaminen, käyttöliittymän saavutettavuus sekä sovelluksen suoritusympäristön toistettavuus. Teknologioiden valinnassa huomioitiin lisäksi niiden soveltuvuus selainpohjaiseen toteutukseen ja yhteensopivuus keskenään.

Käyttöliittymän toteutusteknologiaksi valittiin React, joka mahdollistaa käyttöliittymän jakamisen uudelleenkäytettäviin komponentteihin ja soveltuu hyvin dynaamisen käyttöliittymän toteuttamiseen @react-components. Komponenttirakenteen avulla käyttöliittymän eri osien tilaa ja sisältöä voidaan hallita toisistaan erillään. Reactin lisäksi käyttöliittymän toteutuksessa hyödynnettiin TypeScriptiä, jonka staattinen tyypitys tukee erityisesti WebRTC- ja signalointilogiikan hallintaa @typescript.

Käyttöliittymän kehitys- ja build-työkaluksi valittiin Vite, joka tarjoaa nopean kehityspalvelimen ja tehokkaan tuotantorakennuksen @vite. Se soveltuu hyvin yhteen React- ja TypeScript-pohjaisen kehityksen kanssa ja mahdollistaa nopean iteroinnin kehitysvaiheessa.

WebRTC valittiin reaaliaikaisen ääni- ja videoliikenteen toteutusteknologiaksi, koska se mahdollistaa reaaliaikaisen mediaviestinnän suoraan selaimessa ilman erillistä selainlaajennusta. Usean osallistujan videopuhelun toteuttamiseen valittiin Janus WebRTC Gateway ja sen VideoRoom-plugin. VideoRoom perustuu SFU-arkkitehtuuriin, jossa osallistujien mediavirrat välitetään palvelimen kautta muille osallistujille @janus-videoroom. Ratkaisu mahdollistaa usean osallistujan tukemisen ilman, että jokaisen selaimen tarvitsee muodostaa erillistä mediayhteyttä kaikkien muiden osallistujien kanssa.

WebRTC-yhteyksien NAT-läpäisyä varten valittiin Coturn, joka tarjoaa STUN- ja TURN-palvelut @coturn. STUN-palvelua voidaan hyödyntää yhteysehdokkaiden muodostamisessa, kun taas TURN mahdollistaa mediavirran välittämisen palvelimen kautta tilanteissa, joissa suoraa yhteyttä ei voida muodostaa. Ratkaisu tukee sovelluksen tavoitetta toimia erilaisissa verkkoympäristöissä ja NAT-ratkaisujen takana.

Sovelluksen palvelinympäristö toteutettiin Docker-konteilla ja niiden hallintaan käytettiin Docker Composea. Kontit mahdollistavat sovelluksen eri palveluiden erottamisen toisistaan ja Docker Compose niiden yhtenäisen käynnistämisen sekä keskinäisen verkottamisen @docker-compose. Käyttöliittymän ja Januksen välisen liikenteen välittämiseen valittiin NGINX, joka toimii palvelinympäristön käänteisenä välityspalvelimena @nginx-reverse-proxy. NGINX:n avulla liikennettä voidaan välittää palvelinympäristön eri palveluille keskitetyn rajapinnan kautta. Lisäksi NGINX huolehtii tässä toteutuksessa HTTPS- ja WSS-yhteyksien TLS-terminoinnista. Näiden teknologioiden muodostama kokonaisuus tukee sovelluksen vaatimusta toistettavasti pystytettävästä palvelinympäristöstä sekä suojatuista käyttöliittymä-, signalointi- ja mediayhteyksistä.

Sovelluksen laadunvarmistukseen valittiin Playwright-testauskehys, joka mahdollistaa selainpohjaisten käyttötapausten automatisoidun testaamisen todellista selainta vasten. Saavutettavuusvaatimusten arviointiin valittiin axe DevTools -työkalu, joka mahdollistaa WCAG-kriteeristöön perustuvien saavutettavuuspuutteiden automatisoidun tunnistamisen. Näitä työkaluja hyödynnetään työn myöhemmässä vaiheessa osana sovelluksen laadunvarmistusta ja saavutettavuuden arviointia.
