import 'package:flutter/material.dart';
import '../tyokalut/pisteet_DB.dart' as piste_db;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'pisteet.dart';

class LatausNaytto extends StatefulWidget {
  const LatausNaytto({super.key});

  @override
  LatausNayttoState createState() => LatausNayttoState();
}

class LatausNayttoState extends State<LatausNaytto> {
  @override
  void initState() {
    super.initState();
    pisteetKysely();
  }

  void pisteetKysely() async {
    final database = piste_db.openDB();
    var kyselyTulos = await piste_db.pisteet(database);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PisteNaytto(
            kysely: kyselyTulos,//kun hakenut tulokset siirrytään pistesivulle
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitFadingCube(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
