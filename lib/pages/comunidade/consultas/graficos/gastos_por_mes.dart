import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/customer.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/graficos/grafCol.dart';
import 'package:merenda_escolar/utils/utils.dart';


class GastosPorMes extends StatefulWidget {
  int escola;
  GastosPorMes({this.escola});
  @override
  _GastosPorMesState createState() => _GastosPorMesState();
}

class _GastosPorMesState extends State<GastosPorMes> {
  int get escola => widget.escola;
  final _blocItens = PedidoItensBloc();
  List<PedidoItens> itens;
  int ano = DateTime.now().year;
  int esco;
  int atual;

  @override
  void initState() {
    setState(() {});
    print('aki01 ${widget.escola}');
    if (widget.escola == null) {
      print('02');
      esco = 0;
    } else {
      print('03');
      esco = escola;
    }
    if (esco == 0) {
      print('04');
      _blocItens.fetchTotalMes(context, ano);
    } else {
      print('aki05');
      _blocItens.fetchTotalMesEscola(context, esco, ano);
    }


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

    esco = escola;
    print("okx ${esco}");

    return StreamBuilder(
        stream: _blocItens.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Ainda não existe pedidos para esta Escolax");
          }
          if (!snapshot.hasData) {
            return Container();
          }
          List<PedidoItens> listItens = snapshot.data;
          listItens.sort((a, b) => a.id.compareTo(b.id));
          print('listItensx ${listItens}');
          for (var y in listItens) {
            print('aqui ${y.mes}');
          }

          List<Customer> list3 = [];
          int i2 = 0;

          print('listItensx ${listItens}');
          for (var c in listItens) {
            list3.add(Customer(c.mes, c.tot, Cores.colorList[i2]));
            i2++;
          }
          return GrafCol(list3,true);
        });
  }
}
