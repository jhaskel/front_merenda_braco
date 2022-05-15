import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens.dart';
import 'package:merenda_escolar/pages/pedidoItens/PedidoItens_bloc.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();

}

class _TablePageState extends State<TablePage> {
  final _bloc = PedidoItensBloc();
  List<PedidoItens> itens;

  @override
  void initState() {
    _bloc.fetchAfi(context);
    super.initState();
  }
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;

  
  void _sort<T>(
      Comparable<T> getField(PedidoItens d), int columnIndex, bool ascending) {
    _items.sort((PedidoItens a, PedidoItens b) {
      if (!ascending) {
        final PedidoItens c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  List<PedidoItens> _items = [];
  int _rowsOffset = 0;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return TextError("Não foi possível buscar os niveis escolares");
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<PedidoItens> listNiveis= snapshot.data;
        print('niv ${listNiveis}');
       for(PedidoItens ped in listNiveis){
         _items.add(ped);
       }

        return NativeDataTable.builder(
          rowsPerPage: _rowsPerPage,
          itemCount: _items?.length ?? 0,
          firstRowIndex: _rowsOffset,
          handleNext: () async {
            setState(() {
              _rowsOffset += _rowsPerPage;
            });       
            
          },
          handlePrevious: () {
            setState(() {
              _rowsOffset -= _rowsPerPage;
            });
          },
          itemBuilder: (int index) {
            final PedidoItens dessert = _items[index];
            return DataRow.byIndex(
                index: index,
                selected: dessert.ischeck,
                onSelectChanged: (bool value) {
                  if (dessert.ischeck != value) {
                    setState(() {
                      dessert.ischeck = value;
                    });
                  }
                },
                cells: <DataCell>[
                  DataCell(Text('${dessert.alias}')),
                  DataCell(Text('${dessert.af}')),
                  DataCell(Text('${dessert.valor.toStringAsFixed(1)}')),
                  DataCell(Text('${dessert.nivel}')),
                  DataCell(Text('${dessert.total.toStringAsFixed(1)}')),
                  DataCell(Text('${dessert.fornecedor}')),
                  DataCell(Text('${dessert.escola}%')),
                ]);
          },
          header: const Text('Data Management'),
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          onRefresh: () async {
            await new Future.delayed(new Duration(seconds: 3));
            setState(() {
              //_items = _bloc.fetchAfi(context);
            });
            return null;
          },
          onRowsPerPageChanged: (int value) {
            setState(() {
              _rowsPerPage = value;
            });
            print("New Rows: $value");
          },
          // mobileItemBuilder: (BuildContext context, int index) {
          //   final i = _desserts[index];
          //   return ListTile(
          //     title: Text(i?.name),
          //   );
          // },
          onSelectAll: (bool value) {
            for (var row in _items) {
              setState(() {
                row.ischeck = value;
              });
            }
          },
          rowCountApproximate: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {},
            ),
          ],
          selectedActions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  for (var item in _items
                      ?.where((d) => d?.ischeck ?? false)
                      ?.toSet()
                      ?.toList()) {
                    _items.remove(item);
                  }
                });
              },
            ),
          ],
          columns: <DataColumn>[
            DataColumn(
                label: const Text('PedidoItens (100g serving)'),
                onSort: (int columnIndex, bool ascending) => _sort<String>(
                        (PedidoItens d) => d.alias, columnIndex, ascending)),
            DataColumn(
                label: const Text('Calories'),
                tooltip:
                'The total amount of food energy in the given serving size.',
                numeric: false,
                onSort: (int columnIndex, bool ascending) => _sort<num>(
                        (PedidoItens d) => d.af, columnIndex, ascending)),
            DataColumn(
                label: const Text('Fat (g)'),
                numeric: false,
                onSort: (int columnIndex, bool ascending) =>
                    _sort<num>((PedidoItens d) => d.valor, columnIndex, ascending)),
            DataColumn(
                label: const Text('Carbs (g)'),
                numeric: false,
                onSort: (int columnIndex, bool ascending) =>
                    _sort<num>((PedidoItens d) => d.total, columnIndex, ascending)),
            DataColumn(
                label: const Text('Protein (g)'),
                numeric: false,
                onSort: (int columnIndex, bool ascending) => _sort<num>(
                        (PedidoItens d) => d.fornecedor, columnIndex, ascending)),
            DataColumn(
                label: const Text('Sodium (mg)'),
                numeric: false,
                onSort: (int columnIndex, bool ascending) => _sort<num>(
                        (PedidoItens d) => d.escola, columnIndex, ascending)),
            DataColumn(
                label: const Text('Calcium (%)'),
                tooltip:
                'The amount of calcium as a percentage of the recommended daily amount.',
                numeric: false,
                onSort: (int columnIndex, bool ascending) => _sort<num>(
                        (PedidoItens d) => d.nivel, columnIndex, ascending)),
            DataColumn(
                label: const Text('Iron (%)'),
                numeric: false,
                onSort: (int columnIndex, bool ascending) =>
                    _sort<num>((PedidoItens d) => d.escola, columnIndex, ascending)),
          ],
        );
        
      }
    );
  }
}
