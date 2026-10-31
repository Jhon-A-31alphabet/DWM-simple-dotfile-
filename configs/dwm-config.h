/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 5;        /* border pixel of windows */
static const int gappx              = 30;       /* gap between windows */
static const int bargap             = 20;       /* gap between the bar and windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int barheight          = 20;       /* extra bar height in pixels */
static const char *fonts[]          = { "monospace:size=10" };
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#000000";
static const char col_accent[]      = "#00FFFF";
static const char col_border[]      = "#00FFFF";
static const char *colors[][3]      = {
	/*               fg         bg         border    */
	[SchemeNorm] = { col_gray3, col_gray1, col_border },
	[SchemeSel]  = { col_gray4, col_accent, col_border },
};

/* píxeles desde el borde de la ventana para redimensionar con el ratón */
static const unsigned int edgepx    = 6;

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",       NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",    NULL,       NULL,       1 << 8,       0,           -1 },
	{ "wifi-manager", NULL,     NULL,       0,            1,           -1 },
	{ "bluetooth-manager", NULL, NULL,      0,            1,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const int refreshrate = 120;  /* refresh rate (per second) for client move/resize */

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

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0";
static const char *dmenucmd[] = { "/usr/local/bin/dwm-dmenu", NULL };
static const char *termcmd[]  = { "kitty", NULL };
static const char *wificmd[]  = { "kitty", "--class", "wifi-manager",
                                  "--title", "Redes WiFi", "-e", "nmtui", NULL };
static const char *btcmd[]    = { "kitty", "--class", "bluetooth-manager",
                                  "--title", "Administrador Bluetooth",
                                  "-e", "/usr/local/bin/bluetooth-tui", NULL };
static const char *scrotcmd[] = { "/usr/local/bin/scrot-shot", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ 0,                            XK_F13,    spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_F13,    spawn,          {.v = dmenucmd } },
	{ Mod1Mask,                     XK_F4,     killclient,     {0} },
	{ ControlMask|Mod1Mask,         XK_x,      killclient,     {0} },
	{ ControlMask,                  XK_j,      focusstack,     {.i = +1 } },
	{ ControlMask|Mod1Mask,         XK_z,      spawn,          {.v = termcmd } },
	{ ControlMask,                  XK_s,      spawn,          {.v = scrotcmd } },
	{ 0,                            XF86XK_AudioLowerVolume, spawn, SHCMD("pamixer --decrease 5") },
	{ 0,                            XF86XK_AudioRaiseVolume, spawn, SHCMD("pamixer --increase 5") },
	{ 0,                            XF86XK_AudioMute,        spawn, SHCMD("pamixer --toggle-mute") },
	{ 0,                            XF86XK_MonBrightnessDown, spawn, SHCMD("brightnessctl set 5%-") },
	{ 0,                            XF86XK_MonBrightnessUp,   spawn, SHCMD("brightnessctl set 5%+") },
	{ MODKEY|ShiftMask,             XK_v,      spawn,          SHCMD("pavucontrol") },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ Mod1Mask,                     XK_Left,   viewadj,        {.i = -1 } },
	{ Mod1Mask,                     XK_Right,  viewadj,        {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
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
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkWifi,              0,              Button1,        spawn,          {.v = wificmd } },
	{ ClkBluetooth,         0,              Button1,        spawn,          {.v = btcmd } },
	{ ClkScrot,             0,              Button1,        spawn,          {.v = scrotcmd } },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         0,              Button1,        NULL,           {0} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

