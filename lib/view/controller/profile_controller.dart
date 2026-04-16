import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileController extends GetxController {
  var image = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    loadImage();
  }

  /// Pick Image
  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = File('${directory.path}/profile.png');

    final newImage = await File(picked.path).copy(imagePath.path);

    image.value = newImage;
  }

  /// Load Image
  Future loadImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = File('${directory.path}/profile.png');

    if (await imagePath.exists()) {
      image.value = imagePath;
    }
  }

  /// Delete Image
  Future deleteImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = File('${directory.path}/profile.png');

    if (await imagePath.exists()) {
      await imagePath.delete();
    }

    image.value = null;
  }
}
