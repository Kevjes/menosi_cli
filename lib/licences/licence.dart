import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:menosi_cli/licences/get_api_key.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../app/constants.dart';

String getSystemDirectory() {
  if (Platform.isWindows) {
    return Platform.environment['APPDATA'] ?? 'C:\\';
  } else if (Platform.isLinux || Platform.isMacOS) {
    return Platform.environment['HOME'] ?? '/';
  } else if (Platform.isIOS || Platform.isAndroid) {
    throw UnsupportedError(
        'Les systèmes mobiles ne sont pas supportés par ce script.');
  } else {
    throw UnsupportedError('Système d\'exploitation non supporté.');
  }
}

Future<bool> isLicenseValid() async {
  final expiredDate = await readExpirationDate();
  if (expiredDate == null || DateTime.now().isAfter(expiredDate)) {
    print("License has expired!");
    return await getExpirationDate();
  }
  final restOfDays = expiredDate.difference(DateTime.now()).inDays;
  print("${green}License is valid.$reset");
  print(
      "Rest of days : ${restOfDays > 5 ? "$green" : restOfDays > 1 ? "$yellow" : "$red"} $restOfDays$reset");
  return true;
}

Future<DateTime?> readExpirationDate() async {
  final encodedDate = await readLicenceFile();
  if (encodedDate != null && encodedDate.isNotEmpty) {
    final expirationDateString = decryptString(encodedDate);
    final expirationDate = DateTime.parse(expirationDateString);
    return expirationDate;
  } else {
    print('No licence file found.');
    return null;
  }
}

String encryptString(String plainText) {
  final keyBytes = utf8.encode("E3PpLwC9zA1FhG7yN0KqVtXjR5Ud2Sa8");
  final digest = sha256.convert(keyBytes).bytes;
  final encrypterKey =
      Key(Uint8List.fromList(digest.sublist(0, 32))); // Conversion en Uint8List

  final iv = IV.fromSecureRandom(16); // Génère un IV aléatoire

  final encrypter = Encrypter(AES(encrypterKey));
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  // Combine l'IV et les données chiffrées
  final combined = iv.bytes + encrypted.bytes;

  return base64.encode(combined);
}

String decryptString(String encryptedText) {
  final keyBytes = utf8.encode("E3PpLwC9zA1FhG7yN0KqVtXjR5Ud2Sa8");
  final digest = sha256.convert(keyBytes).bytes;
  final encrypterKey =
      Key(Uint8List.fromList(digest.sublist(0, 32))); // Conversion en Uint8List

  final combined = base64.decode(encryptedText);

  // Sépare l'IV des données chiffrées
  final iv = IV(Uint8List.fromList(combined.sublist(0, 16)));
  final encryptedBytes = combined.sublist(16);

  final encrypter = Encrypter(AES(encrypterKey));
  final encrypted = Encrypted(Uint8List.fromList(encryptedBytes));

  return encrypter.decrypt(encrypted, iv: iv);
}

Future<void> saveLicenceFile(String content) async {
  final directory = getSystemDirectory();
  final folderName = '.menosi_cli';
  final folderPath = path.join(directory, folderName);

  // Crée le dossier s'il n'existe pas
  final folder = Directory(folderPath);
  if (!folder.existsSync()) {
    folder.createSync();
  }
  final filePath = path.join(folderPath, 'licence');
  final file = File(filePath);
  await file.writeAsString(content);

  print('Fichier licence.dat sauvegardé à : $filePath');
}

Future<String?> readLicenceFile() async {
  final directory = getSystemDirectory();
  final folderName = '.menosi_cli';
  final filePath = path.join(directory, folderName, 'licence');

  final file = File(filePath);

  if (await file.exists()) {
    return await file.readAsString();
  } else {
    print('Le fichier licence n\'existe pas.');
    return null;
  }
}
