class AgentDashboardModel {
  String? todaysRevenue;
  int? pendingBookings;
  int? todayActive;
  // List<Null>? todaysCheckin;
  // List<Null>? todaysCheckout;

  AgentDashboardModel({
    this.todaysRevenue,
    this.pendingBookings,
    this.todayActive,

    // this.todaysCheckin,
    // this.todaysCheckout
  });

  AgentDashboardModel.fromJson(Map<String, dynamic> json) {
    todaysRevenue = json['todays_revenue'];
    pendingBookings = json['pending_bookings'];
    todayActive = json['today_active'];
    // if (json['todays_checkin'] != null) {
    //   todaysCheckin = <Null>[];
    //   json['todays_checkin'].forEach((v) {
    //     todaysCheckin!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['todays_checkout'] != null) {
    //   todaysCheckout = <Null>[];
    //   json['todays_checkout'].forEach((v) {
    //     todaysCheckout!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['todays_revenue'] = this.todaysRevenue;
    data['pending_bookings'] = this.pendingBookings;
    data['today_active'] = this.todayActive;
    // if (this.todaysCheckin != null) {
    //   data['todays_checkin'] =
    //       this.todaysCheckin!.map((v) => v.toJson()).toList();
    // }
    // if (this.todaysCheckout != null) {
    //   data['todays_checkout'] =
    //       this.todaysCheckout!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
