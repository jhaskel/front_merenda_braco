class ApiResponse<T> {
  bool ok;
  String msg;
  T result;
  int id;

  ApiResponse.ok({this.result, this.msg,this.id}) {
    ok = true;
  }

  ApiResponse.error({this.result, this.msg}) {
    ok = false;
  }
}

