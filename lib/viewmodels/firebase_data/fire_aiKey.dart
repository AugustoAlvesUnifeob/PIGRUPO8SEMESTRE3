import 'package:cloud_firestore/cloud_firestore.dart';

class FireAikey {
  static const String _colecao = 'Sensor';
  static const String _documentoId = 'FVAfHvFsKDpgjoUFhxcd';

  static Future<String> getGeminiKey() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(_colecao)
          .doc(_documentoId)
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.get('apiKey') as String;
      } else {
        throw Exception("Documento de configuração não encontrado!");
      }
    } catch (e) {
      print("Erro ao buscar API Key: $e");
      return "";
    }
  }
}
