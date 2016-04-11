
import qualified Data.Map                 as M
import           Graphics.X11.ExtraTypes
import           System.IO
import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet          as W
import           XMonad.Util.EZConfig     (additionalKeys)
import           XMonad.Util.Run          (spawnPipe)


myTerminal   = "terminator"

myModMask    = mod4Mask

myFocusedBorderColor = "#1793D1"

myLayout = avoidStruts  $  layoutHook defaultConfig

myManageHook = manageDocks <+> manageHook defaultConfig

myLogHook xmproc = dynamicLogWithPP xmobarPP {
    ppOutput = hPutStrLn xmproc,
    ppTitle  = xmobarColor "green" "" . shorten 50
    }


myKeys x = M.union (M.fromList (keys' x)) (keys defaultConfig x)

keys' conf@(XConfig {XMonad.modMask = modMask}) =
    [ ((controlMask .|. mod4Mask, xK_Delete), spawn "xscreensaver-command -lock")
    , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
    , ((0, xK_Print), spawn "scrot")

    -- 
    , ((0, xF86XK_AudioLowerVolume),        spawn "pactl set-sink-volume 1 -1.5%")
    , ((0, xF86XK_AudioRaiseVolume),        spawn "pactl set-sink-volume 1 +1.5%")
    , ((0, xF86XK_AudioMute),        spawn "pactl set-sink-mute 1 toggle")
      
    ]


-- main
main = do
    xmproc <- spawnPipe "xmobar ~/.xmobarrc"
    xmonad $ defaults {
        logHook            = myLogHook xmproc
        }

defaults = defaultConfig {
    terminal           = myTerminal,
    modMask            = myModMask,
    focusedBorderColor = myFocusedBorderColor,
    layoutHook         = myLayout,
    manageHook         = myManageHook,
    keys               = myKeys
    }
