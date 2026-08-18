from tkinter import Frame, Label
import customtkinter as tk
import pyperclip
# import os
import math
from PIL import Image, ImageDraw, ImageFont, ImageTk

from helper_functions import *
from data_file import *



class Tabview():
    def __init__(self, frame, padx, pady, active_idx, pages, corner_radius=18):
        self.frame = frame
        self.pages = [fix_ar(page) for page in pages]

        self.tab_container = tk.CTkFrame(self.frame, fg_color="transparent", corner_radius=0)
        self.tab_container.pack(padx=0, pady=0, fill="both", expand=True)
        self.tab_container.grid_rowconfigure(0, weight=1)
        self.tab_container.grid_columnconfigure(0, weight=1)

        self.bottom_tabs = tk.CTkSegmentedButton(
            self.tab_container,
            values=self.pages,
            font=tk.CTkFont(family=GLOBAL_FONT_FAMILY, weight="bold", size=13),
            fg_color=get_parent_bg_clr(self.tab_container),
            corner_radius=20,
            border_width=5,
            command=self.switch_tab,
        )

        self.bottom_tabs.set(self.pages[active_idx]) # تحديد الصفحة الافتراضية
        self.active_page = self.pages[active_idx]
        self.bottom_tabs.grid(row=1, column=0, sticky="ew", padx=padx, pady=(0, 15), ipady=5)

        self.content_frames = {}

        for i, page_name in enumerate(self.pages):
            i+=1
            tclr = "#7A7A7A"
            tclr = tclr[:i+1] + str(i) + tclr[i+2:]
            tclr = "#282c34"
            # print(tclr)
            self.content_frames[page_name] = tk.CTkFrame(self.tab_container, fg_color=tclr, corner_radius=corner_radius)
            self.content_frames[page_name].grid(row=0, column=0, sticky="nsew", padx=padx, pady=pady)


    def switch_tab(self, new_selected_page_name):
        self.content_frames[self.active_page].grid_remove()
        self.content_frames[new_selected_page_name].grid()
        self.active_page=new_selected_page_name

    def get_tab(self, idx):
        return self.content_frames[self.pages[idx]]
    
