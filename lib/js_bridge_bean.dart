class JsBridge {
  String method;
  dynamic parameters;
  String callback;

  JsBridge({this.method, this.parameters, this.callback});

  JsBridge.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    parameters = json['parameters'];
    callback = json['callback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    data['parameters'] = this.parameters;
    data['callback'] = this.callback;
    return data;
  }
}
