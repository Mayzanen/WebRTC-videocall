/** 03_kaytettavyys.typ
 *
 * This is an example introdution in a multi-file Typst project.
 *
***/

#pdf.attach(
  "03_kaytettavyys.typ",
  relationship: "source",
  mime-type: "text/vnd.typst",
  description: "The Typst source code for the usability and accessibility chapter 3 of this thesis.",
)

#import "../preamble.typ": *

= Saavutettavuus verkkosovelluksissa <saavutettavuus-kappale>

Verkkosovellusten saavutettavuudella tarkoitetaan sitä, että sovellukset ovat mahdollisimman monen käyttäjän käytettävissä riippumatta käyttäjän toimintakyvystä tai tavasta, jolla sovellusta käytetään. Saavutettavuudessa huomioidaan esimerkiksi erilaiset näkemiseen, kuulemiseen, liikkumiseen ja kognitiivisiin toimintoihin liittyvät tarpeet. Saavutettavuus ei siten rajoitu yksittäisiin käyttöliittymän ominaisuuksiin, vaan se koskee sovelluksen rakennetta, sisältöä ja toimintaa kokonaisuutena. @wcag21

Verkkosovellusten saavutettavuus voidaan huomioida jo sovelluksen suunnitteluvaiheessa, jolloin käyttöliittymän rakenteeseen ja vuorovaikutukseen liittyvät ratkaisut voidaan toteuttaa saavutettavuutta tukevalla tavalla. Saavutettavuuden toteutumista voidaan arvioida saavutettavuusohjeistusten avulla. Tässä työssä saavutettavuutta tarkastellaan erityisesti verkkosovellusten näkökulmasta ja WCAG-ohjeistuksen perusteella. Seuraavissa alaluvuissa käsitellään saavutettavuuden merkitystä, WCAG-ohjeistusta sekä saavutettavuuden huomioimista videopuhelusovelluksen käyttöliittymässä.

== Saavutettavuuden merkitys <saavutettavuus-merkitys-kappale>

Saavutettavuudella on merkittävä rooli verkkosovellusten suunnittelussa, sillä saavutettavuuden puutteet voivat rajoittaa käyttäjien mahdollisuuksia käyttää sovelluksen tarjoamia palveluita. Saavutettavuuden huomioiminen edistää käyttäjien yhdenvertaisia mahdollisuuksia käyttää digitaalisia palveluita ja vähentää tilanteita, joissa käyttäjän toimintakyky tai käyttötapa muodostuu esteeksi sovelluksen käytölle. Verkkosaavutettavuus ei myöskään hyödytä ainoastaan käyttäjiä, joilla on pysyviä toimintarajoitteita, vaan saavutettavasta suunnittelusta voivat hyötyä kaikki käyttäjät erilaisissa tilanteissa. Esimerkiksi erilaiset käyttöympäristöt, päätelaitteet ja tilapäiset toimintarajoitteet voivat vaikuttaa siihen, miten käyttäjä pystyy käyttämään verkkopalvelua. @w3c-accessibility

Saavutettavuuden merkitys näkyy myös lainsäädännössä. Euroopan unionin saavutettavuusdirektiivi (EU) 2016/2102 koskee julkisen sektorin elinten verkkosivustojen ja mobiilisovellusten saavutettavuutta. Suomessa direktiivi on pantu täytäntöön lailla digitaalisten palvelujen tarjoamisesta (306/2019), jäljempänä digipalvelulaki. Lain tarkoituksena on muun muassa parantaa jokaisen mahdollisuuksia käyttää digitaalisia palveluja yhdenvertaisesti. @saavutettavuusdirektiivi @digipalvelulaki

Digipalvelulain 7 §:ssä saavutettavuusvaatimukset kohdistuvat digitaalisten palvelujen sisältöjen havaittavuuteen ja ymmärrettävyyteen sekä käyttöliittymien ja navigoinnin hallittavuuteen ja toimintavarmuuteen. Saavutettavuus on siten otettava huomioon käyttöliittymän suunnittelussa ja toteutuksessa kokonaisuutena, eikä sitä voida tarkastella ainoastaan yksittäisten käyttöliittymäelementtien ominaisuutena. @digipalvelulaki

Videopuhelusovelluksessa saavutettavuus on erityisen tärkeää, koska sovelluksen keskeinen tarkoitus on mahdollistaa reaaliaikainen viestintä käyttäjien välillä. Käyttöliittymän saavutettavuus vaikuttaa tällöin suoraan käyttäjän mahdollisuuteen osallistua videopuheluun, hallita puhelun toimintoja ja havaita sovelluksen välittämä tieto. Tässä työssä verkkosovellusten saavutettavuutta tarkastellaan erityisesti WCAG 2.1 -ohjeistuksen perusteella.


== WCAG-ohjeistus <saavutettavuus-wcag-kappale>

Web Content Accessibility Guidelines (WCAG) on World Wide Web Consortiumin (W3C) laatima verkkosisällön saavutettavuutta koskeva ohjeistus. WCAG sisältää suosituksia, joiden avulla verkkosisällöstä ja verkkosovelluksista voidaan tehdä saavutettavampia erilaisille käyttäjille ja erilaisilla päätelaitteilla. Ohjeistus perustuu neljään periaatteeseen: verkkosisällön tulee olla havaittavaa, hallittavaa, ymmärrettävää ja toimintavarmaa. Näiden periaatteiden alle sijoittuu tarkempia ohjeita ja testattavia onnistumiskriteerejä, joille on määritelty vaatimustasot A, AA ja AAA. @wcag21

