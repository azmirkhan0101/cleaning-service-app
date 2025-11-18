enum HttpRequestType {
  get("GET"),
  post("POST"),
  put("PUT"),
  patch("PATCH"),
  delete("DELETE");

  const HttpRequestType(this.method);
  final String method;

  @override
  String toString() => method;
}
