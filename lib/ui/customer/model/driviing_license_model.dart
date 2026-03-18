class DrivingLicenseModel {
  String? status;
  LicenseDetails? details;

  DrivingLicenseModel({this.status, this.details});

  factory DrivingLicenseModel.fromJson(Map<String, dynamic> json) {
    return DrivingLicenseModel(
      status: json['status'],
      details: json['details'] != null 
          ? LicenseDetails.fromJson(json['details']) 
          : null,
    );
  }
}

class LicenseDetails {
  String? licenseNumber;
  String? licenseExpiryDate;
  String? licenseStatus;
  String? licenseRejectionReason;
  String? licenseFrontImage;
  String? licenseFrontUrl;
  String? licenseBackImage;
  String? licenseBackUrl;
  String? licenseVerifiedAt;

  LicenseDetails({
    this.licenseNumber,
    this.licenseExpiryDate,
    this.licenseStatus,
    this.licenseRejectionReason,
    this.licenseFrontImage,
    this.licenseFrontUrl,
    this.licenseBackImage,
    this.licenseBackUrl,
    this.licenseVerifiedAt,
  });

  factory LicenseDetails.fromJson(Map<String, dynamic> json) {
    return LicenseDetails(
      licenseNumber: json['license_number'],
      licenseExpiryDate: json['license_expiry_date'],
      licenseStatus: json['license_status'],
      licenseRejectionReason: json['license_rejection_reason'],
      licenseFrontImage: json['license_front_image'],
      licenseFrontUrl: json['license_front_url'],
      licenseBackImage: json['license_back_image'],
      licenseBackUrl: json['license_back_url'],
      licenseVerifiedAt: json['license_verified_at'],
    );
  }
}