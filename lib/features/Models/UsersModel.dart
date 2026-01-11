class UserModel {
  String? id;
  String? nama;
  String? email;
  String? password;
  String? role;
  String? noTelepon;

  UserModel({
    this.id,
    this.nama,
    this.email,
    this.password,
    this.role,
    this.noTelepon,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Gunakan .toString() dan tanda ? untuk keamanan
      id: json['id_user']?.toString(),
      nama: json['nama']?.toString(),
      email: json['email']?.toString(),
      password: json['password']?.toString(),
      role: json['role']?.toString(),
      noTelepon: json['no_telepon']?.toString(),
    );
  }
}
