class CarsModel {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  CarsModel({this.count, this.next, this.previous, this.results});

  CarsModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  String? carName;
  String? category;
  String? pricePerDay;
  String? transmission;
  String? fuelType;
  int? seats;
  int? doors;
  String? featuredImageUrl;
  String? agencyName;
  String? agencyLocation;
  double? averageRating;
  int? totalReviews;

  Results({
    this.id,
    this.carName,
    this.category,
    this.pricePerDay,
    this.transmission,
    this.fuelType,
    this.seats,
    this.doors,
    this.featuredImageUrl,
    this.agencyName,
    this.agencyLocation,
    this.averageRating,
    this.totalReviews,
  });

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carName = json['car_name'];
    category = json['category'];
    pricePerDay = json['price_per_day'];
    transmission = json['transmission'];
    fuelType = json['fuel_type'];
    seats = json['seats'];
    doors = json['doors'];
    featuredImageUrl = json['featured_image_url'];
    agencyName = json['agency_name'];
    agencyLocation = json['agency_location'];
    averageRating = json['average_rating'];
    totalReviews = json['total_reviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['car_name'] = this.carName;
    data['category'] = this.category;
    data['price_per_day'] = this.pricePerDay;
    data['transmission'] = this.transmission;
    data['fuel_type'] = this.fuelType;
    data['seats'] = this.seats;
    data['doors'] = this.doors;
    data['featured_image_url'] = this.featuredImageUrl;
    data['agency_name'] = this.agencyName;
    data['agency_location'] = this.agencyLocation;
    data['average_rating'] = this.averageRating;
    data['total_reviews'] = this.totalReviews;
    return data;
  }
}
