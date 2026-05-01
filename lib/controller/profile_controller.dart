import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileController extends GetxController {
  var image = Rx<File?>(null);

  // 👇 USER DATA (FROM FIREBASE)
  var firstName = "".obs;
  var lastName = "".obs;
  var email = "".obs;

  String get fullName => "${firstName.value} ${lastName.value}";

  @override
  void onInit() {
    super.onInit();
    loadUserData(); // 🔥 load firebase data
    loadImage();
  }

  /// =========================
  /// 🔥 LOAD USER FROM FIREBASE
  /// =========================
  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data();

      final fullName = data?["name"] ?? "";

      firstName.value = fullName.split(" ").isNotEmpty
          ? fullName.split(" ").first
          : "";
      lastName.value = fullName.split(" ").length > 1
          ? fullName.split(" ").last
          : "";

      email.value = data?["email"] ?? "";
    }
  }

  /// =========================
  /// UPDATE PROFILE (UI + FIREBASE)
  /// =========================
  Future<void> updateProfile({
    required String fName,
    required String lName,
    required String mail,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final fullName = "$fName $lName";

    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "name": fullName,
      "email": mail,
    });

    firstName.value = fName;
    lastName.value = lName;
    email.value = mail;
  }

  /// =========================
  /// PICK IMAGE
  /// =========================
  Future pickImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = File('${directory.path}/profile_${user.uid}.png');

    final newImage = await File(picked.path).copy(imagePath.path);
    image.value = newImage;
  }

  /// =========================
  /// LOAD IMAGE
  /// =========================
  Future loadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = File('${directory.path}/profile_${user.uid}.png');

    if (await imagePath.exists()) {
      image.value = imagePath;
    } else {
      image.value = null; // Ensure it's null if file doesn't exist for this user
    }
  }

  /// =========================
  /// DELETE IMAGE
  /// =========================
  Future deleteImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = File('${directory.path}/profile_${user.uid}.png');

    if (await imagePath.exists()) {
      await imagePath.delete();
    }

    image.value = null;
  }
}
