// class Role {
//   static const String provider = "PROVIDER";
//   static const String owner = "OWNER";
// }

enum Role {
  owner('OWNER'),
  provider('PROVIDER');

  const Role(this.value);
  final String value;

  @override
  String toString() => value;
}
