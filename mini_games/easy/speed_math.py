import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

class SpeedMathGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="speed_math",
            name_ar="الرياضيات السريعة",
            tier_ar="سهل",
            time_limit=5.0,
            objective_ar="احسب ناتج العملية الحسابية واختر الإجابة الصحيحة قبل انتهاء الوقت!",
            on_result=on_result,
            on_timeout=on_timeout
        )
        self.option_buttons = []
        self.correct_answer = None
        self.setup_ui()
        self.start_timer()

    def generate_question(self):
        op = random.choice(["+", "-", "*"])
        if op == "+":
            a = random.randint(10, 50)
            b = random.randint(5, 45)
            ans = a + b
            eq_text = f"{a} + {b}"
        elif op == "-":
            a = random.randint(20, 60)
            b = random.randint(5, a - 2)
            ans = a - b
            eq_text = f"{a} - {b}"
        else:
            a = random.randint(3, 9)
            b = random.randint(3, 9)
            ans = a * b
            eq_text = f"{a} × {b}"
            
        self.correct_answer = ans
        distractors = set()
        candidates = [ans + 1, ans - 1, ans + 2, ans - 2, ans + 10, ans - 10, ans + 5, ans - 5]
        random.shuffle(candidates)
        for c in candidates:
            if c > 0 and c != ans:
                distractors.add(c)
            if len(distractors) == 3:
                break
        while len(distractors) < 3:
            fake = ans + random.choice()
            if fake > 0 and fake != ans:
                distractors.add(fake)
                
        options = list(distractors) + [ans]
        random.shuffle(options)
        return eq_text, ans, options

    def setup_ui(self):
        self.build_header()
        self.build_timer()
        
        eq_text, ans, options = self.generate_question()
        
        card = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=16, border_width=2, border_color="#2c3340")
        card.pack(fill="x", pady=10, padx=10, ipady=12)
        
        eq_label = tk.CTkLabel(
            card,
            text=fix_ar(eq_text + " = ؟"),
            font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=32),
            text_color="#f0f6fc"
        )
        eq_label.pack()
        
        grid_frame = tk.CTkFrame(self.container, fg_color="transparent")
        grid_frame.pack(fill="x", padx=10, pady=5)
        grid_frame.grid_columnconfigure(0, weight=1)
        grid_frame.grid_columnconfigure(1, weight=1)
        
        self.option_buttons = []
        for idx, val in enumerate(options):
            r, c = idx // 2, idx % 2
            btn = tk.CTkButton(
                grid_frame,
                text=fix_ar(str(val)),
                font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=20),
                fg_color="#282c34",
                border_color="#3e4451",
                border_width=2,
                corner_radius=12,
                height=50,
                hover_color="#3e4451",
                command=lambda v=val, b_idx=idx: self.on_option_click(v, b_idx)
            )
            btn.grid(row=r, column=c, padx=6, pady=6, sticky="nsew")
            self.option_buttons.append((btn, val))

    def on_option_click(self, selected_val, clicked_idx):
        if self.is_finished:
            return
        is_correct = (selected_val == self.correct_answer)
        
        for btn, val in self.option_buttons:
            btn.configure(state="disabled")
            if val == self.correct_answer:
                btn.configure(fg_color="#2ea043", border_color="#3fb950", text_color="#ffffff")
            elif btn == self.option_buttons[clicked_idx][0] and not is_correct:
                btn.configure(fg_color="#f85149", border_color="#da3633", text_color="#ffffff")
                
        if is_correct:
            self.show_status("إجابة صحيحة! أحسنت 🎉", success=True)
            self.finish(True, "answered_correctly")
        else:
            self.show_status("إجابة خاطئة! ❌", success=False)
            self.finish(False, "answered_wrong")

    def handle_timeout(self):
        super().handle_timeout()
        for btn, val in self.option_buttons:
            btn.configure(state="disabled")
            if val == self.correct_answer:
                btn.configure(fg_color="#2ea043", border_color="#3fb950", text_color="#ffffff")