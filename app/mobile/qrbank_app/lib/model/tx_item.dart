import 'package:flutter/material.dart';
import 'package:qrbank_app/model/transaction.dart';

class TxGroup {
  final String label;
  final List<Transaction> transactions;
  const TxGroup({required this.label, required this.transactions});
}

class TxItem {
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;
  final String date;

  const TxItem({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.date,
  });
}

// ── Tile ──────────────────────────────────────────────────────

class TxTile extends StatelessWidget {
  final Transaction tx;
  const TxTile({required this.tx});

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
  final style = _resolveStyle(); // <-- adicione

  return InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: style.iconColor,        // <-- era tx.iconColor
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(style.icon, size: 20, color: style.iconFgColor), // <-- era tx.icon
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title ?? 'Transação',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '${style.subtitle}  •  ${tx.createdAt.toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFFB0A8C8)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${style.isCredit ? '+' : '-'} Kz ${tx.amount}', // <-- style
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: style.isCredit
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded,
              size: 16, color: Color(0xFFB0A8C8)),
        ],
      ),
    ),
  );
}
}
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


