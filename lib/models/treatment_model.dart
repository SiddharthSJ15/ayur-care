import 'package:ayur_care/models/branch_model.dart';

class TreatmentModel {
  final bool? status;
  final String? message;
  final List<Treatment>? treatments;

  TreatmentModel({this.status, this.message, this.treatments});
}

class Treatment {
  final int? id;
  final List<Branch>? branches;
  final String? name;
  final String? duration;
  final String? price;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
}
