import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';

import '../../../models/user_model.dart';
import '../controller/auth_controller.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  static const routeName = '/my-profile';
  final UserModel? user;

  const MyProfileScreen({required this.user, super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _profilePicUrl; // Changed from File? to String?
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Get the initial user data
    ref.read(authControllerProvider).getUserData().then((user) {
      if (user != null) {
        _nameController.text = user.name;
        // Set the initial profile picture URL
        setState(() {
          _profilePicUrl = user.profilePic; // Store the URL directly
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  Future<void> signOut() async {
    await ref.read(authControllerProvider).signOut(context);
  }

  Future<void> _selectImage() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profilePicUrl = pickedImage.path; // Store the local file path
      });
    }
  }

  void _updateProfile() {
    final String name = _nameController.text.trim();
    ref.read(authControllerProvider).updateUserDataToFirebase(
          context,
          name,
          File(_profilePicUrl!), // Pass File if _profilePicUrl is not null
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Profile'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Stack(
                children: [
                  _profilePicUrl !=
                          null // Check if _profilePicUrl is a URL or a local file path
                      ? CircleAvatar(
                          backgroundImage: _profilePicUrl!.startsWith('http')
                              ? NetworkImage(_profilePicUrl!)
                              : FileImage(File(_profilePicUrl!))
                                  as ImageProvider<Object>?,
                          radius: 64,
                        )
                      : const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                          ),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: _selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: size.width * 0.9,
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      hintText: 'Enter your name', labelText: 'Username'),
                ),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(tabColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Change the border radius to make it rounded
                    ),
                  ),
                ),
                onPressed: _updateProfile,
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(tabColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Change the border radius to make it rounded
                    ),
                  ),
                ),
                onPressed: signOut,
                child: const Text(
                  'Sign out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
