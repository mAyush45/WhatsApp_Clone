import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';

class WebSearchBar extends StatelessWidget {
  const WebSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      width: MediaQuery.of(context).size.width * 0.25,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: dividerColor))),
      child: Center(
        child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: searchBarColor,
                prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.search,
                      color: Colors.white70,
                    )),
                hintStyle: const TextStyle(fontSize: 15, color: Colors.white70),
                hintText: 'Search',
                border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(20)),
              contentPadding: EdgeInsets.all(15)
            ),
            ),
      ),
    );
  }
}
