import 'package:app_demo_firebase/constants/firebase.dart';
import 'package:app_demo_firebase/helpers/showLoading.dart';
import 'package:app_demo_firebase/models/user.dart';
import 'package:app_demo_firebase/screens/authentication/auth.dart';
import 'package:app_demo_firebase/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  RxBool isLoggedIn = false.obs;
  Rx<User> firebaseUser;
  Rx<UserModel> userModel = UserModel().obs;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String userCollection = 'users';

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User user) {
    if (user == null) {
      Get.offAll(() => AuthenticationScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  void signIn() async {
    showLoading();
    try {
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        String _userId = result.user.uid;
        _initializeUserModel(_userId);
        _clearControllers();
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Sign In Failed', 'Try again');
    }
  }

  void signUp() async {
    showLoading();
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        String _userId = result.user.uid;
        _addUserToFirestore(_userId);
        _initializeUserModel(_userId);
        _clearControllers();
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Sign Up Failed', 'Try again');
    }
  }

  void signOut() async {
    auth.signOut();
  }

  _addUserToFirestore(String userId) {
    firebaseFirestore.collection(userCollection).doc(userId).set({
      "name": name.text.trim(),
      "id": userId,
      "email": email.text.trim(),
    });
  }

  _initializeUserModel(String userId) async {
    userModel.value = await firebaseFirestore
        .collection(userCollection)
        .doc(userId)
        .get()
        .then((doc) => UserModel.fromSnapshot(doc));
  }

  _clearControllers() {
    name.clear();
    email.clear();
    password.clear();
  }
}
