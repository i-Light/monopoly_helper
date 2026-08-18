import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

DATASET = [
    {"c1": "يبدأ بحرف (م)", "c2": "ينتهي بحرف (ر)", "examples": "مصر / مطر / معبر / ممر"},
    {"c1": "اسم بلد أو عاصمة", "c2": "خالٍ تماماً من النقاط", "examples": "مصر / عمان / روما / حماة"},
    {"c1": "يبدأ بحرف (س)", "c2": "مكون من 3 حروف فقط", "examples": "سيف / سمر / سور / سمك"},
    {"c1": "اسم حيوان أو طائر", "c2": "يبدأ بحرف (ف)", "examples": "فهد / فيل / فقر / فراشة"},
    {"c1": "اسم جماد أو أداة", "c2": "ينتهي بتاء مربوطة (ة)", "examples": "طاولة / سيارة / مرآة / ملعقة"},
    {"c1": "أكلة أو طعام", "c2": "يبدأ بحرف (ك)", "examples": "كشري / كباب / كنافة / كوسة"},
]

class DoubleConstraintWordGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="double_constraint_word",
            name_ar="الشرط المزدوج للكلمة",
            tier_ar="صعب",
            time_limit=5.0,
            objective_ar="اذكر كلمة واحدة تحقق الشرطين المحددين معاً في نفس الوقت!",
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
        card.pack(fill="x", pady=6, padx=10, ipady=8)
        
        c1_box = tk.CTkFrame(card, fg_color="#36165e", corner_radius=12, border_width=1, border_color="#583484")
        c1_box.pack(fill="x", padx=12, pady=4, ipady=4)
        c1_tag = tk.CTkLabel(c1_box, text=fix_ar("الشرط الأول (1)"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=11), text_color="#c4b5fd")
        c1_tag.pack()
        c1_val = tk.CTkLabel(c1_box, text=fix_ar(self.item["c1"]), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=16), text_color="#ffffff")
        c1_val.pack()
        
        c2_box = tk.CTkFrame(card, fg_color="#165e29", corner_radius=12, border_width=1, border_color="#2ea043")
        c2_box.pack(fill="x", padx=12, pady=4, ipady=4)
        c2_tag = tk.CTkLabel(c2_box, text=fix_ar("الشرط الثاني (2)"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=11), text_color="#86efac")
        c2_tag.pack()
        c2_val = tk.CTkLabel(c2_box, text=fix_ar(self.item["c2"]), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=16), text_color="#ffffff")
        c2_val.pack()
        
        rule_lbl = tk.CTkLabel(self.container, text=fix_ar("📢 انطق كلمة تحقق الشرطين معاً واللاعبون يتحققون من صحتها"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=13), text_color="#e6edf3", justify="center")
        rule_lbl.pack(pady=4)
        
        self.examples_btn = tk.CTkButton(self.container, text=fix_ar("إظهار أمثلة صحيحة 👁️"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=12), fg_color="#21262d", hover_color="#30363d", text_color="#8b949e", height=30, corner_radius=8, command=self.toggle_examples)
        self.examples_btn.pack(pady=3)
        
        self.examples_label = tk.CTkLabel(self.container, text="", font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=13), text_color="#7ee787", justify="center")
        self.examples_label.pack(pady=2)

    def toggle_examples(self):
        self.showing_examples = not self.showing_examples
        if self.showing_examples:
            self.examples_label.configure(text=fix_ar(f"أمثلة صحيحة: {self.item['examples']}"))
            self.examples_btn.configure(text=fix_ar("إخفاء الأمثلة 👁️"))
        else:
            self.examples_label.configure(text="")
            self.examples_btn.configure(text=fix_ar("إظهار أمثلة صحيحة 👁️"))