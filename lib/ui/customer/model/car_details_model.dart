class CarDetailsModel {
  int? id;
  String? carName;
  String? category;
  String? pricePerDay;
  String? transmission;
  String? fuelType;
  int? seats;
  int? doors;
  String? status;
  List<dynamic>? features;
  String? featuredImageUrl;
  String? agencyName;
  String? agencyLocation;
  List<AvailableServices>? availableServices;
  double? averageRating;
  int? totalReviews;

  CarDetailsModel({
    this.id,
    this.carName,
    this.category,
    this.pricePerDay,
    this.transmission,
    this.fuelType,
    this.seats,
    this.doors,
    this.status,
    this.features,
    this.featuredImageUrl,
    this.agencyName,
    this.agencyLocation,
    this.availableServices,
    this.averageRating,
    this.totalReviews,
  });

  CarDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carName = json['car_name'];
    category = json['category'];
    pricePerDay = json['price_per_day'];
    transmission = json['transmission'];
    fuelType = json['fuel_type'];
    seats = json['seats'];
    doors = json['doors'];
    status = json['status'];
    features = json['features'];
    featuredImageUrl = json['featured_image_url'];
    agencyName = json['agency_name'];
    agencyLocation = json['agency_location'];
    if (json['available_services'] != null) {
      availableServices = <AvailableServices>[];
      json['available_services'].forEach((v) {
        availableServices!.add(AvailableServices.fromJson(v));
      });
    }
    averageRating = json['average_rating']?.toDouble();
    totalReviews = json['total_reviews'];
  }
}

class AvailableServices {
  int? id;
  String? name;
  String? pricePerDay;

  AvailableServices({this.id, this.name, this.pricePerDay});

  AvailableServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pricePerDay = json['price_per_day'];
  }
}