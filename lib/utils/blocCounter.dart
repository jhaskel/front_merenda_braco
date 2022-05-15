
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:merenda_escolar/utils/bloc/bloc.dart';
import 'package:merenda_escolar/utils/bloc/bloc_af.dart';

class BlocCounter extends StatelessWidget {
 // final BlocController bloc = BlocProvider.getBloc<BlocController>();
  final BlocAf blocx = BlocProvider.getBloc<BlocAf>();
  @override
  Widget build(BuildContext context) {

  return Column(
      children: [
        Container(
          child: StreamBuilder(
            stream: blocx.outAf,
            initialData: 0,
            builder: (context, snapshot) {
              return Text('${snapshot.data}');
            }
          ),
        ),
        SizedBox(height: 50,),
        RaisedButton(
            onPressed: (){
              blocx.increment();
            },
          child: Text('Add'),
        )
      ],

    );
  }
}




