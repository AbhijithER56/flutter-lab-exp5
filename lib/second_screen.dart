import 'package:flutter/material.dart';
import 'user_data_model.dart';

// Screen 2 - Student Result Screen.
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  // Shows 78 as "78" and 82.666 as "82.67".
  static String _format(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // Reading data passed from the previous screen.
    final user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(title: const Text('Student Result Screen')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Student details card
                  Card(
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        'Name: ${user.name}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text('Reg No: ${user.regNo}'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subject marks card
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.menu_book, color: Colors.green),
                              SizedBox(width: 10),
                              Text(
                                'Subject Marks',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          for (var i = 0; i < user.marks.length; i++)
                            _MarkRow(
                              label: 'Mark ${i + 1}',
                              mark: user.marks[i],
                              text: '${_format(user.marks[i])} / 100',
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Result card: total, average and percentage
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.calculate, color: Colors.blue),
                              SizedBox(width: 10),
                              Text(
                                'Result',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          _ResultRow(
                            label: 'Total Marks',
                            value: '${_format(user.total)} / 300',
                          ),
                          _ResultRow(
                            label: 'Average Marks',
                            value: user.average.toStringAsFixed(2),
                          ),
                          _ResultRow(
                            label: 'Percentage',
                            value: '${user.percentage.toStringAsFixed(2)}%',
                            highlight: true,
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: user.percentage / 100,
                              minHeight: 10,
                              color: Colors.deepOrange,
                              backgroundColor: Colors.orange.shade50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    key: const Key('back'),
                    onPressed: () {
                      // Return to the previous screen (Student Input Screen).
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MarkRow extends StatelessWidget {
  const _MarkRow({required this.label, required this.mark, required this.text});

  final String label;
  final double mark;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: mark / 100,
              minHeight: 6,
              color: Colors.green,
              backgroundColor: Colors.green.shade50,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(
            value,
            style: TextStyle(
              fontSize: highlight ? 18 : 15,
              fontWeight: FontWeight.bold,
              color: highlight ? Colors.deepOrange : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
