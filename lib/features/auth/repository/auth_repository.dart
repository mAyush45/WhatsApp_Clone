import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whatsapp_clone/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/landing/screens/landing_screen.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  // void signInWithPhone(BuildContext context, String phoneNumber) async {
  //   try {
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await auth.signInWithCredential(credential);
  //       },
  //       verificationFailed: (e) {
  //         throw Exception(e.message);
  //       },
  //       codeSent: ((String verificationId, int? resendToken) async {
  //         Navigator.pushNamed(
  //           context,
  //           OTPScreen.routeName,
  //           arguments: verificationId,
  //         );
  //       }),
  //       codeAutoRetrievalTimeout: (String verificationId) {},
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context: context, content: e.message!);
  //   }
  // }
  // void verifyOTP({
  //   required BuildContext context,
  //   required String verificationId,
  //   required String userOTP,
  // }) async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: userOTP,
  //     );
  //
  //     // Sign in with the credential
  //     await auth.signInWithCredential(credential);
  //
  //     // Check if the user has signed up using the phone number before
  //     QuerySnapshot querySnapshot = await firestore
  //         .collection('users')
  //         .where('phoneNumber', isEqualTo: auth.currentUser!.phoneNumber)
  //         .get();
  //
  //     if (querySnapshot.docs.isNotEmpty) {
  //       // User has signed up before, get the UID of the previous user
  //       String uid = querySnapshot.docs.first.id;
  //
  //       // Update the UID of the current user to the previous UID
  //       await firestore
  //           .collection('users')
  //           .doc(auth.currentUser!.uid)
  //           .update({'uid': uid});
  //
  //       // Get the updated user data
  //       UserModel? user = await getCurrentUserData();
  //
  //       if (user != null) {
  //         // Navigate to the mobile layout screen with the updated user data
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => MobileLayoutScreen(
  //               user: user,
  //             ),
  //           ),
  //               (route) => false,
  //         );
  //         return;
  //       }
  //     }
  //
  //     // User is signing up for the first time, navigate to the user information screen
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       UserInformationScreen.routeName,
  //           (route) => false,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context: context, content: e.message!);
  //   }
  // }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        //Create a new credential
        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      await auth.signInWithCredential(credential);
        Navigator.pushNamedAndRemoveUntil(
          context,
          UserInformationScreen.routeName,
              (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  // void verifyOTP({
  //   required BuildContext context,
  //   required String verificationId,
  //   required String userOTP,
  // }) async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: userOTP,
  //     );
  //     await auth.signInWithCredential(credential);
  //     Navigator.pushNamedAndRemoveUntil(
  //       context,
  //       UserInformationScreen.routeName,
  //       (route) => false,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context: context, content: e.message!);
  //   }
  // }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required String phoneNumber,
    required ProviderRef ref,
    required BuildContext context,

  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseRepositoryStorageProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: phoneNumber,
      );

      await firestore.collection('users').doc(uid).set(user.toMap());

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MobileLayoutScreen(
            user: user,
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void updateUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      UserModel? currentUser = await getCurrentUserData();

      String updatedName;
      if (name != currentUser!.name) {
        updatedName = name;
      } else {
        updatedName = currentUser.name;
      }

      String updatedProfilePic = currentUser.profilePic;

      if (profilePic != null && profilePic.existsSync()) {
        updatedProfilePic = await ref
            .read(commonFirebaseRepositoryStorageProvider)
            .storeFileToFirebase(
          'profilePic/$uid',
          profilePic,
        );
      }

      if (updatedProfilePic.isEmpty) {
        updatedProfilePic = currentUser.profilePic;
      }

      var user = UserModel(
        name: updatedName,
        uid: uid,
        profilePic: updatedProfilePic,
        isOnline: currentUser.isOnline,
        phoneNumber: FirebaseAuth.instance.currentUser!.phoneNumber!,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(user.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      print(e.toString());
      showSnackBar(context: context, content: e.toString());
    }
  }




  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        LandingScreen.routeName,
            (route) => false,
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context: context, content: e.toString());
    }
  }
}


