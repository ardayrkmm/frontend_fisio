class UserModel {
  int Id;
  String nama;
  String email;
  String password;
  String role;
  String no_telepon;
  UserModel({
    required this.Id,
    required this.nama,
    required this.email,
    required this.password,
    required this.role,
    required this.no_telepon,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      Id: json['id'],
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      no_telepon: json['no_telepon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': Id,
      'nama': nama,
      'email': email,
      'password': password,
      'role': role,
      'no_telepon': no_telepon,
    };
  }
}
