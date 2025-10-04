import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static final NumberFormat _numberFormat = NumberFormat('#,##0', 'pt_BR');
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final DateFormat _monthYearFormat = DateFormat('MMM/yyyy', 'pt_BR');

  /// Formatar valores monetários
  static String formatCurrency(double value) {
    if (value >= 1000000) {
      return 'R\$ ${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return 'R\$ ${(value / 1000).toStringAsFixed(1)}K';
    }
    return _currencyFormat.format(value);
  }

  /// Formatar números grandes
  static String formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return _numberFormat.format(value.toInt());
  }

  /// Formatar percentual
  static String formatPercent(double value) {
    return '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}%';
  }

  /// Formatar percentual com símbolo
  static String formatPercentWithSymbol(double value) {
    String symbol = value > 0 ? '↗' : value < 0 ? '↘' : '→';
    return '$symbol ${formatPercent(value)}';
  }

  /// Formatar data
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Formatar mês/ano
  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  /// Converter string de data para DateTime
  static DateTime? parseDate(String dateString) {
    try {
      if (dateString.contains('-')) {
        // Formato: 2025-09-01
        return DateTime.parse(dateString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Formatar período para exibição
  static String formatPeriod(String period) {
    if (period.length == 7 && period.contains('-')) {
      // Formato: 2025-08
      final parts = period.split('-');
      final year = parts[0];
      final month = int.parse(parts[1]);
      final monthNames = [
        '', 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
        'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'
      ];
      return '${monthNames[month]}/$year';
    }
    return period;
  }

  /// Formatar CNAE para exibição
  static String formatCnae(String cnae) {
    // Mapear códigos CNAE para descrições amigáveis
    const cnaeDescriptions = {
      '01.11-3': 'Cultivo de cereais',
      '47.89-0': 'Comércio varejista',
      '62.01-1': 'Desenvolvimento de software',
      '86.10-1': 'Atividades hospitalares',
    };
    
    return cnaeDescriptions[cnae] ?? cnae;
  }

  /// Formatar valor baseado no tipo de KPI
  static String formatKpiValue(String key, double value) {
    switch (key) {
      case 'pib':
      case 'iss':
        return formatCurrency(value);
      case 'empregos':
      case 'empresas':
      case 'alvaras':
        return formatNumber(value);
      default:
        return formatNumber(value);
    }
  }

  /// Obter unidade do KPI
  static String getKpiUnit(String key) {
    switch (key) {
      case 'pib':
      case 'iss':
        return 'R\$ mi';
      case 'empregos':
        return 'empregos';
      case 'empresas':
        return 'empresas';
      case 'alvaras':
        return 'alvarás';
      default:
        return '';
    }
  }
}