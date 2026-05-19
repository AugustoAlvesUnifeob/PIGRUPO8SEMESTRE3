import 'package:cloud_firestore/cloud_firestore.dart';

class FireAikey {
  static const String _colecao = 'apikey';
  static const String _documentoId = 'apiKey1';

  static Future<String> getGeminiKey() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(_colecao)
          .doc(_documentoId)
          .get();

      DocumentSnapshot doc2 = await FirebaseFirestore.instance
          .collection(_colecao)
          .doc('apiKey2')
          .get();

      if (doc.exists && doc.data() != null) {
        return doc.get('apiKey') as String;
      } else {
        if (doc2.exists && doc2.data() != null) {
          return doc.get('apiKey') as String;
        }
        else {
          throw Exception("Documento de configuração não encontrado!");
        }
      }
    } catch (e) {
      print("Erro ao buscar API Key: $e");
      return "";
    }
  }
}
