import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

DATASET = [
    {"starter": "شمس", "last_letter": "س", "example": "شمس ← ساعة ← تمر"},
    {"starter": "كتاب", "last_letter": "ب", "example": "كتاب ← بحر ← رمان"},
    {"starter": "نجمة", "last_letter": "ة (أو ت)", "example": "نجمة ← تفاح ← حصان"},
    {"starter": "قمر", "last_letter": "ر", "example": "قمر ← رمح ← حوت"},
    {"starter": "طريق", "last_letter": "ق", "example": "طريق ← قطار ← ريشة"},
    {"starter": "هلال", "last_letter": "ل", "example": "هلال ← ليمون ← نسر"},
    {"starter": "صقر", "last_letter": "ر", "example": "صقر ← رمل ← ليل"},
    {"starter": "مسجد", "last_letter": "د", "example": "مسجد ← دراجة ← جمل"},
]

class LastLetterWordChainGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="last_letter_word_chain",
            name_ar="سلسلة الحرف الأخير",
            tier_ar="متوسط",
            time_limit=6.0,
            objective_ar="انطق كلمتين متتاليتين؛ كل كلمة تبدأ بآخر حرف من الكلمة السابقة!",
            on_result=on_result,
            on_timeout=on_timeout
        )
        self.item = random.choice(DATASET)
        self.showing_example = False
        self.setup_ui()
        self.start_timer()

    def setup_ui(self):
        self.build_header()
        self.build_timer()
        
        card = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=16, border_width=2, border_color="#2c3340")
        card.pack(fill="x", pady=6, padx=10, ipady=8)
        
        starter_tag = tk.CTkLabel(card, text=fix_ar("كلمة البداية:"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=13), text_color="#8b949e")
        starter_tag.pack(pady=(2, 0))
        
        starter_lbl = tk.CTkLabel(card, text=fix_ar(f"« {self.item['starter']} »"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=28), text_color="#58a6ff")
        starter_lbl.pack(pady=2)
        
        info_lbl = tk.CTkLabel(card, text=fix_ar(f"الحرف المطلوب للكلمة التالية: ( {self.item['last_letter']} )"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=14), text_color="#7ee787")
        info_lbl.pack(pady=(0, 4))
        
        rule_lbl = tk.CTkLabel(self.container, text=fix_ar("📢 المطلوب: تكملة السلسلة بكلمتين صحيحتين سريعاً بصوت عالٍ"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=13), text_color="#e6edf3", justify="center")
        rule_lbl.pack(pady=4)
        
        self.example_btn = tk.CTkButton(self.container, text=fix_ar("إظهار مثال للسلسلة 👁️"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=12), fg_color="#21262d", hover_color="#30363d", text_color="#8b949e", height=30, corner_radius=8, command=self.toggle_example)
        self.example_btn.pack(pady=3)
        
        self.example_lbl = tk.CTkLabel(self.container, text="", font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=13), text_color="#7ee787", justify="center")
        self.example_lbl.pack(pady=2)

    def toggle_example(self):
        self.showing_example = not self.showing_example
        if self.showing_example:
            self.example_lbl.configure(text=fix_ar(f"مثال صحيح: {self.item['example']}"))
            self.example_btn.configure(text=fix_ar("إخفاء المثال 👁️"))
        else:
            self.example_lbl.configure(text="")
            self.example_btn.configure(text=fix_ar("إظهار مثال للسلسلة 👁️"))