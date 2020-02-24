import 'dart:convert';

String statusToJson(List<Status> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Status {
  String trackingNumber;
  String status;
  String reason;

  Status(this.trackingNumber, this.status, this.reason);

  Map<String, dynamic> toJson() => {
        "Trackingnumber": trackingNumber,
        "Status": status,
        "Reason": reason,
      };
}
