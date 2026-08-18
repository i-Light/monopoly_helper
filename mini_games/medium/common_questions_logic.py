import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

DATASET = [
    {"question": "سارة أطول من ندى، ومي أقصر من ندى. مين أطول واحدة؟", "options": ["سارة", "ندى", "مي"], "correct": "سارة"},
    {"question": "أحمد أسرع من عمر، وخالد أسرع من أحمد. مين الأبطأ فيهم؟", "options": ["عمر", "أحمد", "خالد"], "correct": "عمر"},
    {"question": "الكتاب أثقل من القلم، والمسطرة أخف من القلم. مين أثقل حاجة؟", "options": ["الكتاب", "القلم", "المسطرة"], "correct": "الكتاب"},
    {"question": "طارق أكبر من سامي، ومحمود أصغر من سامي. مين الأوسط في السن؟", "options": ["سامي", "طارق", "محمود"], "correct": "سامي"},
    {"question": "بيت علي أقرب للمدرسة من بيت حسن، وبيت زياد أبعد من بيت حسن. مين الأقرب؟", "options": ["علي", "حسن", "زياد"], "correct": "علي"},
    {"question": "الأزرق أغلى من الأحمر، والأخضر أرخص من الأحمر. مين الأرخص فيهم؟", "options": ["الأخضر", "الأحمر", "الأزرق"], "correct": "الأخضر"},
    {"question": "السيارة أسرع من الدراجة، والقطار أسرع من السيارة. مين الأسرع على الإطلاق؟", "options": ["القطار", "السيارة", "الدراجة"], "correct": "القطار"},
]

class CommonQuestionsLogicGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="common_questions_logic",
            name_ar="سؤال الاستنتاج والمنطق",
            tier_ar="متوسط",
            time_limit=6.0,
            objective_ar="اقرأ المقارنة المنطقية بسرعة واختر الإجابة الصحيحة!",
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
        
        card = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=16, border_width=2, border_color="#2c3340")
        card.pack(fill="x", pady=6, padx=10, ipady=10)
        
        q_lbl = tk.CTkLabel(card, text=fix_ar(self.item["question"]), font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=16), text_color="#f0f6fc", wraplength=340, justify="center")
        q_lbl.pack(pady=4, padx=10)
        
        opts_frame = tk.CTkFrame(self.container, fg_color="transparent")
        opts_frame.pack(fill="x", padx=10, pady=6)
        
        options = self.item["options"][:]
        random.shuffle(options)
        for i in range(len(options)):
            opts_frame.grid_columnconfigure(i, weight=1)
            
        self.option_buttons = []
        for idx, opt in enumerate(options):
            btn = tk.CTkButton(
                opts_frame,
                text=fix_ar(opt),
                font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=17),
                fg_color="#282c34",
                border_color="#3e4451",
                border_width=2,
                corner_radius=12,
                height=48,
                hover_color="#3e4451",
                command=lambda o=opt, i=idx: self.on_option_click(o, i)
            )
            btn.grid(row=0, column=idx, padx=4, pady=4, sticky="ew")
            self.option_buttons.append((btn, opt))

    def on_option_click(self, selected_opt, clicked_idx):
        if self.is_finished:
            return
        is_correct = (selected_opt == self.item["correct"])
        
        for btn, opt in self.option_buttons:
            btn.configure(state="disabled")
            if opt == self.item["correct"]:
                btn.configure(fg_color="#2ea043", border_color="#3fb950", text_color="#ffffff")
            elif btn == self.option_buttons[clicked_idx][0] and not is_correct:
                btn.configure(fg_color="#f85149", border_color="#da3633", text_color="#ffffff")
                
        if is_correct:
            self.show_status("إجابة منطقية صحيحة! 🎉", success=True)
            self.finish(True, "answered_correctly")
        else:
            self.show_status(f"إجابة خاطئة! ❌ الإجابة الصحيحة: {self.item['correct']}", success=False)
            self.finish(False, "answered_wrong")

    def handle_timeout(self):
        super().handle_timeout()
        for btn, opt in self.option_buttons:
            btn.configure(state="disabled")
            if opt == self.item["correct"]:
                btn.configure(fg_color="#2ea043", border_color="#3fb950", text_color="#ffffff")