import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/customer.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/graficos/grafCol.dart';
import 'package:merenda_escolar/utils/utils.dart';


class MediaPorAlunos extends StatefulWidget {
  @override
  _MediaPorAlunosState createState() => _MediaPorAlunosState();
}

class _MediaPorAlunosState extends State<MediaPorAlunos> {
  final _blocItens = PedidoItensBloc();
  List<PedidoItens> itens;
  int ano = DateTime.now().year;
  @override
  void initState() {
    _blocItens.fetchMediaAlunos(context, ano);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _blocItens.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _blocItens.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Ainda não existe pedidos para esta Escola");
          }
          if (!snapshot.hasData) {
            return Container();
          }
          List<PedidoItens> listItens = snapshot.data;
          print('listItens ${listItens}');
          List<Customer> list = [];
          int i = 0;
          for (var c in listItens) {
            list.add(Customer(c.nomec, c.tot, Cores.colorList[i]));
            i++;
          }
          return GrafCol(list,true);
        });
  }
}
