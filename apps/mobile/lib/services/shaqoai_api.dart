import 'dart:convert';

import 'package:http/http.dart' as http;

class SupportConversation {
  const SupportConversation({required this.sender, required this.message, required this.status});
  final String sender;
  final String message;
  final String status;

  factory SupportConversation.fromJson(Map<String, dynamic> json) => SupportConversation(
        sender: json['sender'] as String? ?? 'Customer',
        message: json['last_message'] as String? ?? 'Awaiting an update',
        status: json['status'] as String? ?? 'active',
      );
}

/// Set with --dart-define=SHAQOAI_API_URL=... plus a signed-in session.
class ShaqoAiApi {
  ShaqoAiApi({http.Client? client}) : _client = client ?? http.Client();
  static const _baseUrl = String.fromEnvironment('SHAQOAI_API_URL');
  static const _accessToken = String.fromEnvironment('SHAQOAI_ACCESS_TOKEN');
  static const _workspaceId = String.fromEnvironment('SHAQOAI_WORKSPACE_ID');
  final http.Client _client;

  bool get isConfigured => _baseUrl.isNotEmpty && _accessToken.isNotEmpty && _workspaceId.isNotEmpty;

  Future<List<SupportConversation>> supportConversations() async {
    if (!isConfigured) return const [];
    final response = await _client.get(Uri.parse('$_baseUrl/api/v1/support/conversations'), headers: {
      'Authorization': 'Bearer $_accessToken',
      'X-Workspace-ID': _workspaceId,
    });
    if (response.statusCode != 200) throw Exception('Unable to load workspace support conversations');
    return (jsonDecode(response.body) as List)
        .map((item) => SupportConversation.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
