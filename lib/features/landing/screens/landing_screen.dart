import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';

import '../../../common/utils/utils.dart';
import '../../auth/controller/auth_controller.dart';

class LandingScreen extends ConsumerStatefulWidget {
  static const routeName = '/landing-screen';

  const LandingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  // void navigateToLoginScreen(BuildContext context) {
  //   Navigator.pushNamed(context, LoginScreen.routeName);
  // }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await ref.read(authControllerProvider).signInWithGoogle(context);
      var user = await ref.read(authControllerProvider).getUserData();
      // if(user!= null){
      //   Navigator.pushNamed(context, MobileLayoutScreen.routeName, arguments: user);
      // }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Welcome to WhatsApp X',
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: size.height / 9),
                Image.asset(
                  'assets/bg.png',
                  height: 340,
                  width: 340,
                  color: Colors.blue,
                ),
                SizedBox(height: size.height / 9),

                const SizedBox(height: 10),

                SignInButton(
                  elevation: 10,
                  Buttons.Google,
                  text: "Sign up with Google",
                  onPressed: () => signInWithGoogle(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
