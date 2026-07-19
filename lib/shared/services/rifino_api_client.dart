import 'package:rifino/shared/services/api_client.dart';

class RifinoApiClient implements ApiClient {
  RifinoApiClient({
    this.baseUrl = 'https://api.rifino.app',
  });

  final String baseUrl;

  @override
  Future<T> request<T>(Endpoint endpoint) {
    throw UnimplementedError('Connect the real HTTP client here.');
  }
}

