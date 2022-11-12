class CheckAppVersionModel {
  bool? status;
  int? responsecode;
  String? message;
  VersionData? data;

  CheckAppVersionModel(
      {this.status, this.responsecode, this.message, this.data});

  CheckAppVersionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    responsecode = json['responsecode'];
    message = json['message'];
    data = json['data'] != null ? new VersionData.fromJson(json['data']) : null;
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

class VersionData {
  int? appId;
  String? appVersionName;
  String? appUpdateStatus;
  String? appStoreVerStatus;
  String? appPlateform;
  int? isMaintenanceStatus;
  String? appUrl;
  int? authiId;
  String? userId;
  String? deviceType;
  String? deviceToken;
  String? uniqueToken;
  String? userApplicationVersion;
  String? lastOnlineStatus;

  VersionData(
      {this.appId,
        this.appVersionName,
        this.appUpdateStatus,
        this.appStoreVerStatus,
        this.appPlateform,
        this.isMaintenanceStatus,
        this.appUrl,
        this.authiId,
        this.userId,
        this.deviceType,
        this.deviceToken,
        this.uniqueToken,
        this.userApplicationVersion,
        this.lastOnlineStatus});

  VersionData.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    appVersionName = json['app_version_name'];
    appUpdateStatus = json['app_update_status'];
    appStoreVerStatus = json['app_store_ver_status'];
    appPlateform = json['app_plateform'];
    isMaintenanceStatus = json['is_maintenance_status'];
    appUrl = json['app_url'];
    authiId = json['authi_id'];
    userId = json['user_id'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    uniqueToken = json['unique_token'];
    userApplicationVersion = json['user_application_version'];
    lastOnlineStatus = json['last_online_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_id'] = this.appId;
    data['app_version_name'] = this.appVersionName;
    data['app_update_status'] = this.appUpdateStatus;
    data['app_store_ver_status'] = this.appStoreVerStatus;
    data['app_plateform'] = this.appPlateform;
    data['is_maintenance_status'] = this.isMaintenanceStatus;
    data['app_url'] = this.appUrl;
    data['authi_id'] = this.authiId;
    data['user_id'] = this.userId;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['unique_token'] = this.uniqueToken;
    data['user_application_version'] = this.userApplicationVersion;
    data['last_online_status'] = this.lastOnlineStatus;
    return data;
  }
}
