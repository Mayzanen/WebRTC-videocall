/** 02_webrtc.typ
 *
 * This is an example introdution in a multi-file Typst project.
 *
***/

#pdf.attach(
  "02_webrtc.typ",
  relationship: "source",
  mime-type: "text/vnd.typst",
  description: "The Typst source code for the WebRTC technology chapter 2 of this thesis.",
)

#import "../preamble.typ": *
#import "@preview/scholarly-tauthesis:0.22.0" as tauthesis
#import "@preview/cetz:0.5.2"

= WebRTC-pohjaiset videopuhelujärjestelmät <teoria-kappale>

Tässä luvussa esitellään työn kannalta keskeiset WebRTC-teknologiaan ja
videopuhelujärjestelmien toteutukseen liittyvät käsitteet. Aluksi tarkastellaan
WebRTC-teknologiaa sekä sen tarjoamia ohjelmointirajapintoja ja
tiedonsiirtomekanismeja. Tämän jälkeen käsitellään WebRTC-yhteyden muodostamisessa
tarvittavaa signalointia sekä WebRTC-pohjaisten videopuhelujärjestelmien
yleisimpiä arkkitehtuureja ja niiden ominaisuuksia. Lisäksi esitellään työssä
käytettävä Janus WebRTC Gateway sekä tarkastellaan WebRTC-yhteyden muodostamiseen
liittyvää NAT-läpäisyä ja siihen liittyviä ICE-, STUN- ja TURN-mekanismeja.

== WebRTC-teknologia <teoria-webrtc-kappale>

WebRTC on avoimiin standardeihin perustuva teknologia, joka mahdollistaa
reaaliaikaisen ääni-, video- ja tiedonsiirron verkkoselainten ja muiden
WebRTC:tä tukevien sovellusten välillä. WebRTC:n tavoitteena on tarjota
standardoidut ohjelmointirajapinnat ja tiedonsiirtoprotokollat, joiden avulla
kehittäjät voivat toteuttaa reaaliaikaisia viestintäsovelluksia hyödyntäen
verkkoselainten tarjoamia sisäänrakennettuja toimintoja. Teknologia on
standardoitu yhteistyössä W3C:n ja IETF:n kanssa. W3C määrittelee selaimille
tarjottavat ohjelmointirajapinnat, kun taas IETF vastaa tiedonsiirtoon
liittyvistä protokollista. WebRTC:tä hyödynnetään laajasti erilaisissa
reaaliaikaisissa viestintäsovelluksissa, kuten videopuheluissa,
videoneuvotteluissa ja asiakaspalveluratkaisuissa. @webrtc-definition

WebRTC-sovellukset hyödyntävät useita ohjelmointirajapintoja reaaliaikaisen
viestinnän toteuttamiseen. Ääni- ja videolaitteiden käyttö perustuu Media
Capture and Streams -standardin määrittelemään MediaDevices-rajapintaan ja
MediaStream-olioihin. Vertaisyhteyksien muodostamisesta ja hallinnasta vastaa
WebRTC-spesifikaation määrittelemä RTCPeerConnection-rajapinta, jonka kautta
ääni-, video- ja datavirtoja voidaan siirtää osapuolten välillä.
RTCDataChannel mahdollistaa sovellusdatan siirtämisen vertaisyhteyden yli.
WebRTC ei määrittele signaloinnissa käytettävää protokollaa, vaan signaloinnin
toteutustapa on sovelluskohtainen. Yhteyden muodostaminen hyödyntää signalointia
sekä ICE-mekanismia, jota käsitellään tarkemmin luvussa
@teoria-nat-webrtc-kappale. @mediacapture-streams @webrtc-definition

== Signalointi WebRTC-yhteyden muodostamisessa <teoria-signalointi-kappale>

