import os
import subprocess
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

myTerm = "alacritty"
mod = "mod4"

keys = [
    # Switch between windows in current stack pane
    Key([mod], "k", lazy.layout.down()),
    Key([mod], "j", lazy.layout.up()),

    # Move windows up or down in current stack
    Key([mod, "shift"], "k", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_up()),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next()),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),

    # Toggle between different layouts as defined below
    Key([mod], "space", lazy.next_layout()),
    Key([mod], "w", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),

    # Custom Krybindings
    Key([mod], "d", lazy.spawn("rofi -show drun -show-icons")),

    # Media Controls
    Key([], "XF86MonBrightnessUp", lazy.spawn("blight set +5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("blight set -5%")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer set Master -q 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer set Master -q 5%-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master,0 toggle")),
    Key([mod], "x", lazy.spawn("/home/suphal/.scripts/screenlock.sh")),
    Key([], "Print",
        lazy.spawn("flameshot full -p /home/suphal/Data/Screenshots/")),
    Key([mod], "Print", lazy.spawn("flameshot gui")),

    # Window resize
    Key([mod, "shift"], 'h', lazy.layout.shrink()),
    Key([mod, "shift"], 'l', lazy.layout.grow()),
    Key([mod, "shift"], 'n', lazy.layout.reset()),
    Key([mod], 'm', lazy.layout.maximize()),
    Key([mod], 'n', lazy.layout.normalize()),

    # Window change
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod, "shift", "control"], "k", lazy.layout.grow_up()),
    Key([mod, "shift", "control"], "j", lazy.layout.grow_down()),

    # Launch Applications
    Key([mod, "shift"], "b", lazy.spawn("firefox")),
    Key([mod, "shift"], "c", lazy.spawn("qutebrowser")),
    Key([mod], "Return", lazy.spawn(myTerm)),
    Key([mod, "shift"], "e", lazy.spawn("thunar")),
    Key([mod], "e", lazy.spawn(myTerm + " -e vifm")),
    Key([mod], "v", lazy.spawn(myTerm + " -e nvim")),
    Key([mod, "shift"], "v", lazy.spawn("emacsclient -c -a emacs")),
    Key([mod, "shift"], "d",
        lazy.spawn("/home/suphal/.scripts/launchscripts.py")),
    Key([mod], "c",
        lazy.spawn(
            "rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'"
        )),
]

groups = []

# FOR QWERTY KEYBOARDS
group_names = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
]

# FOR AZERTY KEYBOARDS
# group_names = ["ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "section", "egrave", "exclam", "ccedilla", "agrave",]
# 
group_labels = [
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
]

group_layouts = [
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
    "monadtall",
]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend([

        # CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key(["mod1"], "Tab", lazy.screen.next_group()),
        Key(["mod1", "shift"], "Tab", lazy.screen.prev_group()),

        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        #Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            lazy.group[i.name].toscreen()),
    ])

# groups = [Group(i) for i in "123456789"]

# for i in groups:
#   keys.extend([
# mod1 + letter of group = switch to group
#      Key([mod], i.name, lazy.group[i.name].toscreen()),

# mod1 + shift + letter of group = switch to & move focused window to group
#     Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True)),
# Or, use below if you prefer not to switch to that group.
# # mod1 + shift + letter of group = move focused window to group
# Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
# ])

