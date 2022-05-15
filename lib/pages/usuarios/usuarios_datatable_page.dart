import 'dart:math';

import 'package:flutter/material.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/pages/usuarios/usuario_form_page.dart';
import 'package:merenda_escolar/pages/usuarios/usuario_page.dart';
import 'package:merenda_escolar/pages/usuarios/usuarios_bloc.dart';
import 'package:merenda_escolar/pages/widgets/add_button.dart';
import 'package:merenda_escolar/pages/widgets/text_error.dart';
import 'package:merenda_escolar/utils/utils.dart';
import 'package:merenda_escolar/web/breadcrumb.dart';

class UsuariosPage extends StatefulWidget {
  UsuariosPage();

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage>
    with AutomaticKeepAliveClientMixin<UsuariosPage> {
  final _bloc = UsuariosBloc();

  List<Usuario> usuarios;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _bloc.fetch(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: BreadCrumb(
        child: _stream(),
        actions: [
          AddButton(
            onPressed: _onClickAdd,
          )
        ],
      ),
    );
  }

  _stream() {
    return Card(
      child: StreamBuilder(
        initialData: usuarios,
        stream: _bloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar os usuários");
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          usuarios = snapshot.data;

          return _grid(usuarios);
        },
      ),
    );
  }

  _grid(List<Usuario> usuarios) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(16),
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                Usuario c = usuarios[index];
                return Container(
                  child: _cardCategoria(c, constraints),
                  //       onTap: () => {},
                );
              },
            ),
          ),
        );
      },
    );
  }

  _cardCategoria(Usuario c, BoxConstraints constraints) {
    return ListTile(
      onTap: () {
        _onClickUsuario(c);
      },
      leading: CircleAvatar(
        backgroundColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
      ),
      title: Text(c.nome),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(c.email),
          Text(c.login),
        ],

      ),
      trailing: IconButton(
          icon: Icon(
            Icons.edit,
            size: 20,
          ),
          onPressed: () {
            _onClickUsuario(c);
          }),
    );
  }

  _onClickUsuario(Usuario u) {
    final pageInfo = PageInfo("Usuario ${u.nome}", UsuarioPage(usuario: u));
    PagesModel.get(context).push(pageInfo);
  }

  _onClickAdd() {
    final pageInfo = PageInfo("Usuario ", UsuarioFormPage());
    PagesModel.get(context).push(pageInfo);
  }

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
  }
}
