import arabic_reshaper
from bidi.algorithm import get_display
from helper_functions import get_path

GLOBAL_FONT_FAMILY = "Playpen Sans Arabic"
FONT_PATH = get_path("assets/fonts/PlaypenSansArabic-VariableFont_wght.ttf")

# الإعدادات المثالية لخط Cairo
reshaper = arabic_reshaper.ArabicReshaper(
    configuration={
        'delete_harakat': True,
        'support_ligatures': False,                 # يمنع الحروف المندمجة الغريبة
        'use_unshaped_instead_of_isolated': True    # يمنع مشكلة الخط الرفيع
    }
)

def fix_ar(text: str) -> str:
    if not text: return ""

    # if len(text) > 100:
    # print(len(text))
    
    # 1. ربط الحروف (Shaping)
    reshaped_text = reshaper.reshape(text)
    
    # 2. الترتيب الصحيح والكامل للنص (عربي، إنجليزي، أرقام)
    bidi_text = get_display(reshaped_text, base_dir='R')
    
    # 3. السحر هنا: علامة LRO (\u202D) في البداية 
    # تقوم بإيقاف محرك Tkinter وتجبره على عرض bidi_text كما هو تماماً بدون أي تدخل!
    return '\u202D' + bidi_text +'\u202D'

def generate_prices_data(base_price, base_fee, garage_price, market_price):
    market_fee=base_fee*2* market_price/garage_price if garage_price!=0 else 0
    return {
            "base": {"price":base_price, "fee":base_fee, "is owned":False},
            "garage": {"price":garage_price, "fee":base_fee*2, "is owned":False},
            "market": {"price":market_price, "fee":market_fee, "is owned":False},}

curr_player_idx=0

players_stats = [
    {"idx":0, "name":fix_ar("جنى"), "color":"#843434", "place_idx":0},
    {"idx":1, "name":fix_ar("أحمد"), "color":"#583484", "place_idx":0},
    {"idx":2, "name":fix_ar("مصطفى"), "color":"#3B8434", "place_idx":0},
]

city_colors = {"blue":"#36165E", "green":"#165E29", "red":"#5E2916", "orange":"#A95C18",
                "pink":"#781C50", "yellow":"#81771C", "cyan":"#0F6083", "white":"#ffffff"}