WebRTC-yhteyden muodostaminen edellyttää, että yhteyden osapuolet vaihtavat
keskenään tietoja ennen varsinaisen mediayhteyden muodostumista. Tätä
tiedonvaihtoa kutsutaan signaloinniksi. Signaloinnin avulla välitetään
esimerkiksi yhteyden muodostamiseen tarvittavat istuntokuvaukset sekä
verkkoyhteyden muodostamisessa käytettävät ICE-ehdokkaat. WebRTC ei määrittele
signaloinnissa käytettävää protokollaa, vaan sen toteutustapa voidaan valita
sovelluksen tarpeiden perusteella. @rfc8825

WebRTC käyttää yhteyden parametrien neuvottelussa SDP:tä (Session Description
Protocol), jolla kuvataan istunnon media- ja yhteysasetukset. Yhteyden muodostaminen perustuu
Offer/Answer-malliin, jossa toinen osapuoli muodostaa yhteystarjouksen (offer)
ja toinen vastaa siihen (answer). Istuntokuvaukset sisältävät tietoja
esimerkiksi käytettävistä mediavirroista, koodekeista ja yhteyden muodostamiseen
liittyvistä parametreista. Osapuolet asettavat vastaanotetut kuvaukset
WebRTC-yhteyden etäkuvauksiksi, minkä perusteella yhteyden muodostamista voidaan
jatkaa. @rfc9429

Istuntokuvausten lisäksi signaloinnissa voidaan välittää ICE-ehdokkaita, jotka
kuvaavat mahdollisia verkkoreittejä yhteyden muodostamiseksi. ICE-ehdokkaita
voidaan välittää myös sitä mukaa, kun niitä löydetään. Tätä kutsutaan Trickle
ICE -menetelmäksi. Menetelmä mahdollistaa yhteyden muodostamisen aloittamisen
ennen kaikkien mahdollisten ICE-ehdokkaiden keräämistä. ICE-mekanismia ja sen
yhteyttä NAT-läpäisyyn käsitellään tarkemmin luvussa
@teoria-nat-webrtc-kappale. @rfc8838

Signalointi voidaan toteuttaa esimerkiksi WebSocket-yhteydellä, joka
mahdollistaa kaksisuuntaisen viestinvälityksen verkkoselaimen ja palvelimen
välillä. Signalointikanavan tehtävänä on välittää yhteyden muodostamiseen ja
hallintaan liittyviä viestejä, eikä varsinaista ääni- tai videoliikennettä
siirretä sen kautta. WebRTC:n mediayhteys muodostetaan erikseen signaloinnin
avulla vaihdettujen tietojen perusteella. @rfc6455 @rfc8825

== WebRTC-videopuhelujärjestelmien arkkitehtuurit <teoria-arkkitehtuurit>

WebRTC-pohjaiset videopuhelujärjestelmät voidaan toteuttaa useilla erilaisilla
arkkitehtuureilla. Arkkitehtuurivalinta vaikuttaa muun muassa järjestelmän
skaalautuvuuteen, palvelinkuormaan, kaistanleveyden käyttöön sekä viiveeseen.
Yleisimmät toteutusmallit ovat P2P-, MCU- ja SFU-arkkitehtuurit @rfc7667.
Tässä luvussa esitellään näiden arkkitehtuurien toimintaperiaatteet sekä niiden
keskeiset ominaisuudet.

=== Vertaisyhteys

P2P-arkkitehtuurissa jokainen osallistuja muodostaa WebRTC-yhteyden muihin osallistujiin ilman keskitettyä median käsittelystä vastaavaa palvelinta. Tavallisesti ääni- ja videodata siirtyvät suoraan päätelaitteiden välillä. NAT- tai palomuuriympäristössä media voidaan kuitenkin välittää TURN-palvelimen kautta, mikäli suoraa yhteysreittiä ei saada muodostettua. Signalointiin tarvitaan yleensä erillinen palvelu, jonka avulla osapuolet vaihtavat yhteyden muodostamiseen tarvittavat tiedot. @rfc8825, @rfc8656

P2P-arkkitehtuuri soveltuu erityisesti kahden osallistujan välisiin videopuheluihin, sillä
se minimoi palvelinkuorman ja mahdollistaa pienen viiveen @rfc7667.
Useamman osallistujan videopuheluissa P2P-arkkitehtuurin heikkoutena on
yhteyksien määrän nopea kasvu. Jokaisen osallistujan on ylläpidettävä
erillinen WebRTC-yhteys jokaiseen muuhun osallistujaan, mikä kasvattaa sekä
päätelaitteen laskentakuormaa että käytettävän kaistanleveyden määrää.

