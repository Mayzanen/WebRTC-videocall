/** 01_johdanto.typ
 *
 * This is an example introdution in a multi-file Typst project.
 *
***/

#pdf.attach(
  "01_johdanto.typ",
  relationship: "source",
  mime-type: "text/vnd.typst",
  description: "The Typst source code for the introduction chapter 1 of this thesis.",
)

#import "../preamble.typ": *
#import "@preview/cetz:0.5.2"

= Johdanto <johdanto-kappale>

Tässä diplomityössä suunnitellaan ja toteutetaan selainpohjainen usean käyttäjän videopuhelusovellus WebRTC-teknologiaa hyödyntäen. Työssä tarkastellaan videopuhelusovelluksen toteuttamiseen liittyviä teknisiä ratkaisuja sekä käyttöliittymän saavutettavuutta. Toteutettua järjestelmää arvioidaan sille määriteltyjen toiminnallisten, ei-toiminnallisten ja saavutettavuusvaatimusten perusteella.

Tässä luvussa esitellään työn tausta, tavoitteet ja tutkimusmenetelmä sekä työn keskeiset rajaukset. Luvun lopuksi kuvataan työn rakenne.

== Tausta <johdanto-tausta-kappale>

Videopuhelutoiminto voidaan toteuttaa osaksi verkkosovellusta siten, että käyttäjä voi osallistua puheluun suoraan verkkoselaimella ilman erillisen sovelluksen asentamista. Selainpohjaisen toteutuksen kannalta keskeinen teknologia on WebRTC, joka mahdollistaa reaaliaikaisen äänen, videon ja muun datan välittämisen verkkoselainten ja muiden päätelaitteiden välillä. @webrtc-definition

Videopuhelusovelluksen toteuttaminen edellyttää kuitenkin varsinaisen ääni- ja videokuvan välittämisen lisäksi useiden muiden osa-alueiden huomioimista. Yhteyden muodostamiseen vaikuttavat esimerkiksi osallistujien verkkoympäristöt ja NAT-laitteet. @rfc8445 Usean käyttäjän videopuhelu edellyttää puolestaan tarkoitukseen sopivan media-arkkitehtuurin valintaa. @rfc7667 Lisäksi selainpohjaisen käyttöliittymän tulee tarjota käyttäjälle keinot liittyä videopuheluun sekä hallita kameraa, mikrofonia ja muita puhelun aikaisia toimintoja.

Teknisen toimivuuden lisäksi verkkosovelluksen suunnittelussa ja toteutuksessa on tärkeää huomioida saavutettavuus. Videopuhelusovelluksessa tämä koskee esimerkiksi käyttöliittymän hallintaa näppäimistöllä, toimintojen tunnistettavuutta, riittäviä kontrasteja sekä puhelun aikana tapahtuvien tilamuutosten välittämistä käyttäjälle. Tässä työssä selainpohjaisen videopuhelusovelluksen toteutusta tarkastellaan siten sekä teknisten että saavutettavuuteen liittyvien vaatimusten näkökulmasta. @wcag21

== Tavoitteet ja tutkimusmenetelmä <johdanto-tavoitteet-kappale>

Työn tavoitteena on suunnitella ja toteuttaa selainpohjainen usean käyttäjän videopuhelusovellus WebRTC-teknologiaa hyödyntäen. Toteutukselle määritellään toiminnalliset, ei-toiminnalliset ja saavutettavuuteen liittyvät vaatimukset, joiden toteutumista arvioidaan työn lopuksi. Työn tutkimuskysymykseksi asetetaan:

#emph[
  Miten selainpohjainen usean käyttäjän videopuhelusovellus voidaan toteuttaa WebRTC-teknologialla ja miten toteutus vastaa sille asetettuja toiminnallisia, ei-toiminnallisia ja saavutettavuusvaatimuksia?
]

Työn tutkimusmenetelmänä sovelletaan suunnittelutieteellistä tutkimusta. Suunnittelutieteellisessä tutkimuksessa tutkimusongelmaa lähestytään suunnittelemalla ja toteuttamalla artefakti sekä arvioimalla sen soveltuvuutta määritellyn ongelman ratkaisemiseen. Tietojärjestelmätutkimuksessa artefakti voi olla esimerkiksi toteutettu järjestelmä tai sen osa. @hevner2004

Tässä työssä tutkimuksen artefaktina toimii toteutettava selainpohjainen WebRTC-videopuhelusovellus. Tutkimusprosessi alkaa työn tavoitteiden ja sovellukselle asetettavien vaatimusten määrittelystä. Tämän jälkeen suunnitellaan järjestelmän arkkitehtuuri ja käyttöliittymä sekä toteutetaan sovellus valittujen teknologioiden avulla. Toteutuksen jälkeen järjestelmää testataan ja sen toimintaa arvioidaan suhteessa määriteltyihin toiminnallisiin, ei-toiminnallisiin ja saavutettavuusvaatimuksiin. Työssä sovellettava tutkimusprosessi on esitetty kuvassa @kuva-tutkimusprosessi.

