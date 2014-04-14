import XMonad
import XMonad.Layout.Circle
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.Script
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

myStartupHook = do
	execScriptHook "startup"

myLayout = windowNavigation
		$ onWorkspace "3:pidgin" im
		$ subLayout [] subThirds
		$ onWorkspace "1:consoles" (thespiral ||| Full)
		$ tiled ||| Full ||| thespiral ||| Circle
	where
		-- one master window, half screen, and 3/100ths resize interval
		tiled = Tall 1 (3/100) (1/2)
		-- sublayout, one master at 2/3rds, unresizable
		subThirds = Tall 1 0 (1/3)
		-- spiral layout
		thespiral = spiralWithDir South CW (4/7)
		-- IM
		im = withIM (18/100) (Role "buddy_list") gridLayout
		gridLayout = spacing 8 Grid

myManageHook = composeAll
   [ className =? "google-chrome" --> doShift "3:chrome"
   , className =? "Pidgin" --> doShift "3:pidgin"
   ]

main = xmonad defaultConfig {
	startupHook = myStartupHook,
	logHook = fadeInactiveLogHook 0.7,
	terminal = "xfce4-terminal",
	manageHook = myManageHook <+> manageHook defaultConfig, -- uses default too
	borderWidth = 0,
	keys = keys defaultConfig `mappend`
        \c -> fromList [
                ((mod4Mask, xK_space), spawn "battery"),
                ((mod4Mask, xK_F5), spawn "sudo brightness down"),
                ((mod4Mask, xK_F6), spawn "sudo brightness up"),
                ((mod4Mask, xK_F7), spawn "volume 0"),
                ((mod4Mask, xK_F8), spawn "volume down"),
                ((mod4Mask, xK_F9), spawn "volume up"),
				((mod1Mask .|. controlMask, xK_h), sendMessage $ pullGroup L),
				((mod1Mask .|. controlMask, xK_l), sendMessage $ pullGroup R),
				((mod1Mask .|. controlMask, xK_k), sendMessage $ pullGroup U),
				((mod1Mask .|. controlMask, xK_j), sendMessage $ pullGroup D),
				((mod1Mask .|. controlMask, xK_m), withFocused (sendMessage . MergeAll)),
				((mod1Mask .|. controlMask, xK_u), withFocused (sendMessage . UnMerge)),
				((mod1Mask .|. controlMask, xK_period), focusUp),
				((mod1Mask .|. controlMask, xK_comma), focusDown)
				-- ((0, xK_Print), spawn "gnome-screenshot -i")
        ],
	layoutHook = myLayout
}