=== Multipoint Control Unit

MCU-arkkitehtuurissa kaikki osallistujat lähettävät media-aineistonsa
keskitetylle palvelimelle. Palvelin vastaanottaa videovirrat, dekoodaa ne,
yhdistää ne yhdeksi mediavirraksi ja koodaa lopputuloksen uudelleen ennen sen
lähettämistä takaisin osallistujille @rfc7667.

MCU-ratkaisun etuna on, että asiakas vastaanottaa vain yhden mediavirran, mikä
vähentää päätelaitteen kuormitusta. Haittapuolena on palvelimen suuri
laskentatarve, sillä mediavirran uudelleenkoodaus lisää sekä
prosessointikuormaa että viivettä.

=== Selective Forwarding Unit

SFU-arkkitehtuurissa jokainen osallistuja lähettää videovirtansa palvelimelle,
joka välittää vastaanotetut mediavirrat edelleen valituille vastaanottajille
ilman niiden dekoodaamista tai uudelleenkoodaamista @rfc7667.

Koska mediaa ei käsitellä uudelleen, SFU tarjoaa hyvän kompromissin
palvelinkuorman, viiveen ja skaalautuvuuden välillä. Lisäksi palvelimen
laskentakuorma on huomattavasti pienempi kuin MCU-arkkitehtuurissa, mikä tekee
SFU:sta hyvin soveltuvan usean osallistujan WebRTC-pohjaisiin
videoneuvottelujärjestelmiin @grozev2015.

Tässä työssä valittiin SFU-arkkitehtuuri, koska se mahdollistaa usean
osallistujan videopuhelut ilman median uudelleenkoodausta ja säilyttää samalla
pienen viiveen. Työssä käytettävä Janus Gateway toteuttaa tämän toimintamallin,
minkä vuoksi se soveltuu hyvin työn toteutusalustaksi. Janus Gatewayn rakennetta
ja toimintaa käsitellään tarkemmin luvussa @teoria-janus-kappale. @taulukko-videopuheluarkkitehtuurit vertailee P2P-, MCU- ja SFU-arkkitehtuurien keskeisiä ominaisuuksia lähteiden @rfc7667 ja @grozev2015 perusteella.

#figure(
  [
    #set par(justify: false)
    #set text(hyphenate: true)
    #table(
    columns: (2.4fr, 1.5fr, 1.5fr, 1.5fr),

    inset: 6pt,
    stroke: 0.5pt,

    align: left + horizon,

    table.header(
      [*Ominaisuus*],
      [*P2P*],
      [*MCU*],
      [*SFU*],
    ),

    [Median välitys],
    [Suoraan osallistujien välillä],
    [Palvelin yhdistää mediavirrat],
    [Palvelin välittää mediavirrat],

    [Mediapalvelimen kuormitus],
    [Ei mediapalvelinta],
    [Suuri median käsittelyn vuoksi],
    [Pienempi kuin MCU:ssa],

    [Päätelaitteen kuormitus],
    [Kasvaa osallistujamäärän mukana],
    [Pienempi, koska vastaanotetaan yhdistetty mediavirta],
    [Kasvaa vastaanotettavien virtojen mukana],

    [Skaalautuvuus],
    [Heikkenee osallistujamäärän kasvaessa],
    [Riippuu palvelimen mediankäsittelykapasiteetista],
    [Soveltuu usean osallistujan mediavirtojen välittämiseen],

    [Viive],
    [Ei palvelimen mediankäsittelyn aiheuttamaa lisäviivettä],
    [Kasvaa median käsittelyn vuoksi],
    [Ei median uudelleenkoodauksen aiheuttamaa lisäviivettä],

    [Median uudelleenkoodaus],
    [Ei],
    [Kyllä],
    [Ei],
    )
  ],
  caption: [P2P-, MCU- ja SFU-arkkitehtuurien yleispiirteinen vertailu.]
) <taulukko-videopuheluarkkitehtuurit>

