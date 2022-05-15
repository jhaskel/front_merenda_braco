import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/customer.dart';
import 'package:merenda_escolar/pages/master/gastos_por_categoria.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/graficos/grafCol.dart';
import 'package:merenda_escolar/utils/utils.dart';

class GastosPorMesNivel extends StatefulWidget {
  int id;
  GastosPorMesNivel(this.id);


  @override
  _GastosPorMesNivelState createState() => _GastosPorMesNivelState();
}

class _GastosPorMesNivelState extends State<GastosPorMesNivel> {

  final _blocItens= PedidoItensBloc();
  List<PedidoItens> itens;
  int ano = DateTime.now().year;
  @override
  void initState() {
    _blocItens.fetchTotalMesNivel(context,widget.id,ano);
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
          return TextError("Não foi possível buscar os itens do pedido");
        }
        if (!snapshot.hasData) {
          return Container();
        }
        List<PedidoItens> listItens = snapshot.data;
        listItens.sort((a, b) => a.id.compareTo(b.id));

        List<Customer> list3 = [];
        int i = 0;
        for(var c in listItens){
          list3.add(Customer(c.mes, c.tot, Cores.colorList[i]));
          i++;
        }
        return GrafCol(list3,false);
      }
    );
  }
}

