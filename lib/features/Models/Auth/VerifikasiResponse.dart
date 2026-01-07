class VerifikasiResponse {
  final String message;

  VerifikasiResponse({required this.message});

  factory VerifikasiResponse.fromJson(Map<String, dynamic> json) {
    return VerifikasiResponse(
      message: json['message'],
    );
  }
}
