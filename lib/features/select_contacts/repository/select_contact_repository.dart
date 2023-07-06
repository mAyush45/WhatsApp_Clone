import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

import '../screens/select_contacts_screen.dart';

final selectContactsRepositoryProvider = Provider((ref) =>
    SelectContactRepository(firebaseFirestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firebaseFirestore;

  SelectContactRepository({required this.firebaseFirestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );

        // Filter out duplicate contacts based on display name
        contacts = contacts.fold<List<Contact>>([], (previous, current) {
          if (!previous.any((c) => c.displayName == current.displayName)) {
            previous.add(current);
          }
          return previous;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  // void selectContact(Contact selectedContact, BuildContext context) async {
  //   try {
  //     var userCollection = await firebaseFirestore.collection('users').get();
  //     bool isFound = false;
  //     for (var document in userCollection.docs) {
  //       var userData = UserModel.fromMap(document.data());
  //       String selectedPhoneNumber =
  //           selectedContact.phones[0].number.replaceAll(' ', '');
  //       if (selectedPhoneNumber == userData.phoneNumber) {
  //         isFound = true;
  //         Navigator.pushNamed(context, MobileChatScreen.routeName,
  //             arguments: {'name': userData.name, 'uid': userData.uid});
  //       }
  //     }
  //     if (!isFound) {
  //       showSnackBar(context: context, content: 'This number is not found');
  //     }
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  // }


  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firebaseFirestore.collection('users').get();
      List<UserModel> matchingUsers = [];

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());

        String selectedPhoneNumber = selectedContact.phones[0].number.replaceAll(' ', '').replaceAll('-', '');
        String normalizedPhoneNumber = userData.phoneNumber.replaceAll(' ', '');

        if (!normalizedPhoneNumber.startsWith('+')) {
          normalizedPhoneNumber = '+91$normalizedPhoneNumber'; // Assume India country code (+91) if not present
        }

        if (selectedPhoneNumber == normalizedPhoneNumber) {
          matchingUsers.add(userData);
        }
      }

      if (matchingUsers.isEmpty) {
        showSnackBar(context: context, content: 'This number is not found');
      } else if (matchingUsers.length == 1) {
        Navigator.pushNamed(context, MobileChatScreen.routeName,
            arguments: {'name': matchingUsers[0].name, 'uid': matchingUsers[0].uid});
      } else {
        // Multiple matching contacts found, handle the selection logic in the UI
        // Pass the list of matching contacts to the SelectContactsScreen
        Navigator.pushNamed(
          context,
          SelectContactsScreen.routeName,
          arguments: {'matchingUsers': matchingUsers},
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }


}
