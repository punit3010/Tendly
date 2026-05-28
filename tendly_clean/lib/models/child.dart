class Child {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final List<String> interests;

  const Child({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    this.interests = const [],
  });

  int get ageYears {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  String get ageLabel {
    final y = ageYears;
    if (y == 0) return 'Under 1 yr';
    if (y == 1) return '1 yr';
    return '$y yrs';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'date_of_birth': dateOfBirth.toIso8601String(),
    'interests': interests,
  };

  factory Child.fromJson(Map<String, dynamic> j) => Child(
    id: j['id'],
    name: j['name'],
    dateOfBirth: DateTime.parse(j['date_of_birth']),
    interests: List<String>.from(j['interests'] ?? []),
  );
}
