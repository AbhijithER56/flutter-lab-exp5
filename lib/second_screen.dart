// Result screen (route '/second'): reads the User passed as a route argument
// and shows each mark, Total, Average, Percentage and a letter grade.

import 'package:flutter/material.dart';
import 'main.dart' show kNavy, kBlue, kHighlighter, kMint, kMuted;
import 'user_data_model.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  // 78.0 -> "78", 82.5 -> "82.50"
  static String _format(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // Receive the User sent by Navigator.pushNamed(..., arguments: user)
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
                  // Student identity
                  _Panel(
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: kHighlighter,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.person, color: kNavy),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: ${user.name}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: kNavy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Reg No: ${user.regNo}',
                                style: const TextStyle(color: kMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Percentage ring with the grade
                  _Panel(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 110,
                                height: 110,
                                child: CircularProgressIndicator(
                                  value: user.percentage / 100,
                                  strokeWidth: 10,
                                  strokeCap: StrokeCap.round,
                                  color: kBlue,
                                  backgroundColor: const Color(0xFFE1EDF8),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: FittedBox(
                                  child: Text(
                                    '${user.percentage.toStringAsFixed(2)}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: kNavy,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Percentage',
                                  style: TextStyle(color: kMuted)),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: kHighlighter,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Grade ${user.grade}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: kNavy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subject marks
                  _Panel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _PanelTitle(
                            icon: Icons.menu_book, title: 'Subject Marks'),
                        const SizedBox(height: 8),
                        for (var i = 0; i < user.marks.length; i++)
                          _MarkRow(
                            label: 'Mark ${i + 1}',
                            mark: user.marks[i],
                            text: '${_format(user.marks[i])} / 100',
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Totals
                  _Panel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _PanelTitle(
                            icon: Icons.calculate, title: 'Result'),
                        const SizedBox(height: 8),
                        _ResultRow(
                          label: 'Total Marks',
                          value: '${_format(user.total)} / 300',
                        ),
                        _ResultRow(
                          label: 'Average Marks',
                          value: user.average.toStringAsFixed(2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Back: pops this route off the Navigator stack
                  FilledButton.icon(
                    key: const Key('back'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                    style: FilledButton.styleFrom(
                      backgroundColor: kNavy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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

// White rounded container used for each block on the page
class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD9E6F3)),
      ),
      child: child,
    );
  }
}

class _PanelTitle extends StatelessWidget {
  const _PanelTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: kBlue),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: kNavy,
          ),
        ),
      ],
    );
  }
}

// One subject: label, "78 / 100" and a thin progress bar
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
              Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: mark / 100,
              minHeight: 6,
              color: kMint,
              backgroundColor: const Color(0xFFDDF4F1),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

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
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: kNavy,
            ),
          ),
        ],
      ),
    );
  }
}
