import random
import customtkinter as tk
from mini_games.base_game import BaseMiniGame
from data_file import fix_ar, GLOBAL_FONT_FAMILY

COLOR_PALETTE = {
    "أحمر": {"bg": "#c53030", "fg": "#ffffff"},
    "أزرق": {"bg": "#2b6cb0", "fg": "#ffffff"},
    "أخضر": {"bg": "#276749", "fg": "#ffffff"},
    "أصفر": {"bg": "#b7791f", "fg": "#ffffff"},
    "بنفسجي": {"bg": "#6b46c1", "fg": "#ffffff"},
    "برتقالي": {"bg": "#c05621", "fg": "#ffffff"},
}

TARGET_SCORE = 3

class StroopEffectGame(BaseMiniGame):
    def __init__(self, parent, on_result=None, on_timeout=None):
        super().__init__(
            parent=parent,
            game_id="stroop_effect",
            name_ar="تأثير ستروب (تطابق اللون والنص)",
            tier_ar="صعب",
            time_limit=7.0,
            objective_ar=f"اضغط على الزر الذي يتطابق فيه اسم اللون المكتوب مع لون خلفيته (المطلوب {TARGET_SCORE} نقاط)!",
            on_result=on_result,
            on_timeout=on_timeout
        )
        self.score = 0
        self.option_buttons = []
        self.score_label = None
        self.grid_frame = None
        self.setup_ui()
        self.start_timer()

    def setup_ui(self):
        self.build_header()
        self.build_timer()
        
        score_box = tk.CTkFrame(self.container, fg_color="#181c24", corner_radius=12, border_width=1, border_color="#2c3340")
        score_box.pack(fill="x", padx=10, pady=(0, 6), ipady=4)
        
        self.score_label = tk.CTkLabel(
            score_box,
            text=fix_ar(f"🎯 النقاط المطلوبة: {self.score} / {TARGET_SCORE}"),
            font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=16),
            text_color="#f0f6fc"
        )
        self.score_label.pack()
        
        self.grid_frame = tk.CTkFrame(self.container, fg_color="transparent")
        self.grid_frame.pack(fill="both", expand=True, padx=10, pady=4)
        self.grid_frame.grid_columnconfigure(0, weight=1)
        self.grid_frame.grid_columnconfigure(1, weight=1)
        
        self.render_round()

    def render_round(self):
        for btn, _ in self.option_buttons:
            btn.destroy()
        self.option_buttons.clear()
        
        color_names = list(COLOR_PALETTE.keys())
        random.shuffle(color_names)
        
        matching_color = random.choice(color_names)
        other_colors = [c for c in color_names if c != matching_color]
        random.shuffle(other_colors)
        selected_others = other_colors[:3]
        
        button_configs = [(matching_color, matching_color, True)]
        for bg_col in selected_others:
            available_texts = [c for c in color_names if c != bg_col]
            text_col = random.choice(available_texts)
            button_configs.append((text_col, bg_col, False))
            
        random.shuffle(button_configs)
        
        for idx, (text_name, bg_name, is_match) in enumerate(button_configs):
            r, c = idx // 2, idx % 2
            palette = COLOR_PALETTE[bg_name]
            btn = tk.CTkButton(
                self.grid_frame,
                text=fix_ar(text_name),
                font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=22),
                fg_color=palette["bg"],
                text_color=palette["fg"],
                hover_color=palette["bg"],
                border_color="#ffffff",
                border_width=1,
                corner_radius=14,
                height=55,
                command=lambda m=is_match: self.on_button_click(m)
            )
            btn.grid(row=r, column=c, padx=6, pady=6, sticky="nsew")
            self.option_buttons.append((btn, is_match))

    def on_button_click(self, is_matching):
        if self.is_finished:
            return
            
        if is_matching:
            self.score += 1
            self.score_label.configure(text=fix_ar(f"🎯 النقاط المطلوبة: {self.score} / {TARGET_SCORE}"))
            
            if self.score >= TARGET_SCORE:
                for btn, _ in self.option_buttons:
                    btn.configure(state="disabled")
                self.show_status(f"أحسنت! أكملت {TARGET_SCORE} نقاط بنجاح! 🎉", success=True)
                self.finish(True, "answered_correctly")
            else:
                self.render_round()
        else:
            self.score = max(0, self.score - 1)
            self.score_label.configure(text=fix_ar(f"🎯 النقاط المطلوبة: {self.score} / {TARGET_SCORE}"))
            self.show_status("خطأ! ركّز في تطابق اسم اللون ولون الخلفية!", success=False)
            self.render_round()

    def handle_timeout(self):
        super().handle_timeout()
        for btn, _ in self.option_buttons:
            btn.configure(state="disabled")