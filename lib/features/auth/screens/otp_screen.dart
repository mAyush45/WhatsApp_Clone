import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';

import '../controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = 'otp-screen';
  final String verificationId;

  const OTPScreen({Key? key, required this.verificationId}) : super(key: key);

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          verificationId,
          userOTP,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Your Phone Number',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'We have sent an SMS with a code.',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(color: textColor),
                decoration: const InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(color: textColor, fontSize: 30),
                ),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if (val.length == 6) {
                    verifyOTP(ref, context, val.trim());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
