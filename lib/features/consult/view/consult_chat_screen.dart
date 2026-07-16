import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:glowbebe/core/widgets/glow_ui.dart';
import 'package:glowbebe/routes/route_names.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsultChatScreen extends StatefulWidget {
  const ConsultChatScreen({super.key});

  @override
  State<ConsultChatScreen> createState() => _ConsultChatScreenState();
}

class _ConsultChatScreenState extends State<ConsultChatScreen> {
  final _controller = TextEditingController();
  final _messages = <_ChatMsg>[
    _ChatMsg(
      isAi: true,
      text:
          'Hi — I\'ve reviewed your latest scan. Dark spots and mild texture unevenness stand out. What would you like to improve first?',
    ),
    _ChatMsg(
      isAi: false,
      text: 'I want to fade dark spots without irritation.',
    ),
    _ChatMsg(
      isAi: true,
      text:
          'Great focus. Introduce a gentle vitamin C in the morning under SPF, and keep niacinamide at night. Avoid stacking strong acids the same night as retinoid.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMsg(isAi: false, text: text));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GlowAppBar(
        title: 'Skin Coach',
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.consultSummary),
            child: Text(
              'End',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return Align(
                  alignment:
                      m.isAi ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.78,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: m.isAi
                          ? AppColors.surface
                          : AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(m.isAi ? 4 : 16),
                        bottomRight: Radius.circular(m.isAi ? 16 : 4),
                      ),
                      border: m.isAi
                          ? Border.all(color: AppColors.borderSoft)
                          : null,
                    ),
                    child: Text(
                      m.text,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 1.45,
                        color: m.isAi ? AppColors.textPrimary : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask your coach…',
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide:
                              const BorderSide(color: AppColors.borderSoft),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide:
                              const BorderSide(color: AppColors.borderSoft),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide:
                              const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: AppColors.primary,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: _send,
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMsg {
  const _ChatMsg({required this.isAi, required this.text});
  final bool isAi;
  final String text;
}
