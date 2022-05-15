import 'dart:convert' as convert;

import 'package:merenda_escolar/constants.dart';
import 'package:merenda_escolar/pages/cart/Cart.dart';
import 'package:merenda_escolar/utils/api_response.dart';

import 'package:merenda_escolar/utils/http_helper.dart' as http;

class CartApi {
  static Future<List<Cart>> get(
    context,
  ) async {
    String url = "$BASE_URL/cart";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Cart> favoritos = list.map<Cart>((map) => Cart.fromMap(map)).toList();
    print(favoritos);
    return favoritos;
  }

  static Future<List<Cart>> getId(context, int id) async {
    String url = "$BASE_URL/cart/id/$id";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Cart> favoritos = list.map<Cart>((map) => Cart.fromMap(map)).toList();
    return favoritos;
  }

  static Future<List<Cart>> getUnidade(context, int unidade) async {
    String url = "$BASE_URL/cart/escola/$unidade";
    final response = await http.get(context,url);
    String json = response.body;
    List list = convert.json.decode(json);
    List<Cart> favoritos = list.map<Cart>((map) => Cart.fromMap(map)).toList();
    return favoritos;
  }

  static Future<double> getCartProduto(context, int produto) async {
    String url = "$BASE_URL/cart/cart/$produto";
    final response = await http.get(context,url);
    String json = response.body;
    double list = convert.json.decode(json);
    print("LKJ $list");
    return list;
  }

  static Future<ApiResponse<bool>> save(context, Cart c) async {
    try {
      var url = "$BASE_URL/cart";

      if (c.id != null) {
        url += "/${c.id}";
      }

      String json = c.toJson();

      var response = await (c.id == null
          ? http.post(context,url, body: json)
          : http.put(context,url, body: json));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map mapResponse = convert.json.decode(response.body);
        Cart cart = Cart.fromMap(mapResponse);
        print(cart);
        return ApiResponse.ok(id: cart.id);
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      return ApiResponse.error(msg: "Não foi possível salvar a cart");
    }
  }

  static Future<ApiResponse<bool>> update(context, Cart c) async {
    try {
      var url = "$BASE_URL/cart/${c.id}";
      String json = c.toJson();

      var response = await (http.put(context,url, body: json));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.ok();
      }

      Map mapResponse = convert.json.decode(response.body);
      return ApiResponse.error(msg: mapResponse["error"]);
    } catch (e) {
      return ApiResponse.error(msg: "Não foi possível salvar a cart");
    }
  }

  static Future<ApiResponse> delete(context, Cart c) async {
    try {
      String url = "$BASE_URL/cart/${c.id}";

      var response = await http.delete(context,url);

      if (response.statusCode == 200) {
        Map mapResponse = convert.json.decode(response.body);
        Cart cart = Cart.fromMap(mapResponse);
        return ApiResponse.ok(msg: mapResponse["msg"], id: cart.id);
      }
    } catch (e) {}

    return ApiResponse.error(msg: "Não foi possível deletar a cart");
  }
}
