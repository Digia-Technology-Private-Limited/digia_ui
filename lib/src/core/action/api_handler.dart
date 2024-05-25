import '../../../digia_ui.dart';
import '../../network/api_request/api_request.dart';

const Map<String, String> defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

class ApiHandler {
  static final ApiHandler _instance = ApiHandler._();

  ApiHandler._();

  static ApiHandler get instance => _instance;

  Future<Object?> execute(
      {required APIModel apiModel, required Map<String, dynamic>? args}) async {
    final url = _hydrateTemplate(apiModel.url, args);
    // final headers = apiModel.headers?.map((key, value) =>
    //     MapEntry(_hydrateTemplate(key, args), _hydrateTemplate(value, args)));
    // final headers = {for (var e in apiModel.headers!) e.key!: e.value!};
    final Map<String, dynamic> headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJkZXZpY2UiOjUsImV4cCI6MTcxNjY2Mjk1OSwiaWF0IjoxNzE2NjQ0OTU5LCJqayI6ImF1dGgiLCJ1c2VyIjp7ImlkIjoiNjY1MTlkNmViOTNlYzA1MmJhZTU5MTZkIiwiaXNRdWl6VGFrZW4iOmZhbHNlLCJwaG9uZSI6IiIsIkludml0ZSI6eyJUb2tlbiI6IiIsIkV4cGlyYXRpb25FcG9jaCI6MH0sIndoYXRzYXBwT3B0aW4iOmZhbHNlLCJhb2ZEZXRhaWxzIjp7InBlcm1hbmVudEFkZHJlc3MiOnt9LCJiaXJ0aENpdHkiOiIiLCJwb2xpdGljYWxseUV4cG9zZWQiOmZhbHNlLCJjdXJyZW50QWRkcmVzcyI6e319LCJDeWJyaWxsYUFjY291bnRJRCI6IiIsIkN5YnJpbGxhQWNjb3VudE9sZElEIjowLCJBY2NvdW50SUQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAiLCJDeWJyaWxsYUludmVzdG9ySUQiOjAsIkludmVzdG9ySUQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAiLCJPbGRNZW1iZXJQYXJ0bmVyIjowLCJMaW5rZWRpblBob3RvU2F2ZWQiOmZhbHNlLCJpbnZpdGVBY2Nlc3NQaG9uZSI6IiIsImVtcGxveWVyTmFtZSI6IiIsInJlZmVycmFsVXNlcklkIjoiMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwIiwiaXNJbnZpdGVBY2Nlc3NQaG9uZVZlcmlmaWVkIjpmYWxzZSwiYXBwbGljYW50c0FoZWFkIjowLCJpc0ludml0ZVdoYXRzYXBwTm90aWZ5IjpmYWxzZSwicGluIjoiIiwiaW52aXRlRXh0ZW5zaW9uUmVhc29uIjoiIiwicXVpelRva2VuIjoiIiwiY3licmlsbGFNYW5kYXRlSWQiOjAsInJ0YUN5YnJpbGxhTWFuZGF0ZUlkIjowLCJzaXBJRCI6IjAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMCIsIk9uYm9hcmRpbmdNb2RlIjowLCJ1dG0iOnt9LCJvYmplY3RpdmUiOnsiaWQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAifSwicG9ydGZvbGlvUmV2aWV3SUQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAiLCJwbXNFeHBlcnRDYWxsRGV0YWlscyI6eyJsYXN0VXBkYXRlZFRzIjoiMDAwMS0wMS0wMVQwMDowMDowMFoifSwiYXBwc2ZseWVyVVRNIjp7fSwiY3JlYXRlZEJ5IjoiMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwIiwiZGV6ZXJ2QXBwUmF0aW5nQ2xpY2tlZCI6ZmFsc2UsImFtbERldGFpbHMiOnt9fX0.iQ-Ln8j3QdotGHNt8dWPgulpB7i5wN-Mhu7BaoJoM9Sqj1rv-Y9wQq_F9_NAB3CmxpWAEQ2qQS7e2eFj5aj7zA',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Date': 'Sat, 25 May 2024 13:39:00 GMT',
      'Content-Length': '69',
      'Connection': 'keep-alive',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers':
          'Content-Type ,Content-Length ,Accept-Encoding ,Authorization ,accept ,Origin ,Cookie ,Cache-Control ,X-Client-App ,X-Client-Package ,X-Client-App ,X-Device ,X-Device-Id ,X-Client-Version, apikey, secret, X-Dezerv-Auth-Type',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Origin': '',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
      'Vary': 'Accept-Encoding, Origin',
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'SAMEORIGIN',
      'X-Xss-Protection': '1; mode=block',
    };

    final networkClient = DigiaUIClient.getNetworkClient();
    final response = await networkClient.execute(
        url: url,
        method: apiModel.method,
        headers: headers,
        data: apiModel.body);
    return response.data;
  }

  String _hydrateTemplate(String template, Map<String, dynamic>? values) {
    final regex = RegExp(r'\{\{(\w+)\}\}');
    return template.replaceAllMapped(regex, (match) {
      final variableName = match.group(1);
      return values?[variableName]?.toString() ??
          match.group(0)!; // Keep original if value not found
    });
  }
}