== Janus WebRTC Gateway <teoria-janus-kappale>

Janus WebRTC Gateway on yleiskäyttöinen WebRTC-palvelin, jonka tarkoituksena on
mahdollistaa WebRTC-mediayhteyksien muodostaminen selainten ja palvelinpuolen
sovelluslogiikan välille. Januksen core vastaa WebRTC-yhteyksien hallinnasta,
selainten kanssa käytävästä JSON-pohjaisesta viestinnästä sekä reaaliaikaisen
median välittämisestä. Janus ei itsessään toteuta tiettyä
sovellustoiminnallisuutta, vaan sovelluskohtaiset ominaisuudet toteutetaan
palvelinpuolen plugineilla @janus-documentation.

Januksen arkkitehtuuri perustuu core-komponentin ja pluginien väliseen
työnjakoon. Core hallitsee muun muassa WebRTC-yhteyksiä ja välittää viestit sekä
median asiakkaiden ja niihin liitettyjen pluginien välillä. Pluginit puolestaan
toteuttavat sovelluskohtaisen toiminnallisuuden. Januksen dokumentaatiossa
mainitaan esimerkkeinä muun muassa konferenssisillat, median tallennus ja
SIP-yhdyskäytävä. Plugin-rajapinnan avulla myös uusia plugineja voidaan toteuttaa
Januksen yhteyteen @janus-core @janus-plugin-api.

Janus tarjoaa useita tapoja kommunikoida sovelluksen ja palvelimen välillä.
Dokumentaatiossa tuettuina rajapintoina mainitaan muun muassa HTTP- ja
WebSocket-yhteydet sekä muita kuljetusmekanismeja. Sovellus voi luoda Janukseen
session ja liittää siihen plugin-handleja, joiden kautta pluginille voidaan
lähettää sovelluskohtaisia viestejä ja joiden yhteydessä voidaan neuvotella
WebRTC-yhteyksiä @janus-api.

Tässä työssä Janusta hyödynnetään SFU-arkkitehtuurin toteuttamiseen
VideoRoom-pluginin avulla. Januksen dokumentaatio määrittelee VideoRoom-pluginin
videoneuvotteluihin tarkoitetuksi SFU:ksi, joka toimii ääni- ja videoreitittimenä.
Plugin perustuu julkaisija-tilaaja-malliin, jossa osallistuja voi julkaista oman
ääni- tai videovirtansa huoneeseen ja muut osallistujat voivat tilata julkaistuja
mediavirtoja @janus-videoroom.

VideoRoom-pluginissa osallistujan julkaisema media muodostaa muiden osallistujien
tilattavissa olevan streamin. Tilaaja muodostaa WebRTC-yhteyden, jonka kautta
Janus voi aloittaa tilattujen mediavirtojen välittämisen vastaanottajalle.
Pluginin dokumentaation mukaan Janus ei sekoita tai uudelleenkoodaa näitä
mediavirtoja, vaan välittää ne vastaanottajille, minkä vuoksi VideoRoom toimii
SFU-arkkitehtuurin mukaisesti @janus-videoroom.

Työssä toteutettava videopuhelu hyödyntää tätä VideoRoom-pluginin toimintamallia.
React-pohjainen käyttöliittymä toimii Januksen asiakkaana ja hallitsee
videopuhelun käyttöliittymän sekä osallistujien julkaisemien ja tilattujen
mediavirtojen käsittelyn. Janus puolestaan vastaa WebRTC-yhteyksien ja
mediavirtojen välityksestä VideoRoom-pluginin kautta. Tämän työn toteutuksessa
Janus muodostaa siten järjestelmän mediasiirtokerroksen, kun taas sovelluksen muu
logiikka toteutetaan Januksen ulkopuolella.

== NAT-läpäisy WebRTC:ssä <teoria-nat-webrtc-kappale>

