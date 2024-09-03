import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:menosi_cli/licences/get_api_key.dart';

Future<bool> isLicenseValid() async {
  final expiredDate = await readExpirationDate();
  if (expiredDate == null || DateTime.now().isAfter(expiredDate)) {
    print("License has expired!");
    return await getExpirationDate();
  }
  print("License is valid.");
  return true;
}

Future<DateTime?> readExpirationDate() async {
  final file = File('licence.dat');

  try {
    if (await file.exists()) {
      final encodedDate = await file.readAsString();

      // Convertir les données binaires en chaîne de caractères
      final expirationDateString = decryptString(encodedDate);

      // Convertir la chaîne en DateTime
      final expirationDate = DateTime.parse(expirationDateString);

      return expirationDate;
    } else {
      print('No licence file found.');
      return null;
    }
  } catch (e) {
    print('Error occurred while reading the licence file: $e');
    return null;
  }
}

String encryptString(String plainText) {
  final keyBytes = utf8.encode("E3PpLwC9zA1FhG7yN0KqVtXjR5Ud2Sa8");
  final digest = sha256.convert(keyBytes).bytes;
  final encrypterKey = Key(Uint8List.fromList(digest.sublist(0, 32))); // Conversion en Uint8List
  final iv = IV.fromLength(16); // Initialisation vector (16 bytes)

  final encrypter = Encrypter(AES(encrypterKey));
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  return base64.encode(encrypted.bytes);
}

String decryptString(String encryptedText) {
  final keyBytes = utf8.encode("E3PpLwC9zA1FhG7yN0KqVtXjR5Ud2Sa8");
  final digest = sha256.convert(keyBytes).bytes;
  final encrypterKey = Key(Uint8List.fromList(digest.sublist(0, 32))); // Conversion en Uint8List
  final iv = IV.fromLength(16); // Initialisation vector (16 bytes)

  final encrypter = Encrypter(AES(encrypterKey));
  final encryptedBytes = base64.decode(encryptedText);
  final encrypted = Encrypted(encryptedBytes);

  return encrypter.decrypt(encrypted, iv: iv);
}