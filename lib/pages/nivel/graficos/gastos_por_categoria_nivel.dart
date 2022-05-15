


import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/categorias/Categoria.dart';
import 'package:merenda_escolar/pages/categorias/Categoria_bloc.dart';
import 'package:merenda_escolar/pages/customer.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/graficos/piza.dart';
import 'package:merenda_escolar/utils/utils.dart';

class GastosPorCategoriaNivel extends StatefulWidget {
 int id;
  GastosPorCategoriaNivel(this.id);


  @override
  _GastosPorCategoriaNivelState createState() => _GastosPorCategoriaNivelState();
}

class _GastosPorCategoriaNivelState extends State<GastosPorCategoriaNivel> {

  final _blocItens= PedidoItensBloc();
  List<PedidoItens> itens;

  int ano = DateTime.now().year;
  @override
  void initState() {
    _blocItens.fetchTotalCategoriaNivel(context,widget.id,ano);

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
                return TextError("Não foi possível buscar os itens do pedido");
              }
              if (!snapshot.hasData) {
                return Container( );
              }

              List<PedidoItens> listItens = snapshot.data;
              int i2 = 0;
              for(var c in listItens){
                list2.add(Customer(c.nomec, c.tot.toDouble(), Cores.colorList[i2]));
                i2++;
              }
              return  Piza(list2);
            }
          ),
        );

  }
}