#figure(
  cetz.canvas({
    import cetz.draw: *

    let box-width = 11
    let box-height = 1.5
    let header-height = 0.55
    let gap = 0.6

    let stages = (
      (
        "Ongelman ja tavoitteiden määrittely",
        "Selainpohjaisen videopuhelusovelluksen tavoitteiden määrittely",
      ),
      (
        "Vaatimusten määrittely",
        "Toiminnalliset, ei-toiminnalliset ja saavutettavuusvaatimukset",
      ),
      (
        "Suunnittelu",
        "Arkkitehtuuri ja käyttöliittymä",
      ),
      (
        "Toteutus",
        "React, WebRTC, Janus ja Coturn",
      ),
      (
        "Arviointi",
        "Järjestelmän testaus ja vaatimusten toteutumisen arviointi",
      ),
    )

    for (i, stage) in stages.enumerate() {
      let y = -i * (box-height + gap)

      // Koko laatikko
      rect(
        (0, y),
        (box-width, y + box-height),
      )

      // Otsikon tausta
      rect(
        (0, y + box-height - header-height),
        (box-width, y + box-height),
        fill: luma(220),
      )

      // Otsikko
      content(
        (box-width / 2, y + box-height - header-height / 2),
        stage.at(0),
        align: center,
      )

      // Vaiheen sisältö
      content(
        (box-width / 2, y + (box-height - header-height) / 2),
        stage.at(1),
        align: center,
      )

      // Nuoli seuraavaan vaiheeseen
      if i < stages.len() - 1 {
        line(
          (box-width / 2, y),
          (box-width / 2, y - gap),
          mark: (end: "stealth"),
        )
      }
    }
  }),
  caption: [
    Työssä sovellettava suunnittelutieteellisen tutkimuksen prosessi.
  ],
) <kuva-tutkimusprosessi>

== Rajaukset <johdanto-rajaukset-kappale>

Työ rajataan selainpohjaisen usean käyttäjän videopuhelusovelluksen suunnitteluun, toteutukseen ja arviointiin. Tarkastelu keskittyy videopuhelun toteuttamisen kannalta keskeisiin teknisiin ratkaisuihin sekä käyttöliittymän saavutettavuuteen. Työssä ei toteuteta erillisiä työpöytä- tai mobiilisovelluksia, vaan sovellusta käytetään verkkoselaimen kautta.

Videopuhelusovelluksen toiminnallisuus rajataan videohuoneen luomiseen ja siihen liittymiseen sekä videopuhelun keskeisiin toimintoihin, kuten kameran ja mikrofonin hallintaan. Työssä ei toteuteta esimerkiksi käyttäjätunnuksia, pysyvää käyttäjähallintaa, tekstipohjaista keskustelua, tiedostojen jakamista tai puheluiden tallentamista.

Työssä tarkastellaan järjestelmän toimintaa usean käyttäjän videopuhelussa, mutta järjestelmälle ei tehdä laajamittaista suorituskyky- tai kuormitustestausta. Työssä ei siten määritetä järjestelmän suurinta mahdollista samanaikaista käyttäjämäärää eikä arvioida tuotantoympäristön edellyttämää palvelinkapasiteettia.

Saavutettavuutta tarkastellaan WCAG 2.1 -ohjeistuksen A- ja AA-tason onnistumiskriteerien näkökulmasta siltä osin kuin ne ovat sovellettavissa toteutetun videopuhelusovelluksen käyttöliittymään. Työssä ei tehdä käyttäjätutkimusta tai käytettävyystestausta eri käyttäjäryhmillä, joten saavutettavuuden arviointi perustuu sovelluksen tekniseen tarkasteluun ja määriteltyjen saavutettavuusvaatimusten toteutumisen arviointiin.

== Työn rakenne <johdanto-rakenne-kappale>

Työ koostuu johdannon lisäksi teoreettisten lähtökohtien käsittelystä, järjestelmän suunnittelusta ja toteutuksesta, toteutetun järjestelmän arvioinnista sekä johtopäätöksistä. Työn alussa käsitellään WebRTC-pohjaisten videopuhelujärjestelmien teknistä taustaa. Luvussa esitellään WebRTC-teknologia, videopuhelujärjestelmien keskeiset arkkitehtuurit, Janus WebRTC Gateway sekä WebRTC-yhteyden muodostamiseen liittyvät ICE-, STUN- ja TURN-mekanismit. Tämän jälkeen käsitellään verkkosovellusten saavutettavuutta, WCAG-ohjeistusta sekä saavutettavuuden huomioimista videopuhelusovelluksissa.

Teoreettisten lähtökohtien käsittelyn jälkeen kuvataan toteutettavan järjestelmän suunnittelu. Luvussa määritellään järjestelmälle asetettavat toiminnalliset, ei-toiminnalliset ja saavutettavuusvaatimukset sekä esitellään järjestelmän arkkitehtuuri ja keskeiset suunnitteluratkaisut. Tämän jälkeen käsitellään videopuhelusovelluksen toteutus ja kuvataan, miten suunnitteluvaiheessa määritellyt ratkaisut toteutetaan käytännössä.

Työn lopuksi arvioidaan toteutettua järjestelmää suhteessa sille asetettuihin vaatimuksiin. Arvioinnissa tarkastellaan järjestelmän toiminnallisuutta ja teknistä toimintaa sekä käyttöliittymän saavutettavuutta. Lopuksi esitetään työn johtopäätökset, tarkastellaan työn tavoitteiden toteutumista ja vastataan asetettuun tutkimuskysymykseen.