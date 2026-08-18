import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

DATASET = [
    {"items": ["ميسي", "رونالدو", "صلاح", "مايكل جوردن"], "odd": "مايكل جوردن", "reason": "لاعب كرة سلة بين لاعبي كرة قدم"},
    {"items": ["القاهرة", "دمشق", "بغداد", "دبي"], "odd": "دبي", "reason": "ليست عاصمة دولة"},
    {"items": ["تفاح", "موز", "برتقال", "طماطم"], "odd": "طماطم", "reason": "خضار بين فواكه"},
    {"items": ["16", "25", "36", "42"], "odd": "42", "reason": "ليس مربعاً كاملاً"},
    {"items": ["أسد", "نمر", "فهد", "غزال"], "odd": "غزال", "reason": "آكل عشب بين مفترسات"},
    {"items": ["ذهب", "فضة", "نحاس", "خشب"], "odd": "خشب", "reason": "ليس معدناً"},
    {"items": ["عطارد", "المريخ", "المشتري", "القمر"], "odd": "القمر", "reason": "قمر/تابع وليس كوكباً"},
    {"items": ["عين", "أنف", "أذن", "قلب"], "odd": "قلب", "reason": "عضو داخلي وليس حاسة خارجية"},
]

class OddOneOutGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="odd_one_out",
            name_ar="العنصر الدخيل",
            tier_ar="متوسط",
            time_limit=5.0,
            objective_ar="اضغط على الكلمة التي لا تنتمي لنفس المجموعة قبل انتهاء الوقت!",
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
        
        grid_frame = tk.CTkFrame(self.container, fg_color="transparent")
        grid_frame.pack(fill="x", padx=10, pady=8)
        grid_frame.grid_columnconfigure(0, weight=1)
        grid_frame.grid_columnconfigure(1, weight=1)
        
        items = self.item["items"][:]
        random.shuffle(items)
        
        self.option_buttons = []
        for idx, word in enumerate(items):
            r, c = idx // 2, idx % 2
            btn = tk.CTkButton(
                grid_frame,
                text=fix_ar(word),
                font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=18),
                fg_color="#282c34",
                border_color="#3e4451",
                border_width=2,
                corner_radius=12,
                height=52,
                hover_color="#3e4451",
                command=lambda w=word, i=idx: self.on_option_click(w, i)
            )
            btn.grid(row=r, column=c, padx=6, pady=6, sticky="nsew")
            self.option_buttons.append((btn, word))

    def on_option_click(self, selected_word, clicked_idx):
        if self.is_finished:
            return
        is_correct = (selected_word == self.item["odd"])
        
        for btn, word in self.option_buttons:
            btn.configure(state="disabled")
            if word == self.item["odd"]:
                btn.configure(fg_color="#2ea043", border_color="#3fb950", text_color="#ffffff")
            elif btn == self.option_buttons[clicked_idx][0] and not is_correct:
                btn.configure(fg_color="#f85149", border_color="#da3633", text_color="#ffffff")
                
        if is_correct:
            self.show_status(f"إجابة صحيحة! 🎉 ({self.item['reason']})", success=True)
            self.finish(True, "answered_correctly")
        else:
            self.show_status(f"إجابة خاطئة! ❌ ({self.item['reason']})", success=False)
            self.finish(False, "answered_wrong")

    def handle_timeout(self):
        super().handle_timeout()
        for btn, word in self.option_buttons:
            btn.configure(state="disabled")
            if word == self.item["odd"]:
                btn.configure(fg_color="#2ea043", border_color="#3fb950", text_color="#ffffff")