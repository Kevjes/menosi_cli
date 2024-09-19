String responsiveTemplate() {
  return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Responsive {
  // Récupère la largeur de l'écran
  static double screenWidth() {
    return Get.context!.width;
  }

  // Récupère la hauteur de l'écran
  static double screenHeight() {
    return Get.context!.height;
  }

  // Vérifie si l'écran est considéré comme petit (ex: mobile)
  static bool isSmallScreen() {
    return screenWidth() < 600;
  }

  // Vérifie si l'écran est considéré comme moyen (ex: petite tablette)
  static bool isMediumScreen() {
    return screenWidth() >= 600 && screenWidth() < 1200;
  }

  // Vérifie si l'écran est considéré comme grand (ex: grande tablette, desktop)
  static bool isLargeScreen() {
    return screenWidth() >= 1200;
  }

  // Calcule une largeur responsive basée sur un ratio et un offset facultatif
  static double responsiveWidth(double ratio, {double offset = 0.0}) {
    double width = screenWidth() * ratio;
    return width + offset;
  }

  // Calcule une hauteur responsive basée sur un ratio et un offset facultatif
  static double responsiveHeight(double ratio, {double offset = 0.0}) {
    double height = screenHeight() * ratio;
    return height + offset;
  }

  // Retourne une taille de police adaptée en fonction de la taille de l'écran
  static double responsiveFontSize(double baseSize) {
    if (isSmallScreen()) {
      return baseSize * 0.8;
    } else if (isMediumScreen()) {
      return baseSize * 1.0;
    } else {
      return baseSize * 1.2;
    }
  }

  // Gestion des marges/paddings responsives basées sur la taille de l'écran
  static double responsivePadding(double basePadding) {
    if (isSmallScreen()) {
      return basePadding * 0.8;
    } else if (isMediumScreen()) {
      return basePadding * 1.0;
    } else {
      return basePadding * 1.2;
    }
  }

  // Exemple de méthode spécifique : ajustement pour les marges de la toolbar sur différents écrans
  static double toolbarHeight() {
    if (isSmallScreen()) {
      return 50.0;
    } else if (isMediumScreen()) {
      return 56.0;
    } else {
      return 64.0;
    }
  }

  // Méthode pour gérer la taille des boutons en fonction de l'écran
  static Size buttonSize() {
    if (isSmallScreen()) {
      return Size(screenWidth() * 0.8, 48.0);
    } else if (isMediumScreen()) {
      return Size(screenWidth() * 0.6, 56.0);
    } else {
      return Size(screenWidth() * 0.4, 64.0);
    }
  }
}

''';
}
