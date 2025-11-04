enum Role {
  owner('OWNER'),
  provider('PROVIDER');

  const Role(this.value);
  final String value;

  @override
  String toString() => value;
}
