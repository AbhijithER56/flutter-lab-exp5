// Data model used to pass student details from the input screen
// (home_screen.dart) to the result screen (second_screen.dart)
// through Navigator.pushNamed(..., arguments: user).
class User {
  final String name;
  final String regNo;
  final double mark1;
  final double mark2;
  final double mark3;

  // Each subject is marked out of 100.
  static const double maxMarkPerSubject = 100;
  static const int subjectCount = 3;

  User({
    required this.name,
    required this.regNo,
    required this.mark1,
    required this.mark2,
    required this.mark3,
  });

  List<double> get marks => [mark1, mark2, mark3];

  // Total Marks = Mark 1 + Mark 2 + Mark 3
  double get total => mark1 + mark2 + mark3;

  // Average Marks = Total / number of subjects
  double get average => total / subjectCount;

  // Percentage = (Total / Maximum Total) x 100
  double get percentage => (total / (maxMarkPerSubject * subjectCount)) * 100;

  // Letter grade shown on the result screen
  String get grade {
    final p = percentage;
    if (p >= 90) return 'O';
    if (p >= 80) return 'A+';
    if (p >= 70) return 'A';
    if (p >= 60) return 'B';
    if (p >= 50) return 'C';
    return 'F';
  }
}