Verkkolaitteet sijaitsevat usein yksityisessä verkossa, jossa niiden käyttämät
IP-osoitteet eivät ole suoraan saavutettavissa Internetistä. NAT mahdollistaa
useiden yksityisessä verkossa olevien laitteiden Internet-yhteyksien jakamisen
yhden tai useamman julkisen IP-osoitteen kautta. NAT vaikeuttaa kuitenkin
vertaisyhteyksien muodostamista, koska toinen osapuoli ei välttämättä pysty
suoraan tavoittamaan toisen osapuolen yksityisessä verkossa sijaitsevaa
päätelaitetta. @rfc2663

WebRTC käyttää NAT-läpäisyyn ICE-mekanismia. ICE:n tarkoituksena on selvittää
päätelaitteiden käytettävissä olevat yhteysosoitteet ja löytää niiden välille
toimiva yhteysreitti. Yhteydenmuodostuksessa voidaan hyödyntää suoraa yhteyttä
sekä tarvittaessa STUN- ja TURN-palveluita @rfc8445 @rfc8835.

Tässä luvussa käsitellään NAT-läpäisyn kannalta keskeisiä ICE-, STUN- ja
TURN-mekanismeja. Näiden mekanismien toimintaa tarkastellaan tässä luvussa
yleisellä tasolla, ja niiden roolia työn toteutuksessa käsitellään tarkemmin
myöhemmissä luvuissa.

=== Interactive Connectivity Establishment

ICE perustuu siihen, että päätelaitteet keräävät useita mahdollisia
yhteysosoitteita eli ehdokkaita (ICE candidates). Ehdokkaat voivat olla
päätelaitteen omia verkko-osoitteita, NAT-laitteen kautta näkyviä julkisia
osoitteita tai TURN-palvelimen tarjoamia välitettyjä osoitteita. Päätelaitteet
vaihtavat ehdokkaat signaloinnin avulla ja suorittavat niiden muodostamille
ehdokaspareille yhteystarkistuksia. Tarkistusten perusteella valitaan toimiva
yhteysreitti @rfc8445.

ICE ei itsessään määrittele signalointia, vaan olettaa, että osapuolet pystyvät
vaihtamaan yhteyden muodostamiseen tarvittavat tiedot jonkin muun mekanismin
avulla. Signalointia voidaan käyttää esimerkiksi ICE-ehdokkaiden välittämiseen
osapuolten välillä @rfc8445.

=== Session Traversal Utilities for NAT

STUN on protokolla, jonka avulla päätelaite voi selvittää NAT-laitteen sille
määrittämän julkisen IP-osoitteen ja portin. Tätä tietoa voidaan käyttää ICE:n
yhteydessä niin sanotun server-reflexive-ehdokkaan muodostamiseen. STUN-palvelin
ei kuitenkaan välitä varsinaista mediaa osapuolten välillä, vaan sitä käytetään
erityisesti päätelaitteen server-reflexive-yhteysosoitteen selvittämiseen
@rfc8489.

STUN ei yksinään ratkaise NAT-läpäisyä kaikissa verkkotilanteissa. Jos
päätelaitteiden välille ei saada muodostettua toimivaa suoraa yhteyttä,
ICE voi hyödyntää TURN-palvelinta @rfc8489 @rfc8445.

=== Traversal Using Relays around NAT

TURN tarjoaa välityspalvelun tilanteisiin, joissa päätelaitteiden välistä suoraa
yhteyttä ei voida muodostaa. Päätelaite varaa TURN-palvelimelta osoitteen, jonka
kautta liikenne voidaan välittää toiselle osapuolelle. TURN tarjoaa siten ICE:n
yhteydessä välitetyn yhteysreitin tilanteisiin, joissa suora yhteys ei ole
käyttökelpoinen @rfc8656.

TURN-yhteyden etuna on sen toimivuus myös sellaisissa verkkotilanteissa,
joissa NAT- tai palomuuriasetukset estävät suoran yhteyden. Haittapuolena on,
että media kulkee tällöin ylimääräisen palvelimen kautta, mikä lisää
palvelimen kaistanleveyden tarvetta ja voi kasvattaa yhteyden viivettä
@rfc8656.

