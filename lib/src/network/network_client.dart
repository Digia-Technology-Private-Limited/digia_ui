import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../../digia_ui.dart';
import 'api_response/base_response.dart';
import 'core/types.dart';

/// Configures developer-specific options for the Dio HTTP client.
///
/// This function sets up proxy configuration for debugging and development
/// purposes. When a proxy URL is provided in debug mode, it configures
/// the HTTP client to route requests through the specified proxy server.
///
/// Parameters:
/// - [dio]: The Dio instance to configure
/// - [developerConfig]: Developer configuration containing proxy settings
///
/// The configuration only applies in debug mode and on non-web platforms
/// to avoid affecting production builds or web deployments.
void configureDeveloperOptions(Dio dio, DeveloperConfig? developerConfig) {
  if (developerConfig == null) {
    return;
  }
  if (!kIsWeb && kDebugMode && developerConfig.proxyUrl != null) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        return HttpClient()
          ..findProxy = ((uri) => 'PROXY ${developerConfig.proxyUrl}')
          ..badCertificateCallback = (cert, host, port) => true;
      },
    );
  }
}

/// Creates a Dio instance configured for Digia internal API requests.
///
/// This instance is used for communication with Digia Studio backend
/// services and includes proper authentication headers and base configuration.
///
/// Parameters:
/// - [baseUrl]: The base URL for Digia API requests
/// - [headers]: Authentication and metadata headers
/// - [developerConfig]: Optional developer configuration for debugging
///
/// Returns a configured Dio instance ready for Digia API communication.
Dio _createDigiaDio(String baseUrl, Map<String, dynamic> headers,
    DeveloperConfig? developerConfig) {
  var dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 1000),
      headers: {
        ...headers,
        Headers.contentTypeHeader: Headers.jsonContentType,
      }));
  configureDeveloperOptions(dio, developerConfig);
  return dio;
}

/// Creates a Dio instance configured for project-specific API requests.
///
/// This instance is used for making requests to the project's own APIs
/// as defined in the Digia Studio configuration. It uses project-specific
/// timeouts, headers, and other configurations.
///
/// Parameters:
/// - [projectNetworkConfiguration]: Network configuration from project settings
/// - [developerConfig]: Optional developer configuration for debugging
///
/// Returns a configured Dio instance ready for project API communication.
Dio _createProjectDio(NetworkConfiguration projectNetworkConfiguration,
    DeveloperConfig? developerConfig) {
  var dio = Dio(BaseOptions(
      connectTimeout:
          Duration(milliseconds: projectNetworkConfiguration.timeoutInMs),
      headers: {
        ...projectNetworkConfiguration.defaultHeaders,
      }));
  configureDeveloperOptions(dio, developerConfig);
  return dio;
}

/// Network client for handling HTTP requests in the Digia UI system.
///
/// [NetworkClient] manages two separate Dio instances for different types of requests:
/// 1. **Digia Instance**: For internal Digia Studio API communication
/// 2. **Project Instance**: For project-specific API requests
///
/// This separation allows for different configurations, headers, and policies
/// for internal vs. external API calls. The client handles authentication,
/// request/response interceptors, and error handling.
///
/// Key features:
/// - **Dual HTTP Clients**: Separate instances for Digia and project APIs
/// - **Header Management**: Automatic header handling and merging
/// - **Developer Tools**: Integration with debugging and inspection tools
/// - **Multipart Support**: File upload capabilities with progress tracking
/// - **Error Handling**: Structured error responses and exception handling
///
/// Example usage:
/// ```dart
/// final client = NetworkClient(
///   baseUrl,
///   digiaHeaders,
///   projectNetworkConfig,
///   developerConfig,
/// );
///
/// // Make project API request
/// final response = await client.requestProject(
///   bodyType: BodyType.json,
///   url: '/api/users',
///   method: HttpMethod.get,
/// );
/// ```
class NetworkClient {
  /// Dio instance configured for Digia internal API requests
  final Dio digiaDioInstance;

  /// Dio instance configured for project-specific API requests
  final Dio projectDioInstance;

  /// Creates a new [NetworkClient] with dual HTTP client configuration.
  ///
  /// Parameters:
  /// - [baseUrl]: Base URL for Digia internal API requests
  /// - [digiaHeaders]: Headers for authenticating with Digia services
  /// - [projectNetworkConfiguration]: Configuration for project APIs
  /// - [developerConfig]: Optional configuration for debugging and development
  ///
  /// The constructor sets up both Dio instances and configures debugging
  /// interceptors if provided in the developer configuration.
  ///
  /// Throws an exception if the base URL is empty or invalid.
  NetworkClient(
    String baseUrl,
    Map<String, dynamic> digiaHeaders,
    NetworkConfiguration projectNetworkConfiguration,
    DeveloperConfig? developerConfig,
  )   : digiaDioInstance =
            _createDigiaDio(baseUrl, digiaHeaders, developerConfig),
        projectDioInstance =
            _createProjectDio(projectNetworkConfiguration, developerConfig) {
    // Validate base URL
    if (baseUrl.isEmpty) {
      throw 'Invalid BaseUrl';
    }

    // Add interceptor if provided by logger
    final dioInterceptor = developerConfig?.inspector?.dioInterceptor;
    if (dioInterceptor != null) {
      projectDioInstance.interceptors.add(dioInterceptor.interceptor);
    }
  }

