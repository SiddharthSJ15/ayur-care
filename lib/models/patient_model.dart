import 'package:ayur_care/models/branch_model.dart';

class AyurModel {
  final bool? status;
  final String? message;
  final List<PatientModel>? patient;

  AyurModel({this.status, this.message, this.patient});
}

class PatientModel {
  final int? id;
  final List<PatientdetailsSet>? patientdetailsSet;
  final BranchModel? branch;
  final String? user;
  final String? payment;
  final String? name;
  final String? phone;
  final String? address;
  final dynamic price;
  final int? totalAmount;
  final int? discountAmount;
  final int? advanceAmount;
  final int? balanceAmount;
  final dynamic dateNdTime;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PatientModel({
    this.id,
    this.patientdetailsSet,
    this.branch,
    this.user,
    this.payment,
    this.name,
    this.phone,
    this.address,
    this.price,
    this.totalAmount,
    this.discountAmount,
    this.advanceAmount,
    this.balanceAmount,
    this.dateNdTime,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });
}

class PatientdetailsSet {
  final int? id;
  final String? male;
  final String? female;
  final int? patient;
  final int? treatment;
  final String? treatmentName;

  PatientdetailsSet({
    this.id,
    this.male,
    this.female,
    this.patient,
    this.treatment,
    this.treatmentName,
  });
}
