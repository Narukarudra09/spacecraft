import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/room.dart';
import '../provider/room_provider.dart';

class AddRoomDialog extends StatefulWidget {
  const AddRoomDialog({super.key});

  @override
  State<AddRoomDialog> createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  File? _imageFile;
  String _designType = 'Room'; // Default value

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Design'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                dropdownColor: const Color.fromARGB(255, 17, 24, 31),
                value: _designType,
                decoration: InputDecoration(
                  labelText: 'Design Type',
                  labelStyle: GoogleFonts.montserrat(
                      color: const Color.fromARGB(255, 17, 24, 31)),
                  border: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 17, 24, 31)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 17, 24, 31)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 17, 24, 31), width: 2),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                      value: 'Room',
                      child: Text(
                        'Room',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF5F5DC),
                        ),
                      )),
                  DropdownMenuItem(
                      value: 'Kitchen',
                      child: Text(
                        'Kitchen',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF5F5DC),
                        ),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _designType = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a design type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: const Color(0xFFF5F5DC),
                ),
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: GoogleFonts.montserrat(
                      color: const Color.fromARGB(255, 17, 24, 31)),
                  border: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 17, 24, 31)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 17, 24, 31)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 17, 24, 31), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: const Color(0xFFF5F5DC),
                ),
                controller: _subtitleController,
                decoration: InputDecoration(
                  labelText: 'Subtitle',
                  labelStyle: GoogleFonts.montserrat(
                      color: const Color.fromARGB(255, 17, 24, 31)),
                  border: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 17, 24, 31)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 17, 24, 31)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 17, 24, 31), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subtitle';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 17, 24, 31),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_a_photo, size: 50),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to add image',
                                style: GoogleFonts.montserrat(
                                    color:
                                        const Color.fromARGB(255, 17, 24, 31)),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.montserrat(
                            color: const Color.fromARGB(255, 17, 24, 31),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 17, 24, 31),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_imageFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an image'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          final newDesign = Room(
                            id: DateTime.now().toString(),
                            name: _titleController.text,
                            description: _subtitleController.text,
                            imageUrl: _imageFile!.path,
                            type: _designType,
                            onTap: () {},
                          );

                          // Add to provider
                          context.read<RoomProvider>().addRoom(newDesign);

                          // Show success message and pop
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Design added successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Add Design',
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }
}
