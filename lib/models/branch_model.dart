class BranchModel {
    final bool? status;
    final String? message;
    final List<Branch>? branches;

    BranchModel({
        this.status,
        this.message,
        this.branches,
    });

}

class Branch {
    final int? id;
    final String? name;
    final int? patientsCount;
    final String? location;
    final String? phone;
    final String? mail;
    final String? address;
    final String? gst;
    final bool? isActive;

    Branch({
        this.id,
        this.name,
        this.patientsCount,
        this.location,
        this.phone,
        this.mail,
        this.address,
        this.gst,
        this.isActive,
    });

}
