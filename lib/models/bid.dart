import 'package:WSHCRD/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bid{

  double amount;
  String type;
  String ownerId;
  String storeName;
  GeoPoint storeLocation;
  String status;
  DateTime biddenAt;
  Request request;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["amount"] = amount;
    data["type"] = type;
    data["ownerId"] = ownerId;
    data["storeName"] = storeName;
    data["storeLocation"] = storeLocation;
    data["status"] = status;
    data["biddenAt"] = biddenAt??FieldValue.serverTimestamp();
    data["request"] = request.toJson();
    return data;
  }

  Bid();

  Bid.fromJson(Map<String, dynamic> json){
    this.amount = json["amount"] is int?(json["amount"] as int).toDouble():json["amount"];
    this.type = json["type"];
    this.ownerId = json["ownerId"];
    this.status = json["status"];
    this.storeName = json["storeName"];
    this.storeLocation = json["storeLocation"];
    this.biddenAt = (json["biddenAt"] as Timestamp).toDate();
    this.request = Request.fromJson(json["request"]);

  }

}