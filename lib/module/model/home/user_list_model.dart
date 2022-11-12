class UserListModel {
  bool? status;
  int? responsecode;
  String? message;
  List<UserListData>? data;

  UserListModel({this.status, this.responsecode, this.message, this.data});

  UserListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    responsecode = json['responsecode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserListData>[];
      json['data'].forEach((v) {
        data!.add(new UserListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['responsecode'] = this.responsecode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserListData {
  int? userId;
  String? name;
  String? email;
  String? socialId;
  String? phone;
  String? phoneCountryCode;
  String? createdAt;
  String? profileImage;
  String? profileStatus;
  String? bioVideo;
  String? bioThumb;

  UserListData(
      {this.userId,
        this.name,
        this.email,
        this.socialId,
        this.phone,
        this.phoneCountryCode,
        this.createdAt,
        this.profileImage,
        this.profileStatus,
        this.bioVideo,
        this.bioThumb});

  UserListData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    socialId = json['social_id'];
    phone = json['phone'];
    phoneCountryCode = json['phone_country_code'];
    createdAt = json['created_at'];
    profileImage = json['profile_image'];
    profileStatus = json['profile_status'];
    bioVideo = json['bio_video'];
    bioThumb = json['bio_thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['social_id'] = this.socialId;
    data['phone'] = this.phone;
    data['phone_country_code'] = this.phoneCountryCode;
    data['created_at'] = this.createdAt;
    data['profile_image'] = this.profileImage;
    data['profile_status'] = this.profileStatus;
    data['bio_video'] = this.bioVideo;
    data['bio_thumb'] = this.bioThumb;
    return data;
  }
}
