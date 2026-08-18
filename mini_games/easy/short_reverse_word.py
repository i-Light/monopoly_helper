import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

DATASET = [
    {"word": "قلم", "letters": ["ق", "ل", "م"]},
    {"word": "شمس", "letters": ["ش", "م", "س"]},
    {"word": "نجم", "letters": ["ن", "ج", "م"]},
    {"word": "بحر", "letters": ["ب", "ح", "ر"]},
    {"word": "ورد", "letters": ["و", "ر", "د"]},
    {"word": "ذهب", "letters": ["ذ", "هـ", "ب"]},
    {"word": "صقر", "letters": ["ص", "ق", "ر"]},
    {"word": "طير", "letters": ["ط", "ي", "ر"]},
    {"word": "سيف", "letters": ["س", "ي", "ف"]},
    {"word": "كتاب", "letters": ["ك", "ت", "ا", "ب"]},
    {"word": "جمل", "letters": ["ج", "م", "ل"]},
    {"word": "عين", "letters": ["ع", "ي", "ن"]},
]

class ShortReverseWordGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="short_reverse_word",
            name_ar="عكس الكلمة",
            tier_ar="سهل",
            time_limit=4.0,
            objective_ar="اختر الترتيب المعكوس الصحيح لحروف الكلمة من اليسار إلى اليمين!",
            on_result=on_result,
            on_timeout=on_timeout
        )
        self.option_buttons = []
        self.correct_str = ""
        self.setup_ui()
        self.start_timer()

    def generate_options(self):
        item = random.choice(DATASET)
        word = item["word"]
        letters = item["letters"]
        
        correct_rev = list(reversed(letters))
        self.correct_str = " - ".join(correct_rev)
        
        distractors = set()
        distractors.add(" - ".join(letters))
        
        attempts = 0
        while len(distractors) < 3 and attempts < 20:
            attempts += 1
            shuffled = letters[:]
            random.shuffle(shuffled)
            s_str = " - ".join(shuffled)
            if s_str != self.correct_str:
                distractors.add(s_str)
                
        while len(distractors) < 3:
            fake = letters[:]
            fake[0], fake[-1] = fake[-1], fake[0]
            distractors.add(" - ".join(fake))
            
        options = list(distractors)[:3] + [self.correct_str]
        random.shuffle(options)
        return word, options

    def setup_ui(self):
        self.build_header()
        self.build_timer()
        
        word, options = self.generate_options()
        
        card = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=16, border_width=2, border_color="#2c3340")
        card.pack(fill="x", pady=8, padx=10, ipady=8)
        
        lbl = tk.CTkLabel(card, text=fix_ar(f"الكلمة: « {word} »"), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=26), text_color="#f0f6fc")
        lbl.pack()
        
        grid_frame = tk.CTkFrame(self.container, fg_color="transparent")
        grid_frame.pack(fill="x", padx=10, pady=5)
        grid_frame.grid_columnconfigure(0, weight=1)
        grid_frame.grid_columnconfigure(1, weight=1)
        
        self.option_buttons = []
        for idx, opt in enumerate(options):
            r, c = idx // 2, idx % 2
            btn = tk.CTkButton(
                grid_frame,
                text=fix_ar(opt),
                font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=17),
                fg_color="#282c34",
                border_color="#3e4451",
                border_width=2,
                corner_radius=12,
                height=46,
                hover_color="#3e4451",
                command=lambda o=opt, i=idx: self.on_option_click(o, i)
            )
            btn.grid(row=r, column=c, padx=5, pady=5, sticky="nsew")
            self.option_buttons.append((btn, opt))

    def on_option_click(self, selected_opt, clicked_idx):
        if self.is_finished:
            return
        is_correct = (selected_opt == self.correct_str)
        
        for btn, opt in self.option_buttons:
            btn.configure(state="disabled")
            if opt == self.correct_str:
                btn.configure(fg_color="#2ea043", border_color="#3fb950", text_color="#ffffff")
            elif btn == self.option_buttons[clicked_idx][0] and not is_correct:
                btn.configure(fg_color="#f85149", border_color="#da3633", text_color="#ffffff")
                
        if is_correct:
            self.show_status("إجابة صحيحة! 🎉", success=True)
            self.finish(True, "answered_correctly")
        else:
            self.show_status("إجابة خاطئة! ❌", success=False)
            self.finish(False, "answered_wrong")

    def handle_timeout(self):
        super().handle_timeout()
        for btn, opt in self.option_buttons:
            btn.configure(state="disabled")
            if opt == self.correct_str:
                btn.configure(fg_color="#2ea043", border_color="#3fb950", text_color="#ffffff")