import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar formatação de data/hora em português
  await initializeDateFormatting('pt_BR', null);
  Intl.defaultLocale = 'pt_BR';
  
  runApp(const CascavelApp());
}