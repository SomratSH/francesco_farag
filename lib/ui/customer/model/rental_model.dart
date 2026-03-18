class RentalRequest {
  final int id;
  final int carId;
  final CarDetails carDetails;
  final int customerId;
  final String customerName;
  final String customerEmail;
  final String pickupDate;
  final String returnDate;
  final int totalDays;
  final List<SelectedService> selectedServices;
  final String? notes;
  final String status;
  final String paymentStatus;
  final String createdAt;
  final Quotation? quotation;

  RentalRequest({
    required this.id,
    required this.carId,
    required this.carDetails,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.pickupDate,
    required this.returnDate,
    required this.totalDays,
    required this.selectedServices,
    this.notes,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    this.quotation,
  });

  factory RentalRequest.fromJson(Map<String, dynamic> json) {
    return RentalRequest(
      id: json['id'],
      carId: json['car'],
      carDetails: CarDetails.fromJson(json['car_details']),
      customerId: json['customer'],
      customerName: json['customer_name'] ?? "",
      customerEmail: json['customer_email'] ?? "",
      pickupDate: json['pickup_date'],
      returnDate: json['return_date'],
      totalDays: json['total_days'] ?? 0,
      selectedServices: (json['selected_services'] as List)
          .map((i) => SelectedService.fromJson(i))
          .toList(),
      notes: json['notes'],
      status: json['status'] ?? 'pending',
      paymentStatus: json['payment_status'] ?? 'pending',
      createdAt: json['created_at'],
      quotation: json['quotation'] != null 
          ? Quotation.fromJson(json['quotation']) 
          : null,
    );
  }
}

class CarDetails {
  final int id;
  final String carName;
  final String category;
  final String pricePerDay;
  final String transmission;
  final String fuelType;
  final int seats;
  final int doors;
  final String? imageUrl;
  final String agencyName;
  final String agencyLocation;
  final double averageRating;
  final int totalReviews;

  CarDetails({
    required this.id,
    required this.carName,
    required this.category,
    required this.pricePerDay,
    required this.transmission,
    required this.fuelType,
    required this.seats,
    required this.doors,
    this.imageUrl,
    required this.agencyName,
    required this.agencyLocation,
    required this.averageRating,
    required this.totalReviews,
  });

  factory CarDetails.fromJson(Map<String, dynamic> json) {
    return CarDetails(
      id: json['id'],
      carName: json['car_name'],
      category: json['category'],
      pricePerDay: json['price_per_day'],
      transmission: json['transmission'],
      fuelType: json['fuel_type'],
      seats: json['seats'],
      doors: json['doors'],
      imageUrl: json['featured_image_url'],
      agencyName: json['agency_name'] ?? "Unknown Agency",
      agencyLocation: json['agency_location'] ?? "No Location Provided",
      averageRating: (json['average_rating'] as num).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
    );
  }
}

class SelectedService {
  final int id;
  final String name;
  final String pricePerDay;

  SelectedService({required this.id, required this.name, required this.pricePerDay});

  factory SelectedService.fromJson(Map<String, dynamic> json) {
    return SelectedService(
      id: json['id'],
      name: json['name'],
      pricePerDay: json['price_per_day'],
    );
  }
}

class Quotation {
  final int id;
  final String basePrice;
  final String insuranceCost;
  final String extraServicesCost;
  final String subtotal;
  final String vatPercentage;
  final String vatAmount;
  final String discountAmount;
  final String securityDeposit;
  final String totalPrice;
  final String? notesForCustomer;
  final String status;

  Quotation({
    required this.id,
    required this.basePrice,
    required this.insuranceCost,
    required this.extraServicesCost,
    required this.subtotal,
    required this.vatPercentage,
    required this.vatAmount,
    required this.discountAmount,
    required this.securityDeposit,
    required this.totalPrice,
    this.notesForCustomer,
    required this.status,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      id: json['id'],
      basePrice: json['base_price'] ?? "0.00",
      insuranceCost: json['insurance_cost'] ?? "0.00",
      extraServicesCost: json['extra_services_cost'] ?? "0.00",
      subtotal: json['subtotal'] ?? "0.00",
      vatPercentage: json['vat_percentage'] ?? "0.00",
      vatAmount: json['vat_amount'] ?? "0.00",
      discountAmount: json['discount_amount'] ?? "0.00",
      securityDeposit: json['security_deposit'] ?? "0.00",
      totalPrice: json['total_price'] ?? "0.00",
      notesForCustomer: json['notes_for_customer'],
      status: json['status'] ?? 'draft',
    );
  }
}