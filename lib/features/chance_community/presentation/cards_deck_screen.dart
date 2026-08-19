import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/data/models/chance_card_model.dart';
import 'package:monopoly_helper/features/player_management/state/player_provider.dart';
import 'package:monopoly_helper/features/chance_community/state/cards_provider.dart';

class CardsDeckScreen extends StatelessWidget {
  const CardsDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardsProvider = context.watch<CardsProvider>();
    final playerProvider = context.watch<PlayerProvider>();
    final card = cardsProvider.lastDrawnCard;
    final isChance = cardsProvider.activeDeck == CardDeckType.chance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navCards),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Deck Switcher
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => cardsProvider.selectDeck(CardDeckType.chance),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isChance ? AppColors.chanceOrange : AppColors.darkCard,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      AppStrings.chanceTitle,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isChance ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => cardsProvider.selectDeck(CardDeckType.communityChest),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isChance ? AppColors.communityBlue : AppColors.darkCard,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      AppStrings.communityTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: !isChance ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Card Display Area
            Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400, minHeight: 280),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isChance
                        ? [const Color(0xFFE65100), const Color(0xFFFF9800)]
                        : [const Color(0xFF01579B), const Color(0xFF0288D1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (isChance ? AppColors.chanceOrange : AppColors.communityBlue).withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: card == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isChance ? Icons.question_mark : Icons.inventory_2,
                              size: 80,
                              color: Colors.white70,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isChance ? 'كروت فرصة (Chance)' : 'صندوق الجماعة (Community Chest)',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'اضغط على الزر أدناه لسحب كارت عشوائي',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                card.titleEnglish,
                                style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              card.titleArabic,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              card.descriptionArabic,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (card.amount > 0) ...[
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.cashGold,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'المبلغ: ${card.amount} £',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Draw Button
            ElevatedButton.icon(
              onPressed: () => cardsProvider.drawCard(),
              icon: const Icon(Icons.style, size: 22),
              label: const Text(AppStrings.drawCard),
              style: ElevatedButton.styleFrom(
                backgroundColor: isChance ? AppColors.chanceOrange : AppColors.communityBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 14),

            // Apply card action directly on a player
            if (card != null && playerProvider.activePlayers.isNotEmpty) ...[
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تطبيق تأثير الكارت على لاعب:',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: playerProvider.activePlayers.map((p) {
                        return ElevatedButton(
                          onPressed: () {
                            cardsProvider.applyCardEffect(playerProvider, p.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('تم تطبيق الكارت على ${p.name}')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: p.color,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                          child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