layouts = [
    layout.MonadTall(
        #  border_focus = "#e1acff",
        #  border_normal = "#000000",
        max_ratio=0.75,
        border_width=0,
        margin=4),
    layout.Floating(),
    layout.Max(),
    layout.TreeTab(),
    #  layout.Bsp(),
    #  layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    # layout.Columns(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]
colors = [
    ["#292d3e", "#292d3e"],  # panel background
    ["#434758", "#434758"],  # background for current screen tab
    ["#ffffff", "#ffffff"],  # font color for group names
    ["#ff5555", "#ff5555"],  # border line color for current tab
    ["#8d62a9", "#8d62a9"],  # border line color for other tab and odd widgets
    ["#668bd7", "#668bd7"],  # color for the even widgets
    ["#e1acff", "#e1acff"]
]  # window name

widget_defaults = dict(font='Ubuntu Mono',
                       fontsize=12,
                       padding=0,
                       background="#292d3e")
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    text='  ',
                    background="#263238",
                    center_aligned=True,
                    padding=0,
                    fontsize=20,
                    mouse_callbacks={
                        'Button1':
                        lambda qtile: qtile.cmd_spawn(
                            'rofi -show drun -show-icons -fullscreen True -lines 5 -line-margin 5 -padding 300 -bw 0'
                        )
                    },
                ),
                widget.TextBox(text='',
                               background="#37474F",
                               foreground="#263238",
                               padding=0,
                               fontsize=20),
                widget.CurrentLayoutIcon(
                    custom_icon_paths="~/.config/qtile/icons/",
                    fontsize=10,
                    padding=10,
                    background="#37474F",
                    scale=0.8),
                widget.TextBox(text='',
                               background="#455A64",
                               foreground="#37474F",
                               padding=0,
                               fontsize=20),
                widget.Sep(linewidth=0,
                           padding=10,
                           foreground=colors[2],
                           background="#455A64"),
                widget.WindowName(
                    show_state=True,
                    foreground="#ffffff",
                    background="#455A64",
                ),
                widget.TextBox(text='',
                               background="#292d3e",
                               foreground="#455A64",
                               padding=0,
                               fontsize=20),
                widget.Sep(linewidth=0,
                           padding=150,
                           foreground=colors[2],
                           background=colors[0]),
                widget.GroupBox(font="Mononoki Nerd Font",
                                fontsize=18,
                                borderwidth=7,
                                active="#ffffff",
                                inactive="#546E7A",
                                rounded=False,
                                highlight_color="#666666",
                                highlight_method="block",
                                foreground=colors[2],
                                background=colors[0]),
                widget.Sep(linewidth=0,
                           padding=100,
                           foreground=colors[2],
                           background=colors[0]),
                widget.Systray(),
                widget.TextBox(text='',
                               center_aligned=True,
                               background="#292d3e",
                               foreground="#607D8B",
                               padding=0,
                               fontsize=20),
                widget.TextBox(
                    text=" ",
                    background="#607D8B", fontsize=18, margin_y=-2),
                widget.Backlight(
                    backlight_name="radeon_b10",
                    brightness_file=
                    "/sys/class/backlight/radeon_bl0/actual_brightness",
                    max_brightness_file=
                    "/sys/class/backlight/radeon_bl0/max_brightness",
                    background="#607D8B",
                    change_command='blight set {0}'),
                #                 widget.ThermalSensor(
                #                       foreground = "#ffffff",
                #                       background = "#607D8B",
                #                       threshold = 90,
                #                       padding = 5,
                #                       mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn(myTerm + ' -e htop')}
                #                       ),
                widget.TextBox(text='',
                               background="#607D8B",
                               foreground="#546E7A",
                               padding=0,
                               fontsize=20),
                widget.TextBox(
                    text='  ', background="#546E7A", padding=0, fontsize=20),
                widget.CPU(
                    core=all,
                    background="#546E7A",
                    format=' {load_percent}%',
                    mouse_callbacks={
                        'Button1':
                        lambda qtile: qtile.cmd_spawn(myTerm + ' -e bashtop')
                    }),
                widget.TextBox(text='',
                               background="#546E7A",
                               foreground="#455A64",
                               padding=0,
                               fontsize=20),
                widget.TextBox(text="  ",
                               background="#455A64",
                               fontsize=20,
                               mouse_callbacks={
                                   'Button1':
                                   lambda qtile: qtile.cmd_spawn('pavucontrol')
                               }),
                widget.Volume(
                    foreground="#ffffff",
                    background="#455A64",
                ),
                widget.TextBox(text='',
                               background="#455A64",
                               foreground="#37474F",
                               padding=0,
                               fontsize=20),
                widget.TextBox(
                    text='',
                    background="#37474F",
                    foreground="#ffffff",
                    padding=0,
                    fontsize=20,
                    mouse_callbacks={
                        'Button1':
                        lambda qtile: qtile.cmd_spawn(myTerm + ' -e bashtop')
                    }),
                widget.Net(
                    interface="enp4s0",
                    background="#37474F",
                    format=' ↓{down} ↑{up}',
                    padding=5,
                    mouse_callbacks={
                        'Button1':
                        lambda qtile: qtile.cmd_spawn(myTerm + ' -e nmtui')
                    },
                ),
                widget.TextBox(text='',
                               background="#37474F",
                               foreground="#263238",
                               padding=0,
                               fontsize=20),
                widget.Clock(format=' %Y-%m-%d %a  %I:%M %p',
                             background="#263238"),
                #  widget.TextBox(
                #         text = '',
                #         background = "#263238",
                #         foreground = "#000000",
                #         padding = 0,
                #         fontsize =20
                #         ),
                #  widget.TextBox(
                #          text = "",
                #          background = "#000000",
                #          mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn('exit-menu.py'),}
                #          )
            ],
            20,
        ), ),
]

