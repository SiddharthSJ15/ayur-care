import 'package:ayur_care/models/branch_model.dart';

class AyurModel {
  bool? status;
  String? message;
  List<PatientModel>? patient;

  AyurModel({this.status, this.message, this.patient});

  AyurModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['patient'] != null) {
      patient = <PatientModel>[];
      json['patient'].forEach((v) {
        patient!.add(PatientModel.fromJson(v));
      });
    }
  }
}

class PatientModel {
  int? id;
  List<PatientdetailsSet>? patientdetailsSet;
  BranchModel? branch;
  String? user;
  String? payment;
  String? name;
  String? phone;
  String? address;
  dynamic price;
  int? totalAmount;
  int? discountAmount;
  int? advanceAmount;
  int? balanceAmount;
  dynamic dateNdTime;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

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

  PatientModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['patientdetails_set'] != null) {
      patientdetailsSet = <PatientdetailsSet>[];
      json['patientdetails_set'].forEach((v) {
        patientdetailsSet!.add(PatientdetailsSet.fromJson(v));
      });
    }
    branch = json['branch'] != null
        ? BranchModel.fromJson(json['branch'])
        : null;
    user = json['user'];
    payment = json['payment'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    price = json['price'];
    totalAmount = json['total_amount'];
    discountAmount = json['discount_amount'];
    advanceAmount = json['advance_amount'];
    balanceAmount = json['balance_amount'];
    dateNdTime = json['date_nd_time'];
    isActive = json['is_active'];
    createdAt = json['created_at'] != null
        ? DateTime.tryParse(json['created_at'])
        : null;
    updatedAt = json['updated_at'] != null
        ? DateTime.tryParse(json['updated_at'])
        : null;
  }
}

class PatientdetailsSet {
  int? id;
  String? male;
  String? female;
  int? patient;
  int? treatment;
  String? treatmentName;

  PatientdetailsSet({
    this.id,
    this.male,
    this.female,
    this.patient,
    this.treatment,
    this.treatmentName,
  });

  PatientdetailsSet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    male = json['male'];
    female = json['female'];
    patient = json['patient'];
    treatment = json['treatment'];
    treatmentName = json['treatmentName'];
  }
}
