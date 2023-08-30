import 'dart:async';

import 'package:http/http.dart' as http;

class SummaryApiClient {
  static const String baseUrl = 'ADD_CLOUD_FUNCTION_URL_HERE';

  final http.Client _httpClient;

  SummaryApiClient({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  Future<String> getSummary(url) async {
    final request = Uri.https(
      baseUrl,
      '/text-summarization',
      {'url': url},
    );

    final response = await _httpClient.get(request, headers: {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    });

    if (response.statusCode != 200) throw Exception();
    return response.body;
  }