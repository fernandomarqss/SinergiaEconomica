import 'dart:convert';
import 'dart:html' as html;

import '../core/utils/formatters.dart';
import '../data/models/alert.dart';
import '../data/models/kpi.dart';
import '../data/models/series.dart';

class ExportService {
  static const _csvSeparator = ';';

  /// Exporta os dados do dashboard para CSV com formatação amigável.
  static void exportarCsv(
    List<Kpi> kpis, {
    List<Alert>? alertas,
    SeriesData? series,
  }) {
    final buffer = StringBuffer();

    // Indicadores principais
    buffer.writeln('Indicadores principais');
    buffer.writeln(_csvHeader([
      'Indicador',
      'Valor',
      'Variação M/M',
      'Variação A/A',
      'Fonte',
      'Atualizado em',
    ]));

    for (final kpi in kpis) {
      buffer.writeln(_csvRow([
        kpi.titulo,
        Formatters.formatKpiValue(kpi.chave, kpi.valor),
        Formatters.formatPercent(kpi.variacao),
        Formatters.formatPercent(kpi.variacaoAnual),
        kpi.fonte,
        _formatDate(kpi.ultimaAtualizacao),
      ]));
    }

    // Séries temporais
    if (series != null) {
      if (series.pib.isNotEmpty) {
        buffer.writeln();
        buffer.writeln('Série PIB (ano base)');
        buffer.writeln(_csvHeader(['Ano', 'Valor']));
        for (final ponto in series.pib) {
          buffer.writeln(_csvRow([
            ponto.periodo,
            Formatters.formatNumber(ponto.valor),
          ]));
        }
      }

      if (series.empregosMensal.isNotEmpty) {
        buffer.writeln();
        buffer.writeln('Série Empregos (mensal)');
        buffer.writeln(_csvHeader(['Período', 'Total de empregos']));
        for (final ponto in series.empregosMensal) {
          buffer.writeln(_csvRow([
            _formatPeriod(ponto.periodo),
            Formatters.formatNumber(ponto.valor),
          ]));
        }
      }

      if (series.admissoesPorCnae.isNotEmpty) {
        buffer.writeln();
        buffer.writeln('Admissões registradas (Top 10)');
        buffer.writeln(_csvHeader(['CNAE', 'Período', 'Bairro', 'Admissões']));
        for (final item in series.admissoesPorCnae) {
          buffer.writeln(_csvRow([
            item.cnae,
            item.periodo ?? '-',
            item.bairro ?? '-',
            Formatters.formatNumber(item.valor),
          ]));
        }
      }
    }

    // Alertas
    if (alertas != null && alertas.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Alertas ativos');
      buffer.writeln(_csvHeader(['Severidade', 'Tipo', 'Descrição']));
      for (final alert in alertas) {
        buffer.writeln(_csvRow([
          _severityLabel(alert.severidade),
          alert.tipo,
          alert.mensagem,
        ]));
      }
    }

    _baixarArquivo(
      buffer.toString(),
      'cascavel_dashboard.csv',
      'text/csv',
    );
  }