# Drag and resize floating layouts.
mouse = [
    Drag([mod],
         "Button1",
         lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod, "shift"],
         "Button1",
         lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod, "mod1"], "Button1", lazy.window.bring_to_front())
]

#  follow_mouse_focus = True
#  bring_front_click = True
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {
        'wmclass': 'confirm'
    },
    {
        'wmclass': 'dialog'
    },
    {
        'wmclass': 'download'
    },
    {
        'wmclass': 'error'
    },
    {
        'wmclass': 'file_progress'
    },
    {
        'wmclass': 'notification'
    },
    {
        'wmclass': 'splash'
    },
    {
        'wmclass': 'toolbar'
    },
    {
        'wmclass': 'confirmreset'
    },  # gitk
    {
        'wmclass': 'makebranch'
    },  # gitk
    {
        'wmclass': 'maketag'
    },  # gitk
    {
        'wname': 'branchdialog'
    },  # gitk
    {
        'wname': 'pinentry'
    },  # GPG key password entry
    {
        'wmclass': 'ssh-askpass'
    },  # ssh-askpass
    {
        'wname': 'Zoom Cloud Meetings'
    },
    {
        'wmclass': 'Zoom'
    },
    {
        'wmclass': 'zoom'
    },
    {
        'wmclass': 'wineboot.exe'
    },
    {
        'wmclass': 'Wine'
    },
    {
        'wmclass': 'wine'
    },
    {
        'wmclass': 'tk'
    },
    {
        'wmclass': 'Tk'
    },
    {
        'wmclass': 'Toplevel'
    },
    {
        'wname': 'Unity Package Manager'
    },
])


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.autostart.sh')
    subprocess.call([home])
    subprocess.Popen(['xsetroot', '-cursor_name', 'Breeze_Default'])


@hook.subscribe.client_new
def assign_app_group(client):
    d = {}
    #########################################################
    ################ assgin apps to groups ##################
    #########################################################
    d["2"] = ["firefox", "Mozilla Firefox", "chromium", "Chromium"]
    d["4"] = ["kodi", "Kodi"]
    d["5"] = ["rambox", "Rambox", "Mail", "Thunderbird"]
    d["6"] = ["zoom", "Zoom"]
    d["8"] = ["vscodium", "VSCodium"]
    d["9"] = ["unity", "Unity", "unity-editor", "unity package manager"]
    ##########################################################
    wm_class = client.window.get_wm_class()[0]

    # ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME
    for i in range(len(d)):
        if wm_class in list(d.values())[i]:
            group = list(d.keys())[i]
            client.togroup(group)


wmname = "LG3D"
# Must install xcb-util-cursor for changing cursor themes
