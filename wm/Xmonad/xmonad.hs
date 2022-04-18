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
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Grid
import XMonad.Layout.MultiColumns
import XMonad.Layout.Spiral
import Data.Ratio -- this makes the '%' operator available (optional)

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

-- Colors
import Colors.Dracula
--------------------------------------------------------------------------------------------------------------------------------------------
-- User Vars
myModMask              = mod4Mask                                                                 :: KeyMask
myFocusFollowsMouse    = True                                                                     :: Bool
myClickJustFocuses     = False                                                                    :: Bool
myBorderWidth          = 2                                                                        :: Dimension
myWindowGap            = 25                                                                       :: Integer
myTerminal             = "alacritty"                                                              :: String
myFocusedBorderColor   = "#bd93f9"                                                                :: String
myNormalBorderColor    = "#000000"                                                                :: String
myBrowser              = "brave"                                                                  :: String
-- myWorkspaces = [" 一 ", " 二 "," 三 ", " 四", " 五 ", " 六", " 七", " 八 ", " 九 "]
myWorkspaces = [" 1 ", " 2 "," 3 ", " 4 ", " 5 ", " 6", " 7", " 8 ", " 9 "]

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

--------------------------------------------------------------------------------------------------------------------------------------------
-- Layout
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices
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
spiralLayout =
  renamed [Replace "Spiral"] $
    mySpacing myWindowGap $
        spiral (6/7)

threeLayout = 
  renamed [Replace "Three"] $
    mySpacing myWindowGap $
        ThreeColMid 1 (3/100) (1/2)

grid = 
  renamed [Replace "Grid"] $
    mySpacing myWindowGap $
         Grid
myLayout =
  avoidStruts $ smartBorders myDefaultLayout
  --smartBorders myDefaultLayout
  where
    myDefaultLayout = tall ||| wide ||| grid ||| spiralLayout ||| threeLayout
--------------------------------------------------------------------------------------------------------------------------------------------

main :: IO ()
main = do
  xmproc0 <- spawnPipe "~/.fehbg"
  xmproc1 <- spawnPipe "picom"
  xmproc2 <- spawnPipe "xmobar"
  xmonad $ docks $ ewmh def
        { terminal           = myTerminal,
          focusFollowsMouse  = myFocusFollowsMouse,
          clickJustFocuses   = myClickJustFocuses,
          borderWidth        = myBorderWidth,
          modMask            = myModMask,
          focusedBorderColor = myFocusedBorderColor,
          layoutHook         = myLayout,
          normalBorderColor  = myNormalBorderColor,
          workspaces         = myWorkspaces,
          logHook            = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP {
                ppOutput = \x -> hPutStrLn xmproc2 x   -- xmobar on monitor 1
-- Current workspace
              , ppCurrent = xmobarColor color06 "" . wrap
                            ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">") "</box>"
                -- Visible but not current workspace
              , ppVisible = xmobarColor color06 "" . clickable
                -- Hidden workspace
              , ppHidden = xmobarColor color05 "" . wrap
                           ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">") "</box>" . clickable
                -- Hidden workspaces (no windows)
              , ppHiddenNoWindows = xmobarColor color05 ""  . clickable
                -- Title of active window
              , ppTitle = xmobarColor color16 "" . shorten 60
                -- Separator character
              , ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"
                -- Urgent workspace
              , ppUrgent = xmobarColor color02 "" . wrap "!" "!"
                -- Adding # of windows on current workspace to the bar
              , ppExtras  = [windowCount]
                -- order of things in xmobar
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]

        }
}
