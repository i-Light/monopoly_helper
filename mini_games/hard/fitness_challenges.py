import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

DATASET = [
    {"exercise": "10 ضغط (Push-ups) 💪", "time": 20.0, "tip": "حافظ على استقامة ظهرك أثناء التمرين"},
    {"exercise": "15 سكوات (Squats) 🦵", "time": 20.0, "tip": "انزل بزاوية 90 درجة مع صعود كامل"},
    {"exercise": "20 ثانية ثبات بلانك (Plank) ⏱️", "time": 25.0, "tip": "اثبت في وضعية البلانك حتى ينتهي الوقت"},
    {"exercise": "20 قفزة جاك (Jumping Jacks) ⭐", "time": 15.0, "tip": "قفز متواصل مع حركة كاملة للذراعين"},
    {"exercise": "15 تمرين بطن (Sit-ups) 🔥", "time": 25.0, "tip": "صعود ونزول محكم لعضلات البطن"},
]

class FitnessChallengesGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        self.item = random.choice(DATASET)
        super().__init__(
            parent=parent,
            game_id="fitness_physical_challenges",
            name_ar="التحدي البدني الرياضي",
            tier_ar="صعب",
            time_limit=self.item["time"],
            objective_ar="قم من مكانك ونفّذ التمرين البدني المطلوب بالكامل قبل انتهاء الوقت!",
            on_result=on_result,
            on_timeout=on_timeout
        )
        self.setup_ui()
        self.start_timer()

    def setup_ui(self):
        self.build_header()
        self.build_timer()
        
        card = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=16, border_width=2, border_color="#2c3340")
        card.pack(fill="x", pady=6, padx=10, ipady=10)
        
        ex_tag = tk.CTkLabel(card, text=fix_ar("التمرين المطلوب:"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=13), text_color="#8b949e")
        ex_tag.pack(pady=(2, 0))
        
        ex_lbl = tk.CTkLabel(card, text=fix_ar(self.item["exercise"]), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=24), text_color="#ff7b72")
        ex_lbl.pack(pady=4)
        
        tip_lbl = tk.CTkLabel(card, text=fix_ar(f"💡 نصيحة: {self.item['tip']}"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=13), text_color="#86efac")
        tip_lbl.pack(pady=(2, 4))
        
        rule_lbl = tk.CTkLabel(self.container, text=fix_ar("📢 اللاعبون يشاهدون ويحكمون على اكتمال العدات وصحتها"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=13), text_color="#e6edf3", justify="center")
        rule_lbl.pack(pady=4)