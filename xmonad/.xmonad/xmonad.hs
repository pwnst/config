-- ~/.xmonad/xmonad.hs
import XMonad

import XMonad.Config.Desktop

import XMonad.Prompt
import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
import XMonad.Prompt.AppendFile (appendFilePrompt)

import XMonad.Operations

import System.IO
import System.Exit

import XMonad.Util.Run


import XMonad.Actions.CycleWS
import XMonad.Actions.FloatKeys

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.IM
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Grid

import Data.Ratio ((%))

import qualified XMonad.StackSet as W
import qualified Data.Map as M


myTerminal      = "termite"
modMask' :: KeyMask
modMask' = mod4Mask
myWorkspaces    = ["1:main","2:web","3:ide","4:term","5:chat", "6:gimp", "7:misc"]

myXmonadBar = "dzen2 -dock -x '0' -y '0' -h '24' -w '920' -ta 'l' -fg '#FFFFFF' -bg '#1B1D1E'"
myStatusBar = "conky -c /home/pwnst/.xmonad/.conky_dzen | dzen2 -dock -x '920' -w '1000' -h '24' -ta 'r' -bg '#1B1D1E' -fg '#FFFFFF' -y '0'"
myBitmapsDir = "/home/pwnst/.xmonad/dzen2"

main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    xmonad $ desktopConfig
      { terminal            = myTerminal
      , workspaces          = myWorkspaces
      , keys                = keys'
      , modMask             = modMask'
      , layoutHook          = avoidStruts  $  layoutHook desktopConfig
      , manageHook          = manageDocks <+> manageHook desktopConfig
      , logHook             = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd
      , normalBorderColor   = colorNormalBorder
      , focusedBorderColor  = colorFocusedBorder
      , borderWidth         = 2
      , startupHook         = setWMName "LG3D"
}

manageHook' :: ManageHook
manageHook' = (composeAll . concat $ [[ className =? c --> doShift "1:main" | c <- ["telegram-desktop"]]])


myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor "white" "#1B1D1E" . pad
      , ppVisible           =   dzenColor "#ebac54" "#1B1D1E" . pad
      , ppHidden            =   dzenColor "#ebac54" "#1B1D1E" . pad
      , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#1B1D1E" . pad
      , ppUrgent            =   dzenColor "black" "red" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   dzenColor "#ebac54" "#1B1D1E" .
                                (\x -> case x of
                                    "Tall"             ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Mirror Tall"      ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Full"                      ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    "Simple Float"              ->      "~"
                                    _                           ->      x
                                )
      , ppTitle             =   (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }

colorOrange         = "#FD971F"
colorDarkGray       = "#1B1D1E"
colorPink           = "#F92672"
colorGreen          = "#A6E22E"
colorBlue           = "#66D9EF"
colorYellow         = "#E6DB74"
colorWhite          = "#CCCCC6"
 
colorNormalBorder   = "#CCCCC6"
colorFocusedBorder  = "#fd971f"

barFont  = "terminus"
barXFont = "inconsolata:size=12"
xftFont = "xft: inconsolata-14"
rofi = "rofi -combi-modi drun,run -show drun -font 'terminus 12' -theme gruvbox-dark-soft"

keys' conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask,                    xK_p        ), spawn rofi)
    , ((modMask .|. shiftMask,      xK_Return   ), spawn $ XMonad.terminal conf)
    , ((modMask,                    xK_F2       ), spawn "dmenu")
    , ((modMask .|. shiftMask,      xK_c        ), kill)
    , ((modMask .|. shiftMask,      xK_l        ), spawn "slock")
    -- FloatKeys
    , ((modMask,               xK_d     ), withFocused (keysResizeWindow (0, 10) (1,1)))
    , ((modMask,               xK_s     ), withFocused (keysResizeWindow (10, 0) (1,1)))
    , ((modMask .|. shiftMask, xK_d     ), withFocused (keysResizeWindow (0,-10) (1,1)))
    , ((modMask .|. shiftMask, xK_s     ), withFocused (keysResizeWindow (-10,0) (1,1)))
    , ((modMask,               xK_a     ), withFocused (keysMoveWindowTo (980,600) (1%2,1%2)))
    -- Programs
    , ((0,                          xK_Print    ), spawn "scrot -e 'mv $f ~/screenshots/'")
    , ((modMask,		            xK_o        ), spawn "chromium-browser")
    , ((modMask,                    xK_m        ), spawn "nautilus --no-desktop --browser")
    -- Media Keys
    , ((0,                          0x1008ff12  ), spawn "amixer -q sset Master toggle")        -- XF86AudioMute
    , ((0,                          0x1008ff11  ), spawn "amixer -q sset Master 5%-")   -- XF86AudioLowerVolume
    , ((0,                          0x1008ff13  ), spawn "amixer -q sset Master 5%+")   -- XF86AudioRaiseVolume
    , ((0,                          0x1008ff14  ), spawn "rhythmbox-client --play-pause")
    , ((0,                          0x1008ff17  ), spawn "rhythmbox-client --next")
    , ((0,                          0x1008ff16  ), spawn "rhythmbox-client --previous")

    -- layouts
    , ((modMask,                    xK_space    ), sendMessage NextLayout)
    , ((modMask .|. shiftMask,      xK_space    ), setLayout $ XMonad.layoutHook conf)          -- reset layout on current desktop to default
    , ((modMask,                    xK_b        ), sendMessage ToggleStruts)
    , ((modMask,                    xK_n        ), refresh)
    , ((modMask,                    xK_Tab      ), windows W.focusDown)                         -- move focus to next window
    , ((modMask,                    xK_j        ), windows W.focusDown)
    , ((modMask,                    xK_k        ), windows W.focusUp  )
    , ((modMask .|. shiftMask,      xK_j        ), windows W.swapDown)                          -- swap the focused window with the next window
    , ((modMask .|. shiftMask,      xK_k        ), windows W.swapUp)                            -- swap the focused window with the previous window
    , ((modMask,                    xK_Return   ), windows W.swapMaster)
    , ((modMask,                    xK_t        ), withFocused $ windows . W.sink)              -- Push window back into tiling
    , ((modMask,                    xK_h        ), sendMessage Shrink)                          -- %! Shrink a master area
    , ((modMask,                    xK_l        ), sendMessage Expand)                          -- %! Expand a master area
    , ((modMask,                    xK_comma    ), sendMessage (IncMasterN 1))
    , ((modMask,                    xK_period   ), sendMessage (IncMasterN (-1)))


    -- workspaces
    , ((modMask .|. controlMask,   xK_Right     ), nextWS)
    , ((modMask .|. shiftMask,     xK_Right     ), shiftToNext)
    , ((modMask .|. controlMask,   xK_Left      ), prevWS)
    , ((modMask .|. shiftMask,     xK_Left      ), shiftToPrev)
    
    -- quit, or restart
    , ((modMask .|. shiftMask,      xK_q        ), io (exitWith ExitSuccess))
    , ((modMask,                    xK_q        ), spawn "xmonad --recompile && xmonad --restart")
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e] [1, 0]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- vim:foldmethod=marker sw=4 sts=4 ts=4 tw=0 et ai nowrap