  /// Makes an HTTP request using the project-configured Dio instance.
  ///
  /// This method is used for all API requests to project-specific endpoints
  /// as defined in the Digia Studio configuration. It handles header merging,
  /// content type configuration, and request execution.
  ///
  /// Parameters:
  /// - [bodyType]: The content type for the request body
  /// - [url]: The endpoint URL (relative to project base URL)
  /// - [method]: HTTP method (GET, POST, PUT, DELETE, etc.)
  /// - [additionalHeaders]: Optional headers to add to the request
  /// - [cancelToken]: Optional token for request cancellation
  /// - [data]: Request body data
  /// - [apiName]: Optional API name for enhanced logging (from APIModel.name)
  ///
  /// Returns a [Response] containing the server response.
  ///
  /// The method automatically handles:
  /// - Header deduplication (removes conflicting headers)
  /// - Content type setting based on body type
  /// - Base header merging from project configuration
  Future<Response<Object?>> requestProject({
    required BodyType bodyType,
    required String url,
    required HttpMethod method,
    // These headers get appended to base headers (default Dio behavior)
    Map<String, dynamic>? additionalHeaders,
    CancelToken? cancelToken,
    Object? data,
    String? apiName,
  }) {
    // Remove headers already passed in base headers to avoid conflicts
    if (additionalHeaders != null) {
      Set<String> commonKeys = projectDioInstance.options.headers.keys
          .toSet()
          .intersection(additionalHeaders.keys.toSet());
      for (var key in commonKeys) {
        additionalHeaders.remove(key);
      }
    }

    // Merge additional headers with content type
    final headers = {
      ...?additionalHeaders,
      Headers.contentTypeHeader: bodyType.contentTypeHeader,
    };

    return projectDioInstance.request(
      url,
      data: data,
      cancelToken: cancelToken,
      options: Options(
        method: method.stringValue,
        headers: headers,
        contentType: bodyType.contentTypeHeader,
        extra: {
          if (apiName != null) 'apiName': apiName,
        },
      ),
    );
  }

  /// Internal method for executing requests with the Digia Dio instance.
  ///
  /// This method is used for internal Digia Studio API communication.
  /// It handles authentication and request execution with proper error handling.
  ///
  /// Parameters:
  /// - [path]: API endpoint path
  /// - [method]: HTTP method
  /// - [data]: Optional request body data
  /// - [headers]: Optional additional headers
  ///
  /// Returns a typed [Response] with the server response.
  Future<Response<T>> _execute<T>(String path, HttpMethod method,
      {dynamic data, Map<String, dynamic>? headers}) async {
    return digiaDioInstance.request<T>(path,
        data: data,
        options: Options(method: method.stringValue, headers: headers));
  }

  /// Makes a structured request to Digia internal APIs with response parsing.
  ///
  /// This method provides a higher-level interface for internal API requests
  /// with automatic response parsing and error handling. It returns a structured
  /// [BaseResponse] that indicates success/failure and contains parsed data.
  ///
  /// Parameters:
  /// - [method]: HTTP method for the request
  /// - [path]: API endpoint path
  /// - [fromJsonT]: Function to deserialize response data to type T
  /// - [data]: Optional request body data
  /// - [headers]: Optional additional headers
  ///
  /// Returns a [BaseResponse<T>] containing the parsed response or error information.
  ///
  /// The method handles:
  /// - Response status code validation
  /// - JSON deserialization using the provided function
  /// - Error response structure creation
  /// - Exception handling and wrapping
  Future<BaseResponse<T>> requestInternal<T>(
      HttpMethod method, String path, T Function(Object? json) fromJsonT,
      {dynamic data, Map<String, dynamic> headers = const {}}) async {
    try {
      final response =
          await _execute(path, method, data: data, headers: headers);

      if (response.statusCode == 200) {
        return BaseResponse.fromJson(
            response.data as Map<String, Object?>, fromJsonT);
      } else {
        return BaseResponse(
            isSuccess: false, data: null, error: {'code': response.statusCode});
      }
    } catch (e) {
      throw Exception('Error making HTTP request: $e');
    }
  }

  /// Replaces all headers for project API requests.
  ///
  /// This method completely replaces the current header configuration
  /// for the project Dio instance. This is useful for updating authentication
  /// tokens or changing request context during runtime.
  ///
  /// Parameters:
  /// - [headers]: New headers to set for all future project requests
  ///
  /// Warning: This replaces ALL headers, including default ones.
  /// Make sure to include necessary headers like Content-Type if needed.
  void replaceProjectHeaders(Map<String, String> headers) {
    projectDioInstance.options.headers = headers;
  }

