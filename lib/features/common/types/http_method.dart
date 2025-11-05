enum HttpMethod {
  get("GET"),
  post("POST"),
  put("PUT"),
  patch("PATCH"),
  delete("DELETE");

  const HttpMethod(this.method);
  final String method;

  @override
  String toString() => method;
}
