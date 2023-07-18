import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);

        // Filter out duplicates based on contact name
        List<Contact> uniqueContacts = [];
        Set<String> seenNames = {};

        for (var contact in contacts) {
          if (!seenNames.contains(contact.displayName)) {
            uniqueContacts.add(contact);
            seenNames.add(contact.displayName);
          }
        }

        contacts = uniqueContacts;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      List<Contact> matchingContacts = [];

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());

        String selectedPhoneNum = selectedContact.phones[0].number;

        // Remove all spaces and dashes from the phone number
        selectedPhoneNum = selectedPhoneNum.replaceAll(' ', '').replaceAll('-', '');

        // Check if the phone number is a 10-digit number without the country code
        if (selectedPhoneNum.length == 10 && !selectedPhoneNum.startsWith('+91') && !selectedPhoneNum.startsWith('0')) {
          selectedPhoneNum = '+91$selectedPhoneNum'; // Add +91 prefix
        }

        // Check if the phone number starts with 0 and has 10 digits
        if (selectedPhoneNum.length == 11 && selectedPhoneNum.startsWith('0')) {
          selectedPhoneNum = '+91${selectedPhoneNum.substring(1)}'; // Remove 0 and add +91 prefix
        }

        // Perform any other necessary formatting or validation for phone numbers

        if (selectedPhoneNum == userData.phoneNumber) {
          if (selectedPhoneNum.startsWith('+91')) {
            matchingContacts.add(selectedContact);
          }
        }
      }

      if (matchingContacts.length == 1) {
        var selectedContact = matchingContacts[0];
        var userData = UserModel.fromMap(userCollection.docs[0].data());

        Navigator.pushNamed(
          context,
          MobileChatScreen.routeName,
          arguments: {
            'name': userData.name,
            'uid': userData.uid,
            'isGroupChat': false,
          },
        );
      } else {
        showSnackBar(
          context: context,
          content: 'This number does not exist on this app or is not unique.',
        );
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
