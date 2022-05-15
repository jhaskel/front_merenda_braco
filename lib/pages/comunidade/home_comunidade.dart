import 'package:flutter/material.dart';
import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/comunidade/consultas/tabs_page.dart';
import 'package:merenda_escolar/pages/login/login_page.dart';
import 'package:merenda_escolar/utils/app_colors.dart';
import 'package:merenda_escolar/utils/app_text_styles.dart';
import 'package:merenda_escolar/utils/nav.dart';


class HomeComunidade extends StatelessWidget {
  const HomeComunidade({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/imgs/brasao.png",fit: BoxFit.fill,),
        backgroundColor: AppColors.white,
        title: Text('Secretaria da Educação',style: AppTextStyles.bodyLightGrey20,),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            push(context, LoginPage());
          }, icon: Icon(Icons.person,color: Colors.blue,))
        ],

        elevation: 0,),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder: (context,constraints){
      var largura = constraints.maxWidth;
     var  limite = 600.0;
      return Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/imgs/merenda.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: largura,
            height: altura,
            color: Colors.white70,

          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Merenda escolar',style: largura > limite?AppTextStyles.heading70:TextStyle(fontWeight: FontWeight.bold,fontSize: 50,color: Colors.black54)),

                    Text('Direito do aluno, dever do Estado!',style: AppTextStyles.heading,),
                    SizedBox(height:100),
                    Text('Sistema da merenda Escolar do municipio de $CIDADE',style: AppTextStyles.bodyBold,),
                    Text('Aqui você acompanha os gastos com alimentação escolar em cada escola!',style: AppTextStyles.bodyBold,),
                    SizedBox(height:50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        MaterialButton(
                          onPressed: (){
                            //  push(context, Pn());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('Ver mais\nSobre merenda escolar',style: AppTextStyles.body11White,),
                          ),
                          color: Colors.orange[900],
                        ),
                        SizedBox(width: 10,),MaterialButton(
                          onPressed: (){
                            push(context, TabsPage());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text('Ver\nGastos',style: AppTextStyles.body11White,),
                          ),
                          color: Colors.blue,
                        )




                      ],)
                  ],


                )

              ],
            ),
          ),


        ],

      );
    });

  }
}