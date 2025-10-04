import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: AppTheme.neutral900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildDesktopFooter();
          } else {
            return _buildMobileFooter();
          }
        },
      ),
    );
  }

  Widget _buildDesktopFooter() {
    return Row(
      children: [
        // Logo e informações principais
        Expanded(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.cascavelGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cascavel em Números',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Inteligência Econômica Municipal',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // // Status e versão
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   children: [
        //     Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Container(
        //           width: 8,
        //           height: 8,
        //           decoration: const BoxDecoration(
        //             color: AppTheme.crownGold,
        //             shape: BoxShape.circle,
        //           ),
        //         ),
        //         const SizedBox(width: 8),
        //         // const Text(
        //         //   'MVP • Dados mockados',
        //         //   style: TextStyle(
        //         //     color: AppTheme.crownGold,
        //         //     fontSize: 12,
        //         //     fontWeight: FontWeight.w500,
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //     const SizedBox(height: 4),
        //     Text(
        //       'v0.1.0 • ${DateTime.now().year}',
        //       style: TextStyle(
        //         color: Colors.white.withOpacity(0.5),
        //         fontSize: 12,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildMobileFooter() {
    return Column(
      children: [
        // Logo e título
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.cascavelGreen,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.analytics_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cascavel em Números',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Inteligência Econômica Municipal',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // // Status e versão
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Container(
        //           width: 6,
        //           height: 6,
        //           decoration: const BoxDecoration(
        //             color: AppTheme.crownGold,
        //             shape: BoxShape.circle,
        //           ),
        //         ),
        //         const SizedBox(width: 6),
        //         // const Text(
        //         //   'MVP • Dados mockados',
        //         //   style: TextStyle(
        //         //     color: AppTheme.crownGold,
        //         //     fontSize: 10,
        //         //     fontWeight: FontWeight.w500,
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //     Text(
        //       'v0.1.0 • ${DateTime.now().year}',
        //       style: TextStyle(
        //         color: Colors.white.withOpacity(0.5),
        //         fontSize: 10,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

/// Footer alternativo mais simples
class SimpleFooter extends StatelessWidget {
  const SimpleFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      child: Center(
        child: Column(
          children: [
            Divider(
              color: AppTheme.neutral400.withOpacity(0.3),
              thickness: 1,
            ),
            const SizedBox(height: 16),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

/// Footer com informações adicionais
class DetailedFooter extends StatelessWidget {
  const DetailedFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutral400.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sobre o Sistema',
                      style: TextStyle(
                        color: AppTheme.heraldicBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sistema de inteligência econômica para acompanhamento dos indicadores municipais de Cascavel-PR.',
                      style: TextStyle(
                        color: AppTheme.neutral400,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
