import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  String selectedCountryCode = '+91';
  bool isButtonDisabled = false;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void sendPhoneNumber()  {
    String phoneNumber = selectedCountryCode + phoneController.text;
    if (selectedCountryCode.isNotEmpty && phoneNumber.isNotEmpty) {
      setState(() {
        isButtonDisabled = true;
      });
      try {
        ref.read(authControllerProvider).signInWithPhone(context, phoneNumber);
        // Navigate to OTP screen or handle the logic as needed
      } catch (error) {
        // Handle the error if needed
      } finally {
        setState(() {
          isButtonDisabled = false;
        });
      }
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  void showCountryPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick Country'),
          content: CountryCodePicker(
            onChanged: (value) {
              setState(() {
                selectedCountryCode = value.dialCode!;
              });
              Navigator.pop(context); // Close the dialog
            },
            initialSelection: 'IN',
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter Your Phone Number',
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
      body: SingleChildScrollView(
        child: Container(
          height: size.height - MediaQuery.of(context).padding.top - kToolbarHeight,
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'WhatsApp will need to verify your phone number.',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  showCountryPickerDialog();
                },
                child: const Text(
                  'Pick Country',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedCountryCode.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 90,
                child: CustomButton(onPressed: sendPhoneNumber, text: 'NEXT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
