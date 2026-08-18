import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

DATASET = [
    {"words": ["قارب", "برتقال", "صابر", "مكتب"], "common": "ب", "distractors": ["ر", "ت", "ق"]},
    {"words": ["شمس", "سماء", "مسجد", "سوق"], "common": "س", "distractors": ["م", "ش", "ق"]},
    {"words": ["نهر", "فهد", "هرم", "وجه"], "common": "هـ", "distractors": ["ر", "ف", "م"]},
    {"words": ["عنب", "شارع", "عين", "قلعة"], "common": "ع", "distractors": ["ن", "ر", "ل"]},
    {"words": ["ورد", "دلو", "صوت", "ضوء"], "common": "و", "distractors": ["د", "ص", "ت"]},
    {"words": ["مطر", "طريق", "بطة", "قطار"], "common": "ط", "distractors": ["ر", "م", "ق"]},
    {"words": ["جمل", "ليمون", "حبل", "علم"], "common": "ل", "distractors": ["م", "ج", "ع"]},
]

class CommonLetterFinderGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="common_letter_finder",
            name_ar="كاشف الحرف المشترك",
            tier_ar="متوسط",
            time_limit=5.0,
            objective_ar="اختر الحرف الموجود في جميع الكلمات الأربع المعروضة!",
            on_result=on_result,
            on_timeout=on_timeout
        )
        self.item = random.choice(DATASET)
        self.option_buttons = []
        self.setup_ui()
        self.start_timer()

    def setup_ui(self):
        self.build_header()
        self.build_timer()
        
        words_card = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=16, border_width=2, border_color="#2c3340")
        words_card.pack(fill="x", pady=6, padx=10, ipady=8)
        
        grid_words = tk.CTkFrame(words_card, fg_color="transparent")
        grid_words.pack(pady=4)
        for i in range(2):
            grid_words.grid_columnconfigure(i, weight=1)
            
        for idx, w in enumerate(self.item["words"]):
            r, c = idx // 2, idx % 2
            pill = tk.CTkLabel(
                grid_words,
                text=fix_ar(w),
                font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=18),
                fg_color="#282c34",
                text_color="#58a6ff",
                corner_radius=10,
                padx=16,
                pady=6
            )
            pill.grid(row=r, column=c, padx=8, pady=4, sticky="nsew")
            
        opts_frame = tk.CTkFrame(self.container, fg_color="transparent")
        opts_frame.pack(fill="x", padx=10, pady=8)
        
        options = self.item["distractors"][:] + [self.item["common"]]
        random.shuffle(options)
        for i in range(len(options)):
            opts_frame.grid_columnconfigure(i, weight=1)
            
        self.option_buttons = []
        for idx, letter in enumerate(options):
            btn = tk.CTkButton(
                opts_frame,
                text=fix_ar(f"( {letter} )"),
                font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=20),
                fg_color="#282c34",
                border_color="#3e4451",
                border_width=2,
                corner_radius=12,
                height=48,
                hover_color="#3e4451",
                command=lambda l=letter, i=idx: self.on_option_click(l, i)
            )
            btn.grid(row=0, column=idx, padx=4, pady=4, sticky="ew")
            self.option_buttons.append((btn, letter))

    def on_option_click(self, selected_letter, clicked_idx):
        if self.is_finished:
            return
        is_correct = (selected_letter == self.item["common"])
        
        for btn, ltr in self.option_buttons:
            btn.configure(state="disabled")
            if ltr == self.item["common"]:
                btn.configure(fg_color="#2ea043", border_color="#3fb950", text_color="#ffffff")
            elif btn == self.option_buttons[clicked_idx][0] and not is_correct:
                btn.configure(fg_color="#f85149", border_color="#da3633", text_color="#ffffff")
                
        if is_correct:
            self.show_status(f"إجابة صحيحة! 🎉 الحرف المشترك هو: « {self.item['common']} »", success=True)
            self.finish(True, "answered_correctly")
        else:
            self.show_status(f"إجابة خاطئة! ❌ الحرف الصحيح هو: « {self.item['common']} »", success=False)
            self.finish(False, "answered_wrong")

    def handle_timeout(self):
        super().handle_timeout()
        for btn, ltr in self.option_buttons:
            btn.configure(state="disabled")
            if ltr == self.item["common"]:
                btn.configure(fg_color="#2ea043", border_color="#3fb950", text_color="#ffffff")