  /// Exporta os dados para um HTML estilizado (visualização impressa / PDF).
  static void exportarPdf(
    String tituloDashboard, {
    List<Kpi>? kpis,
    List<Alert>? alertas,
    SeriesData? series,
  }) {
    final agora = Formatters.formatDate(DateTime.now());
    final buffer = StringBuffer();

    buffer.writeln('''
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Relatório - $tituloDashboard</title>
  <style>
    body {
      font-family: 'Segoe UI', Roboto, sans-serif;
      background: #f3f4f6;
      margin: 0;
      padding: 32px;
      color: #0f172a;
    }
    .wrapper {
      max-width: 1080px;
      margin: 0 auto;
    }
    .header {
      background: linear-gradient(135deg, #0f172a, #0f670e);
      color: #ffffff;
      padding: 28px;
      border-radius: 16px;
      margin-bottom: 32px;
      box-shadow: 0 12px 24px rgba(15, 23, 42, 0.24);
    }
    .header h1 {
      margin: 0 0 12px 0;
      font-size: 28px;
      letter-spacing: 0.5px;
    }
    .header p {
      margin: 4px 0;
      font-size: 15px;
      opacity: .85;
    }
    section.card {
      background: #ffffff;
      border-radius: 16px;
      padding: 24px 28px;
      margin-bottom: 24px;
      box-shadow: 0 10px 18px rgba(15, 23, 42, 0.08);
    }
    section.card h2 {
      margin: 0 0 18px 0;
      font-size: 20px;
      color: #0f172a;
    }
    .kpi-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      gap: 18px;
    }
    .kpi-card {
      border-radius: 14px;
      border: 1px solid #e2e8f0;
      padding: 16px;
      background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
    }
    .kpi-card h3 {
      margin: 0 0 8px 0;
      font-size: 15px;
      color: #1e3a8a;
    }
    .kpi-value {
      font-size: 26px;
      font-weight: 700;
      margin-bottom: 12px;
      color: #0f172a;
    }
    .delta {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-size: 12px;
      border-radius: 12px;
      padding: 4px 8px;
      font-weight: 600;
    }
    .delta.positive { background: #dcfce7; color: #166534; }
    .delta.negative { background: #fee2e2; color: #991b1b; }
    .delta.neutral { background: #e2e8f0; color: #475569; }
    .delta span.icon { font-size: 12px; }
    .meta {
      margin-top: 12px;
      font-size: 12px;
      color: #64748b;
    }
    table.data {
      width: 100%;
      border-collapse: collapse;
      margin: 8px 0 16px;
      font-size: 13px;
    }
    table.data th,
    table.data td {
      padding: 10px;
      text-align: left;
      border-bottom: 1px solid #e2e8f0;
    }
    table.data th {
      background: #f1f5f9;
      color: #0f172a;
      font-weight: 600;
    }
    .alerts {
      display: grid;
      gap: 12px;
    }
    .alert {
      border-radius: 12px;
      padding: 14px 16px;
      border: 1px solid rgba(15, 23, 42, 0.08);
    }
    .alert.alto { background: #fee2e2; border-color: #fecaca; color: #991b1b; }
    .alert.medio { background: #fef3c7; border-color: #fde68a; color: #92400e; }
    .alert.baixo { background: #dcfce7; border-color: #bbf7d0; color: #166534; }
    .alert.info { background: #e0f2fe; border-color: #bae6fd; color: #0369a1; }
    .alert strong { display: block; margin-bottom: 4px; }
    footer {
      text-align: center;
      font-size: 12px;
      color: #64748b;
      margin-top: 32px;
    }
  </style>
</head>
<body>
  <div class="wrapper">
    <header class="header">
      <h1>${_escapeHtml(tituloDashboard)}</h1>
      <p>Inteligência Econômica · Cascavel em Números</p>
      <p>Relatório gerado em: $agora</p>
    </header>
''');

    if (kpis != null && kpis.isNotEmpty) {
      buffer.writeln('  <section class="card">');
      buffer.writeln('    <h2>Indicadores principais</h2>');
      buffer.writeln('    <div class="kpi-grid">');
      for (final kpi in kpis) {
        final valor =
            _escapeHtml(Formatters.formatKpiValue(kpi.chave, kpi.valor));
        final deltaClass = kpi.variacao > 0
            ? 'positive'
            : kpi.variacao < 0
                ? 'negative'
                : 'neutral';
        final deltaIcon = kpi.variacao > 0
            ? '▲'
            : kpi.variacao < 0
                ? '▼'
                : '■';
        final deltaYClass = kpi.variacaoAnual > 0
            ? 'positive'
            : kpi.variacaoAnual < 0
                ? 'negative'
                : 'neutral';
        final deltaYIcon = kpi.variacaoAnual > 0
            ? '▲'
            : kpi.variacaoAnual < 0
                ? '▼'
                : '■';

        buffer.writeln('''
      <article class="kpi-card">
        <h3>${_escapeHtml(kpi.titulo)}</h3>
        <div class="kpi-value">$valor</div>
        <div class="delta $deltaClass">
          <span class="icon">$deltaIcon</span>
          <span>M/M ${_escapeHtml(Formatters.formatPercent(kpi.variacao))}</span>
        </div>
        <div class="delta $deltaYClass" style="margin-top:6px;">
          <span class="icon">$deltaYIcon</span>
          <span>A/A ${_escapeHtml(Formatters.formatPercent(kpi.variacaoAnual))}</span>
        </div>
        <div class="meta">Fonte: ${_escapeHtml(kpi.fonte)} · ${_escapeHtml(_formatDate(kpi.ultimaAtualizacao))}</div>
      </article>
''');
      }
      buffer.writeln('    </div>');
      buffer.writeln('  </section>');
    }

    if (series != null &&
        (series.pib.isNotEmpty ||
            series.empregosMensal.isNotEmpty ||
            series.admissoesPorCnae.isNotEmpty)) {
      buffer.writeln('  <section class="card">');
      buffer.writeln('    <h2>Séries temporais</h2>');

      if (series.pib.isNotEmpty) {
        buffer.writeln('    <h3>PIB Municipal</h3>');
        buffer.writeln('    <table class="data">');
        buffer.writeln('      <tr><th>Ano</th><th>Valor</th></tr>');
        for (final ponto in series.pib) {
          buffer.writeln(
              '      <tr><td>${_escapeHtml(ponto.periodo)}</td><td>${_escapeHtml(Formatters.formatNumber(ponto.valor))}</td></tr>');
        }
        buffer.writeln('    </table>');
      }

      if (series.empregosMensal.isNotEmpty) {
        buffer.writeln('    <h3>Empregos formais (mensal)</h3>');
        buffer.writeln('    <table class="data">');
        buffer.writeln('      <tr><th>Período</th><th>Total</th></tr>');
        for (final ponto in series.empregosMensal) {
          buffer.writeln(
              '      <tr><td>${_escapeHtml(_formatPeriod(ponto.periodo))}</td><td>${_escapeHtml(Formatters.formatNumber(ponto.valor))}</td></tr>');
        }
        buffer.writeln('    </table>');
      }

      if (series.admissoesPorCnae.isNotEmpty) {
        buffer.writeln('    <h3>Top 10 admissões por CNAE</h3>');
        buffer.writeln('    <table class="data">');
        buffer.writeln(
            '      <tr><th>CNAE</th><th>Período</th><th>Bairro</th><th>Admissões</th></tr>');
        for (final item in series.admissoesPorCnae) {
          buffer.writeln(
              '      <tr><td>${_escapeHtml(item.cnae)}</td><td>${_escapeHtml(item.periodo ?? '-')}</td><td>${_escapeHtml(item.bairro ?? '-')}</td><td>${_escapeHtml(Formatters.formatNumber(item.valor))}</td></tr>');
        }
        buffer.writeln('    </table>');
      }

      buffer.writeln('  </section>');
    }

    if (alertas != null && alertas.isNotEmpty) {
      buffer.writeln('  <section class="card">');
      buffer.writeln('    <h2>Alertas e tendências</h2>');
      buffer.writeln('    <div class="alerts">');
      for (final alert in alertas) {
        final classe = _severityClass(alert.severidade);
        buffer.writeln(
            '      <article class="alert $classe"><strong>${_escapeHtml(_severityLabel(alert.severidade))}</strong>${_escapeHtml(alert.mensagem)}</article>');
      }
      buffer.writeln('    </div>');
      buffer.writeln('  </section>');
    }

    buffer.writeln('''
    <footer>
      <p>Cascavel em Números · Relatório gerado automaticamente</p>
    </footer>
  </div>
</body>
</html>
''');

    _baixarArquivo(
      buffer.toString(),
      'cascavel_dashboard.html',
      'text/html',
    );
  }

  static String _csvHeader(List<String> columns) => _csvRow(columns);

  static String _csvRow(List<String> columns) {
    return columns.map(_sanitizeCsv).join(_csvSeparator);
  }

  static String _sanitizeCsv(String value) {
    final sanitized = value.replaceAll('"', '""');
    return '"$sanitized"';
  }

  static String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  static String _formatDate(String value) {
    final date = Formatters.parseDate(value);
    if (date != null) {
      return Formatters.formatDate(date);
    }
    return value;
  }

  static String _formatPeriod(String period) {
    return Formatters.formatPeriod(period);
  }

  static String _severityLabel(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return 'Alto';
      case 'medium':
        return 'Médio';
      case 'low':
        return 'Baixo';
      default:
        return 'Informativo';
    }
  }

  static String _severityClass(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return 'alto';
      case 'medium':
        return 'medio';
      case 'low':
        return 'baixo';
      default:
        return 'info';
    }
  }

  static void _baixarArquivo(
    String conteudo,
    String nomeArquivo,
    String tipoMime,
  ) {
    final bytes = utf8.encode(conteudo);
    final blob = html.Blob([bytes], tipoMime);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', nomeArquivo)
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
