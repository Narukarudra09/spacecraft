import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/provider/auth_provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool _hasChanges = false;

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();

    final info = statuses[Permission.camera].toString();
    print(info);
  }

  Future<void> pickImage(ImageSource source) async {
    await requestPermissions();
    final XFile? pickedFile = await _picker.pickImage(source: source);
    print(pickedFile);
    if (pickedFile != null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateProfilePicture(pickedFile.path);
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_hasChanges) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text(
                'You have unsaved changes. Do you want to discard them?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  authProvider.updateTempProfile(authProvider.profile);
                  setState(() {
                    _hasChanges = false;
                  });
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );
      return shouldPop ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final profile = authProvider.tempProfile;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: profile.profilePicture.isEmpty
                                ? const AssetImage('assets/profile.jpeg')
                                    as ImageProvider
                                : FileImage(File(profile.profilePicture)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.camera),
                                        title: const Text('Camera'),
                                        onTap: () {
                                          pickImage(ImageSource.camera);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.photo_library),
                                        title: const Text('Gallery'),
                                        onTap: () {
                                          pickImage(ImageSource.gallery);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Color.fromARGB(255, 21, 27, 31),
                                child:
                                    Icon(Icons.camera_alt, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: GoogleFonts.montserrat(color: Colors.white),
                      initialValue: profile.fullName,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: GoogleFonts.montserrat(
                            color: const Color(0xFFF5F5DC),
                            fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 21, 27, 31),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter your full name'
                          : null,
                      onChanged: (value) {
                        authProvider.updateTempProfile(
                          profile.copyWith(fullName: value),
                        );
                        setState(() {
                          _hasChanges = true;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: GoogleFonts.montserrat(color: Colors.white),
                      initialValue: profile.email,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.email_outlined),
                        suffixIconColor: const Color.fromARGB(255, 64, 87, 82),
                        labelText: 'Email',
                        labelStyle: GoogleFonts.montserrat(
                            color: const Color(0xFFF5F5DC),
                            fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 21, 27, 31)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 21, 27, 31),
                      ),
                      validator: (value) =>
                          value?.isEmpty ?? !value!.contains('@')
                              ? 'Please enter a valid email'
                              : null,
                      onChanged: (value) {
                        authProvider.updateTempProfile(
                          profile.copyWith(email: value),
                        );
                        setState(() {
                          _hasChanges = true;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      shape: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 21, 27, 31)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      tileColor: const Color.fromARGB(255, 21, 27, 31),
                      title: const Text('Date of Birth'),
                      iconColor: const Color.fromARGB(255, 64, 87, 82),
                      titleTextStyle: GoogleFonts.montserrat(
                          color: const Color(0xFFF5F5DC),
                          fontWeight: FontWeight.bold),
                      subtitleTextStyle:
                          GoogleFonts.montserrat(color: Colors.white),
                      subtitle: Text(
                          '${profile.dateOfBirth.year}-${profile.dateOfBirth.month}-${profile.dateOfBirth.day}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: profile.dateOfBirth,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          authProvider.updateTempProfile(
                            profile.copyWith(dateOfBirth: date),
                          );
                          setState(() {
                            _hasChanges = true;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      shape: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 21, 27, 31)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      tileColor: const Color.fromARGB(255, 21, 27, 31),
                      titleTextStyle: GoogleFonts.montserrat(
                          color: const Color(0xFFF5F5DC),
                          fontWeight: FontWeight.bold),
                      subtitleTextStyle:
                          GoogleFonts.montserrat(color: Colors.white),
                      title: const Text('Gender'),
                      subtitle: Text(profile.gender),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => SimpleDialog(
                            backgroundColor: const Color(0xFFF5F5DC),
                            title: Text(
                              'Select Gender',
                              style: GoogleFonts.montserrat(
                                  color: const Color(0xFF333333),
                                  fontWeight: FontWeight.bold),
                            ),
                            children: ['Male', 'Female', 'Other']
                                .map(
                                  (gender) => SimpleDialogOption(
                                    onPressed: () {
                                      authProvider.updateTempProfile(
                                        profile.copyWith(gender: gender),
                                      );
                                      setState(() {
                                        _hasChanges = true;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      gender,
                                      style: GoogleFonts.montserrat(
                                          color: const Color(0xFF333333)),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            authProvider.saveProfileChanges();
                            setState(() {
                              _hasChanges = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Profile updated successfully')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 21, 27, 31),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Save Changes',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