WCAG-ohjeistuksesta on julkaistu useita versioita. WCAG 2.0 julkaistiin vuonna 2008, WCAG 2.1 vuonna 2018 ja WCAG 2.2 vuonna 2023. Uudemmat versiot ovat taaksepäin yhteensopivia aiempien versioiden kanssa, ja ne laajentavat ohjeistusta lisäämällä uusia onnistumiskriteerejä. WCAG 2.2 ei siten korvaa WCAG 2.1 -ohjeistusta, vaan molemmat ovat edelleen W3C:n suosituksia. @wcag-overview

Tässä työssä tarkastelun kohteena on WCAG 2.1. Versio laajensi WCAG 2.0 -ohjeistusta erityisesti mobiililaitteiden, heikon näön sekä kognitiivisten ja oppimisvaikeuksien näkökulmasta. WCAG 2.1 sisältää 17 uutta onnistumiskriteeriä, jotka liittyvät esimerkiksi sisällön uudelleenjärjestymiseen pienillä näytöillä, ei-tekstimuotoisten käyttöliittymäelementtien kontrastiin, osoitinlaitteiden käyttöön ja käyttöliittymän tilaviestien välittämiseen. @wcag21

WCAG 2.1:n onnistumiskriteerit on jaettu kolmeen vaatimustasoon: A, AA ja AAA. Taso A sisältää saavutettavuuden kannalta perustavanlaatuisia vaatimuksia, kun taas tasot AA ja AAA sisältävät niitä täydentäviä vaatimuksia. Tässä työssä saavutettavuutta tarkastellaan erityisesti WCAG 2.1:n A- ja AA-tasojen vaatimusten näkökulmasta, sillä ne muodostavat keskeisen perustan verkkosovellusten saavutettavuuden arvioinnille.

== Saavutettavuuden huomioiminen videopuhelusovelluksissa <saavutettavuus-videopuhelut-kappale>

Videopuhelusovelluksen saavutettavuudessa on huomioitava käyttöliittymän lisäksi reaaliaikaiseen ääni- ja videoviestintään liittyvät erityispiirteet. Käyttäjän tulee pystyä havaitsemaan sovelluksen välittämä tieto sekä käyttämään puhelun keskeisiä toimintoja riippumatta siitä, millä tavalla hän käyttää käyttöliittymää. Tämä korostaa erityisesti käyttöliittymän havaittavuutta, hallittavuutta ja ymmärrettävyyttä.

Käyttöliittymän hallittavuuden kannalta keskeistä on, että puhelun toimintoja voidaan käyttää näppäimistöllä (2.1.1 Keyboard) ja että käyttöliittymän kohdistuksen sijainti on käyttäjälle havaittavissa (2.4.7 Focus Visible). Puhelun aikana käyttäjän tulee esimerkiksi pystyä hallitsemaan mikrofonia ja kameraa sekä lopettamaan puhelu ilman riippuvuutta yksittäisestä osoitinlaitteesta. Käyttöliittymäelementtien nimen ja tarkoituksen tulee lisäksi olla ohjelmallisesti määritettävissä, jotta ne ovat avustavan teknologian tulkittavissa (4.1.2 Name, Role, Value). @wcag21

Havaittavuuteen liittyvät muun muassa värin käyttö ja käyttöliittymäelementtien riittävä kontrasti. Tietoa ei tule välittää ainoastaan värin avulla (1.4.1 Use of Color), ja tekstin sekä sen taustan välisen kontrastin tulee täyttää asetetut vähimmäisvaatimukset (1.4.3 Contrast (Minimum)). Myös käyttöliittymäkomponenttien ja graafisten objektien kontrastille on määritelty erilliset vaatimukset (1.4.11 Non-text Contrast). Videopuhelusovelluksessa esimerkiksi mikrofonin tai kameran tila ei siten saisi olla pääteltävissä ainoastaan käyttöliittymäelementin väristä. Lisäksi käyttöliittymän tulee mukautua erilaisiin näyttökokoihin ja suurennettuun tekstikokoon siten, että sen keskeiset toiminnot säilyvät käytettävissä (1.4.4 Resize Text, 1.4.10 Reflow). @wcag21

Videopuhelun aikana tapahtuvista tilamuutoksista tulee välittää käyttäjälle riittävä tieto. Esimerkiksi mikrofonin mykistyminen, kameran käynnistyminen tai yhteyden muodostuminen voivat tapahtua ilman, että käyttäjä siirtyy uuteen käyttöliittymän osaan. Tällaiset muutokset tulee välittää tavalla, jonka myös avustavaa teknologiaa käyttävä käyttäjä voi havaita. WCAG 2.1 sisältää tätä varten tilaviestien välittämistä koskevan onnistumiskriteerin 4.1.3 Status Messages. @wcag21

Tässä työssä teoriaosassa esitellään videopuhelusovelluksen kannalta keskeisiä WCAG 2.1:n A- ja AA-tasojen onnistumiskriteerejä. Varsinainen arviointi rajataan luvussa @suunnittelu-maarittely-kappale määriteltyihin saavutettavuusvaatimuksiin A1–A6. Näin esimerkiksi kohdistuksen havaittavuutta, ei-tekstimuotoisten elementtien kontrastia, sisällön uudelleenjärjestymistä ja tilaviestien välittämistä käsitellään teoreettisina näkökulmina, mutta niitä ei arvioida tässä työssä erillisinä testattavina vaatimuksina.
