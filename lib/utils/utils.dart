
 import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class Utils{

 static calcularSemanaAno(){
   var diaAtual = Jiffy([2020,11,28]);
   var semanaAtual = Jiffy(DateTime.now()).week; // 1s
   print("semana ${semanaAtual}");
    return semanaAtual;
  }

}

 class Status {
   static final String comprando = "Comprando!";
   static final String pedidoRealizado = "Pedido Realizado!";
   static final String pedidoChecado = "Pedido Checado!";
   static final String pedidoProcessado = "Pedido Processado!";
   static final String pedidoAutorizado = "Pedido Autorizado!";
   static final String pedidoFornecedor = "Pedido com fornececedor!";
   static final String aguardandoEntrega = "Aguardando Entrega";
   static final String entregue = "entregue!";
   static final String ordemExcluida = "Ordem Excluida!";
   static final String ordemProcessada = "Ordem Processada!";
   static final String ordemAutorizada = "Ordem Autorizada!";
   static final String ordemEmpenhada = "Ordem Empenhada!";
   static final String ordemFornecedor = "Ordem com Fornecedor!";
 }


 class Niveis{
   static final String dev = "1";
   static final String master = "2";
   static final String admin = "3";
   static final String unidade = "4";
   static final String fornecedor = "5";
   static final String publico = "6";
   static final String empenho = "7";

 }



 class Role{
   static final String dev = "Desenvolvedor";
   static final String master = "Master";
   static final String gerente = "Gerente";
   static final String escola = "Compras";
   static final String admin = "Admin";
   static final String fornecedor = "Fornecedor";
   static final String empenho = "Empenho";
 }



 class Cores {
   static List<Color> colorList = [
     Colors.red,
     Colors.green,
     Colors.blue,
     Colors.yellow,
     Colors.orange,
     Colors.purple,
     Colors.brown,
     Colors.cyanAccent,
     Colors.pink,
     Colors.teal,
     Colors.lime,
     Colors.grey,
     Colors.greenAccent,
   ];
 }
 class CorContainer {
   List<Color> cores = [
     Colors.green[900],
     Colors.green[700],
     Colors.green[500],
     Colors.green[300]
   ];
 }

 class Mostrador{
   static List<LinearGradient> gradient = [
     LinearGradient(
       begin: Alignment.topLeft,
       end: Alignment.bottomRight,
       colors: [
         Colors.blue[200],
         Colors.blue[600],
       ],
     ),
     LinearGradient(
       begin: Alignment.topLeft,
       end: Alignment.bottomRight,
       colors: [
         Colors.yellow[200],
         Colors.yellow[600],
       ],
     ),
     LinearGradient(
       begin: Alignment.topLeft,
       end: Alignment.bottomRight,
       colors: [
         Colors.green[200],
         Colors.green[600],
       ],
     ),
     LinearGradient(
       begin: Alignment.topLeft,
       end: Alignment.bottomRight,
       colors: [
         Colors.orange[200],
         Colors.orange[600],
       ],
     ),
   ];

   static const icones = <IconData>[
     Icons.speed,
     Icons.apartment,
     CommunityMaterialIcons.food_variant,
     CommunityMaterialIcons.broom,
     CommunityMaterialIcons.water_outline,
     CommunityMaterialIcons.food_steak,
     CommunityMaterialIcons.gas_cylinder,
     CommunityMaterialIcons.food_croissant,//7
     CommunityMaterialIcons.fruit_pineapple,//8
     CommunityMaterialIcons.cheese,//9


     Icons.map,
     Icons.account_balance,
     Icons.account_circle_outlined,
     Icons.work_outline_rounded,
     Icons.apps,
     Icons.star,
     Icons.airport_shuttle,
     Icons.carpenter_outlined,
     Icons.view_sidebar_outlined,
     Icons.agriculture,
     Icons.anchor,
     Icons.airline_seat_flat,
     Icons.add_a_photo_outlined,
     Icons.watch,
     Icons.flag_outlined,
     Icons.album_outlined,
     Icons.assessment,
     Icons.architecture_outlined,
     Icons.view_compact,
     Icons.backup_table,
     Icons.campaign_outlined,
     Icons.desktop_windows_outlined,
     Icons.emoji_events_outlined,
     Icons.fastfood_outlined,
     Icons.filter_vintage_sharp,
     Icons.handyman_rounded,

   ];


 }

 class Meses {
   static List<String> meses = [
     "","JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"
   ];
 }


 class MyCustomScrollBehavior extends MaterialScrollBehavior {
   // Override behavior methods and getters like dragDevices
   @override
   Set<PointerDeviceKind> get dragDevices => {
     PointerDeviceKind.touch,
     PointerDeviceKind.mouse,
     PointerDeviceKind.stylus
     // etc.
   };
 }


