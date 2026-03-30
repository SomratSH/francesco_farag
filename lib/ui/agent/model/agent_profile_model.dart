class AgentProfileModel {
  String? role;
  Profile? profile;

  AgentProfileModel({this.role, this.profile});

  AgentProfileModel.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? fullName;
  String? email;
  String? phone;
  String? agencyName;
  bool? agencyVerified;
  Null? profilePhoto;
  Null? profilePhotoUrl;

  Profile(
      {this.fullName,
      this.email,
      this.phone,
      this.agencyName,
      this.agencyVerified,
      this.profilePhoto,
      this.profilePhotoUrl});

  Profile.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    agencyName = json['agency_name'];
    agencyVerified = json['agency_verified'];
    profilePhoto = json['profile_photo'];
    profilePhotoUrl = json['profile_photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['agency_name'] = this.agencyName;
    data['agency_verified'] = this.agencyVerified;
    data['profile_photo'] = this.profilePhoto;
    data['profile_photo_url'] = this.profilePhotoUrl;
    return data;
  }
}
