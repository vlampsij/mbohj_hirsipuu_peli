import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class HirsipuuSanat {
  int wordCounter = 0;

  // käytetyt numerot tallennetaan automaattisesti uniikkeina
  final Set<int> _kaytetytNum = {};

  List<String> _sanat = [];

  Future<void> lataaSanat() async {
    // Lataa sanat tiedostosta
    String fileText = await rootBundle.loadString('sanat/hirsipuu_sanat.txt');
    _sanat = fileText.split('\n');
    // jakaa tiedoston tekstit rivinvaihdoista ja tallenna sanat listalle
  }

  void nollaaSanat() {
    wordCounter = 0;
    _kaytetytNum.clear(); // Nollaa sanat ja käytetyt numerot.
  }

  String haeSana() {
    // Jos kaikki sanat on jo käytetty, palauta tyhjä merkkijono.
    if (wordCounter >= _sanat.length) {
      return '';
    }

    wordCounter++;
    var rand = Random();
    int sanatPituus = _sanat.length; //hakee kuinka monta sanaa on

    int randNum;
    do {
      randNum = rand.nextInt(sanatPituus);//hakee randomin numeron 0 ja sanojen määrän välillä
    }
    while (_kaytetytNum.contains(randNum)); //jatkaa kunnes on numero jota ei ole käytetty

    _kaytetytNum.add(randNum); // lisää käytetty numero joukkoon
    return _sanat[randNum]; // palauttaa randomi sanan
  }
}
