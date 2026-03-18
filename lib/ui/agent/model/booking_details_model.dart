class BookingDetailsModel {
  final String? bookingId;
  final CustomerInfo? customerInfo;
  final String? carName;
  final DateTime? pickupDate;
  final DateTime? returnDate;
  final String? pickupLocation;
  final int? durationDays;
  final String? status;
  final List<ExtraService>? availableExtraServices;
  final List<ExtraService>? selectedExtraServices;
  final PricingBreakdown? pricingBreakdown;

  BookingDetailsModel({
    this.bookingId,
    this.customerInfo,
    this.carName,
    this.pickupDate,
    this.returnDate,
    this.pickupLocation,
    this.durationDays,
    this.status,
    this.availableExtraServices,
    this.selectedExtraServices,
    this.pricingBreakdown,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) =>
      BookingDetailsModel(
        bookingId: json["booking_id"],
        customerInfo: json["customer_info"] != null
            ? CustomerInfo.fromJson(json["customer_info"])
            : null,
        carName: json["car_name"],
        pickupDate: json["pickup_date"] != null
            ? DateTime.parse(json["pickup_date"])
            : null,
        returnDate: json["return_date"] != null
            ? DateTime.parse(json["return_date"])
            : null,
        pickupLocation: json["pickup_location"],
        durationDays: json["duration_days"],
        status: json["status"],
        availableExtraServices: json["available_extra_services"] != null
            ? List<ExtraService>.from(
                json["available_extra_services"].map(
                  (x) => ExtraService.fromJson(x),
                ),
              )
            : [],
        selectedExtraServices: json["selected_extra_services"] != null
            ? List<ExtraService>.from(
                json["selected_extra_services"].map(
                  (x) => ExtraService.fromJson(x),
                ),
              )
            : [],
        pricingBreakdown: json["pricing_breakdown"] != null
            ? PricingBreakdown.fromJson(json["pricing_breakdown"])
            : null,
      );
}

class CustomerInfo {
  final String? name;
  final String? licenseStatus;

  CustomerInfo({this.name, this.licenseStatus});

  factory CustomerInfo.fromJson(Map<String, dynamic> json) =>
      CustomerInfo(name: json["name"], licenseStatus: json["license_status"]);
}

class ExtraService {
  final int? id;
  final String? name;
  final String? pricePerDay;

  ExtraService({this.id, this.name, this.pricePerDay});

  factory ExtraService.fromJson(Map<String, dynamic> json) => ExtraService(
    id: json["id"],
    name: json["name"],
    pricePerDay: json["price_per_day"],
  );
}

class PricingBreakdown {
  final double? basePrice;
  final double? extraServicesCost;
  final double? subtotal;
  final double? vatPercentage;
  final double? vatAmount;
  final double? insuranceCost;
  final double? discount;
  final double? securityDeposit;
  final double? totalPrice;
  final String? notes;

  PricingBreakdown({
    this.basePrice,
    this.extraServicesCost,
    this.subtotal,
    this.vatPercentage,
    this.vatAmount,
    this.securityDeposit,
    this.totalPrice,
    this.discount,
    this.insuranceCost,
    this.notes,
  });

  factory PricingBreakdown.fromJson(Map<String, dynamic> json) =>
      PricingBreakdown(
        basePrice: (json["base_price"] as num?)?.toDouble(),
        extraServicesCost: (json["extra_services_cost"] as num?)?.toDouble(),
        subtotal: (json["subtotal"] as num?)?.toDouble(),
        vatPercentage: (json["vat_percentage"] as num?)?.toDouble(),
        vatAmount: (json["vat_amount"] as num?)?.toDouble(),
        securityDeposit: (json["security_deposit"] as num?)?.toDouble(),
        totalPrice: (json["total_price"] as num?)?.toDouble(),
        notes: json["notes"],
        discount: json['discount'],
        insuranceCost: json['insurance_cost'],
      );
}
