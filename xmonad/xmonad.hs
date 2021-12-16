{- Xmonad Config File
   Nicholas Huber
   20211216
-}

-- IMPORTS

-- Base Imports
  import XMonad

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.EwmhDesktops

-- Utils
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Ungrab

-- Layout
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing

-- Data
import Data.Monoid
import qualified Data.Map as M

-- Variables
myModMask :: KeyMask
myModMask = mod4Mask  --Sets modkey to Super

myTerminal :: String
myTerminal = "alacritty" -- Set default terminal to Alacritty

myEditor :: String
myEditor = "emacs" -- Set default editor to Emacs

myBrowser :: String
myBrowser = "firefox"

-- Layout
myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes

-- WorkSpaces
myWorkSpaces = [ " Dev "
               , " WWW "
               , " Misc"
               ]

myWorkSpaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

-- Managehook
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
   [ className =? "Mozilla Firefox" --> doShift (myWorspaces !! 1)
   , className =? "dialog"          --> doFloat

-- Keybindings
myKeys :: [(String, X ())]
myKeys = [ ("M-b" , spawn (myBrowser))
         , ("M-<Return>" , spawn (myTerminal))
         , ("M-e" , spawn (myEditor))
         ]

-- XMobar
myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

-- Config
myConfig = def
   { modMask = myModMask
   , manageHook = myManageHook
   , layoutHook = myLayoutHook
   , terminal = myTerminal
   , workspaces = myWorkSpaces
   } ` additionalKeysP` myKeys

-- Main
main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar" (pur myXmobarPP)) defToggleStrusKey
     $ myConfig
