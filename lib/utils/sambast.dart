import 'dart:html';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/pages/pedido/Pedido.dart';
import 'package:merenda_escolar/pages/pedido/pedido_bloc.dart';
import 'package:merenda_escolar/pages/produtos/Produto.dart';
import 'package:merenda_escolar/pages/produtos/Produto_bloc.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/bloc/bloc_produtos.dart';

import 'dart:async';
import 'package:sembast_web/sembast_web.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart';

class Animals{
  String name;
  int idade;
  Animals(this.name,this.idade);

}
class TesteBloc extends StatefulWidget {
  @override
  _TesteBlocState createState() => _TesteBlocState();
}

class _TesteBlocState extends State<TesteBloc> {


  final _bloc = PedidoBloc();
  List<Pedido> produtos;
  List<Animals> animals = [Animals('', null)];

  grava(List<Animals> animals) async{
    String dbPath = 'sample.db';
    DatabaseFactory dbFactory = databaseFactoryWeb;
 //  var store = StoreRef.main();
   Database db = await dbFactory.openDatabase(dbPath);
  //  await store.record('settings').put(db, {'offline': false});
    // Use the animals store using Map records with int keys
    var store = intMapStoreFactory.store('animals');

// Store some objects
    await db.transaction((txn) async {
      int index = 1;
      for(var ite in animals){
        await store.record(index).put(txn, {'name': ite.name,'idade':ite.idade});
        index++;
      }

    });
    await db.close();
  }

   Future read() async{
    animals.clear();
    String dbPath = 'sample.db';
    DatabaseFactory dbFactory = databaseFactoryWeb;
    Database db = await dbFactory.openDatabase(dbPath);
   // var store = StoreRef.main();
    var store = intMapStoreFactory.store('animals');
    var settings = await store.find(db);

    for( var jh in settings){
      var lk = jh.cast();
      print('valor1 ${lk.value['name']}');
      print('valor2 ${lk.value["idade"]}');

      setState(() {
        animals.add(Animals(lk.value['name'], lk.value['idade']));
      });

    }
    print('listAnimal ${animals}');
    await db.close();
  }

  @override
  void initState() {
    _bloc.fetch(context).then((value) {
      setState(() {
        produtos = value;
      });

      print('produtos ${produtos}');
    });
     read();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(animals.length == 0){
      for(var jh in animals){
        print('primeiro ${jh.name}');
      }
          return StreamBuilder(
            stream: _bloc.stream,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Text('erro');
              }
              return Column(
                children: [
                  Container(
                    child: RaisedButton(
                      onPressed: (){
                        grava(animals);
                      },
                      child: Text('enviar'),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: RaisedButton(
                      onPressed: (){
                        read();
                        setState(() {});
                      },
                      child: Text('recupera'),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: animals.length,
                      itemBuilder: (context, index) {
                        Animals ani = animals[index];
                        return Container(
                          child: Text(ani.name),
                        );
                      }
                    ),
                  )
                ],

              );
            }
          );

    }
    return Container(child: Text("aqui"),);

  }
}
