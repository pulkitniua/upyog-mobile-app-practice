import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Function to get access token from secure storage
  Future<String> getAccessToken() async {
    const  storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'access_token');
    return token ?? '';  // Handle null case
  }

  // Function to store the token if needed
  Future<void> saveAccessToken(String token) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'access_token', value: token);
  }
}