WebRTC:n yhteydenmuodostus voidaan siten kuvata prosessina, jossa ICE pyrkii
löytämään toimivan yhteysreitin käytettävissä olevien ehdokkaiden joukosta.
STUN mahdollistaa NATin takaa näkyvän julkisen osoitteen selvittämisen, kun taas
TURN tarjoaa välitetyn yhteysreitin tilanteissa, joissa suora yhteys ei
onnistu. Näiden mekanismien avulla WebRTC-yhteys voidaan muodostaa erilaisista
verkkorakenteista ja NAT-asetuksista huolimatta @rfc8445.

#figure(
  alt: "Kaavio esittää kaksi WebRTC-päätelaitetta, jotka ovat erillisten NAT-laitteiden takana. NAT-laitteiden välillä voidaan muodostaa suora kaksisuuntainen yhteys. Molemmat päätelaitteet käyttävät STUN-palvelinta julkisen osoitteen selvittämiseen. Jos suora yhteys ei onnistu, liikenne voidaan välittää kaksisuuntaisesti TURN-palvelimen kautta; välitetty yhteys on kuvattu katkoviivalla.",
  cetz.canvas({
    import cetz.draw: *

    //=========================================================
    // WebRTC-päätelaitteet
    //=========================================================
    rect((0, 5.5), (3.8, 6.5))
    content(
      (1.9, 6),
      [WebRTC-päätelaite A],
      align: center,
    )

    rect((8.2, 5.5), (12, 6.5))
    content(
      (10.1, 6),
      [WebRTC-päätelaite B],
      align: center,
    )

    //=========================================================
    // NATit
    //=========================================================
    rect((0.5, 3.8), (3.3, 4.6))
    content((1.9, 4.2), [NAT], align: center)

    rect((8.7, 3.8), (11.5, 4.6))
    content((10.1, 4.2), [NAT], align: center)

    //=========================================================
    // STUN-palvelin
    //=========================================================
    rect((4.2, 1.75), (7.8, 2.75))
    content(
      (6, 2.25),
      [STUN-palvelin],
      align: center,
    )

    //=========================================================
    // TURN-palvelin
    //=========================================================
    rect((4.2, 0), (7.8, 1))
    content(
      (6, 0.5),
      [TURN-palvelin],
      align: center,
    )

    //=========================================================
    // Päätelaitteet -> NAT
    //=========================================================
    line(
      (1.9, 5.5),
      (1.9, 4.6),
    )

    line(
      (10.1, 5.5),
      (10.1, 4.6),
    )

    //=========================================================
    // STUN-yhteydet
    //=========================================================
    line(
      (2.7, 3.8),
      (4.2, 2.25),
      mark: (
        start: "stealth",
        end: "stealth",
      ),
    )

    line(
      (9.3, 3.8),
      (7.8, 2.25),
      mark: (
        start: "stealth",
        end: "stealth",
      ),
    )

    //=========================================================
    // TURN-yhteydet
    //=========================================================
    line(
      (1.9, 3.8),
      (4.2, 0.5),
      stroke: (dash: "dashed"),
      mark: (
        start: "stealth",
        end: "stealth",
      ),
    )

    line(
      (7.8, 0.5),
      (10.1, 3.8),
      stroke: (dash: "dashed"),
      mark: (
        start: "stealth",
        end: "stealth",
      ),
    )

    //=========================================================
    // Suora yhteys NATien välillä
    //=========================================================
    line(
      (3.3, 4.2),
      (8.7, 4.2),
      mark: (
        start: "stealth",
        end: "stealth",
      ),
    )

    //=========================================================
    // Selitteet
    //=========================================================
    content(
      (6, 4.5),
      [Suora yhteys],
      align: center,
    )

    content(
      (6, 1.275),
      [Välitetty yhteys],
      align: center,
    )

    content(
      (6, 3.05),
      [Osoitteen selvitys],
      align: center,
    )
  }),
  caption: [
    STUN- ja TURN-palveluiden rooli WebRTC-yhteyden NAT-läpäisyssä.
  ],
) <kuva-nat-lapaisy>
  
