import 'package:image_picker/image_picker.dart';

class FormValidator {
  // Valide la sélection de l'image
  static String? validateImage(XFile? imageFile) {
    if (imageFile == null) {
      return 'Vous devez choisir une image';
    }
    return null;
  }
}
