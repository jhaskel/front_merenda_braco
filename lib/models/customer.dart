import 'package:flutter/material.dart';

class Customer {
  String nome;
  double valor;
  Color cor;
  double percent;

  Customer(this.nome, this.valor,this.cor,{this.percent});

  @override
  String toString() {
    return '{ ${this.nome}, ${this.valor}, ${this.cor}, ${this.percent} }';
  }
}
