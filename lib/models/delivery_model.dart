class DeliveryModel {
  final int id;
  final String status;
  final String delivered_at;
  final String received_at;
  final String created_at;
  final String updated_at;
  final int residence_id;
  final String admin_id;
  final String admin_email;

  DeliveryModel({
    required this.id,
    required this.status,
    required this.delivered_at,
    required this.received_at,
    required this.created_at,
    required this.updated_at,
    required this.residence_id,
    required this.admin_id,
    required this.admin_email,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      status: json['status'],
      delivered_at: json['delivered_at'],
      received_at: json['received_at'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      residence_id: json['residence_id'],
      admin_id: json['admin_id'],
      admin_email: json['admin_email'],
    );
  }
}
