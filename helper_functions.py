import os
from modules.CTkRangeSlider import CTkRangeSlider as CTkRangeSlider

class RangeSlider():
    def __init__(self, tk, row, frame, min, max, name, is_doudble_slider=True, _temp_current_value=(0, 0), comment="", settings_key="", step=0.01):
        self.is_double_slider = is_doudble_slider
        self.name = name
        self.step = (max-min)/step

        self.settings_key                         = "value"
        if settings_key:        self.settings_key = settings_key
        elif is_doudble_slider: self.settings_key = "range"
        
        # change to be loaded from settings file
        self.label = tk.CTkLabel(frame, text=name.replace("_", " ").capitalize() + (" (K)" if self.name == "minimum_subscribers" else ""))
        self.label.grid(row=row, column=0, padx=20, pady=10, sticky="e")

        self.range_value = [tk.DoubleVar(value=_temp_current_value[0]), tk.DoubleVar(value=_temp_current_value[1])]
        self.range_value_range_slider = tk.CTkSlider(frame, from_=min, to=max, command= lambda x: self.range_slider_value_update((x, 0)), number_of_steps=self.step)
        self.range_value_text1 = tk.CTkEntry(frame, width=50, textvariable=self.range_value[0])
        self.range_value_text1.grid(row=row, column=1, padx=20, pady=10, sticky="ew")

        if is_doudble_slider:
            self.range_value_range_slider = CTkRangeSlider(frame, from_=min, to=max, command= lambda x: self.range_slider_value_update(x), number_of_steps=self.step)
            self.range_value_range_slider.set([self.range_value[0].get(), self.range_value[1].get()])
            self.range_value_text2 = tk.CTkEntry(frame, width=50, textvariable=self.range_value[1])
            self.range_value_text2.grid(row=row, column=3, padx=20, pady=10, sticky="ew")
        else:
            self.range_value_range_slider.set(self.range_value[0].get())
        
        self.range_value_range_slider.grid(row=row, column=2, padx=20, pady=10, sticky="ew", columnspan=1 if is_doudble_slider else 2)

    def range_slider_value_update(self, value):
            result = (round(value[0]*100)/100, round(value[1]*100)/100)

            # target_var_array = getattr(self, var_name_string)
            self.range_value[0].set(result[0])
            self.range_value[1].set(result[1])


def auto_hide_scrollbar(tkinter_element, event=None):
    # Get the physical width of the visible canvas area
    canvas_width = tkinter_element._parent_canvas.winfo_width()
    
    # Get the total required width of all the widgets you put inside the frame
    inner_width = tkinter_element.winfo_reqwidth()
    
    # If the window hasn't fully drawn yet, skip to prevent math errors
    if canvas_width <= 1: 
        return

    # Compare them
    if inner_width <= canvas_width:
        # Hide the scrollbar completely
        tkinter_element._scrollbar.grid_remove()
    else:
        # Show the scrollbar (row=1, column=0 is CustomTkinter's default placement for horizontal)
        tkinter_element._scrollbar.grid()

    # self.search_filtering_frame.bind("<Configure>", lambda event=None: auto_hide_scrollbar(self.search_filtering_frame, event))
    # self.search_filtering_frame._parent_canvas.bind("<Configure>", lambda event=None: auto_hide_scrollbar(self.search_filtering_frame, event))

def get_path(relative_path):
    script_directory = os.path.dirname(os.path.abspath(__file__))
    return os.path.abspath(os.path.join(script_directory, relative_path))

class get_next_row():
    def __init__(self, starting_num=0, max_range=-1):
        self.max_range = max_range
        self.starting_num = starting_num
        self.num = starting_num-1

    def next(self):
        self.num += 1
        if self.max_range!=-1 and self.num>self.max_range: self.reset()
        return self.num

    def reset(self):
        self.num=self.starting_num

def get_parent_bg_clr(parent):
		clr = ""
		# parent.master.cget("fg_color")
		# print(parent.cget("master").cget("fg_color"), parent.master.cget("fg_color"), parent.master.master.cget("fg_color"), sep="\t")
		for i in range(4):
				clr = parent.cget('fg_color')
				if clr != 'transparent': break

				try: parent = parent.master
				except AttributeError: break
		return clr