-- core
import XMonad

-- window stack manipulation and map creation
import Data.Tree
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Maybe (fromJust)

-- system
import System.Exit (exitSuccess)
import System.IO (hPutStrLn)

-- hooks
import XMonad.Hooks.DynamicLog(dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops

-- layout
import XMonad.Layout.Renamed
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutModifier(ModifiedLayout)

-- actions
import XMonad.Actions.CopyWindow(copy, kill1, copyToAll, killAllOtherCopies)
import XMonad.Actions.Submap(submap)

-- utils
import XMonad.Util.Run (spawnPipe)

--import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce

-- keys
import Graphics.X11.ExtraTypes.XF86

-- prompts
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Window
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Shell
import XMonad.Prompt.FuzzyMatch
--------------------------------------------------------------------------------------------------------------------------------------------
-- User Vars
myModMask              = mod4Mask                                                                 :: KeyMask
myFocusFollowsMouse    = True                                                                     :: Bool
myClickJustFocuses     = False                                                                    :: Bool
myBorderWidth          = 2                                                                        :: Dimension
myWindowGap            = 20                                                                       :: Integer
myTerminal             = "alacritty"                                                              :: String
myFocusedBorderColor   = "#9ec0ff"                                                                 :: String
myNormalBorderColor    = "#04c494"                                                                 :: String
myBrowser              = "brave"                                                                  :: String
--------------------------------------------------------------------------------------------------------------------------------------------
-- Layout
mySpacing :: Integer -> l a -> ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border 0 i 0 i) True (Border i 0 i 0) True

tall =
  renamed [Replace "Tall"] $
    mySpacing myWindowGap $
        ResizableTall 1 (10 /100) (1/2) []

wide =
  renamed [Replace "Wide"] $
    mySpacing myWindowGap $
        Mirror (Tall 1 (3 / 100) (1 / 2))

full =
  renamed [Replace "Full"] $
    mySpacing myWindowGap $
        Full

myLayout =
  avoidStruts $ smartBorders myDefaultLayout
  --smartBorders myDefaultLayout
  where
    myDefaultLayout = full ||| wide
--------------------------------------------------------------------------------------------------------------------------------------------
main :: IO ()
main = do
  xmproc <- spawnPipe "~/.fehbg"
  xmproc <- spawnPipe "picom"
  xmproc <- spawnPipe "xmobar"
  xmonad $ docks $ ewmh def
        { terminal           = myTerminal,
          focusFollowsMouse  = myFocusFollowsMouse,
          clickJustFocuses   = myClickJustFocuses,
          borderWidth        = myBorderWidth,
          modMask            = myModMask,
          focusedBorderColor = myFocusedBorderColor,
          layoutHook         = myLayout,
          normalBorderColor  = myNormalBorderColor
        }
