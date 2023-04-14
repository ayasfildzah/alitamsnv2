import 'dart:convert';

List<Complaint> modelComplaintFromJson(String str) =>
    List<Complaint>.from(json.decode(str).map((x) => Complaint.fromJson(x)));
String modelComplaintToJson(List<Complaint> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Complaint {
  int id;
  String name;
  String notlpn;
  String size;
  String nosp;
  Brand brand;
  int area;
  ProductType producttype;
  Images img;
  String created;
  String creator;
  String status;
  String complaint;
  String category;
  String complaintstatuses;
  int complaintid;
  String address;
  String note;

  Complaint(
      {required this.id,
      required this.name,
      required this.notlpn,
      required this.nosp,
      required this.size,
      required this.brand,
      required this.area,
      required this.producttype,
      required this.img,
      required this.created,
      required this.creator,
      required this.status,
      required this.complaint,
      required this.category,
      required this.complaintstatuses,
      required this.complaintid,
      required this.address,
      required this.note});
  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
      id: json["id"],
      name: json["name"],
      notlpn: json["no_tlpn"],
      nosp: json["no_sp"],
      size: json["size"],
      brand: Brand.fromJson(json["brand"]),
      area: json["area_id"],
      producttype: ProductType.fromJson(json["product_type"]),
      created: json["created_at"],
      img: Images.fromJson(json["image"]),
      creator: json["creator"],
      status: json["status"],
      complaint: json["complaint"],
      category: json["category"],
      complaintstatuses: json["complaint_statuses"],
      complaintid: json["complaint_statuses_id"],
      address: json["address"],
      note: json["note"]);
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "no_tlpn": notlpn,
        "no_sp": nosp,
        "brand": brand.toJson(),
        "area": area,
        "product_type": producttype.toJson(),
        "image": img.toJson(),
        "created_at": created,
        "creator": creator,
        "status": status,
        "complaint": complaint,
        "category": category,
        "complaint_statuses": complaintstatuses,
        "complaint_statuses_id": complaintid,
        "address": address,
        "note": note
      };
}

class Brand {
  String namebrand;

  Brand({required this.namebrand});
  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        namebrand: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "name": namebrand,
      };
}

class ProductType {
  String productname;

  ProductType({required this.productname});
  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
        productname: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "name": productname,
      };
}

class Images {
  String url;

  Images({required this.url});
  factory Images.fromJson(Map<String, dynamic> json) => Images(
        url: json["url"],
      );
  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