  /// Adds a version header to Digia internal API requests.
  ///
  /// This method adds the project version to all future Digia API requests.
  /// The version is used by the backend to ensure compatibility and handle
  /// version-specific features or migrations.
  ///
  /// Parameters:
  /// - [version]: The project configuration version number
  void addVersionHeader(int version) {
    digiaDioInstance.options.headers
        .addAll({'x-digia-project-version': version});
  }

  /// Creates the standard headers required for Digia internal API authentication.
  ///
  /// This static method generates the complete set of headers needed for
  /// authenticating and identifying requests to Digia Studio backend services.
  /// These headers include app metadata, device information, and authentication.
  ///
  /// Parameters:
  /// - [packageVersion]: Version of the Digia UI SDK
  /// - [accessKey]: Project access key for authentication
  /// - [platform]: Platform identifier (iOS, Android, Web)
  /// - [uuid]: Device or installation unique identifier
  /// - [packageName]: App package/bundle identifier
  /// - [appVersion]: Application version string
  /// - [appBuildNumber]: Application build number
  /// - [environment]: Environment identifier (dev, staging, prod)
  ///
  /// Returns a map of header names to values ready for HTTP requests.
  ///
  /// Example:
  /// ```dart
  /// final headers = NetworkClient.getDefaultDigiaHeaders(
  ///   '1.0.0',
  ///   'proj_abc123',
  ///   'iOS',
  ///   'device-uuid',
  ///   'com.example.app',
  ///   '2.1.0',
  ///   '42',
  ///   'production',
  /// );
  /// ```
  static Map<String, dynamic> getDefaultDigiaHeaders(
    String packageVersion,
    String accessKey,
    String platform,
    String? uuid,
    String packageName,
    String appVersion,
    String appBuildNumber,
    String environment,
    String buildSignature,
  ) {
    return {
      'x-digia-version': packageVersion,
      'x-digia-project-id': accessKey,
      'x-digia-platform': platform,
      'x-digia-device-id': uuid,
      'x-app-package-name': packageName,
      'x-app-version': appVersion,
      'x-app-build-number': appBuildNumber,
      'x-digia-environment': environment,
      if (buildSignature.isNotEmpty) 'x-app-signature': buildSignature,
    };
  }

  /// Makes a multipart HTTP request for file uploads with progress tracking.
  ///
  /// This method is specifically designed for file upload operations that
  /// require multipart/form-data encoding. It provides upload progress
  /// callbacks and handles large file transfers efficiently.
  ///
  /// Parameters:
  /// - [bodyType]: Content type for the multipart request
  /// - [url]: Upload endpoint URL
  /// - [method]: HTTP method (typically POST or PUT)
  /// - [additionalHeaders]: Optional headers to add to the request
  /// - [data]: Multipart form data (typically FormData)
  /// - [uploadProgress]: Callback function to track upload progress
  /// - [cancelToken]: Optional token for request cancellation
  /// - [apiName]: Optional API name for enhanced logging (from APIModel.name)
  ///
  /// Returns a [Response] containing the server response after upload completion.
  ///
  /// The method:
  /// - Removes connection timeout for large uploads
  /// - Handles header deduplication like other request methods
  /// - Provides real-time upload progress through the callback
  /// - Supports request cancellation for user-initiated stops
  ///
  /// Example:
  /// ```dart
  /// final response = await client.multipartRequestProject(
  ///   bodyType: BodyType.multipart,
  ///   url: '/upload',
  ///   method: HttpMethod.post,
  ///   data: formData,
  ///   uploadProgress: (sent, total) {
  ///     print('Upload: ${(sent / total * 100).toInt()}%');
  ///   },
  /// );
  /// ```
  Future<Response<Object?>> multipartRequestProject({
    required BodyType bodyType,
    required String url,
    required HttpMethod method,
    // These headers get appended to base headers (default Dio behavior)
    Map<String, dynamic>? additionalHeaders,
    Object? data,
    required void Function(int, int) uploadProgress,
    CancelToken? cancelToken,
    String? apiName,
  }) {
    // Remove headers already passed in base headers to avoid conflicts
    if (additionalHeaders != null) {
      Set<String> commonKeys = projectDioInstance.options.headers.keys
          .toSet()
          .intersection(additionalHeaders.keys.toSet());
      for (var key in commonKeys) {
        additionalHeaders.remove(key);
      }
    }

    // Merge additional headers with content type
    final headers = {
      ...?additionalHeaders,
      'Content-Type': bodyType.contentTypeHeader,
    };

    // Remove connection timeout for large file uploads
    projectDioInstance.options.connectTimeout = null;

    return projectDioInstance.request(
      url,
      data: data,
      cancelToken: cancelToken,
      options: Options(
        method: method.stringValue,
        headers: headers,
        contentType: bodyType.contentTypeHeader,
        extra: {
          if (apiName != null) 'apiName': apiName,
        },
      ),
      onSendProgress: (count, total) {
        uploadProgress(count, total);
      },
    );
  }
}
