import 'dart:convert';

class Cardapio {
  int id;
  int escola;
  String nomedaescola;
  String title;
  String imagem;
  bool isativo;
  String createdAt;
  String modifiedAt;

  String nomedaesc;


  Cardapio({
     this.id,
     this.escola,
     this.nomedaescola,
     this.title,
     this.imagem,
     this.isativo,
     this.createdAt,
     this.modifiedAt,
     this.nomedaesc

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'escola': escola,
      'nomedaescola': nomedaescola,

      'title': title,
      'imagem': imagem,
      'isativo': isativo,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
       'nomedaesc': nomedaesc,
    };
  }

  factory Cardapio.fromMap(Map<String, dynamic> map) {
    return Cardapio(
      id: map['id'],
      escola: map['escola'],
      nomedaescola: map['nomedaescola'],
      title: map['title'],
      imagem: map['imagem'],
      isativo: map['isativo'],
      createdAt: map['createdAt'],
      modifiedAt: map['modifiedAt'],
      nomedaesc: map['nomedaesc'],

    );
  }

  String toJson() => json.encode(toMap());

  factory Cardapio.fromJson(String source) => Cardapio.fromMap(json.decode(source));
}
