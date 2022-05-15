
import 'package:merenda_escolar/pages/carros/carro.dart';
import 'package:merenda_escolar/pages/carros/carros_api.dart';
import 'package:merenda_escolar/utils/bloc.dart';

class CarrosBloc extends SimpleBloc<List<Carro>> {
  Future<List<Carro>> fetch(context) async {
    try {

      List<Carro> carros = await CarrosApi.getCarros(context);

      add(carros);

      return carros;
    } catch (e) {
      addError(e);
    }

    return [];
  }
}
