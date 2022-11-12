class ChangePassModel {
  bool? status;
  int? responsecode;
  String? message;

  ChangePassModel({this.status, this.responsecode, this.message});

  ChangePassModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    responsecode = json['responsecode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['responsecode'] = this.responsecode;
    data['message'] = this.message;
    return data;
  }
}
