import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/settings_provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.text,
                maxLines: 5,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: const Color(0xFFF5F5DC),
                ),
                controller: _feedbackController,
                decoration: InputDecoration(
                  labelText: 'Feedback',
                  labelStyle:
                      GoogleFonts.montserrat(color: const Color(0xFFF5F5DC)),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 21, 27, 31)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 21, 27, 31)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 21, 27, 31)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 21, 27, 31),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Feedback';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final feedback = _feedbackController.text;
                      await Provider.of<SettingsProvider>(context,
                              listen: false)
                          .submitFeedback(feedback, context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Feedback submitted!')),
                      );
                      _feedbackController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: const Color.fromARGB(255, 21, 27, 31),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Save Changes',
                      style: TextStyle(color: Color(0xFFF5F5DC))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
