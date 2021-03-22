class JsBridgeBean {
  JsBridgeParams params;
  int id;
  String method;

  JsBridgeBean({this.params, this.id, this.method});

  JsBridgeBean.fromJson(Map<String, dynamic> json) {
    params =
    json['params'] != null ? new JsBridgeParams.fromJson(json['params']) : null;
    id = json['id'];
    method = json['method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.params != null) {
      data['params'] = this.params.toJson();
    }
    data['id'] = this.id;
    data['method'] = this.method;
    return data;
  }
}

class JsBridgeParams {
  String signature;
  String message;
  String value;
  String gasPrice;
  String to;
  String data;
  String from;

  JsBridgeParams(
      {this.signature,
        this.message,
        this.value,
        this.gasPrice,
        this.to,
        this.data,
        this.from});

  JsBridgeParams.fromJson(Map<String, dynamic> json) {
    signature = json['signature'];
    message = json['message'];
    value = json['value'];
    gasPrice = json['gasPrice'];
    to = json['to'];
    data = json['data'];
    from = json['from'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['signature'] = this.signature;
    data['message'] = this.message;
    data['value'] = this.value;
    data['gasPrice'] = this.gasPrice;
    data['to'] = this.to;
    data['data'] = this.data;
    data['from'] = this.from;
    return data;
  }
}
