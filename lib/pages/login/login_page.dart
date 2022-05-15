
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:merenda_escolar/app_model.dart';
import 'package:merenda_escolar/colors.dart';
import 'package:merenda_escolar/home.dart';
import 'package:merenda_escolar/pages/login/login_form.dart';
import 'package:merenda_escolar/pages/login/usuario.dart';
import 'package:merenda_escolar/utils/nav.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Size get size => MediaQuery.of(context).size;

  AppModel get app => AppModel.get(context);

  @override
  void initState() {
    super.initState();
    // Login automático
    _autoLogin();
  }

  void _autoLogin() async {

    // Lê do storage
    Usuario user = await Usuario.get();



    if (user != null) {

      String yourToken = user.token;
      DateTime expirationDate = JwtDecoder.getExpirationDate(yourToken);
      bool hasExpired = JwtDecoder.isExpired(yourToken);
      // Salva no Provider
      if(!hasExpired){
        AppModel.get(context).setUser(user);
        push(context, HomePage(), replace: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      body: _layoutBackgroundImg(),
    );
  }

  _layoutBackgroundImg() {

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          "assets/imgs/background.jpg",
          fit: BoxFit.fill,
          width: double.infinity,
        ),
        Center(
          child: Container(
            width: 460,
            height: 400,
            decoration: BoxDecoration(
                color: AppColors.cinza_background,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.cinza_606060,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  height: 76,
                  child: Center(
                    child: Text(
                      "Merenda Escolar",
                      style: TextStyle(color: Colors.white,fontSize: 22),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: _form(),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  _form() {
    return  LoginForm();
  }
}
