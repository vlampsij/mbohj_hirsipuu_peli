import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PisteNaytto extends StatelessWidget {
  final kysely;

  const PisteNaytto({super.key, this.kysely});

  List<TableRow> luoRivi(var kysely) {
    //lajittelee listan laskevaan järjestykseen merkkijonon perusteella
    kysely.sort((a, b) {
      final int pointsA = a.pelaajanPisteet;
      final int pointsB = b.pelaajanPisteet;
      return pointsB.compareTo(pointsA);
    });



    List<TableRow> rows = [];

    rows.add(
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Center(
              child: Text(
                style: TextStyle(fontSize: 35, color: Colors.grey[400]),
                "Sijoitus",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Center(
              child: Text(
                style: TextStyle(fontSize: 35, color: Colors.grey[400]),
                "Päiväys",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Center(
              child: Text(
                style: TextStyle(fontSize: 35, color: Colors.grey[400]),
                "Pisteet",
              ),
            ),
          ),
        ],
      ),
    );

    int numOfRows = kysely.length;
    List<String> topRanks = ["🥇", "🥈", "🥉"];
    for (var i = 0; i < numOfRows && i < 10; i++) {

      var row = kysely[i].toString().split(",");

      var pistePaivays = DateFormat('dd/MM/yyyy');

      Widget item = TableCell(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 7.0),
          child: Text(
            i < 3 ? '${topRanks[i]}${i + 1}' : '${i + 1}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 35, color: Colors.white),
          ),
        ),
      );
      Widget item1 = TableCell(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              style: const TextStyle(fontSize: 35, color: Colors.white),
              pistePaivays.format(DateTime.parse(row[0])),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
      Widget item2 = TableCell(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            row[1],
            style: const TextStyle(
              fontSize: 45,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      rows.add(
        TableRow(
          children: [item, item1, item2],
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: kysely.length ==
                0 //jos ei ole pisteitä mennään ensimmäiseen valintaan
            ? Stack(
                children: <Widget>[
                  const Center(
                    child: Text(
                      "Ei pisteitä vielä!",
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          letterSpacing: 2),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 15.0),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(MdiIcons.home),
                      iconSize: 35,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        Navigator.pop(context);
                      }, //takaisin äskeiselle sivulle (kotinäyttö)
                    ),
                  ),
                ],
              )
            : Column(
                //jos on pisteitä tehdään rivit ja näytetään ne
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 15.0),
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(MdiIcons.home),
                          iconSize: 35,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          }, //takaisin äskeiselle sivulle (kotinäyttö)
                        ),
                      ),
                      Center(
                        child: Container(
                          margin:
                              const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 15.0),
                          child: const Text(
                            'Huipputulokset',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 45.0,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        textBaseline: TextBaseline.alphabetic,
                        children: luoRivi(kysely),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
