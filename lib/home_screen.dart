import 'package:flutter/material.dart';
import 'user_data_model.dart';

// Screen 1 - Student Input Screen.
// StatefulWidget because it owns the form key and text controllers.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Read form input and store it as a User object.
      final user = User(
        name: _nameController.text.trim(),
        regNo: _regNoController.text.trim(),
        mark1: double.parse(_mark1Controller.text.trim()),
        mark2: double.parse(_mark2Controller.text.trim()),
        mark3: double.parse(_mark3Controller.text.trim()),
      );

      // Pass the object to the result screen using arguments.
      Navigator.pushNamed(context, '/second', arguments: user);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Student Details Submitted..'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
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

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _markField(TextEditingController controller, String label) {
    return TextFormField(
      key: Key(label),
      controller: controller,
      decoration: _decoration(label, Icons.menu_book_outlined),
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
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              child: Icon(Icons.school),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Academic Performance Calculator',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Enter student details and marks (out of 100).',
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: const Key('Student Name'),
                          controller: _nameController,
                          decoration: _decoration('Student Name', Icons.person),
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
                        ElevatedButton.icon(
                          key: const Key('submit'),
                          onPressed: _submit,
                          icon: const Icon(Icons.send),
                          label: const Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton.icon(
                          key: const Key('clear'),
                          onPressed: _clear,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Clear'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