cities_list = {
    0: {"idx":0, "name":fix_ar("البداية"), "color on board":"", "color on card":"", "owner":"",
        "prices": generate_prices_data(-600, 0, 0, 0)},

    1: {"idx":1, "name":fix_ar("القدس"), "color on board":city_colors["blue"], "color on card":city_colors["blue"], "owner":"",
        "prices": generate_prices_data(base_price=300, base_fee=40, garage_price=190, market_price=900),
        },

    2: {"idx":2, "name":fix_ar("غزة"), "color on board":city_colors["blue"], "color on card":city_colors["blue"], "owner":"",
        "prices": generate_prices_data(base_price=250, base_fee=30, garage_price=130, market_price=600),
        },
        

    3: {"idx":3, "name":fix_ar("بيروت"), "color on board":city_colors["green"], "color on card":city_colors["red"], "owner":"",
        "prices": generate_prices_data(base_price=250, base_fee=30, garage_price=180, market_price=850),
        },
        

    4: {"idx":4, "name":fix_ar("الرياض"), "color on board":city_colors["green"], "color on card":city_colors["red"], "owner":"",
        "prices": generate_prices_data(base_price=250, base_fee=30, garage_price=130, market_price=650),
        },
        
    5: {"idx":5, "name":fix_ar("بغداد"), "color on board":city_colors["green"], "color on card":city_colors["red"], "owner":"",
        "prices": generate_prices_data(base_price=250, base_fee=30, garage_price=120, market_price=600),
        },
        
    6: {"idx":6, "name":fix_ar("النادي"), "color on board":"", "color on card":"", "owner":"", "owner2":"",
        "prices": generate_prices_data(base_price=150, base_fee=30, garage_price=0, market_price=0),
        },
        
    7: {"idx":7, "name":fix_ar("بني غازي"), "color on board":city_colors["red"], "color on card":city_colors["green"], "owner":"",
        "prices": generate_prices_data(base_price=150, base_fee=20, garage_price=80, market_price=280),
        },
        
    8: {"idx":8, "name":fix_ar("عدن"), "color on board":city_colors["red"], "color on card":city_colors["red"], "owner":"",
        "base prices": {"price":100, "fee":0, "is owned":False},
        "prices": generate_prices_data(base_price=100, base_fee=20, garage_price=70, market_price=380),
        },
        
    9: {"idx":9, "name":fix_ar("البحرين"), "color on board":city_colors["red"], "color on card":city_colors["red"], "owner":"",
        "prices": generate_prices_data(base_price=90, base_fee=20, garage_price=60, market_price=300),
        },
        
    10: {"idx":10, "name":fix_ar("الدار البيضاء"), "color on board":city_colors["red"], "color on card":city_colors["blue"], "owner":"",
        "prices": generate_prices_data(base_price=250, base_fee=30, garage_price=130, market_price=600),
        },

    11: {"idx":11, "name":fix_ar("محطة البنزين"), "color on board":"", "color on card":"", "owner":"",
        "prices": generate_prices_data(base_price=300, base_fee=40, garage_price=0, market_price=0),
        },
        
    12: {"idx":12, "name":fix_ar("تونس"), "color on board":city_colors["red"], "color on card":city_colors["green"], "owner":"",
        "prices": generate_prices_data(base_price=200, base_fee=30, garage_price=120, market_price=600),
        },
        
    13: {"idx":13, "name":fix_ar("الجزائر"), "color on board":city_colors["red"], "color on card":city_colors["green"], "owner":"",
        "prices": generate_prices_data(base_price=300, base_fee=40, garage_price=190, market_price=850),
        },

    14: {"idx":14, "name":fix_ar("الأوتوبيس السريع"), "color on board":"", "color on card":"", "owner":"",
        "prices": generate_prices_data(base_price=0, base_fee=0, garage_price=0, market_price=0),
        },
        
    15: {"idx":15, "name":fix_ar("الإسكندرية"), "color on board":city_colors["orange"], "color on card":city_colors["green"], "owner":"",
        "prices": generate_prices_data(base_price=330, base_fee=50, garage_price=220, market_price=1000),
        },
        
    16: {"idx":16, "name":fix_ar("حلب"), "color on board":city_colors["orange"], "color on card":city_colors["green"], "owner":"",
        "prices": generate_prices_data(base_price=300, base_fee=40, garage_price=190, market_price=850),
        },
        
    17: {"idx":17, "name":fix_ar("السودان"), "color on board":city_colors["pink"], "color on card":city_colors["green"], "owner":"",
        "prices": generate_prices_data(base_price=200, base_fee=30, garage_price=130, market_price=700),
        },
        
    18: {"idx":18, "name":fix_ar("دمشق"), "color on board":city_colors["pink"], "color on card":city_colors["green"], "owner":"",
        "prices": generate_prices_data(base_price=350, base_fee=50, garage_price=250, market_price=1200),
        },
        
    19: {"idx":19, "name":fix_ar("القاهرة"), "color on board":city_colors["pink"], "color on card":city_colors["green"], "owner":"",
        "prices": generate_prices_data(base_price=450, base_fee=60, garage_price=320, market_price=1500),
        },
        
    20: {"idx":20, "name":fix_ar("السجن"), "color on board":"", "color on card":"", "owner":"",
        "prices": generate_prices_data(base_price=50, base_fee=0, garage_price=0, market_price=0),
        },
        
    21: {"idx":21, "name":fix_ar("الخرطوم"), "color on board":city_colors["yellow"], "color on card":city_colors["red"], "owner":"",
        "prices": generate_prices_data(base_price=200, base_fee=30, garage_price=130, market_price=630),
        },
        
    22: {"idx":22, "name":fix_ar("عمان"), "color on board":city_colors["yellow"], "color on card":city_colors["red"], "owner":"",
        "prices": generate_prices_data(base_price=250, base_fee=30, garage_price=130, market_price=700),
        },
        
    23: {"idx":23, "name":fix_ar("الأقصر"), "color on board":city_colors["white"], "color on card":city_colors["white"], "owner":"",
        "prices": generate_prices_data(base_price=200, base_fee=30, garage_price=80, market_price=100),
        },
        
    24: {"idx":24, "name":fix_ar("بور سعيد"), "color on board":city_colors["yellow"], "color on card":city_colors["red"], "owner":"",
        "prices": generate_prices_data(base_price=250, base_fee=30, garage_price=140, market_price=700),
        },
        
    25: {"idx":25, "name":fix_ar("صنعاء"), "color on board":city_colors["cyan"], "color on card":city_colors["blue"], "owner":"",
        "prices": generate_prices_data(base_price=250, base_fee=30, garage_price=130, market_price=600),
        },
        
    26: {"idx":26, "name":fix_ar("الكويت"), "color on board":city_colors["cyan"], "color on card":city_colors["blue"], "owner":"",
        "prices": generate_prices_data(base_price=250, base_fee=30, garage_price=130, market_price=620),
        },
        
    27: {"idx":27, "name":fix_ar("قطر"), "color on board":city_colors["cyan"], "color on card":city_colors["blue"], "owner":"",
        "prices": generate_prices_data(base_price=150, base_fee=20, garage_price=80, market_price=380),
        },
        
    }


