import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Tópicos com perguntas expandíveis
  final List<_Topic> _topics = [
    _Topic(
      icon: Icons.qr_code_2_rounded,
      title: 'Pagar com QR Code',
      faqs: [
        _Faq(
          question: 'Como pago com QR Code?',
          answer:
              'Abra o app, toque em "Escanear QR" na tela inicial, aponte a câmera para o código QR do estabelecimento e confirme o valor.',
        ),
        _Faq(
          question: 'O QR Code tem validade?',
          answer:
              'Sim, os códigos QR gerados têm validade de 30 minutos. Após esse prazo, é necessário gerar um novo.',
        ),
      ],
    ),
    _Topic(
      icon: Icons.key_rounded,
      title: 'Segurança e Senha',
      faqs: [
        _Faq(
          question: 'Como altero minha senha?',
          answer:
              'Acesse Conta > Definições > Segurança e Senha. Insira sua senha atual e depois a nova senha duas vezes para confirmar.',
        ),
        _Faq(
          question: 'O que fazer se esquecer a senha?',
          answer:
              'Na tela de login, toque em "Esqueci minha senha" e siga as instruções enviadas ao seu e-mail cadastrado.',
        ),
      ],
    ),
    _Topic(
      icon: Icons.credit_card_outlined,
      title: 'Gerenciar Cartões',
      faqs: [
        _Faq(
          question: 'Como adiciono um cartão?',
          answer:
              'Vá em Conta > Métodos de Pagamento Salvos > Adicionar Cartão. Preencha os dados do cartão e confirme.',
        ),
        _Faq(
          question: 'Como bloqueio meu cartão virtual?',
          answer:
              'Na tela inicial, toque no card de saldo e selecione "Gerenciar Cartão Virtual". Deslize o botão para bloquear.',
        ),
      ],
    ),
    _Topic(
      icon: Icons.swap_horiz_rounded,
      title: 'Ajuda com Transferências',
      faqs: [
        _Faq(
          question: 'Qual o limite diário de transferência?',
          answer:
              'O limite padrão é R\$ 5.000,00 por dia. Você pode solicitar aumento do limite em Conta > Segurança.',
        ),
        _Faq(
          question: 'Transferência não chegou, o que faço?',
          answer:
              'Transferências Pix são instantâneas. Caso não receba em até 1 hora, entre em contato com nosso suporte pelo Chat 24h.',
        ),
      ],
    ),
  ];

  List<_Topic> get _filteredTopics {
    if (_searchQuery.isEmpty) return _topics;
    final q = _searchQuery.toLowerCase();
    return _topics
        .where((t) =>
            t.title.toLowerCase().contains(q) ||
            t.faqs.any((f) =>
                f.question.toLowerCase().contains(q) ||
                f.answer.toLowerCase().contains(q)))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topics = _filteredTopics;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.chevron_left_rounded,
                        color: Color(0xFF7B5FC4), size: 22),
                    label: const Text('Voltar',
                        style: TextStyle(
                            color: Color(0xFF7B5FC4),
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFFEDE8F8), width: 1.5),
                    ),
                    child: const Icon(Icons.chat_bubble_outline_rounded,
                        size: 18, color: Color(0xFF7B5FC4)),
                  ),
                ],
              ),
            ),

            // ── Conteúdo ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    const Center(
                      child: Text(
                        'Suporte e Ajuda',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7B5FC4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Barra de pesquisa
                    TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF3D2B7A)),
                      decoration: InputDecoration(
                        hintText: 'Buscar por dúvida...',
                        hintStyle: const TextStyle(
                            color: Color(0xFFB8A8E8), fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded,
                            size: 20, color: Color(0xFFB8A8E8)),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                                child: const Icon(Icons.close_rounded,
                                    size: 18, color: Color(0xFFB8A8E8)),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFFDDD6F3), width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF7B5FC4), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Tópicos Populares
                    const Text(
                      'Tópicos Populares',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    topics.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Center(
                              child: Column(
                                children: const [
                                  Icon(Icons.search_off_rounded,
                                      size: 40, color: Color(0xFFD0C4F0)),
                                  SizedBox(height: 10),
                                  Text('Nenhum resultado encontrado.',
                                      style: TextStyle(
                                          color: Color(0xFFB0A8C8),
                                          fontSize: 14)),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: topics.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                indent: 58,
                                endIndent: 16,
                                color: Color(0xFFF0EBF8),
                              ),
                              itemBuilder: (_, i) =>
                                  _TopicTile(topic: topics[i]),
                            ),
                          ),

                    const SizedBox(height: 28),

                    // Outras Opções de Contato
                    const Text(
                      'Outras Opções de Contato',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _ContactCard(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: 'Chat 24h',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ContactCard(
                            icon: Icons.phone_outlined,
                            label: 'Central\nTelefônica',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // ── Botão Falar com Atendente ─────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: abrir chat com atendente
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B3DBE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Falar com Atendente',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Topic Tile com accordion ──────────────────────────────────

class _TopicTile extends StatefulWidget {
  final _Topic topic;
  const _TopicTile({required this.topic});

  @override
  State<_TopicTile> createState() => _TopicTileState();
}

class _TopicTileState extends State<_TopicTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _ctrl;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _rotate = Tween<double>(begin: 0, end: 0.5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cabeçalho do tópico
        InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE8F8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.topic.icon,
                      size: 18, color: const Color(0xFF7B5FC4)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.topic.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                RotationTransition(
                  turns: _rotate,
                  child: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 22, color: Color(0xFF7B5FC4)),
                ),
              ],
            ),
          ),
        ),

        // FAQs expandidas
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          child: _expanded
              ? Container(
                  color: const Color(0xFFFAF8FF),
                  child: Column(
                    children: widget.topic.faqs
                        .map((faq) => _FaqTile(faq: faq))
                        .toList(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ── FAQ Tile ──────────────────────────────────────────────────

class _FaqTile extends StatefulWidget {
  final _Faq faq;
  const _FaqTile({required this.faq});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
            height: 1, indent: 16, endIndent: 16, color: Color(0xFFF0EBF8)),
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.help_outline_rounded,
                    size: 16, color: Color(0xFFB8A8E8)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.faq.question,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5B3DBE),
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeInOut,
                        child: _open
                            ? Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  widget.faq.answer,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9990B0),
                                    height: 1.5,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _open
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: const Color(0xFFB8A8E8),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Contact Card ──────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE8F8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF7B5FC4)),
            const SizedBox(width: 8),
            Text(
              label,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3D2B7A),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Modelos ───────────────────────────────────────────────────

class _Topic {
  final IconData icon;
  final String title;
  final List<_Faq> faqs;
  const _Topic({required this.icon, required this.title, required this.faqs});
}

class _Faq {
  final String question;
  final String answer;
  const _Faq({required this.question, required this.answer});
}
