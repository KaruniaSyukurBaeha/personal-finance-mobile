class CreateResponse {
  final String message;
  CreateResponse({required this.message});
  factory CreateResponse.fromJson(Map<String, dynamic> json) {
    return CreateResponse(message: json['message']);
  }
}