import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/customer.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/graficos/piza.dart';
import 'package:merenda_escolar/utils/utils.dart';


class GastosPorCategoria extends StatefulWidget {
   int escola;
  GastosPorCategoria({this.escola});

  @override
  _GastosPorCategoriaState createState() => _GastosPorCategoriaState();
}

class _GastosPorCategoriaState extends State<GastosPorCategoria> {
  int get escola => widget.escola;
  final _blocItens = PedidoItensBloc();
  List<PedidoItens> itens;

  int ano = DateTime.now().year;
  int esco;
  @override
  void initState() {
    if (escola == null) {
      esco = 0;
    } else {
      esco = escola;
    }

    if (esco == 0) {
      _blocItens.fetchTotalCategoria(context,ano);
    } else {
      _blocItens.fetchTotalCategoriaEscola(context, escola, ano);
    }

    // TODO: implement initState
    super.initState();
  }

  List<Customer> list2 = [];
  @override
  void dispose() {
    _blocItens.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: _blocItens.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return TextError("Ainda não existe pedidos para esta Escola1");
            }
            if (!snapshot.hasData) {
              return Container();
            }

            List<PedidoItens> listItens = snapshot.data;
            int i2 = 0;
            list2.clear();
            for (var c in listItens) {
              list2.add(
                  Customer(c.nomec, c.tot.toDouble(), Cores.colorList[i2]));
              i2++;
            }
            return Piza(list2);
          }),
    );
  }
}
