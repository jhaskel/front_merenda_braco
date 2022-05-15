import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class BlocController extends BlocBase {

  BlocController();

//Stream that receives a number and changes the count;
  var _counterController = BehaviorSubject<int>.seeded(0);
//output
  Stream<int> get outCounter => _counterController.stream;
//input
  Sink<int> get inCounter => _counterController.sink;

  increment(){
    inCounter.add(_counterController.value+1);

    print(_counterController.value);
  }

//dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _counterController.close();
    super.dispose();
  }

}