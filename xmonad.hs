import XMonad
import XMonad.Layout.Circle
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.Script
import XMonad.Hooks.SetWMName
import XMonad.Layout.Spiral
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import Data.Map (fromList)
import Data.Monoid (mappend)
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout
import XMonad.Layout.BoringWindows
import XMonad.Layout.WindowNavigation
import XMonad.Layout.PerWorkspace
import XMonad.Actions.SpawnOn
import XMonad.Util.EZConfig

myStartupHook =
  (execScriptHook "startup") >>
  (setWMName "LG3D") -- Required for IntelliJ to work

myLayout = windowNavigation
    $ subLayout [] subThirds
    $ onWorkspace "1:terms" (thespiral ||| Full ||| gridLayout)
    $ tiled ||| Full ||| thespiral ||| Circle ||| gridLayout
  where
    -- one master window, half screen, and 3/100ths resize interval
    tiled = Tall 1 (3/100) (1/2)
    -- sublayout, one master at 2/3rds, unresizable
    subThirds = Tall 1 0 (1/3)
    -- spiral layout
    thespiral = spiralWithDir South CW (4/7)
    -- fancy spaced grid
    gridLayout = spacing 8 Grid

myManageHook = composeAll
   [ className =? "google-chrome" --> doShift "2:browsers"
   ]

main = xmonad $ defaultConfig {
  startupHook = myStartupHook,
  workspaces = ["1:terms", "2:browsers", "3:dev", "4", "5", "6", "7", "8", "9"],
  logHook = fadeInactiveLogHook 0.7,
  manageHook = myManageHook <+> manageHook defaultConfig, -- uses default too
  borderWidth = 0,
  -- modMask = mod4Mask,
  layoutHook = myLayout
} `additionalKeysP` specialKeys `additionalKeys` normalKeys
  where
    specialKeys =
      [ ("<XF86MonBrightnessUp>",   spawn "brightness up")
      , ("<XF86MonBrightnessDown>", spawn "brightness down")
      , ("<XF86AudioRaiseVolume>",  spawn "volume up")
      , ("<XF86AudioLowerVolume>",  spawn "volume down")
      , ("<XF86AudioMute>",         spawn "volume toggle") ]
    normalKeys =
      [ ((controlMask, xK_b), spawn "battery")
      , ((controlMask, xK_t), spawn "clock")
      -- , ((controlMask, xK_F1), spawn "/home/mike/bin/mikehelp")
      , ((mod1Mask .|. controlMask, xK_l), spawn "slock")
      , ((mod1Mask .|. controlMask, xK_h), sendMessage $ pullGroup L)
      -- , ((mod1Mask .|. controlMask, xK_l), sendMessage $ pullGroup R)
      , ((mod1Mask .|. controlMask, xK_k), sendMessage $ pullGroup U)
      , ((mod1Mask .|. controlMask, xK_j), sendMessage $ pullGroup D)
      , ((mod1Mask .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
      , ((mod1Mask .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
      , ((mod1Mask .|. controlMask, xK_period), focusUp)
      , ((mod1Mask .|. controlMask, xK_comma), focusDown)
      , ((0, xK_Print), spawn "gnome-screenshot -i")
      ]


{-
    keycode 232 (keysym 0x1008ff03, XF86MonBrightnessDown)
    keycode 233 (keysym 0x1008ff02, XF86MonBrightnessUp)
    keycode 237 (keysym 0x1008ff06, XF86KbdBrightnessDown)
    keycode 238 (keysym 0x1008ff05, XF86KbdBrightnessUp)
    keycode 173 (keysym 0x1008ff16, XF86AudioPrev)
    keycode 172 (keysym 0x1008ff14, XF86AudioPlay)
    keycode 171 (keysym 0x1008ff17, XF86AudioNext)
    keycode 121 (keysym 0x1008ff12, XF86AudioMute)
    keycode 122 (keysym 0x1008ff11, XF86AudioLowerVolume)
    keycode 123 (keysym 0x1008ff13, XF86AudioRaiseVolume)
-}
