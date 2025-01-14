import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacecraft/provider/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final profile = authProvider.profile;
        print('Full Name: ${profile.fullName}');
        print('Email: ${profile.email}');
        print('Date of Birth: ${profile.dateOfBirth}');
        print('Gender: ${profile.gender}');
        print('Profile Picture: ${profile.profilePicture}');

        if (profile == null) {
          return Center(child: CircularProgressIndicator());
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
                              ? const AssetImage('assets/profile_picture.png')
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
                                        //pickImage(context, ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Gallery'),
                                      onTap: () {
                                        //pickImage(context, ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Color.fromARGB(255, 21, 27, 31),
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
                    style: const TextStyle(color: Colors.white),
                    initialValue: authProvider.profile.fullName,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(color: Colors.white),
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
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your full name'
                        : null,
                    onChanged: (value) => authProvider.updateProfile(
                      profile.copyWith(fullName: value),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: const TextStyle(color: Colors.white),
                    initialValue: profile.email,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.email_outlined),
                      suffixIconColor: const Color.fromARGB(255, 64, 87, 82),
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
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
                    onChanged: (value) => authProvider.updateProfile(
                      profile.copyWith(email: value),
                    ),
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
                    titleTextStyle: const TextStyle(color: Colors.white),
                    subtitleTextStyle: const TextStyle(color: Colors.white),
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
                        authProvider.updateProfile(
                          profile.copyWith(dateOfBirth: date),
                        );
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
                    titleTextStyle: const TextStyle(
                      color: Color(0xFFF5F5DC),
                    ),
                    subtitleTextStyle: const TextStyle(color: Colors.white),
                    title: const Text('Gender'),
                    subtitle: Text(profile.gender),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => SimpleDialog(
                          backgroundColor: Color(0xFFF5F5DC),
                          title: Text(
                            'Select Gender',
                            style: TextStyle(color: Color(0xFF333333)),
                          ),
                          children: ['Male', 'Female', 'Other']
                              .map(
                                (gender) => SimpleDialogOption(
                                  onPressed: () {
                                    authProvider.updateProfile(
                                      profile.copyWith(gender: gender),
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    gender,
                                    style: TextStyle(color: Color(0xFF333333)),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
