import 'dart:convert';
import 'dart:io' show File;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleDriveService {
  /// 🔐 Scopes requis pour Google Drive
  static const List<String> _scopes = [
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.readonly',
    'https://www.googleapis.com/auth/drive.appdata',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);

  /// 🔐 Authentifie l'utilisateur et récupère les headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final user = await _googleSignIn.signInSilently();

    if (user == null) {
      if (kIsWeb) {
        throw Exception(
            '⚠️ Connexion Google annulée ou bloquée sur le Web. Utilisez GoogleSignIn().renderButton() pour le Web.');
      }
      final signedInUser = await _googleSignIn.signIn();
      if (signedInUser == null) {
        throw Exception('❌ Connexion Google annulée par l\'utilisateur.');
      }
      return await signedInUser.authHeaders;
    }

    return await user.authHeaders;
  }

  /// 📤 Upload général depuis File ou Uint8List
  Future<String> uploadToDrive({
    required String filename,
    File? file,
    Uint8List? fileBytes,
    required String mimeType,
  }) async {
    final authHeaders = await _getAuthHeaders();

    final metadata = {
      'name': filename,
      'mimeType': mimeType,
    };

    final uploadUrl =
        'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart';

    final metaPart = '''
--foo_bar_baz
Content-Type: application/json; charset=UTF-8

${jsonEncode(metadata)}
--foo_bar_baz
Content-Type: $mimeType

''';

    final content = file != null ? await file.readAsBytes() : fileBytes;
    if (content == null) {
      throw Exception(
          '❌ Aucune donnée à téléverser (file et fileBytes sont null).');
    }

    final bodyBytes = <int>[]
      ..addAll(utf8.encode(metaPart))
      ..addAll(content)
      ..addAll(utf8.encode('\r\n--foo_bar_baz--'));

    final response = await http.post(
      Uri.parse(uploadUrl),
      headers: {
        'Authorization': authHeaders['Authorization']!,
        'Content-Type': 'multipart/related; boundary=foo_bar_baz',
      },
      body: bodyBytes,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return getDownloadUrl(data['id']);
    } else {
      throw Exception('❌ Erreur upload fichier : ${response.body}');
    }
  }

  /// 📤 Upload simplifié depuis des bytes (web/mobile)
  Future<String> uploadFileFromBytes(Uint8List bytes, String fileName) async {
    return uploadToDrive(
      filename: fileName,
      fileBytes: bytes,
      mimeType: 'application/octet-stream',
    );
  }

  /// 📥 Télécharger un fichier Drive
  Future<Uint8List> downloadFile(String fileId) async {
    final authHeaders = await _getAuthHeaders();

    final response = await http.get(
      Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId?alt=media'),
      headers: {'Authorization': authHeaders['Authorization']!},
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('❌ Erreur de téléchargement : ${response.body}');
    }
  }

  /// 🗑️ Supprimer un fichier Drive
  Future<void> deleteFile(String fileId) async {
    final authHeaders = await _getAuthHeaders();

    final response = await http.delete(
      Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId'),
      headers: {'Authorization': authHeaders['Authorization']!},
    );

    if (response.statusCode != 204) {
      throw Exception('❌ Erreur suppression fichier : ${response.body}');
    }
  }

  /// 📁 Liste des fichiers Drive
  Future<List<Map<String, dynamic>>> listFiles({int pageSize = 20}) async {
    final authHeaders = await _getAuthHeaders();

    final response = await http.get(
      Uri.parse(
        'https://www.googleapis.com/drive/v3/files'
        '?pageSize=$pageSize'
        '&fields=files(id,name,mimeType,size,webViewLink,webContentLink)',
      ),
      headers: {'Authorization': authHeaders['Authorization']!},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return List<Map<String, dynamic>>.from(decoded['files']);
    } else {
      throw Exception('❌ Erreur lecture Drive : ${response.body}');
    }
  }

  /// 🔗 URL d'aperçu (iframe)
  String getPreviewUrl(String fileId) =>
      'https://drive.google.com/file/d/$fileId/preview';

  /// 🔗 URL de téléchargement direct
  String getDownloadUrl(String fileId) =>
      'https://drive.google.com/uc?export=download&id=$fileId';
}
