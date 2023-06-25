import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/info.dart';
import 'package:whatsapp_clone/screens/mobile_chat_screen.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: info.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MobileChatScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(info[index]['profilePic']!.toString()),
                      ),
                      title: Text(
                        info[index]['name'].toString(),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(info[index]['message'].toString(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white60))),
                      trailing: Text(
                        info[index]['time'].toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: dividerColor,
                  indent: 85,
                )
              ],
            );
          }),
    );
  }
}
