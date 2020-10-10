import XMonad
import Data.Monoid
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- My imports
import System.IO (hPutStrLn) --For xmobar woekspaces
import XMonad.Hooks.ManageDocks --For dock or bar
import XMonad.Hooks.EwmhDesktops --for desktop name in bar
import XMonad.Util.SpawnOnce -- For spawn once variable
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Hooks.DynamicLog --for polybar
import XMonad.Util.EZConfig (additionalKeysP) --For media keys
import XMonad.Hooks.InsertPosition --For inversion of master and stack
import XMonad.Hooks.ManageHelpers --For fullscreen
import XMonad.Layout.SimplestFloat -- For floating mode
import XMonad.Layout.NoBorders --For no border mode

--For Dbus
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

myTerminal :: String
myTerminal = "termite"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth   = 1

--
myModMask       = mod4Mask

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

--workspaces = [""]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#292d3e"
myFocusedBorderColor = "#bbc5ff"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_d     ), spawn "rofi -show drun -show-icons")

    -- close focused window
    , ((modm , xK_w     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Disable the polybar in one workspace
    , ((modm              , xK_b     ), sendMessage ToggleStruts)
    -- , ((modm              , xK_f     ), doFullFloat)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    , ((modm              , xK_x     ), spawn "/home/suphal/.scripts/screenlock.sh")

    -- Start applications
    , ((modm .|. shiftMask, xK_b     ), spawn "firefox")
    , ((modm .|. shiftMask, xK_c     ), spawn "chromium")
    , ((modm .|. shiftMask, xK_d     ), spawn "python3 /home/suphal/.scripts/launchscripts.py")
    , ((modm              , xK_e     ), spawn "emacsclient -c -a '' --eval '(dired nil)' ")
    , ((modm .|. shiftMask, xK_e     ), spawn "pcmanfm")
    , ((modm              , xK_v     ), spawn "termite -e nvim")
    , ((modm .|. shiftMask, xK_v     ), spawn "emacsclient -c -a emacs")
    ]
    ++

    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_p, xK_o, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
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

------------------------------------------------------------------------
-- Layouts:
myLayout = avoidStruts (tiled ||| noBorders simplestFloat ||| noBorders Full  ||| Mirror tiled)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "firefox" <&&> resource =? "Dialog" --> doFloat  -- Float Firefox Dialog
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , className =? "Chromium"     --> doShift ( myWorkspaces !! 1 )
    , className =? "spotify"     --> doShift ( myWorkspaces !! 2 )
    , className =? "Spotify"     --> doShift ( myWorkspaces !! 2 )
    , className =? "Kodi"     --> doShift ( myWorkspaces !! 3 )
    , className =? "Thunderbird"     --> doShift ( myWorkspaces !! 4 )
    , className =? "Mail"     --> doShift ( myWorkspaces !! 4 )
    , className =? "Caprine"     --> doShift ( myWorkspaces !! 4 )
    , className =? "zoom"     --> doShift ( myWorkspaces !! 5 )
    ]
------------------------------------------------------------------------
myEventHook = docksEventHook
------------------------------------------------------------------------
-- myLogHook = return ()
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
------------------------------------------------------------------------
-- Startup hook
myStartupHook :: X ()
myStartupHook = do
          spawnOnce "sh /home/suphal/.autostart.sh"
          -- setWMName "LG3D"
-- Media keys
mediaKeys :: [(String, X ())]
mediaKeys = [
          ("<XF86MonBrightnessUp>", spawn "/home/suphal/.xmonad/brightnessup.sh")
        , ("<XF86MonBrightnessDown>", spawn "/home/suphal/.xmonad/brightnessdown.sh")
        , ("<XF86AudioPlay>", spawn "playerctl play-pause")
        , ("<XF86AudioPrev>", spawn "playerctl previous")
        , ("<XF86AudioNext>", spawn "playerctl next")
        , ("<XF86AudioMute>",   spawn "amixer set Master toggle")  -- Bug prevents it from toggling correctly in 12.04.
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
        , ("<XF86HomePage>", spawn "firefox")
        , ("<XF86Mail>", spawn "emacsclient -c -a '' --eval '(mu4e)' ")
        , ("<XF86Calculator>", spawn "gcalctool")
        , ("<Print>", spawn "flameshot full -p /home/suphal/Data/Screenshots/")
        , ("M-<Print>", spawn "flameshot gui")
        ]


------------------------------------------------------------------------
-- main = xmonad defaults
main :: IO()
main = do
    dbus <- D.connectSession
    -- xmproc0 <- spawnPipe "xmobar /home/suphal/.config/xmobar/xmobarrc"
    spawnPipe "sh /home/suphal/.config/polybar/launch.sh"
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    xmonad $ ewmh def {
        manageHook = ( isFullscreen --> doFullFloat ) <+>  insertPosition Below Newer <+>  myManageHook <+> manageDocks,
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        -- manageHook         = myManageHook,
        logHook = dynamicLogWithPP (myLogHook dbus),
        -- logHook = dynamicLogWithPP (myLogHook dbus) <+> dynamicLogWithPP xmobarPP
                        -- { ppOutput = \x -> hPutStrLn xmproc0 x
                        -- , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
                        -- , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
                        -- , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                        -- , ppHiddenNoWindows = xmobarColor "#c792ea" ""        -- Hidden workspaces (no windows)
                        -- , ppTitle = xmobarColor "#b3afc2" "" . shorten 60     -- Title of active window in xmobar
                        -- , ppSep =  "<fc=#666666> <fn=2>|</fn> </fc>"                     -- Separators in xmobar
                        -- , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                        -- , ppExtras  = [windowCount]                           -- # of windows current workspace
                        -- , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        -- },

        handleEventHook    = myEventHook,
        -- logHook            = myLogHook,
        startupHook        = myStartupHook
    }`additionalKeysP` mediaKeys
