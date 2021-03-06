import qualified Data.Map as M
import           Data.Monoid
import           System.Exit
import           XMonad
import qualified XMonad.StackSet as W

-- My imports
import System.IO (hPutStrLn)                             --For xmobar woekspaces
import XMonad.Hooks.ManageDocks                          --For dock or bar
import XMonad.Hooks.EwmhDesktops                         --for desktop name in bar
import XMonad.Util.SpawnOnce                             -- For spawn once variable
import XMonad.Util.Run (runProcessWithInput, spawnPipe)
import XMonad.Hooks.DynamicLog                           --for polybar
import XMonad.Util.EZConfig (additionalKeysP)            --For media keys
import XMonad.Hooks.InsertPosition                       --For inversion of master and stack
import XMonad.Hooks.ManageHelpers                        --For fullscreen
import XMonad.Layout.SimplestFloat                       --For floating mode
import XMonad.Layout.Spiral                              --For Spiral layout
import XMonad.Layout.NoBorders                           --For no border mode
import XMonad.Layout.Spacing                             -- For spaces in layouts
import XMonad.Hooks.SetWMName                            -- For java applications
import XMonad.Layout.LayoutModifier
import XMonad.Layout.ResizableTile                       -- For increasing height of tiled windows
import XMonad.Layout.Renamed                             -- For changing laout name
import System.Exit (exitSuccess)
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
--For Dbus
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

myTerminal :: String
myTerminal = "alacritty"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

--workspaces = [""]

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

------------------------------------------------------------------------
altMask :: KeyMask
altMask = mod1Mask

tall     = renamed [Replace "tall"]
           $ mySpacing 4
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"] $ Full
--float    = renamed [Replace "float"] $ simplestFloat
spirals  = renamed [Replace "spirals"]
           $ spiral (6/7) 
myLayout = avoidStruts ( smartBorders tall ||| smartBorders simplestFloat ||| noBorders monocle ||| smartBorders spirals)

myManageHook = composeAll
    [ className =? "MPlayer"             --> doFloat
    , className =? "Gimp"                --> doFloat
    , title     =? "Zoom - Free Account" --> doFloat
    , resource  =? "desktop_window"      --> doIgnore
    , resource  =? "kdesktop"            --> doIgnore
    , title     =? "vlc"                 --> doFullFloat
    , className =? ""                    --> doShift ( myWorkspaces !! 2 )
    , className =? "Spotify"             --> doShift ( myWorkspaces !! 2 )
    , className =? "Kodi"                --> doShift ( myWorkspaces !! 3 )
    , className =? "Thunderbird"         --> doShift ( myWorkspaces !! 4 )
    , className =? "Mail"                --> doShift ( myWorkspaces !! 4 )
    , className =? "Caprine"             --> doShift ( myWorkspaces !! 4 )
    , className =? "zoom"                --> doShift ( myWorkspaces !! 5 )
    , className =? "Chromium"            --> doShift ( myWorkspaces !! 8 )
    , className =? "firefox" <&&> resource =? "Dialog" --> doFloat  -- Float Firefox Dialog
    ]

myEventHook = docksEventHook

myLogHook :: D.Client -> PP
myLogHook dbus = def { ppOutput = dbusOutput dbus }

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

myStartupHook :: X ()
myStartupHook = do
            spawnOnce "trayer --edge top --align center --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x282c34  --height 22"
            spawnOnce "sh /home/suphal/.autostart.sh"
            setWMName "LG3D"

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm .|. shiftMask, button1), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

