class Piste {
  final int id;
  final String pistePaivays;
  final int pelaajanPisteet;

  Piste({required this.id, required this.pistePaivays, required this.pelaajanPisteet});

  Map<String, dynamic> toMap() {
    return {
      'pistePaivays': pistePaivays,
      'pelaajanPisteet': pelaajanPisteet,
    };
  }

  @override
  String toString() {
    return '$pistePaivays,$pelaajanPisteet,$id';
  }
}