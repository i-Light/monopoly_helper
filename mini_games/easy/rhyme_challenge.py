import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

DATASET = [
    {"word": "كتاب", "rhymes": ["سحاب", "عذاب", "ذهاب", "شباب", "جواب", "باب"]},
    {"word": "قمر", "rhymes": ["سمر", "شجر", "بصر", "عمر", "مطر", "حجر"]},
    {"word": "سماء", "rhymes": ["هواء", "فضاء", "دواء", "وفاء", "رجاء", "صفاء"]},
    {"word": "زهور", "rhymes": ["سرور", "بحور", "طيور", "عطور", "نور", "قصور"]},
    {"word": "سلام", "rhymes": ["كلام", "أحلام", "غرام", "حمام", "وئام", "أيام"]},
    {"word": "ليل", "rhymes": ["سيل", "خيل", "ميل", "ويل", "نيل", "دليل"]},
    {"word": "قلب", "rhymes": ["درب", "حب", "صلب", "قرب", "شرب", "عذب"]},
    {"word": "طريق", "rhymes": ["رفيق", "بريق", "حريق", "غريق", "صديق", "عقيق"]},
]

class RhymeChallengeGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="rhyme_challenge",
            name_ar="تحدي القافية",
            tier_ar="سهل",
            time_limit=5.0,
            objective_ar="اذكر كلمتين تنتهيان بنفس قافية الكلمة المعروضة قبل انتهاء الوقت!",
            on_result=on_result,
            on_timeout=on_timeout
        )
        self.item = random.choice(DATASET)
        self.showing_examples = False
        self.setup_ui()
        self.start_timer()

    def setup_ui(self):
        self.build_header()
        self.build_timer()
        
        card = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=16, border_width=2, border_color="#2c3340")
        card.pack(fill="x", pady=8, padx=10, ipady=10)
        
        title_tag = tk.CTkLabel(card, text=fix_ar("الكلمة المستهدفة:"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=14), text_color="#8b949e")
        title_tag.pack(pady=(4, 0))
        
        word_label = tk.CTkLabel(card, text=fix_ar(self.item["word"]), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=32), text_color="#58a6ff")
        word_label.pack(pady=(2, 6))
        
        rule_label = tk.CTkLabel(self.container, text=fix_ar("📢 انطق كلمتين على نفس الوزن والقافية (تحكيم اللاعبين)"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=13), text_color="#e6edf3", justify="center")
        rule_label.pack(pady=(2, 6))
        
        self.examples_btn = tk.CTkButton(self.container, text=fix_ar("إظهار أمثلة للمراجعة 👁️"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=12), fg_color="#21262d", hover_color="#30363d", text_color="#8b949e", height=30, corner_radius=8, command=self.toggle_examples)
        self.examples_btn.pack(pady=4)
        
        self.examples_label = tk.CTkLabel(self.container, text="", font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=13), text_color="#7ee787", justify="center")
        self.examples_label.pack(pady=2)

    def toggle_examples(self):
        self.showing_examples = not self.showing_examples
        if self.showing_examples:
            rhymes_str = " / ".join(self.item["rhymes"][:4])
            self.examples_label.configure(text=fix_ar(f"أمثلة مقبولة: {rhymes_str}"))
            self.examples_btn.configure(text=fix_ar("إخفاء الأمثلة 👁️"))
        else:
            self.examples_label.configure(text="")
            self.examples_btn.configure(text=fix_ar("إظهار أمثلة للمراجعة 👁️"))