newKeys :: [(String, X ())]
newKeys = [  ("M-S-r", spawn "xmonad --recompile") -- Recompiles xmonad
        , ("M-C-r", spawn "xmonad --restart")   -- Restarts xmonad
        , ("M-C-q", io exitSuccess)             -- Quits xmonad
        , ("M-x"  , spawn "dm-tool lock")       -- Lock the screen

        , ("M-w",          kill)                            -- Close the selected window
        , ("M-t",          withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-m",          windows W.focusMaster)           -- Move focus to the master window
        , ("M-j",          windows W.focusDown)             -- Move focus to the next window
        , ("M-k",          windows W.focusUp)               -- Move focus to the prev window
        , ("M-S-<Return>", windows W.swapMaster)            -- Swap the focused window and the master window
        , ("M-S-j",        windows W.swapDown)              -- Swap focused window with next window
        , ("M-S-k",        windows W.swapUp)                -- Swap focused window with prev window
        , ("M-C-<Return>", promote)                         -- Moves focused window to master, others maintain order
        , ("M-h",          sendMessage Shrink)              -- Shrink horiz window width
        , ("M-l",          sendMessage Expand)              -- Expand horiz window width
        , ("M-S-h",        sendMessage MirrorShrink)        -- Shrink vert window width
        , ("M-S-l",        sendMessage MirrorExpand)        -- Exoand vert window width

        , ("M-<Space>",    sendMessage NextLayout)          -- Switch to next layout
        , ("M-b",          sendMessage ToggleStruts)        -- Toggles struts
        , ("M-i",          incWindowSpacing 4)              -- Increase window spacing
        , ("M-S-i",        decWindowSpacing 4)              -- Decrease window spacing
        , ("M-C-i",        incScreenSpacing 4)              -- Increase screen spacing
        , ("M-S-C-i",      decScreenSpacing 4)              -- Decrease screen spacing
        , ("M-M1-j",       sendMessage (IncMasterN 1))      -- Increase number of clients in master pane
        , ("M-M1-k",       sendMessage (IncMasterN (-1)))   -- Decrease number of clients in master pane

        , ("<XF86MonBrightnessUp>",   spawn "/home/suphal/.xmonad/brightnessup.sh")
        , ("<XF86MonBrightnessDown>", spawn "/home/suphal/.xmonad/brightnessdown.sh")
        , ("<XF86AudioPlay>",         spawn "playerctl play-pause")
        , ("<XF86AudioPrev>",         spawn "playerctl previous")
        , ("<XF86AudioNext>",         spawn "playerctl next")
        , ("<XF86AudioMute>",         spawn "amixer set Master toggle")
        , ("<XF86AudioLowerVolume>",  spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>",  spawn "amixer set Master 5%+ unmute")
        , ("<XF86HomePage>",          spawn "firefox")
        , ("<XF86Mail>",              spawn "thunderird")
        , ("<XF86Calculator>",        spawn "gnome-calculator")
        , ("<Print>",                 spawn "flameshot full -p /home/suphal/Data/Screenshots/")
        , ("M-<Print>",               spawn "flameshot gui")

        , ("M-<Return>",   spawn myTerminal)
        , ("M-S-e",        spawn (myTerminal ++ " -e vifm"))
        , ("M-v"  ,        spawn (myTerminal ++ " -e nvim"))
        , ("M-S-d",        spawn "python3 /home/suphal/.scripts/launchscripts.py")

        , ("M-d"  ,        spawn "dmenu_run -c -l 20 -p 'Run :'")
        , ("M-e"  ,        spawn "pcmanfm-qt")
        , ("M-S-v",        spawn "emacsclient -c -a emacs")
        , ("M-c"  ,        spawn "rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'")
        ]

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_p, xK_o, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    ++

    [
      ((modm .|. shiftMask, xK_b     ), spawn "firefox")
    , ((modm .|. shiftMask, xK_c     ), spawn "chromium")
    ]

main :: IO()
main = do
    dbus <- D.connectSession
    xmproc0 <- spawnPipe "/usr/bin/xmobar /home/suphal/.config/xmobar/xmobarrc"
    -- spawnPipe "sh /home/suphal/.config/polybar/launch.sh"
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    xmonad $ ewmh def {
        manageHook = ( isFullscreen --> doFullFloat ) <+>  insertPosition Below Newer <+>  myManageHook <+> manageDocks,
        -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = True,
        clickJustFocuses   = False,
        borderWidth        = 2,
        modMask            = mod4Mask,
        workspaces         = myWorkspaces,
        normalBorderColor  = "#292d3e",
        focusedBorderColor = "#bbc5ff",

        -- key bindings
        keys = myKeys,
        mouseBindings      = myMouseBindings,

        -- hooks, layouts
        layoutHook         = myLayout,
        -- manageHook         = myManageHook,
        -- logHook = dynamicLogWithPP (myLogHook dbus),
        logHook = dynamicLogWithPP (myLogHook dbus) <+> dynamicLogWithPP xmobarPP
                        { ppOutput          = \x -> hPutStrLn xmproc0 x
                        , ppCurrent         = xmobarColor "#c3e88d" "" . wrap "[" "]"  -- Current workspace in xmobar
                        , ppVisible         = xmobarColor "#c3e88d" ""                 -- Visible but not current workspace
                        , ppHidden          = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#c792ea" ""                 -- Hidden workspaces (no windows)
                        , ppTitle           = xmobarColor "#b3afc2" "" . shorten 60    -- Title of active window in xmobar
                        , ppSep             = "<fc=#666666> <fn=2>|</fn> </fc>"        -- Separators in xmobar
                        , ppUrgent          = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras          = [windowCount]                            -- # of windows current workspace
                        , ppOrder           = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        },
        handleEventHook    = myEventHook,
        -- logHook            = myLogHook,
        startupHook        = myStartupHook
    }`additionalKeysP` newKeys
