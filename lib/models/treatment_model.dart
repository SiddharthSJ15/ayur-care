import 'package:ayur_care/models/branch_model.dart';

class TreatmentModel {
  bool? status;
  String? message;
  List<Treatment>? treatments;

  TreatmentModel({this.status, this.message, this.treatments});

  TreatmentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['treatments'] != null) {
      treatments = <Treatment>[];
      json['treatments'].forEach((v) {
        treatments!.add(Treatment.fromJson(v));
      });
    }
  }
}

class Treatment {
  int? id;
  List<Branch>? branches;
  String? name;
  String? duration;
  String? price;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  Treatment({
    this.id,
    this.branches,
    this.name,
    this.duration,
    this.price,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  Treatment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['branches'] != null) {
      branches = <Branch>[];
      json['branches'].forEach((v) {
        branches!.add(Branch.fromJson(v));
      });
    }
    name = json['name'];
    duration = json['duration'];
    price = json['price'];
    isActive = json['is_active'];
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
  }
}
