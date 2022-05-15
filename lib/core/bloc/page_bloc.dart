
import 'package:flutter/widgets.dart';
import 'package:merenda_escolar/constants.dart';

class PageBloc extends ChangeNotifier {

  String page = 'home';
  String nameAppBar = NAME_APP;

  setPage(String pagina){
  page = pagina;
  notifyListeners();
  }
  setNameAppBar(String name){
    nameAppBar = name;
    notifyListeners();
  }

}
