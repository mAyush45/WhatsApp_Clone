import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/error.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contact_controller.dart';

import '../../../colors.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName = '/select--contact';

  const SelectContactsScreen({Key? key}) : super(key: key);

  void selectContact(WidgetRef ref, Contact selectedContact,
      BuildContext context) {
    ref.read(selectContactControllerProvider).selectContact(
        selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Select Contact',
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_outlined, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactList) =>
              ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(ref, contact, context),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: ListTile(
                        leading: contact.photo == null
                            ? const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                          ),
                        )
                            : CircleAvatar(
                          backgroundImage: MemoryImage(contact.photo!),
                        ),
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => const Loader()),
    );
  }
}
