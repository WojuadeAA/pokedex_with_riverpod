/// The abstract `NetworkClient` class provides a common interface for making
/// HTTP requests.
abstract class NetworkClient<T> {
  /// Creates a new `NetworkClient` with the specified `baseUrl`.
  ///
  /// The `baseUrl` is the root URL for all HTTP requests made by this client.
  NetworkClient({String? baseUrl});

  /// Sends an HTTP GET request to the specified `endpoint` and returns the
  /// resulting `http.Response`.
  Future get(String endpoint);

  /// Sends an HTTP POST request to the specified `endpoint` with an optional
  /// request `body`, and returns the resulting `http.Response`.
  Future post(String endpoint, {dynamic body});

  /// Sends an HTTP PUT request to the specified `endpoint` with an optional
  /// request `body`, and returns the resulting `http.Response`.
  Future put(String endpoint, {dynamic body});

  /// Sends an HTTP DELETE request to the specified `endpoint` and returns the
  /// resulting `http.Response`.
  Future delete(String endpoint);
}
