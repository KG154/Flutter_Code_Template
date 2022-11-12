class UserLoginModel {
  bool? status;
  int? responsecode;
  String? message;
  UserLoginData? data;

  UserLoginModel({this.status, this.responsecode, this.message, this.data});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    responsecode = json['responsecode'];
    message = json['message'];
    data = json['data'] != null ? new UserLoginData.fromJson(json['data']) : null;
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

class UserLoginData {
  int? userId;
  String? name;
  String? email;
  String? password;
  String? socialId;
  String? phone;
  String? phoneCountryCode;
  String? profileImage;
  String? profileStatus;
  String? bioVideo;
  String? bioThumb;
  String? userLoginType;
  String? userAppVersion;
  String? deviceType;
  String? deviceToken;
  String? token;
  String? lastOnlineStatus;

  UserLoginData(
      {this.userId,
        this.name,
        this.email,
        this.password,
        this.socialId,
        this.phone,
        this.phoneCountryCode,
        this.profileImage,
        this.profileStatus,
        this.bioVideo,
        this.bioThumb,
        this.userLoginType,
        this.userAppVersion,
        this.deviceType,
        this.deviceToken,
        this.token,
        this.lastOnlineStatus});

  UserLoginData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    socialId = json['social_id'];
    phone = json['phone'];
    phoneCountryCode = json['phone_country_code'];
    profileImage = json['profile_image'];
    profileStatus = json['profile_status'];
    bioVideo = json['bio_video'];
    bioThumb = json['bio_thumb'];
    userLoginType = json['user_login_type'];
    userAppVersion = json['user_app_version'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    token = json['Token'];
    lastOnlineStatus = json['last_online_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['social_id'] = this.socialId;
    data['phone'] = this.phone;
    data['phone_country_code'] = this.phoneCountryCode;
    data['profile_image'] = this.profileImage;
    data['profile_status'] = this.profileStatus;
    data['bio_video'] = this.bioVideo;
    data['bio_thumb'] = this.bioThumb;
    data['user_login_type'] = this.userLoginType;
    data['user_app_version'] = this.userAppVersion;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['Token'] = this.token;
    data['last_online_status'] = this.lastOnlineStatus;
    return data;
  }
}
