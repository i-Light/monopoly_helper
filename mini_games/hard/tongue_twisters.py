import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

DATASET = [
    {"phrase": "خيط حرير على حيط خليل", "repeat": 3},
    {"phrase": "شمس تمشي وشمس مشمش", "repeat": 3},
    {"phrase": "حوش قميص بطة حوش قميص قطة", "repeat": 3},
    {"phrase": "طربوش طقطش طربوشنا، نقدر نطقطش طربوشكم؟", "repeat": 2},
    {"phrase": "لحم الحمام حلال ولحم الحمار حرام", "repeat": 3},
    {"phrase": "بسيط سبح في شط بحر شاطيء", "repeat": 3},
]

class TongueTwistersGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="tongue_twisters",
            name_ar="عقدة اللسان (الترتور)",
            tier_ar="صعب",
            time_limit=6.0,
            objective_ar="كرر الجملة الصعبة المعروضة بسرعة وبدون أي تلعثم أو خطأ!",
            on_result=on_result,
            on_timeout=on_timeout
        )
        self.item = random.choice(DATASET)
        self.setup_ui()
        self.start_timer()

    def setup_ui(self):
        self.build_header()
        self.build_timer()
        
        banner = tk.CTkLabel(self.container, text=fix_ar("🔥 تحدي سريع ونادر — ركّز وانطق بأقصى سرعة! 🔥"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=13), text_color="#f85149")
        banner.pack(pady=(0, 4))
        
        card = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=16, border_width=2, border_color="#2c3340")
        card.pack(fill="x", pady=6, padx=10, ipady=10)
        
        phrase_lbl = tk.CTkLabel(card, text=fix_ar(f"« {self.item['phrase']} »"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=20), text_color="#f0f6fc", wraplength=340, justify="center")
        phrase_lbl.pack(pady=6, padx=10)
        
        rep_frame = tk.CTkFrame(card, fg_color="transparent")
        rep_frame.pack(pady=(4, 6))
        req = self.item["repeat"]
        for i in range(1, req + 1):
            badge = tk.CTkLabel(rep_frame, text=fix_ar(f"المرة {i}"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=12), fg_color="#36165e", text_color="#c4b5fd", corner_radius=8, padx=10, pady=4)
            badge.pack(side="left", padx=4)
            
        rule_lbl = tk.CTkLabel(self.container, text=fix_ar(f"📢 كررها {req} مرات متتالية (تحكيم باقي اللاعبين للوضوح)"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=13), text_color="#e6edf3", justify="center")
        rule_lbl.pack(pady=4)