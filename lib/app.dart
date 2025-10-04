import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/home/pages/home_page.dart';

class CascavelApp extends StatelessWidget {
  const CascavelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Cascavel em Números',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const HomePage(),
        builder: (context, child) {
          return MediaQuery(
            // Garantir que o texto não seja menor que 14px para acessibilidade
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2)),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
