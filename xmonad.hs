
import qualified Data.Map                 as M
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
    ]


-- main
main = do
    xmproc <- spawnPipe "xmobar ~/.xmobarrc"
    xmonad $ defaults xmproc

defaults xmproc = defaultConfig {
    terminal           = myTerminal,
    modMask            = myModMask,
    focusedBorderColor = myFocusedBorderColor,
    layoutHook         = myLayout,
    manageHook         = myManageHook,
    logHook            = myLogHook xmproc,
    keys               = myKeys
    }
