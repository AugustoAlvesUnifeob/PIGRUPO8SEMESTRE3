import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:PIGRUPO8SEMESTRE3main/viewmodels/firebase_data/cortes.dart';

class AiService {
  final String _apiKey =
      'AIzaSyAx4osPL2aaDqj3J1B4gheLh2uY9mDTR6M'; //chave da api do gemini que criei no google ai studio (minha conta[zamai])
  late final GenerativeModel _model;

  AiService() {
    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
  }

  Future<String> gerarInsights(List<LogPHR> logs, int meta) async {
    if (logs.isEmpty) return "Sem dados de producao para analisar hoje.";

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
    Seja direto eu não exiba os pensamentos
    """;

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "Não foi possível gerar insights no momento.";
    } catch (e) {
      return "Erro ao consultar a IA: $e";
    }
  }
}
