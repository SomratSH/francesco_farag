class RentalRequestsModel {
  Counts? counts;
  List<RentalRequest>? requests;

  RentalRequestsModel({this.counts, this.requests});

  factory RentalRequestsModel.fromJson(Map<String, dynamic> json) {
    return RentalRequestsModel(
      counts: json['counts'] != null ? Counts.fromJson(json['counts']) : null,
      requests: json['requests'] != null
          ? List<RentalRequest>.from(
              json['requests'].map((x) => RentalRequest.fromJson(x)))
          : [],
    );
  }
}

class Counts {
  int? pending;
  int? active;
  int? rejected;

  Counts({this.pending, this.active, this.rejected});

  factory Counts.fromJson(Map<String, dynamic> json) {
    return Counts(
      pending: json['pending'],
      active: json['active'],
      rejected: json['rejected'],
    );
  }
}

class RentalRequest {
  int? id;
  Customer? customer;
  Car? car;
  String? pickupDateFormatted;
  String? returnDateFormatted;
  String? pickupLocation;
  String? notes;
  String? status;

  RentalRequest({
    this.id,
    this.customer,
    this.car,
    this.pickupDateFormatted,
    this.returnDateFormatted,
    this.pickupLocation,
    this.notes,
    this.status,
  });

  factory RentalRequest.fromJson(Map<String, dynamic> json) {
    return RentalRequest(
      id: json['id'],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      car: json['car'] != null ? Car.fromJson(json['car']) : null,
      pickupDateFormatted: json['pickup_date_formatted'],
      returnDateFormatted: json['return_date_formatted'],
      pickupLocation: json['pickup_location'],
      notes: json['notes'],
      status: json['status'],
    );
  }
}

class Customer {
  String? fullName;

  Customer({this.fullName});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(fullName: json['full_name']);
  }
}

class Car {
  String? carName;
  String? featuredImageUrl;
  double? averageRating;
  int? seats;
  String? transmission;

  Car({
    this.carName,
    this.featuredImageUrl,
    this.averageRating,
    this.seats,
    this.transmission,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carName: json['car_name'],
      featuredImageUrl: json['featured_image_url'],
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      seats: json['seats'],
      transmission: json['transmission'],
    );
  }
}