import customtkinter as tk
from data_file import fix_ar, GLOBAL_FONT_FAMILY

class BaseMiniGame:
    """Base class for all mini games providing timer, header, state and callbacks."""
    def __init__(self, parent, game_id, name_ar, tier_ar, time_limit, objective_ar="", on_result=None, on_timeout=None):
        self.parent = parent
        self.game_id = game_id
        self.name_ar = name_ar
        self.tier_ar = tier_ar
        self.time_limit = time_limit
        self.remaining_time = time_limit
        self.objective_ar = objective_ar
        self.on_result = on_result
        self.on_timeout = on_timeout
        
        self.is_active = False
        self.is_finished = False
        self.timer_job = None
        
        self.container = tk.CTkFrame(self.parent, fg_color="transparent")
        self.container.pack(fill="both", expand=True, padx=10, pady=5)
        
        self.timer_progress = None
        self.timer_label = None
        self.status_label = None

    def build_header(self, parent_frame=None):
        target = parent_frame if parent_frame else self.container
        
        header = tk.CTkFrame(target, fg_color="transparent")
        header.pack(fill="x", pady=(0, 8))
        
        tier_colors = {"سهل": "#2ea043", "متوسط": "#d29922", "صعب": "#f85149"}
        badge_color = tier_colors.get(self.tier_ar, "#388bfd")
        
        tier_badge = tk.CTkLabel(
            header,
            text=fix_ar(self.tier_ar),
            fg_color=badge_color,
            text_color="#ffffff",
            font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=13),
            corner_radius=10,
            padx=12,
            pady=3
        )
        tier_badge.pack(side="right", padx=(5, 0))
        
        title_label = tk.CTkLabel(
            header,
            text=fix_ar(self.name_ar),
            font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=18),
            text_color="#ffffff"
        )
        title_label.pack(side="left")
        
        if self.objective_ar:
            obj_label = tk.CTkLabel(
                target,
                text=fix_ar(self.objective_ar),
                font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, size=13),
                text_color="#a0a0a0",
                justify="center",
                wraplength=380
            )
            obj_label.pack(pady=(0, 8))

    def build_timer(self, parent_frame=None):
        target = parent_frame if parent_frame else self.container
        
        timer_box = tk.CTkFrame(target, fg_color="#1e222b", corner_radius=12, border_width=1, border_color="#333842")
        timer_box.pack(fill="x", pady=(0, 10), padx=5, ipady=4)
        
        self.timer_label = tk.CTkLabel(
            timer_box,
            text=fix_ar(f"الوقت المتبقي: {self.remaining_time:.1f} ث"),
            font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=14),
            text_color="#58a6ff"
        )
        self.timer_label.pack(pady=(2, 4))
        
        self.timer_progress = tk.CTkProgressBar(
            timer_box,
            orientation="horizontal",
            height=8,
            corner_radius=4,
            progress_color="#58a6ff"
        )
        self.timer_progress.pack(fill="x", padx=15, pady=(0, 6))
        self.timer_progress.set(1.0)

    def start_timer(self):
        if self.is_active or self.is_finished:
            return
        self.is_active = True
        self._tick()

    def _tick(self):
        if not self.is_active or self.is_finished:
            return
        
        self.remaining_time -= 0.1
        if self.remaining_time <= 0:
            self.remaining_time = 0
            self._update_timer_display()
            self.handle_timeout()
            return
        
        self._update_timer_display()
        self.timer_job = self.parent.after(100, self._tick)

    def _update_timer_display(self):
        if self.timer_label and self.timer_progress:
            frac = max(0.0, min(1.0, self.remaining_time / self.time_limit))
            self.timer_progress.set(frac)
            self.timer_label.configure(text=fix_ar(f"الوقت المتبقي: {self.remaining_time:.1f} ث"))
            
            if frac <= 0.25:
                self.timer_progress.configure(progress_color="#f85149")
                self.timer_label.configure(text_color="#f85149")
            elif frac <= 0.5:
                self.timer_progress.configure(progress_color="#d29922")
                self.timer_label.configure(text_color="#d29922")

    def handle_timeout(self):
        self.is_active = False
        self.is_finished = True
        if self.timer_label:
            self.timer_label.configure(text=fix_ar("انتهى الوقت"), text_color="#f85149")
        if self.timer_progress:
            self.timer_progress.configure(progress_color="#f85149")
            self.timer_progress.set(0.0)
            
        self.show_status("انتهى الوقت المحدد للتحدي!", success=False)
        
        if self.on_timeout:
            self.on_timeout()
        if self.on_result:
            self.on_result(False, "timeout")

    def show_status(self, text_ar, success=True):
        if not self.status_label:
            self.status_label = tk.CTkLabel(
                self.container,
                text="",
                font=tk.CTkFont(family=GLOBAL_FONT_FAMILY + " Bold", size=15),
                corner_radius=10,
                pady=6
            )
            self.status_label.pack(fill="x", padx=10, pady=(8, 0))
        
        clr = "#2ea043" if success else "#f85149"
        bg_clr = "#173620" if success else "#3c181a"
        self.status_label.configure(text=fix_ar(text_ar), text_color=clr, fg_color=bg_clr)

    def finish(self, success, reason=""):
        if self.is_finished:
            return
        self.is_finished = True
        self.is_active = False
        self.stop_timer()
        if self.on_result:
            self.on_result(success, reason)

    def stop_timer(self):
        self.is_active = False
        if self.timer_job:
            try:
                self.parent.after_cancel(self.timer_job)
            except Exception:
                pass
            self.timer_job = None

    def destroy(self):
        self.stop_timer()
        if self.container:
            self.container.destroy()