class GameTab():
    def __init__(self, frame):
        self.game_started = False
        # self.corner_radius = 18
        self.current_stage = 0
        self.frame=frame
        self.pages = [self.add_steps_selection_page, self.add_results_page]
        self.go_to_next_page()

    def go_to_next_page(self):
        if not self.game_started: self.pages[self.current_stage](); self.game_started=True; return

        self.pages[self.current_stage](remove_page=True)
        self.current_stage = self.current_stage+1 if self.current_stage+1 < len(self.pages) else 0
        self.pages[self.current_stage]()

    def add_steps_selection_page(self, remove_page=False):
        if remove_page:
            if self.steps_selection_page: self.steps_selection_page.destroy()
            return
        self.steps_selection_page = tk.CTkFrame(self.frame, fg_color="transparent")
        self.steps_selection_page.pack(padx=10, pady=10, fill="both", expand=True)

        self.title_label = tk.CTkLabel(
            self.steps_selection_page, # Replace with your parent container
            text="Select number of steps;\nThe higher the harder the challange",
            font=tk.CTkFont(size=16),
            justify="center",
            text_color="#FFFFFF"
        )
        self.title_label.pack(pady=(10, 10))

        # 2. Main Reddish Container Frame
        self.grid_frame = tk.CTkFrame(
            self.steps_selection_page, 
            fg_color=players_stats[curr_player_idx]['color'],       # The reddish-brown background
            border_color="#000000",   # The darker border edge
            border_width=10,
            corner_radius=20
        )
        self.grid_frame.pack(padx=10, pady=10, fill="both", expand=True)

        self.spacer_grid_frame = tk.CTkFrame(self.grid_frame, fg_color="transparent")
        self.spacer_grid_frame.pack(padx=20, pady=20, fill="both", expand=True)
        for i in range(3):
            self.spacer_grid_frame.grid_rowconfigure(i, weight=1)
            self.spacer_grid_frame.grid_columnconfigure(i, weight=1)

        # 3. Generate the 3x3 Buttons
        number = 1
        for row in range(3):
            for col in range(3):
                btn = tk.CTkButton(
                    self.spacer_grid_frame,
                    text=str(number),
                    font=tk.CTkFont(size=50, weight="bold"),
                    fg_color="transparent",
                    text_color="#ffffff",
                    hover_color="#000000",
                    width=50,
                    height=50,
                    corner_radius=20,
                    command=lambda n=number: self._on_steps_selected(n)
                )
                btn.grid(row=row, column=col, sticky="nsew")
                number += 1
                # break

    def _on_steps_selected(self, n):
        # TODO record number of steps in a variable
        print("Steps/Difficulty selected: ", n)
        self.go_to_next_page()
        # self.go_to_next_page()

    def add_results_page(self, remove_page=False):
        if remove_page:
            if self.results: self.results.destroy()
            return
        self.results = tk.CTkFrame(self.frame, fg_color="transparent")
        self.results.pack(pady=10, fill="both", expand=True)

        # TODO Each path should have the image has the name of the city on it
        city_image = Image.open(get_path("assets\\images\\test.jpg"))

        # ==========================================
        # 1. Header (Title and Player Badge)
        # ==========================================
        header_frame = tk.CTkFrame(self.results, fg_color="transparent")
        header_frame.pack(fill="x", pady=(0, 0))

        # Title
        title = tk.CTkLabel(
            header_frame, 
            text="Go to Cairo", 
            font=tk.CTkFont(size=18, weight="bold"), 
            text_color="#FFFFFF"
        )
        title.pack(side="left")

        # Right side info container
        info_frame = tk.CTkFrame(header_frame, fg_color="transparent")
        info_frame.pack(side="right")

        # Crown Icon
        crown = tk.CTkLabel(
            info_frame, 
            text="👑", 
            font=tk.CTkFont(size=18),
            text_color="#dcac00"
        )
        crown.pack(side="right", padx=(8, 0))

        # Player Pill
        player_pill = tk.CTkLabel(
            info_frame, 
            text="P2", 
            fg_color="#45316D",        # Purple background
            text_color="#FFFFFF",
            font=tk.CTkFont(size=12, weight="bold"),
            height=27, 
            width=5,
            corner_radius=12,          # Half of height
            border_color="#000000",
            border_width=2
        )
        player_pill.pack(side="right")


        # ==========================================
        # 2. Image Area (With Overlapping Elements)
        # ==========================================
        # We use a fixed-size transparent wrapper to safely overlap widgets
        wrapper = tk.CTkFrame(self.results, fg_color="transparent", height=50)
        wrapper.pack(fill='both', expand=True)
        wrapper.pack_propagate(False) # Prevent it from resizing to fit children

        # Main Image (Centered)
        ctk_img = tk.CTkImage(dark_image=city_image, size=(1920*0.3, 1080*0.3))
        img_label = tk.CTkLabel(wrapper, text="", image=ctk_img, corner_radius=30)
        img_label.place(relwidth=1, relheight=1, relx=0.5, rely=0, anchor="n")

        # Indicators
        left_indicator = tk.CTkLabel(wrapper, width=12, corner_radius=6, border_width=3, fg_color="#008080", border_color="#000000", text="",)
        left_indicator.place(relx=0, rely=0.5, relheight=0.35, anchor="w")

        right_indicator = tk.CTkLabel(wrapper, width=12, corner_radius=6, border_width=3, fg_color="#90509B", border_color="#000000", text="",)
        right_indicator.place(relx=1, rely=0.5, relheight=0.35, anchor="e")


        # ==========================================
        # 3. Action Buttons
        # ==========================================
        btn_font = tk.CTkFont(size=14, weight="bold")

        # Button 1 (Disabled Style)
        btn1 = tk.CTkButton(
            self.results, 
            text="Bought Country ✅", 
            font=btn_font,
            fg_color="#878787", 
            text_color="#000000",
            state="disable",
            height=45, 
            corner_radius=10
        )
        btn1.pack(fill="x", padx=0, pady=(5, 5))

        btn2 = tk.CTkButton(
            self.results, 
            text="Bought Garage ✅", 
            font=btn_font,
            fg_color="#878787", 
            text_color="#000000", 
            state="disable",
            height=45, 
            corner_radius=10
        )
        btn2.pack(fill="x", padx=0, pady=(5, 5))

        btn3_text = "Buy Market  Price: 600£   Fee: 200£"
        btn3 = tk.CTkButton(
            self.results, 
            text=btn3_text, 
            font=btn_font,
            height=45, 
            corner_radius=10
        )
        btn3.pack(fill="x", padx=0, pady=(5, 5))

        btn4 = tk.CTkButton(
            self.results, 
            text=fix_ar("أدفع 120£ و " + "انهي الدور"), 
            font=tk.CTkFont(family=GLOBAL_FONT_FAMILY+" Bold", size=18),
            height=45, 
            corner_radius=10, command=self.go_to_next_page()
        )
        btn4.pack(fill="x", padx=0, pady=(5, 0))
    
