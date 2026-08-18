import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monopoly_helper/core/constants/app_colors.dart';
import 'package:monopoly_helper/core/constants/app_strings.dart';
import 'package:monopoly_helper/core/theme/theme_provider.dart';
import 'package:monopoly_helper/core/widgets/custom_card.dart';
import 'package:monopoly_helper/features/player_management/state/player_provider.dart';
import 'package:monopoly_helper/features/settings/state/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final playerProvider = context.read<PlayerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.gameSettings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme & Appearance
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('المظهر والواجهة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text(AppStrings.darkMode),
                  subtitle: const Text('التبديل بين الوضع الليلي والنهاري'),
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
                SwitchListTile(
                  title: const Text('اتجاه الواجهة (RTL / LTR)'),
                  subtitle: Text(themeProvider.isRTL ? 'من اليمين لليسار (العربية)' : 'من اليسار لليمين (English)'),
                  value: themeProvider.isRTL,
                  onChanged: (_) => themeProvider.toggleDirection(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Audio & Feedback
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('المؤثرات الصوتية والاهتزاز', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text(AppStrings.soundEffects),
                  subtitle: const Text('تشغيل أصوات رمي النرد والمؤقت والنتائج'),
                  value: settingsProvider.soundEnabled,
                  onChanged: (val) => settingsProvider.toggleSound(val),
                ),
                SwitchListTile(
                  title: const Text('الاهتزاز اللمسي (Haptics)'),
                  subtitle: const Text('تفعيل الاهتزاز عند التفاعل'),
                  value: settingsProvider.vibrationEnabled,
                  onChanged: (val) => settingsProvider.toggleVibration(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Game Rules Config
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('قواعد اللعبة والمبالغ الافتراضية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('الرصيد الافتتاحي للاعب'),
                  trailing: Text('${settingsProvider.startingCash} £', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                ListTile(
                  title: const Text('مكافأة المرور بالبداية (GO)'),
                  trailing: Text('${settingsProvider.goSalary} £', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                ListTile(
                  title: const Text('كفالة الخروج من السجن'),
                  trailing: Text('${settingsProvider.jailBail} £', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Reset Action
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(AppStrings.resetAll),
                  content: const Text('هل أنت متأكد من إعادة ضبط اللعبة بالكامل؟ سيتم مسح جميع اللاعبين والسجلات.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.cancel)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                      onPressed: () {
                        playerProvider.resetGame();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تمت إعادة ضبط اللعبة بنجاح')),
                        );
                      },
                      child: const Text('تأكيد الإعادة'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text(AppStrings.resetAll),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
