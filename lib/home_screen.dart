// Input screen (route '/'): collects the student details and marks,
// validates them, then navigates to '/second' passing a User object.

import 'package:flutter/material.dart';
import 'main.dart' show kNavy, kBlue, kHighlighter, kMuted;
import 'user_data_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Reaches the Form's validate()/reset()
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _regNoController = TextEditingController();
  final _mark1Controller = TextEditingController();
  final _mark2Controller = TextEditingController();
  final _mark3Controller = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _regNoController.dispose();
    _mark1Controller.dispose();
    _mark2Controller.dispose();
    _mark3Controller.dispose();
    super.dispose();
  }

  // ---------------- Validators ----------------
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the student name.';
    }
    if (!RegExp(r"^[A-Za-z][A-Za-z .']*$").hasMatch(value.trim())) {
      return 'Name can contain only letters and spaces.';
    }
    return null;
  }

  String? _validateRegNo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the registration number.';
    }
    if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value.trim())) {
      return 'Use letters and digits only (no spaces).';
    }
    return null;
  }

  String? _validateMark(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $label.';
    }
    final mark = double.tryParse(value.trim());
    if (mark == null) {
      return 'Enter a valid number.';
    }
    if (mark < 0 || mark > User.maxMarkPerSubject) {
      return '$label must be between 0 and 100.';
    }
    return null;
  }

  // ---------------- Actions ----------------
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: _nameController.text.trim(),
        regNo: _regNoController.text.trim(),
        mark1: double.parse(_mark1Controller.text.trim()),
        mark2: double.parse(_mark2Controller.text.trim()),
        mark3: double.parse(_mark3Controller.text.trim()),
      );

      // Named route + route arguments
      Navigator.pushNamed(context, '/second', arguments: user);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Student Details Submitted..'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: kNavy,
            duration: const Duration(seconds: 2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
  }

  void _clear() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _regNoController.clear();
    _mark1Controller.clear();
    _mark2Controller.clear();
    _mark3Controller.clear();
  }

  // ---------------- UI helpers ----------------
  InputDecoration _decoration(String label, IconData icon) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: w),
        );
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kBlue),
      filled: true,
      fillColor: const Color(0xFFF6FAFE),
      border: border(const Color(0xFFD3E2F1)),
      enabledBorder: border(const Color(0xFFD3E2F1)),
      focusedBorder: border(kBlue, 1.8),
    );
  }

  Widget _markField(TextEditingController controller, String label) {
    return TextFormField(
      key: Key(label),
      controller: controller,
      decoration: _decoration(label, Icons.edit_note),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      validator: (value) => _validateMark(value, label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Input Screen')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Banner: icon + heading + hint, with a highlighter underline
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: kNavy,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: kHighlighter,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.school, color: kNavy),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Academic Performance Calculator',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Enter student details and marks (out of 100).',
                                style: TextStyle(
                                    color: Color(0xFFB9C8DC), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                      side: const BorderSide(color: Color(0xFFD9E6F3)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              key: const Key('Student Name'),
                              controller: _nameController,
                              decoration:
                                  _decoration('Student Name', Icons.person),
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              validator: _validateName,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              key: const Key('Registration Number'),
                              controller: _regNoController,
                              decoration: _decoration(
                                'Registration Number',
                                Icons.badge_outlined,
                              ),
                              textInputAction: TextInputAction.next,
                              validator: _validateRegNo,
                            ),
                            const SizedBox(height: 14),
                            _markField(_mark1Controller, 'Mark 1'),
                            const SizedBox(height: 14),
                            _markField(_mark2Controller, 'Mark 2'),
                            const SizedBox(height: 14),
                            _markField(_mark3Controller, 'Mark 3'),
                            const SizedBox(height: 22),
                            FilledButton.icon(
                              key: const Key('submit'),
                              onPressed: _submit,
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Submit'),
                              style: FilledButton.styleFrom(
                                backgroundColor: kBlue,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              key: const Key('clear'),
                              onPressed: _clear,
                              style: TextButton.styleFrom(
                                  foregroundColor: kMuted),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Clear'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
