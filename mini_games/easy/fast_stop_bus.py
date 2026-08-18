import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

CATEGORIES = [
    {"name": "بلد أو مدينة", "examples": {"م": "مصر / مدريد", "س": "سوريا / سوهاج", "ب": "بيروت / باريس", "ك": "كندا / كويت", "أ": "ألمانيا / أسوان"}},
    {"name": "حيوان", "examples": {"م": "ماعز / مهر", "س": "سمكة / سنجاب", "ب": "بطة / بقرة", "ك": "كلب / كنغر", "أ": "أسد / أرنب"}},
    {"name": "نبات أو خضار", "examples": {"م": "موز / ملوخية", "س": "سبانخ / سمسم", "ب": "برتقال / بصل", "ك": "كمثرى / كوسة", "أ": "أناناس / أرز"}},
    {"name": "جماد", "examples": {"م": "مكتب / مرآة", "س": "سيارة / سرير", "ب": "باب / برميل", "ك": "كرسي / كتاب", "أ": "إبريق / أريكة"}},
    {"name": "مهنة", "examples": {"م": "مهندس / محاسب", "س": "سائق / سباك", "ب": "بائع / بناء", "ك": "كاتب / كهربائي", "أ": "أستاذ / أمين مكتبة"}},
    {"name": "اسم ولد أو بنت", "examples": {"م": "محمد / مريم", "س": "سامي / سارة", "ب": "باسم / بسمة", "ك": "كريم / كاميليا", "أ": "أحمد / أمل"}},
]

LETTERS = ["م", "س", "ب", "ك", "أ", "ت", "ج", "ح", "د", "ر", "ف", "ن", "هـ", "ي"]

class FastStopBusGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="fast_stop_bus_complete",
            name_ar="أتوبيس كومبليت السريع",
            tier_ar="سهل",
            time_limit=5.0,
            objective_ar="اذكر كلمة واحدة صحيحة للتصنيف المطلوب تبدأ بالحرف المحدد بصوت عالٍ!",
            on_result=on_result,
            on_timeout=on_timeout
        )
        self.category = random.choice(CATEGORIES)
        self.letter = random.choice(LETTERS)
        self.showing_examples = False
        self.setup_ui()
        self.start_timer()

    def setup_ui(self):
        self.build_header()
        self.build_timer()
        
        card = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=16, border_width=2, border_color="#2c3340")
        card.pack(fill="x", pady=8, padx=10, ipady=8)
        
        badges_frame = tk.CTkFrame(card, fg_color="transparent")
        badges_frame.pack(pady=4)
        
        l_frame = tk.CTkFrame(badges_frame, fg_color="#36165e", corner_radius=14, border_width=2, border_color="#583484")
        l_frame.pack(side="left", padx=10, pady=4, ipadx=14, ipady=6)
        l_title = tk.CTkLabel(l_frame, text=fix_ar("الحرف"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=12), text_color="#c4b5fd")
        l_title.pack()
        l_val = tk.CTkLabel(l_frame, text=fix_ar(self.letter), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=28), text_color="#ffffff")
        l_val.pack()
        
        c_frame = tk.CTkFrame(badges_frame, fg_color="#165e29", corner_radius=14, border_width=2, border_color="#2ea043")
        c_frame.pack(side="left", padx=10, pady=4, ipadx=14, ipady=6)
        c_title = tk.CTkLabel(c_frame, text=fix_ar("التصنيف"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=12), text_color="#86efac")
        c_title.pack()
        c_val = tk.CTkLabel(c_frame, text=fix_ar(self.category["name"]), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=18), text_color="#ffffff")
        c_val.pack()
        
        rule_label = tk.CTkLabel(self.container, text=fix_ar("📢 انطق الإجابة بصوت عالٍ واللاعبون يحكمون على صحتها"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=13), text_color="#e6edf3", justify="center")
        rule_label.pack(pady=4)
        
        self.examples_btn = tk.CTkButton(self.container, text=fix_ar("إظهار أمثلة للمراجعة 👁️"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=12), fg_color="#21262d", hover_color="#30363d", text_color="#8b949e", height=30, corner_radius=8, command=self.toggle_examples)
        self.examples_btn.pack(pady=4)
        
        self.examples_label = tk.CTkLabel(self.container, text="", font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=13), text_color="#7ee787", justify="center")
        self.examples_label.pack(pady=2)

    def toggle_examples(self):
        self.showing_examples = not self.showing_examples
        if self.showing_examples:
            sample = self.category["examples"].get(self.letter, "أي إجابة مناسبة تبدأ بالحرف")
            self.examples_label.configure(text=fix_ar(f"أمثلة: {sample}"))
            self.examples_btn.configure(text=fix_ar("إخفاء الأمثلة 👁️"))
        else:
            self.examples_label.configure(text="")
            self.examples_btn.configure(text=fix_ar("إظهار أمثلة للمراجعة 👁️"))