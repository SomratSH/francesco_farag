class CheckInBookingModel {
  List<Booking>? bookings;

  CheckInBookingModel({this.bookings});

  CheckInBookingModel.fromJson(Map<String, dynamic> json) {
    if (json['bookings'] != null) {
      bookings = <Booking>[];
      json['bookings'].forEach((v) {
        bookings!.add(Booking.fromJson(v));
      });
    }
  }
}

class Booking {
  int? id;
  Customer? customer;
  String? vehicle;
  String? pickupDate;
  String? returnDate;
  String? location;
  String? agent;

  Booking({
    this.id,
    this.customer,
    this.vehicle,
    this.pickupDate,
    this.returnDate,
    this.location,
    this.agent,
  });

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    vehicle = json['vehicle'];
    pickupDate = json['pickup_date'];
    returnDate = json['return_date'];
    location = json['location'];
    agent = json['agent'];
  }
}

class Customer {
  String? fullName;
  String? email;
  String? phoneNumber;

  Customer({this.fullName, this.email, this.phoneNumber});

  Customer.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
  }
}
