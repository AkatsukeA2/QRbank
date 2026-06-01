import 'package:flutter/material.dart';
import 'package:qrbank_app/model/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction tx;
  const TransactionTile({required this.tx, super.key});

  // Lógica de apresentação fora do build, sem mutar tx
  _TileStyle _resolveStyle() {
    switch (tx.type) {
      case 'CREDIT':
        return _TileStyle(
          subtitle: 'Recebido',
          iconColor: const Color(0xFFE8F5E9),
          iconFgColor: const Color(0xFF4CAF50),
          icon: Icons.arrow_downward_rounded,
          isCredit: true,
        );
      case 'DEBIT':
        return _TileStyle(
          subtitle: 'Pago',
          iconColor: const Color(0xFFFFEBEE),
          iconFgColor: const Color(0xFFF44336),
          icon: Icons.swap_horiz_rounded,
          isCredit: false,
        );
      case 'WITHDRAW':
        return _TileStyle(
          subtitle: 'Levantado',
          iconColor: const Color(0xFFFFEBEE),
          iconFgColor: const Color(0xFFE53935),
          icon: Icons.money_off_csred_rounded,
          isCredit: false,
        );
      default:
        return _TileStyle(
          subtitle: tx.type,
          iconColor: const Color(0xFFEDE8F8),
          iconFgColor: const Color(0xFF7B5FC4),
          icon: Icons.receipt_outlined,
          isCredit: false,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(); // <-- lógica aqui, sem mutar tx

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Ícone
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: style.iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(style.icon, size: 20, color: style.iconFgColor),
          ),
          const SizedBox(width: 12),

          // Título + subtítulo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transação',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  style.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB0A8C8),
                  ),
                ),
              ],
            ),
          ),

          // Valor + data
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${style.isCredit ? '+' : '-'} ${tx.amount}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: style.isCredit
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tx.createdAt.toString().split(' ')[0],
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFB0A8C8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Classe auxiliar para estilo — substitui a mutação do modelo
class _TileStyle {
  final String subtitle;
  final Color iconColor;
  final Color iconFgColor;
  final IconData icon;
  final bool isCredit;

  _TileStyle({
    required this.subtitle,
    required this.iconColor,
    required this.iconFgColor,
    required this.icon,
    required this.isCredit,
  });
}
