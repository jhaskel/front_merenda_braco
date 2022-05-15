import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class BlocAf extends BlocBase {
  BlocAf();
//Stream that receives a number and changes the count;
  var _counterAf = BehaviorSubject<int>.seeded(0);
//output
  Stream<int> get outAf => _counterAf.stream;
//input
  Sink<int> get inAf => _counterAf.sink;

  increment(){
    inAf.add(_counterAf.value+1);
  }

//dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _counterAf.close();
    super.dispose();
  }

}