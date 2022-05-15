import 'dart:async';

import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor.dart';
import 'package:merenda_escolar/pages/fornecedor/Fornecedor_bloc.dart';


class SimpleSearch extends StatefulWidget {
  SimpleSearch({Key key}) : super(key: key);

  @override
  _SimpleSearchState createState() => _SimpleSearchState();
}

class _SimpleSearchState extends State<SimpleSearch> {

  final _blocFornec = FornecedorBloc();
  List<Fornecedor> fornec;
  List<Fornecedor> _allContacts = List<Fornecedor>();
  StreamController<List<Fornecedor>> _contactStream =
  StreamController<List<Fornecedor>>();


  @override
  void initState() {
    _blocFornec.fetch(context).then((value) {
      setState(() {
        for(var x in value){
          _allContacts.add(x);
        }
        _contactStream.add(_allContacts);

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarTextField(
          title: Text("Contacts"),
          onBackPressed: _onRestoreAllData,
          onClearPressed: _onRestoreAllData,
          onChanged: _onSimpleSearch2Changed,
        ),
        body: _buildBody());
  }

  void _onSimpleSearch2Changed(String value) {
    List<Fornecedor> foundContacts = _allContacts
        .where((Fornecedor contact) =>
    contact.nome.toLowerCase().indexOf(value.toLowerCase()) > -1)
        .toList();

    this._contactStream.add(foundContacts);
  }

  void _onRestoreAllData() {
    this._contactStream.add(this._allContacts);
  }

  Widget _buildBody() {
    return StreamBuilder<List<Fornecedor>>(
        stream: _contactStream.stream,
        builder: (context, snapshot) {
          List<Fornecedor> contacts = snapshot.hasData ? snapshot.data : [];
          print ('xx ${contacts}');

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              var contact = contacts[index];
              return ListTile(
                leading: CircleAvatar(),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        contact.nome,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  ],
                ),
                subtitle: Text(faker.job.title()),
              );
            },
          );
        });
  }

  @override
  void dispose() {
    _contactStream.close();
    super.dispose();
  }
}