import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../komponentit/sana_nappi.dart';
import '../naytot/koti.dart';
import '../tyokalut/tyylit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../tyokalut/pisteet_DB.dart' as piste_db;
import '../tyokalut/pelaajan_pisteet.dart';
import '../tyokalut/sanat.dart';

class Aakkoset {
  String aakkoset = 'abcdefghijklmnopqrstuvwxyzåäö';
}

class PeliNaytto extends StatefulWidget {
  const PeliNaytto({super.key, required this.hirsipuuObjekti});

  final HirsipuuSanat hirsipuuObjekti;

  @override
  State<PeliNaytto> createState() => _PeliNayttoState();
}

class _PeliNayttoState extends State<PeliNaytto> {
  final db = piste_db.openDB();
  int elamat = 5;
  Aakkoset suomiAakkoset = Aakkoset();
  late String sana;
  late String piiloitettuSana;
  List<String> sanaLista = [];
  List<int> vihjeKirjaimet = [];
  late List<bool> buttonStatus;
  late bool vihjeTila;
  int hirttoTila = 0;
  int sanojaOikein = 0;
  bool peliLoppu = false;
  bool nollaaPeli = false;

  @override
  void initState() {
    super.initState();
    alustaSanat();
  }

  @override
  Widget build(BuildContext context) {
    if (nollaaPeli) { //katsoo onko nollaa peli true ja alustaa sanat jos on
      setState(() {
        alustaSanat();
      });
    }
    // palauttaa näkymä column
    return PopScope( //popscope antaa pelaajan puhelimella painaa puhelimen omaa takaisin nappia,
                     // vaikka on kotinapit pelissä, tää oli itelle vaa nii hyvä löytö et oli pakko käyttää
      canPop: true,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    ylaRivi(), // Aseta ylärivi näytölle.
                    hirsipuuKuvat(), // Aseta hirsipuukuvat näytölle.
                    piiloitettuSanaPaikka(), // Aseta piilotettu sana paikalleen näytölle.
                  ],
                ),
              ),
              kirjainNapit(), // Aseta kirjainnapit näytölle.
            ],
          ),
        ),
      ),
    );
  }
  void uusiPeli() { //kun peli on hävitty ja elämiä ei ole jäljellä
    setState(() {
      hirttoTila = 0;
      elamat = 5;
      sanojaOikein = 0;
      peliLoppu = false;
      nollaaPeli = false;
      alustaSanat();
    });
  }
