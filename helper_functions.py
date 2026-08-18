import os

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