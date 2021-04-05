/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>
/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int gappx     = 5;        /* gap pixel between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;     /* 0 means no systray */
static const int swallowfloating    = 1;        /* 1 means swallow floating windows by default */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 0;        /* 0 means bottom bar */
static const char *fonts[]          = { "monospace:size=10" };
static const char dmenufont[]       = "monospace:size=10";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#525252";
static const char col_orange[]        = "#b54500";
static const char *colors[][3]      = {
  /*               fg         bg         border   */
  [SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
  [SchemeSel]  = { col_gray4, col_cyan,  col_orange  },
};
/* swallow emacs */
static const char emacsclient[] = "emacsclient";
static const char emacsname[] = "emacs@";

/* tagging */
#define MAX_TAGLEN 16
static char tags[][MAX_TAGLEN] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
static const Rule rules[] = {
  /* xprop(1):
   *	WM_CLASS(STRING) = instance, class
   *	WM_NAME(STRING) = title
   */
  /* class            , instance , title          , tags mask , isfloating , isterminal , noswallow , monitor */
  /* { "Gimp"         , NULL     , NULL           , 0         , 1          , 0          , 0         , -1 }       , */
  /* { "Firefox"      , NULL     , NULL           , 1 << 8    , 0          , 0          , -1        , -1 }       , */
  { "st"              , NULL     , NULL           , 0         , 0          , 1          , -1        , -1 }       ,
  { "todo"            , NULL     , NULL           , 0         , 0          , 1          , 1         , -1 }       ,
  { "kitty"           , NULL     , NULL           , 0         , 0          , 1          , -1        , -1 }       ,
  { "cypress"           , NULL     , NULL           , 0         , 0          , 1          , -1        , -1 }       ,
  { "Peek"            , NULL     , NULL           , 0         , 1          , 0          , 1         , -1 }       ,
  { "Blueman-manager" , NULL     , NULL           , 0         , 1          , 0          , 1         , -1 }       ,
  { "Pavucontrol"     , NULL     , NULL           , 0         , 1          , 0          , 1         , -1 }       ,
  { "termite"         , NULL     , NULL           , 0         , 1          , 1          , -1        , -1 }       ,
  { NULL              , NULL     , "Event Tester" , 0         , 1          , 0          , 1         , -1 }       , 
  { "cypress"         , NULL     , NULL           , 0         , 0          , 0          , -1         , -1 }       , 
};
/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const Layout layouts[] = {
  /* symbol     arrange function */
  { "[]=",      tile },    /* first entry is default */
  { "><>",      NULL },    /* no layout function means floating behavior */
  { "[M]",      monocle },
};
/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },
/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "kitty", NULL };
static const char *screenshotcmd[] = {"/home/joshua/.config/usr-scripts/screenshot.sh"};
static const char *applaunchercmd[] = {"/home/joshua/.config/rofi/launchers/launcher.sh"};
static const char *emojilaunchercmd[] = {"/home/joshua/.config/rofi/launchers/emoji.sh"};
static const char *totpcmd[] = {"/usr/local/bin/totp"};
static const char *sleepcmd[] = {"systemctl","suspend", NULL};
static const char *brightness_up[] = {"light", "-A","10", NULL};
static const char *brightness_down[] = {"light", "-U","10", NULL};
static const char *volume_up[] = {"pactl", "set-sink-volume", "@DEFAULT_SINK@", "+10%", NULL};
static const char *volume_down[] = {"pactl", "set-sink-volume", "@DEFAULT_SINK@", "-10%", NULL};
static const char *volume_mute[] = {"pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", NULL};
static Key keys[] = {
  /* modifier                     key        function        argument */
  { MODKEY,                       XK_d,      spawn,          {.v = applaunchercmd } },
  { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
  { MODKEY,                       XK_s,      spawn,          {.v = screenshotcmd } },
  { ControlMask|ShiftMask,        XK_s,      spawn,          {.v = sleepcmd } },
  { MODKEY,                       XK_e,      spawn,          {.v = emojilaunchercmd } },
  { MODKEY,                       XK_t,      spawn,          {.v = totpcmd } },
  { 0,                            XF86XK_MonBrightnessUp,   spawn, {.v = brightness_up } },
  { 0,                            XF86XK_MonBrightnessDown, spawn, {.v = brightness_down } },
  { 0,                            XF86XK_AudioRaiseVolume, spawn, {.v = volume_up } },
  { 0,                            XF86XK_AudioLowerVolume, spawn, {.v = volume_down } },
  { 0,                            XF86XK_AudioMute, spawn, {.v = volume_mute } },
  { MODKEY,                       XK_b,      togglebar,      {0} },
  { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
  { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
  { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
  { MODKEY,                       XK_o,      incnmaster,     {.i = -1 } },
  { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
  { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
  { MODKEY|ShiftMask,             XK_h,      setcfact,       {.f = +0.50} },
  { MODKEY|ShiftMask,             XK_l,      setcfact,       {.f = -0.50} },
  { MODKEY|ShiftMask,             XK_o,      setcfact,       {.f =  0.00} },
  { MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
  { MODKEY,                       XK_Tab,    view,           {0} },
  { MODKEY,                       XK_q,      killclient,     {0} },
  { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
  { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
  { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
  { MODKEY,                       XK_space,  setlayout,      {0} },
  { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
  { MODKEY|ShiftMask,                       XK_s,      togglesticky,   {0} },
  { MODKEY|ControlMask,                       XK_j,   moveresize,     {.v = "0x 75y 0w 0h" } },
  { MODKEY|ControlMask,                       XK_k,     moveresize,     {.v = "0x -75y 0w 0h" } },
  { MODKEY|ControlMask,                       XK_l,  moveresize,     {.v = "75x 0y 0w 0h" } },
  { MODKEY|ControlMask,                       XK_h,   moveresize,     {.v = "-75x 0y 0w 0h" } },
  { MODKEY|ShiftMask,             XK_j,   moveresize,     {.v = "0x 0y 0w 75h" } },
  { MODKEY|ShiftMask,             XK_k,     moveresize,     {.v = "0x 0y 0w -75h" } },
  { MODKEY|ShiftMask,             XK_l,  moveresize,     {.v = "0x 0y 75w 0h" } },
  { MODKEY|ShiftMask,             XK_h,   moveresize,     {.v = "0x 0y -75w 0h" } },
  { MODKEY|ControlMask|ShiftMask,           XK_k,     moveresizeedge, {.v = "t"} },
  { MODKEY|ControlMask|ShiftMask,           XK_j,   moveresizeedge, {.v = "b"} },
  { MODKEY|ControlMask|ShiftMask,           XK_h,   moveresizeedge, {.v = "l"} },
  { MODKEY|ControlMask|ShiftMask,           XK_l,  moveresizeedge, {.v = "r"} },
  { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
  { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
  { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
  { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
  { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
  { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
  { MODKEY,                       XK_n,      nametag,        {0} },
  TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    TAGKEYS(                        XK_6,                      5)
    TAGKEYS(                        XK_7,                      6)
    TAGKEYS(                        XK_8,                      7)
    TAGKEYS(                        XK_9,                      8)
    { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};
/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
  /* click                event mask      button          function        argument */
  { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
  { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
  { ClkWinTitle,          0,              Button2,        zoom,           {0} },
  { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
  { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
  { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
  { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
  { ClkTagBar,            0,              Button1,        view,           {0} },
  { ClkTagBar,            0,              Button3,        toggleview,     {0} },
  { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
  { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
