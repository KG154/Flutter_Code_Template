class LogoutModel {
  bool? status;
  int? responsecode;
  String? message;
  Data? data;

  LogoutModel({this.status, this.responsecode, this.message, this.data});

  LogoutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    responsecode = json['responsecode'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['responsecode'] = this.responsecode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? uniqueToken;
  int? userId;

  Data({this.uniqueToken, this.userId});

  Data.fromJson(Map<String, dynamic> json) {
    uniqueToken = json['unique_token'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unique_token'] = this.uniqueToken;
    data['user_id'] = this.userId;
    return data;
  }
}