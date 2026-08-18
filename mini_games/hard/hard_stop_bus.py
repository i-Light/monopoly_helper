import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

LETTERS_DATA = [
    {"letter": "س", "categories": ["اسم", "بلد", "جماد"], "examples": "سامي - سوريا - سيارة"},
    {"letter": "م", "categories": ["اسم", "بلد", "حيوان"], "examples": "محمد - مصر - ماعز"},
    {"letter": "ب", "categories": ["اسم", "جماد", "نبات"], "examples": "باسم - باب - برتقال"},
    {"letter": "ك", "categories": ["بلد", "جماد", "حيوان"], "examples": "كندا - كرسي - كلب"},
    {"letter": "ف", "categories": ["اسم", "بلد", "حيوان"], "examples": "فارس - فرنسا - فهد"},
    {"letter": "ر", "categories": ["اسم", "نبات", "جماد"], "examples": "رامي - رمان - راديو"},
    {"letter": "ج", "categories": ["اسم", "بلد", "حيوان"], "examples": "جمال - جزائر - جمل"},
]

class HardStopBusGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="hard_stop_bus_complete",
            name_ar="أتوبيس كومبليت الثلاثي",
            tier_ar="صعب",
            time_limit=10.0,
            objective_ar="اذكر 3 كلمات لثلاثة تصنيفات مختلفة تبدأ بالحرف المحدد خلال 10 ثوانٍ!",
            on_result=on_result,
            on_timeout=on_timeout
        )
        self.item = random.choice(LETTERS_DATA)
        self.showing_examples = False
        self.setup_ui()
        self.start_timer()

    def setup_ui(self):
        self.build_header()
        self.build_timer()
        
        card = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=16, border_width=2, border_color="#2c3340")
        card.pack(fill="x", pady=6, padx=10, ipady=8)
        
        letter_box = tk.CTkFrame(card, fg_color="#36165e", corner_radius=20, border_width=2, border_color="#583484")
        letter_box.pack(pady=(4, 6), ipadx=14, ipady=2)
        
        letter_tag = tk.CTkLabel(letter_box, text=fix_ar("الحرف المطلوب"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=11), text_color="#c4b5fd")
        letter_tag.pack()
        letter_val = tk.CTkLabel(letter_box, text=fix_ar(f"« {self.item['letter']} »"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=30), text_color="#ffffff")
        letter_val.pack()
        
        cats_frame = tk.CTkFrame(card, fg_color="transparent")
        cats_frame.pack(pady=4)
        for i in range(3):
            cats_frame.grid_columnconfigure(i, weight=1)
            
        for idx, cat_name in enumerate(self.item["categories"]):
            badge = tk.CTkLabel(
                cats_frame,
                text=fix_ar(f"{idx+1}. {cat_name}"),
                font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=13),
                fg_color="#165e29",
                text_color="#86efac",
                corner_radius=10,
                padx=10,
                pady=6
            )
            badge.grid(row=0, column=idx, padx=4, pady=2, sticky="ew")
            
        rule_lbl = tk.CTkLabel(self.container, text=fix_ar("📢 انطق الإجابات الثلاث بصوت عالٍ واللاعبون يحكمون على صحتها"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=13), text_color="#e6edf3", justify="center")
        rule_lbl.pack(pady=4)
        
        self.examples_btn = tk.CTkButton(self.container, text=fix_ar("إظهار مثال للإجابة 👁️"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=12), fg_color="#21262d", hover_color="#30363d", text_color="#8b949e", height=30, corner_radius=8, command=self.toggle_examples)
        self.examples_btn.pack(pady=3)
        
        self.examples_label = tk.CTkLabel(self.container, text="", font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=13), text_color="#7ee787", justify="center")
        self.examples_label.pack(pady=2)

    def toggle_examples(self):
        self.showing_examples = not self.showing_examples
        if self.showing_examples:
            self.examples_label.configure(text=fix_ar(f"مثال صحيح: {self.item['examples']}"))
            self.examples_btn.configure(text=fix_ar("إخفاء المثال 👁️"))
        else:
            self.examples_label.configure(text="")
            self.examples_btn.configure(text=fix_ar("إظهار مثال للإجابة 👁️"))