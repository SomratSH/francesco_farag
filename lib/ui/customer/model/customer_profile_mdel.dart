class CustomerProfileModel {
  final String? role;
  final Profile? profile;

  CustomerProfileModel({this.role, this.profile});

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileModel(
      role: json['role'],
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }
}

class Profile {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? profilePhotoUrl;
  final String? licenseStatus;
  final bool? licenseVerified;

  Profile({
    this.fullName,
    this.email,
    this.phone,
    this.profilePhotoUrl,
    this.licenseStatus,
    this.licenseVerified,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      profilePhotoUrl: json['profile_photo_url'],
      licenseStatus: json['license_status'],
      licenseVerified: json['license_verified'],
    );
  }
}