class App(tk.CTk):
    def __init__(self):
        super().__init__()
        # self.update()
        # self.screen_size = (self.winfo_screenwidth(), self.winfo_screenheight())
        # self.screen_size = [720, 1600]; self.screen_size[0]*=1000/1600; self.screen_size[1]*=1000/1600
        # def fix_size_ratio(obj, ratio): return [int(obj[0]*ratio), int(obj[1]*ratio)]

        self.screen_size = [720, 1600]
        self.screen_pos = [-449, 0]
        self.geometry(f"{self.screen_size[0]}x{self.screen_size[1]}+{self.screen_pos[0]}+{self.screen_pos[1]}")
        self.configure(fg_color="#282c34")
        _original_init = tk.CTkFont.__init__
        def _custom_init(self, *args, **kwargs):
            if "family" not in kwargs or kwargs["family"] is None: kwargs["family"] = GLOBAL_FONT_FAMILY
            _original_init(self, *args, **kwargs)
        tk.CTkFont.__init__ = _custom_init
        self.title("أداة مساعدة للعبة بنك العقارات")

        # --- Main Content ---

        self.add_header_section()

        self.tabview = Tabview(frame=self, padx=20, pady=(15, 10), active_idx=2, pages=["الإعدادات", "السوق", "اللعبة"])
        self.gametab = GameTab(self.tabview.get_tab(2))
        
        # --- Made by section ---
        self.add_madeby_section()

    # ----- Pages -----


    def add_header_section(self):
        raw_text="كلمتان حبيبتان إلى الرحمن خفيفتان على اللسان ثقيلتان في الميزان... سبحان الله وبحمده سبحان الله العظيم"
        raw_text = get_display(arabic_reshaper.ArabicReshaper(
            configuration={
                'delete_harakat': True,
                'support_ligatures': False,
                'use_unshaped_instead_of_isolated': True
            }
        ).reshape(raw_text), base_dir='R')
        self.marquee_canvas = tk.CTkCanvas(self, height=45, bg="#161616", highlightthickness=0)
        self.marquee_canvas.pack(fill='x', padx=0, pady=(15, 15))
        self.scrolling_speed = 0.2
        pil_font = ImageFont.truetype(FONT_PATH, 16)
        try: pil_font.set_variation_by_name("Bold")
        except OSError: print("Couldn't find font variation"); # Fails safely if the font doesn't support named variations

        bbox = pil_font.getbbox(raw_text, )#direction='rtl')
        text_width = int(bbox[2] - bbox[0])
        text_height = int(bbox[3] - bbox[1])

        img = Image.new("RGBA", (text_width, text_height + 10), (0, 0, 0, 0))
        draw = ImageDraw.Draw(img)

        draw.text((0, 0), raw_text, font=pil_font, fill="#ffffff")#, direction='rtl')

        self.tk_marquee_img = ImageTk.PhotoImage(img)

        self.text_item = self.marquee_canvas.create_image(
            0, 50 / 2, 
            image=self.tk_marquee_img, 
            anchor="w"
        )

        self.animate_marquee()



        self.timer_frame=Frame(self, background=get_parent_bg_clr(self))
        self.timer_frame.pack(padx=10, pady=10)
        self.restart_game_button = tk.CTkButton(self.timer_frame, font=tk.CTkFont(family=GLOBAL_FONT_FAMILY+" Bold",size=16), text=fix_ar("لعبة جديدة"))
        self.restart_game_button.grid(row=0, column=2, padx=10, pady=0, sticky="w")

        self.timerlabel = tk.CTkLabel(self.timer_frame, font=tk.CTkFont(size=16), text="الوقت المتبقى")
        self.timerlabel.grid(row=0, column=1, padx=10, pady=0, sticky="e")
        self.timerlabel_value = tk.CTkLabel(self.timer_frame, font=tk.CTkFont(size=16), text="49:36")
        self.timerlabel_value.grid(row=0, column=0, padx=10, pady=0, sticky="e")

        self.player_frame=tk.CTkFrame(self, height=10, fg_color="transparent")
        self.player_frame.pack(padx=10, pady=0, fill="x",)
        

        self.player_header_frames = {}
        self.add_player_to_header(self.player_frame, 0)
        self.add_player_to_header(self.player_frame, 1)
        self.add_player_to_header(self.player_frame, 2)

    def add_player_to_header(self, frame, idx):
        frame.grid_columnconfigure(idx, weight=1)
        sidx=str(idx)
        place=cities_list[players_stats[idx]['place_idx']]
        place_name = place['name']

        self.player_header_frames["name" + sidx] = tk.CTkLabel(
            frame,
            font=tk.CTkFont(family=GLOBAL_FONT_FAMILY+" Bold", size=14),
            fg_color=players_stats[idx]['color'],
            border_color="#000000",
            border_width=3,
            corner_radius=20,
            height=34,
            justify="center",
            text=players_stats[idx]['name']
        )
        self.player_header_frames["name" + sidx].grid(row=0, column=idx, padx=10, sticky="swe")

        self.player_header_frames["city" + sidx] = tk.CTkLabel(
            frame,
            font=tk.CTkFont(family=GLOBAL_FONT_FAMILY+" Semibold", size=14),
            text_color="#9E9E9E",
            justify="center",
            text=place_name
        )
        self.player_header_frames["city" + sidx].grid(row=1, column=idx, padx=10, sticky="nwe")

    def add_madeby_section(self):
        self.madebyframe = tk.CTkFrame(self, width=200, height=200, fg_color="transparent")
        self.madebyframe.pack(pady=(0, 15))

        self.madeby = tk.CTkLabel(self.madebyframe, text="Made by", text_color="#888")
        self.madebyname = tk.CTkButton(self.madebyframe, text="Mustafa Khaled", text_color="#1f6aa5", hover_color="#131212", command=self.toggle_email_name, fg_color="transparent", width=1)
        self.madebyyear = tk.CTkLabel(self.madebyframe, text="@2026", text_color="#888")

        self.madeby.grid(row=0, column=0, padx=0, pady=0, sticky="ew")
        self.madebyname.grid(row=0, column=1, padx=0, pady=0, sticky="ew")
        self.madebyyear.grid(row=0, column=2, padx=0, pady=0, sticky="ew")

    # ----- Helpers -----

    def animate_marquee(self):
        # 1. Move the image RIGHT (positive speed)
        self.marquee_canvas.move(self.text_item, self.scrolling_speed, 0)

        # 2. Get the current bounding box
        bounds = self.marquee_canvas.bbox(self.text_item)
        
        if bounds:
            canvas_width = self.marquee_canvas.winfo_width()
            
            # bounds[0] is the left edge of the image.
            # If it's greater than the canvas width, it has fully exited the right side of the screen.
            if bounds[0] > canvas_width:
                
                # Calculate the width of the image to know how far back to push it
                image_width = bounds[2] - bounds[0]
                
                # 3. Teleport it perfectly off-screen to the left (-image_width)
                # Y remains 25 (your 50 / 2)
                self.marquee_canvas.coords(self.text_item, -image_width, 25)
                
        self.after(10, self.animate_marquee)

    def toggle_email_name(self):
        txt= "Mustafa Khaled"
        clr = "#1f6aa5"
        if self.madebyname._text=="Mustafa Khaled":
            txt = "mustafa@gratovo.com"
            pyperclip.copy(txt)
            txt += " (COPIED!)"
            clr = "#1fa578"

        self.madebyname.configure(text= txt, text_color=clr)




tk.set_appearance_mode("dark")
tk.set_default_color_theme("blue")
tk.set_widget_scaling(1.2)
tk.set_window_scaling(0.61)
# tk.set_default_color_theme("monopoly_helper\\assets\\fonts\\my_theme.json")
app = App()
app.mainloop()