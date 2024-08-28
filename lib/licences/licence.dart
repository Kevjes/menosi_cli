import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

String decryptLicenseKey(String encryptedKey) {
  final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
  
  final secretKey =
      "q7ZWbzTHU3V0zy4C";
  final key = encrypt.Key.fromUtf8(secretKey);
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final iv = encrypt.IV.fromLength(16); // Use a consistent IV for simplicity
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  final encryptedData = base64Url.decode(encryptedKey);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);
      // encrypter.decrypt64(String.fromCharCodes(encryptedData), iv: iv);

  return decrypted;
}

bool isLicenseValid(String decryptedLicense) {
  final licenseData = json.decode(decryptedLicense);

  final expiryDate = DateTime.parse(licenseData['expiry_date']);
  if (DateTime.now().isAfter(expiryDate)) {
    print("License has expired!");
    return false;
  }

  print("License is valid.");
  return true;
}
