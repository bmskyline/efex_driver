import 'dart:convert';

import 'package:flutter/material.dart';

String statusToJson(List<Status> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Status {
  String trackingnumber;
  String status;
  String reason;

  Status({
    @required this.trackingnumber,
    @required this.status,
    @required this.reason,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    trackingnumber: json["Trackingnumber"],
    status: json["Status"],
    reason: json["Reason"],
  );

  Map<String, dynamic> toJson() => {
    "Trackingnumber": trackingnumber,
    "Status": status,
    "Reason": reason,
  };
}