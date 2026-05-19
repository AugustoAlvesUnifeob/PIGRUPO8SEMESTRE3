import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/firebase_data/cortes.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/firebase_data/fire_aiKey.dart';

class AiService {
  GenerativeModel? _model;

  static String? _insightCacheado;
  static DateTime? _ultimaGeracaoIA;

  Future<void> _initModel() async {
    if (_model != null) return;

    String key = await FireAikey.getGeminiKey();

    if (key.isNotEmpty) {
      _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: key);
    }
  }

  Future<String> gerarInsights(List<LogPHR> logs, int meta) async {
    if (logs.isEmpty) return "Sem dados de produção para analisar hoje.";

    final agora = DateTime.now();

    if (_insightCacheado != null && _ultimaGeracaoIA != null) {
      if (agora.difference(_ultimaGeracaoIA!).inMinutes < 60) {
        print(
          "💡 [IA] Retornando insight do cache (gerado há ${agora.difference(_ultimaGeracaoIA!).inMinutes} min)",
        );
        return _insightCacheado!;
      }
    }

    print("Gerando novo insight...");

    await _initModel();

    if (_model == null) {
      return "Erro: Não foi possível carregar a configuração da IA.";
    }

    String dadosFormatados = logs
        .map(
          (l) =>
              "- Às ${l.dataHora.hour}:${l.dataHora.minute} produziu ${l.leitura} peças (Lote: ${l.lote})",
        )
        .join("\n");

    final prompt =
        """
    Você é um especialista em gestão de produção industrial. 
    Analise os seguintes dados de produção de hoje:
    $dadosFormatados
    
    A meta diária é de $meta peças.
    
    Por favor, forneça:
    1. Um resumo executivo de uma frase sobre o ritmo atual.
    2. Três insights curtos (ex: picos de produtividade, gargalos ou sugestões de manutenção).
    
    Responda de forma direta e profissional em português.
    Seja direto e não exiba pensamentos ou processos de raciocínio.
    Resposta sem asteristicos, separe e pontue os parágrafos.
    """;

    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      final textoResposta =
          response.text ?? "Não foi possível gerar insights no momento.";
      _insightCacheado = textoResposta;
      _ultimaGeracaoIA = agora;

      return textoResposta;
    } catch (e) {
      final erro = e.toString().toLowerCase();

      // detecta problemas de token/quota/auth
      if (erro.contains("api key") ||
          erro.contains("quota") ||
          erro.contains("permission") ||
          erro.contains("token") ||
          erro.contains("authentication") ||
          erro.contains("403")) {

            DocumentSnapshot doc2 = await FirebaseFirestore.instance
          .collection('apikey')
          .doc('apiKey2')
          .get();

          String key = doc2.get('apiKey') as String;

          _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: key);

          final content = [Content.text(prompt)];
          final response = await _model!.generateContent(content);

          final textoResposta =
              response.text ?? "Não foi possível gerar insights no momento.";

          _insightCacheado = textoResposta;
          _ultimaGeracaoIA = agora;

          return textoResposta;
      }
      else {
        return "Erro ao consultar a IA: $e";
      }
    }
  }
}
