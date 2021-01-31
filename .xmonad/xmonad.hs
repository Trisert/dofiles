-- System --
import Graphics.X11.ExtraTypes.XF86
import XMonad
import System.Directory
import Data.Monoid
import System.Exit
import XMonad.ManageHook
import Data.Char

-- Prompt --
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Input
import XMonad.Prompt.Shell
import XMonad.Prompt.AppLauncher as AL

-- Util --
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.NamedScratchpad
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)

-- Layout --
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.LimitWindows
import XMonad.Layout.NoBorders

-- Hooks --
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops

-- Actions --
import XMonad.Actions.GridSelect
import XMonad.Actions.WithAll
import XMonad.Actions.WindowMenu

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myEditor :: String
myEditor = "alacritty -e nvim"

myTerminal :: String 
myTerminal = "alacritty"

myBrowser  :: String
myBrowser  = "firefox"

myFont :: String
myFont = "xft:JetBrainsMono Nerd Font:regular:pixelsize=13.5"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth :: Dimension
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask :: KeyMask
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces :: [[Char]]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor :: [Char]
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor :: [Char]
myFocusedBorderColor = "#261823"

-- Scatchpads
myScratchPads :: [NamedScratchpad]
myScratchPads = [
        NS "htop" "xterm -e htop" (title =? "htop") manageTerm
    ] 
 where 
 spawnTerm = myTerminal ++ " -e htop"
 manageTerm = customFloating $ W.RationalRect l t w h
        where
         h = 0.9
         w = 0.9
         t = 0.95 -h
         l = 0.95 -w

------------------------------------------------------------------------
-- Xprompt Settings
ndXPConfig :: XPConfig
ndXPConfig = def
      { font = myFont
      , bgColor             = "#1d1f21"
      , fgColor             = "#ffffff"
      , bgHLight            = "#de935f" --"#f2a59a"
      , fgHLight            = "#ffffff"
      , borderColor         = "#535974"
      , promptBorderWidth   = 0
      , position            = Top
      , height              = 23
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Nothing -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Just 6      -- set to Just 5 for 5 rows
      , promptKeymap        = defaultXPKeymap
      , sorter              = fuzzySort
      }


------------------------------------------------------------------------
-- CUSTOM PROMPTS
------------------------------------------------------------------------
-- calcPrompt requires a cli calculator called qalcualte-gtk.
-- You could use this as a template for other custom prompts that
-- use command line programs that return a single line of output.
calcPrompt :: XPConfig -> String -> X ()
calcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "qalc" [input] "") >>= calcPrompt c
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace

editPrompt :: String -> X ()
editPrompt home = do
    str <- inputPrompt cfg "EDIT: ~/"
    case str of
        Just s  -> openInEditor s
        Nothing -> pure ()
  where
    cfg = ndXPConfig { defaultText = "" }

openInEditor :: String -> X ()
openInEditor path =
    -- safeSpawn "emacsclient" ["-c", "-a", "emacs", path]
     safeSpawn "alacritty" ["-e", "nvim", path]


ndGSConfig = def {gs_cellheight = 100
                , gs_cellwidth = 100  
                }

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
--myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
--myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
myKeys :: String -> [([Char], X ())]
myKeys home =

    -- launch a terminal
    [ --((modm .|. shiftMask, xK_Return), spawn myTerminal)
      ("M-S-<Return>", spawn myTerminal)

    -- Htop Scratchpad
    , ("M-S-v", namedScratchpadAction myScratchPads "htop")

    -- launch dmenu
    --, ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch gmrun
    -- , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- Launch ShellPrompt
    --, ((modm, xK_p), shellPrompt ndXPConfig )
     , ("M-p", shellPrompt ndXPConfig)

    -- GridSelect
     , ("M-g", goToSelected ndGSConfig)

    -- Launch AppLauncher
     , ("M-S-e", AL.launchApp ndXPConfig "zathura")

    -- Launch EditPrompt
    -- , ("M-S-f", editPrompt home)
     , ("M-S-f", AL.launchApp ndXPConfig "alacritty -e nvim")
     
    -- Launch CalcPrompt
    -- , ((modm .|. shiftMask, xK_l), calcPrompt ndXPConfig "qalc")
     , ("M-S-l", calcPrompt ndXPConfig "qalc")

    -- SinkAll floating windows
     --, ((modm .|. shiftMask, xK_t), sinkAll)
     , ("M-S-t", sinkAll)

    -- Lock Screen
    , ("M-a",      spawn "slock")

    -- Launch myBrowser
    , ("M-s",      safeSpawnProg myBrowser)

    -- Lower Volume
    , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%")

    -- Raise Volume
    , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%")

    -- Launch Htop Scratchpad
    --, ((modm,               xK_g), namedScratchpadAction myScratchPads "htop")

    -- close focused window
    , ("M-S-c", kill)

    -- Rotate through the available layout algorithms
    , ("M-<Space>", sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    --, ("M-S-<Space>", setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ("M-n", refresh)

    -- Move focus to the next window
    , ("M-<Tab>", windows W.focusDown)

    -- Move focus to the next window
    , ("M-j", windows W.focusDown)

    -- Move focus to the previous window
    , ("M-k", windows W.focusUp  )

    -- Move focus to the master window
    , ("M-m", windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ("M-<Return>", windows W.swapMaster)

    -- Swap the focused window with the next window
    , ("M-S-j", windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ("M-S-k", windows W.swapUp    )

    -- Shrink the master area
    , ("M-h", sendMessage Shrink)

    -- Expand the master area
    , ("M-l", sendMessage Expand)

    -- Push window back into tiling
    , ("M-t", withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    --, ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ("M-<Up>", sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    --, ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    , ("M-<Down>", sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ("M-S-q", io (exitWith ExitSuccess))

    -- Restart xmonad
    , ("M-q", spawn "xmonad --recompile; xmonad --restart")

    ]
  --  ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
   -- [((m .|. modm, k), windows $ f i)
   --     | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
   --     , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
   -- ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
  --  [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
  --      | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
  --      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings :: XConfig l
                   -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

myLayout = avoidStruts $ smartBorders $ (tiled ||| Mirror tiled ||| Full ||| simplestFloat)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   =  renamed [Replace "Tall"] 
           $ mySpacing 5
           $ ResizableTall 1 (3/100) (1/2) []
     
     floating = renamed [Replace "Float"]
           $ limitWindows 20 

-- Percent of screen to increment by when resizing panes
-- 'className' and 'resource' are used below.
--
myManageHook :: Query (Endo WindowSet)
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    ] <+> namedScratchpadManageHook myScratchPads

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook :: Event -> X All
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook :: X()
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X ()
myStartupHook = do
       setWMName "LG3D"
       spawnOnce "setxkbmap it"
       spawnOnce "source $HOME/.fehbg"  --"wal -R"
       spawnOnce "udiskie &"
       spawnOnce "picom"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
  home <- getHomeDirectory
  xmproc <- spawnPipe "xmobar"
  xmonad $ docks def

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
      {
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
      --  keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook <+> manageDocks,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    } `additionalKeysP` myKeys home
