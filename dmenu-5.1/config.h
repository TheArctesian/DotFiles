/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
static int centered = 0;  
static int min_width =500;
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"monospace:size=10"
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
	[SchemeNorm] = { "#f8f8f2", "#282a36" },
	[SchemeSel] = { "#f8f8f2", "#6272a4" },
 	[SchemeOut] = { "#000000", "#00ffff" },
	[SchemeHighlight] = {"#f1fa8c", "#596377", "#3E485B"},
    [SchemeHover] = {"#ffffff", "#353D4B", "#3E485B"},
    [SchemeGreen] = {"#ffffff", "#52E067", "#41b252"},
    [SchemeRed] = {"#ffffff", "#e05252", "#c24343"},
    [SchemeYellow] = {"#ffffff", "#e0c452", "#bca33f"},
    [SchemeBlue] = {"#ffffff", "#5280e0", "#3a62b3"},
    [SchemePurple] = {"#ffffff", "#9952e0", "#7439b0"},
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 20;

static unsigned int lineheight = 10;
static unsigned int min_lineheight = 8;
static int sely = 1;
static int commented = 0;
static int animated = 1;
/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

/* Size of the window border */
static const unsigned int border_width = 2;
static unsigned int columns    = 2;
