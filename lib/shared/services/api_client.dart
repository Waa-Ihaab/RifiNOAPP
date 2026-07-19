abstract interface class ApiClient {
  Future<T> request<T>(Endpoint endpoint);
}

class Endpoint {
  const Endpoint({
    required this.path,
    this.method = HttpMethod.get,
  });

  final String path;
  final HttpMethod method;
}

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

