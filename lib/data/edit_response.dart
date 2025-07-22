class EditResponse {
  final String message;
  final bool status;

  EditResponse({required this.message, required this.status});

  factory EditResponse.fromJson(Map<String, dynamic> json) {
    return EditResponse(
      message: json['message'] ?? '', 
      status: json['status'] ?? true,
    );
  }
}