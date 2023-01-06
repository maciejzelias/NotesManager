class Note {
  final int? id;
  final String nazwa;
  final String data;
  final String? tresc;
  int stan;

  Note(
      {required this.id,
      required this.nazwa,
      required this.data,
      this.tresc,
      required this.stan});

  factory Note.fromMap(Map<String, dynamic> json) => Note(
        id: json['id'],
        nazwa: json['nazwa'],
        data: json['data'],
        tresc: json['tresc'],
        stan: json['stan'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nazwa': nazwa,
      'data': data,
      'tresc': tresc,
      'stan': stan
    };
  }

  @override
  String toString() {
    return 'Note{id : $id, nazwa: $nazwa, data: $data, tresc: $tresc, stan: $stan}';
  }
}
