enum Plan {
  basic('BASIC'),
  pro('PRO');

  const Plan(this.value);
  final String value;

  @override
  String toString() => value;
}
