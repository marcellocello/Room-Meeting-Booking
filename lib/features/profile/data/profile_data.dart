class ProfileData {
  final String name;
  final String email;
  final String? imageUrl;

  ProfileData({required this.name, required this.email, this.imageUrl});
}

abstract class ProfileMockData {
  static Future<ProfileData> fetch() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return ProfileData(
      name: 'Alex Jhonson',
      email: 'admin@gmail.com',
    );
  }
}