//tekee ylärivin tyylin ja asettaa sinne toiset widgetit ja tyylit ja ns logiikka
  Widget ylaRivi() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6.0, 8.0, 10.0, 35.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          elamaKuvaTeksti(), //asetetaan elämä kuva ja teksti yläriviin
          pisteTeksti(), //asetetaan pisteet yläriviin
          vihjeKuva(), //ja vihje kuva yläriviin
        ],
      ),
    );
  }

  Widget elamaKuvaTeksti() { //sydänkuva ja elämät ylänurkassa logiikka
    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 0.5),
              child: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                iconSize: 39,
                icon: Icon(MdiIcons.heart),
                onPressed: (){},
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8.7, 7.9, 0, 0),
              alignment: Alignment.center,
              child: SizedBox(
                height: 38,
                width: 38,
                child: Center(
                  child: Text(
                    elamat.toString() == "1" ? "1" : elamat.toString(),
                    style: const TextStyle(
                      color: Color(0xFF2C1E68),
                      fontSize: 25.9,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: SizedBox(
                child: IconButton(
                  icon: Icon(MdiIcons.home),
                  iconSize: 35,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget pisteTeksti() { //keskellä näyttöä näkyvät pisteet logiikka
    return Container(
      padding: const EdgeInsets.only(right: 35),
      child: Text(
        sanojaOikein == 1 ? "1" : '$sanojaOikein',
        style: const TextStyle(
          fontSize: 29.5,
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget vihjeKuva() { //lampun kuva vasenylä nurkassa, ja logiikka siihen
    return SizedBox(
      child: IconButton(
        iconSize: 39,
        icon: Icon(MdiIcons.lightbulb),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: vihjeTila
            ? () {
                int rand = Random().nextInt(vihjeKirjaimet.length);
                wordPress(suomiAakkoset.aakkoset
                    .indexOf(sanaLista[vihjeKirjaimet[rand]]));
                vihjeTila = false;
                //jos vihje tila on true se antaa yhden kirjaimen vihjeen
                // ja sitten on poissa käytöstä seuraavaan kierroseen
              }
            : null,
      ),
    );
  }

  Widget hirsipuuKuvat() { //hirttotilan kuva ja tyyli
    return Expanded(
      flex: 6,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.asset(
            'assets/$hirttoTila.png',
            height: 1001,
            width: 991,
            gaplessPlayback: true,
          ),
        ),
      ),
    );
  }

  Widget piiloitettuSanaPaikka() { //tyyli johon sana tulee viivoina esille
    return Expanded(
      flex: 5,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35.0),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 57,
              letterSpacing: 8,
              color: Colors.white,
              fontFamily: GoogleFonts.creepster().fontFamily,
            ),
            child: !piiloitettuSana.contains('_')
                ? TekstiAnimaatioInOut(text: piiloitettuSana,)
                : Text(piiloitettuSana),
          ),
        ),
      ),
    );
  }

  Widget kirjainNapit() { //jokaisen kirjaimen napin tyyli
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 2.0, 8.0, 10.0),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: List.generate(4, (rowIndex) { //tekee neljä riviä
          return TableRow(
            children: List.generate(8, (colIndex) {// luo listan tablecell-widgeteistä, ja tekee 8 kertaa sarakkeiden määrän perusteella
              final nappiIndeksi = rowIndex * 8 + colIndex; // laskee napeille indexin käyttäen rowIndex ja colIndex
              return TableCell(
                // sitten palautetaan TableCell-widget käyttäen kirjainNapitToiminta-funktiota
                child: kirjainNapitToiminta(nappiIndeksi),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget kirjainNapitToiminta(int index) {
    if (index >= 0 && index < suomiAakkoset.aakkoset.length) {// tarkistaa onko index sallitulla välillä, eli 0 - aakkosien määrä
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 6.0),
        child: Center(
          child: KirjainNappi(
            // luo KirjainNappi-widgetin annetulla kirjaimella ja painiketilanteeseen liittyvällä toiminnolla
            buttonTitle: suomiAakkoset.aakkoset[index].toUpperCase(),
            onPress: buttonStatus[index] ? () => wordPress(index) : () {}, // wordpress funktiota käyttäen napin indexin mukaan buttonstatus on false, ja kirjainta ei voi uudelleen käyttää
          ),
        ),
      );
    } else {
      // jos index ei ole sallitulla välillä, palautetaan tyhjä Container
      return Container();
    }
  }

  // pelin logiikkaa

  void alustaSanat() { // esim kun aloitetaan peli käytetään alustaSanat kerran
    setState(() {
      peliLoppu = false; //peli on käynnissä
      nollaaPeli = false; //ei nollata peliä
      vihjeTila = true; //vihjeen voi käyttää pelin alussa
      hirttoTila = 0; //ja hirttotila on aina 0 kun uusi kierros aloitetaan
      suomiAakkoset = Aakkoset();

      // luo listan `buttonStatus`, joka seuraa kirjainten painikkeiden tilaa.
      // alustaa kaikki painikkeet tilan aktiiviseksi tai true
      buttonStatus = List.generate(suomiAakkoset.aakkoset.length, (index) {
        return true;
      });

      // tyhjentää sanaLista ja vihjeKirjaimet listat.
      sanaLista = [];
      vihjeKirjaimet = [];
      sana = widget.hirsipuuObjekti.haeSana(); // hakee sanan käyttämällä hirsipuusanat luokan haesana funktiota

      if (sana.isNotEmpty) { //tarkistaa että sana on haettu

        piiloitettuSana = piiloitaSana(sana.length - 1); // jos sana löytyy, luodaan piilotettuSana, jossa jokainen kirjain korvataan alaviivalla,
        // -1 piti laittaa koska muuten tuli yksi alaviiva liikaa
      }
      else {
        takaisinKotiSivulle(); // jos sanaa ei löydy, siirrytään takaisin kotisivulle.
      }

      for (int i = 0; i < sana
          .length; i++) { // lisätään sanan jokainen kirjain sanaListaan ja vihjeKirjaimet-listaan.
        sanaLista.add(sana[i]);
        vihjeKirjaimet.add(i);
      }
    });
  }

  void wordPress(int index) {
    if (elamat == 0) {// tarkistaa, onko elämät loppu, ja jos ovat, siirrytään takaisin kotisivulle
      takaisinKotiSivulle();
    }

    if (peliLoppu) {// jos peli on lopppu asetetaan nollaaPeli=true ja päivitetään näyttö
      setState(() {
        nollaaPeli = true;
      });
      return;
    }

    bool check = false;// alustaa muuttuja check, joka tarkistaa, oliko kirjain oikein arvattu

    setState(() {
      // käy läpi sanaLista ja verrataan jokaista kirjainta painettuun kirjaimeen pelissä
      for (int i = 0; i < sanaLista.length; i++) {
        if (sanaLista[i] == suomiAakkoset.aakkoset[index]) {
          // jos kirjain on oikein, merkitään se oikein arvatuksi
          check = true;
          sanaLista[i] = '';
          piiloitettuSana = piiloitettuSana.replaceFirst(RegExp('_'), sana[i], i);//sitten päivitetään piiloitettuSana ja otetaan arvattu kirjain esille
        }
      }

      for (int i = 0; i < sanaLista.length; i++) {// tämä poistaa vihjeKirjaimet-listasta ne kirjaimet, jotka on jo arvattu
        if (sanaLista[i] == '') {
          vihjeKirjaimet.remove(i);
        }
      }

      if (!check) {// jos ei ole arvattu oikein, hirttotila muuttuu ja uusi osa tulee kuvaan
        hirttoTila += 1;
      }
      buttonStatus[index] = false;// samalla otetaan painettu nappi pois käytöstä

      if (hirttoTila == 8) { //hirttotiloja on 8 ja kun se on maksimissa peli loppu
        peliLoppu = true;
        elamat -= 1;//ja yksi elämä poistuu
        if (elamat < 1) {
          if (sanojaOikein > 0) { //jos elämät loppuu ja sanoja on saatu ainakin yksi oikein lisätään se piste tietokantaan
            Piste piste = Piste(
                id: 1,
                pistePaivays: DateTime.now().toString(),
                pelaajanPisteet: sanojaOikein);
            piste_db.muutaTietokantaa(piste, db);
          }
          naytaAlertti( //joka tapauksessa jos elämät on loppu tulee esiin hävisit alert
              "Hävisit!",
              "Sinun pisteet on: $sanojaOikein",
              [
                teeDialogNappi(
                    () => takaisinKotiSivulle(), MdiIcons.home, Colors.red), //alertin nappi josta pääsee takaisin kotisivulle
                teeDialogNappi(() {
                  uusiPeli(); //ilmoittaa koodille että uusi peli aloitetaan
                  alustaSanat(); //resetoi pelin
                  Navigator.pop(context); //alertin nappi joka menee takaisin peliin
                }, MdiIcons.refresh, Colors.red),
              ],
              alertNapinTyyliHavio, //napin tyyli, tyyli.dart tiedostosta
              AlertType.none);
        }
        else { //else jos elämiä on vielä yli 0, näyttää alertin väärä
          naytaAlertti(
            "Väärin!\n Sana oli:",
              sana, //näyttää oikean sanan uudelleen
              [
                teeDialogNappi(() {
                  alustaSanat(); //resetoi pelin
                  Navigator.pop(context); // ja takaisin jatkamaan peliä
                }, MdiIcons.arrowRightThick, Colors.red),
              ],
              vaaraSanaAlertTyyli,//napin tyyli, tyyli.dart tiedostosta
              AlertType.error);
        }
      }
      buttonStatus[index] = false;
      if (!piiloitettuSana.contains('_')) { //jos kaikki kirjaimet on arvattu oikein peli loppuu
        peliLoppu = true;
        Future.delayed(const Duration(seconds: 5)).then((_) { //ei näytä alerttia heti
          naytaAlertti(
              'Oikein! Sana oli:',
              sana,
              [
                teeDialogNappi(() {
                  Navigator.pop(context);
                  alustaSanat();
                  sanojaOikein += 1;//lisää pisteen
                }, MdiIcons.arrowRightThick, Colors.green),
              ],
              alertNapinTyyliVoitto,//napin tyyli, tyyli.dart tiedostosta
              AlertType.success);
        });
      }
    });
  }

  void naytaAlertti(//alertin funktio, jolle syötetään tarvittavat tiedot jotka näytetään
    String title,
    String description,
    List<DialogButton> buttons,
    AlertStyle style,
    AlertType type,
  ) {
    Alert(
      context: context,
      style: style,
      type: type,
      title: title,
      desc: description,
      buttons: buttons,
    ).show();
  }

  DialogButton teeDialogNappi( //alertissa olevan nappien funktio ja koko
      VoidCallback onPressed, IconData icon, Color color) {
    return DialogButton(
      radius: BorderRadius.circular(10),
      width: 127,
      color: color,
      height: 52,
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 30.0,
      ),
    );
  }

  void takaisinKotiSivulle() {
    //tapahtuma kun painaa nappia jossa käytetään takaisinKotiSivulle()
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => KotiNaytto()),
      ModalRoute.withName('kotiSivu'),
    );
  }

  // piiloitetaan annetun pituisen sanan merkit alaviivoilla ja palauttaa tuloksen
  String piiloitaSana(int wordLength) {
    String piiloitettuSana = ''; //nollataan
    for (int i = 0; i < wordLength; i++) {
      piiloitettuSana += '_';
    }
    return piiloitettuSana;
  }
}
