import 'dart:convert';
import 'dart:html' as html;
import '../data/models/kpi.dart';
import '../data/models/series.dart';
import '../data/models/alert.dart';

class ExportService {
  /// Exporta dados para CSV
  static void exportarCsv(List<Kpi> kpis,
      {List<Alert>? alertas, SeriesData? series}) {
    final buffer = StringBuffer();

    // Cabeçalho do CSV
    buffer.writeln(
        'Tipo,Indicador,Valor,Variação M/M (%),Variação A/A (%),Fonte,Última Atualização');

    // Adicionar KPIs
    for (final kpi in kpis) {
      buffer.writeln(
          'KPI,"${kpi.titulo}",${kpi.valor},${kpi.variacao},${kpi.variacaoAnual},"${kpi.fonte}","${kpi.ultimaAtualizacao}"');
    }

    // Adicionar alertas se fornecidos
    if (alertas != null && alertas.isNotEmpty) {
      buffer.writeln('\nAlertas');
      buffer.writeln('Tipo,Mensagem,Severidade');
      for (final alert in alertas) {
        buffer.writeln(
            '"${alert.tipo}","${alert.mensagem}","${alert.severidade}"');
      }
    }

    // Adicionar séries se fornecidas
    if (series != null) {
      buffer.writeln('\nSérie PIB');
      buffer.writeln('Período,Valor');
      for (final point in series.pib) {
        buffer.writeln('"${point.periodo}",${point.valor}');
      }

      buffer.writeln('\nSérie Empregos');
      buffer.writeln('Período,Valor');
      for (final point in series.empregosMensal) {
        buffer.writeln('"${point.periodo}",${point.valor}');
      }

      buffer.writeln('\nAdmissões por CNAE');
      buffer.writeln('CNAE,Valor');
      for (final cnaeData in series.admissoesPorCnae) {
        buffer.writeln('"${cnaeData.cnae}",${cnaeData.valor}');
      }
    }

    // Download do arquivo
    _baixarArquivo(buffer.toString(), 'cascavel_dashboard.csv', 'text/csv');
  }

  /// Exporta dados para PDF (simulado como HTML)
  static void exportarPdf(String tituloDashboard,
      {List<Kpi>? kpis, List<Alert>? alertas}) {
    final buffer = StringBuffer();

    buffer.writeln('''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>$tituloDashboard - Cascavel em Números</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 20px;
            background-color: #EBECEB;
        }
        .header {
            background-color: #0F670E;
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .kpi-section {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 16px;
        }
        .kpi-card {
            border: 1px solid #ACB0AD;
            border-radius: 8px;
            padding: 16px;
            background-color: #FAFAFA;
        }
        .kpi-title {
            color: #1E3A82;
            font-weight: bold;
            margin-bottom: 8px;
        }
        .kpi-value {
            font-size: 24px;
            font-weight: bold;
            color: #111418;
            margin-bottom: 8px;
        }
        .kpi-delta.positive {
            color: #0F670E;
        }
        .kpi-delta.negative {
            color: #D32F2F;
        }
        .alert {
            background-color: #FFF3CD;
            border: 1px solid #FFEAA7;
            border-radius: 4px;
            padding: 12px;
            margin-bottom: 8px;
        }
        .alert.high {
            background-color: #F8D7DA;
            border-color: #F5C6CB;
        }
        .footer {
            text-align: center;
            color: #ACB0AD;
            margin-top: 20px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>$tituloDashboard</h1>
        <p>Inteligência Econômica - Cascavel em Números</p>
        <p>Gerado em: \${DateTime.now().toString().split('.')[0]}</p>
    </div>
    ''');

    if (kpis != null && kpis.isNotEmpty) {
      buffer.writeln('<div class="kpi-section">');
      buffer.writeln('<h2>Indicadores Principais</h2>');
      buffer.writeln('<div class="kpi-grid">');

      for (final kpi in kpis) {
        final deltaClass = kpi.variacao > 0 ? 'positive' : 'negative';
        buffer.writeln('''
        <div class="kpi-card">
            <div class="kpi-title">\${kpi.titulo}</div>
            <div class="kpi-value">${_formatarValorKpi(kpi)}</div>
            <div class="kpi-delta $deltaClass">
                M/M: \${kpi.variacao >= 0 ? '+' : ''}\${kpi.variacao.toStringAsFixed(1)}%
            </div>
            <div class="kpi-delta \${kpi.variacaoAnual > 0 ? 'positive' : 'negative'}">
                A/A: \${kpi.variacaoAnual >= 0 ? '+' : ''}\${kpi.variacaoAnual.toStringAsFixed(1)}%
            </div>
            <small>Fonte: \${kpi.fonte} | \${kpi.ultimaAtualizacao}</small>
        </div>
        ''');
      }

      buffer.writeln('</div></div>');
    }

    if (alertas != null && alertas.isNotEmpty) {
      buffer.writeln('<div class="kpi-section">');
      buffer.writeln('<h2>Alertas</h2>');

      for (final alert in alertas) {
        buffer.writeln('''
        <div class="alert ${alert.severidade}">
            <strong>${alert.tipo.toUpperCase()}</strong>: ${alert.mensagem}
        </div>
        ''');
      }

      buffer.writeln('</div>');
    }

    buffer.writeln('''
    <div class="footer">
        <p>v0.1</p>
        <p>Cascavel em Números - Inteligência Econômica</p>
    </div>
</body>
</html>
    ''');

    // Download do arquivo HTML (simulando PDF)
    _baixarArquivo(buffer.toString(), 'cascavel_dashboard.html', 'text/html');
  }

  /// Formata valor do KPI para exibição no PDF
  static String _formatarValorKpi(Kpi kpi) {
    switch (kpi.chave) {
      case 'pib':
      case 'iss':
        if (kpi.valor >= 1000) {
          return 'R\$ \${(kpi.valor / 1000).toStringAsFixed(1)}K';
        }
        return 'R\$ \${kpi.valor.toStringAsFixed(1)}';
      case 'empregos':
      case 'empresas':
      case 'alvaras':
        if (kpi.valor >= 1000000) {
          return '\${(kpi.valor / 1000000).toStringAsFixed(1)}M';
        } else if (kpi.valor >= 1000) {
          return '\${(kpi.valor / 1000).toStringAsFixed(1)}K';
        }
        return kpi.valor.toInt().toString();
      default:
        return kpi.valor.toString();
    }
  }

  /// Download do arquivo
  static void _baixarArquivo(
      String conteudo, String nomeArquivo, String tipoMime) {
    final bytes = utf8.encode(conteudo);
    final blob = html.Blob([bytes], tipoMime);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', nomeArquivo)
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
