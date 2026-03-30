class FineInvoiceModel {
  String? totalOutstanding;
  int? pendingCount;
  int? paidCount;
  List<Fine>? fines;

  FineInvoiceModel({this.totalOutstanding, this.pendingCount, this.paidCount, this.fines});

  FineInvoiceModel.fromJson(Map<String, dynamic> json) {
    totalOutstanding = json['total_outstanding'];
    pendingCount = json['pending_count'];
    paidCount = json['paid_count'];
    if (json['fines'] != null) {
      fines = <Fine>[];
      json['fines'].forEach((v) {
        fines!.add(Fine.fromJson(v));
      });
    }
  }
}

class Fine {
  int? id;
  String? fineType;
  String? reason;
  String? amount;
  String? dueDate;
  String? status;
  String? invoiceUrl;
  String? vehicleName;
  String? bookingId;

  Fine({
    this.id,
    this.fineType,
    this.reason,
    this.amount,
    this.dueDate,
    this.status,
    this.invoiceUrl,
    this.vehicleName,
    this.bookingId,
  });

  Fine.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fineType = json['fine_type'];
    reason = json['reason'];
    amount = json['amount'];
    dueDate = json['due_date'];
    status = json['status'];
    invoiceUrl = json['invoice_url'];
    vehicleName = json['vehicle_name'];
    bookingId = json['booking_id'].toString(); // Ensure it's a string
  }

  // Helper to make "speeding_violation" look like "Speeding Violation"
  String get formattedType {
    if (fineType == null) return "Fine";
    return fineType!
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}