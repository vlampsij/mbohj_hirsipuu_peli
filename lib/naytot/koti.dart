import 'package:flutter/material.dart';
import '../komponentit/etusivu_napit.dart';
import '../tyokalut/sanat.dart';
import 'peli.dart';
import 'lataa.dart';

class KotiNaytto extends StatefulWidget {
  final HirsipuuSanat hirsipuuSanat = HirsipuuSanat();

  KotiNaytto({super.key});

  @override
  _KotiNayttoState createState() => _KotiNayttoState();
}

class _KotiNayttoState extends State<KotiNaytto> {
  @override
  Widget build(BuildContext context) {
    double naytonPituus = MediaQuery.of(context).size.height;
    widget.hirsipuuSanat.lataaSanat();
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(8.0, 50.0, 8.0, 8.0),
              child: const Text(
                'HIRSIPUU',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 58.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 10.0),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/gallow.png',
              height: naytonPituus*0.5,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 64,
                    child: ToimenpideNappi(
                      napinTeksti: 'Aloita',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PeliNaytto(
                              hirsipuuObjekti: widget.hirsipuuSanat,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox( //nappien väliin tyhjää tilaa
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 64,
                    child: ToimenpideNappi(
                      napinTeksti: 'Huipputulokset',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LatausNaytto(), //menee latausnäyttöön niin kauan että on hakenut huipputulokset
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
