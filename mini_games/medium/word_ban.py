import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

DATASET = [
    {"prompt": "احكي عملت إيه أول ما صحيت النهاردة بالتفصيل؟", "banned": "ممنوع حرف (الميم - م)"},
    {"prompt": "اوصف أكلتك المفضلة وإزاي بتتعمل ومكوناتها؟", "banned": "ممنوع كلمة (و / مع)"},
    {"prompt": "قول خطتك للصيف والإجازة الجاية؟", "banned": "ممنوع حرف (السين - س)"},
    {"prompt": "اوصف صديقك المفضل وليه بتحبه؟", "banned": "ممنوع كلمة (هو / كان)"},
    {"prompt": "اتكلم عن فيلمك أو مسلسلك المفضل بدون ما تذكر اسمه؟", "banned": "ممنوع حرف (الألف - ا)"},
    {"prompt": "ليه بتحب لعبة بنك الحظ وازاي بتكسب فيها؟", "banned": "ممنوع كلمة (عشان / فلوس)"},
    {"prompt": "اوصف بيتك وغرفتك وترتيبها؟", "banned": "ممنوع حرف (النون - ن)"},
]

class WordBanGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="word_ban",
            name_ar="الممنوع من الكلام",
            tier_ar="متوسط",
            time_limit=10.0,
            objective_ar="تكلم مستمرًا لمدة 10 ثوانٍ مجيبًا على السؤال دون نطق الحرف أو الكلمة الممنوعة!",
            on_result=on_result,
            on_timeout=on_timeout
        )
        self.item = random.choice(DATASET)
        self.setup_ui()
        self.start_timer()

    def setup_ui(self):
        self.build_header()
        self.build_timer()
        
        card = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=16, border_width=2, border_color="#2c3340")
        card.pack(fill="x", pady=6, padx=10, ipady=8)
        
        prompt_tag = tk.CTkLabel(card, text=fix_ar("سؤال التحدي:"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=13), text_color="#8b949e")
        prompt_tag.pack(pady=(2, 0))
        
        prompt_lbl = tk.CTkLabel(card, text=fix_ar(self.item["prompt"]), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=16), text_color="#f0f6fc", wraplength=340, justify="center")
        prompt_lbl.pack(pady=(2, 8), padx=10)
        
        banned_badge = tk.CTkFrame(self.container, fg_color="#5e1616", corner_radius=14, border_width=2, border_color="#f85149")
        banned_badge.pack(fill="x", padx=15, pady=6, ipady=6)
        
        banned_lbl = tk.CTkLabel(banned_badge, text=fix_ar(f"⛔ {self.item['banned']} ⛔"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=18), text_color="#ff7b72")
        banned_lbl.pack()
        
        rule_lbl = tk.CTkLabel(self.container, text=fix_ar("⚠️ إذا توقفت لأكثر من ثانيتين أو نطقت الممنوع تخسر التحدي!"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=12), text_color="#d29922", justify="center")
        rule_lbl.pack(pady=4)