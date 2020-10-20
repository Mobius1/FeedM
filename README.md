# FeedM
Customisable native feed notifications for FiveM 

## v2.0.0-alpha

This version uses the NUI instead of using in-game rendering to increase performance. Built from the ground-up for FiveM and uses no external libraries.

## Usage
Show Notification
```lua
TriggerEvent("FeedM2:ShowNotification", message, timeout, position, progress)
```

Show Advanced Notification
```lua
TriggerEvent("FeedM2:ShowAdvancedNotification", message, title, subject, icon, timeout, position, progress)
```

## Advanced Notification Icons
The notification picture codes are the same as the native ones: https://wiki.rage.mp/index.php?title=Notification_Pictures

To add your own, upload a `64x64` image to the `ui/images` directory and add the custom code and filename to the `Config.Pictures` table in `config.lua`,

#### Example

Upload `my_custom_icon_image.jpg` to the `ui/images` directory and use `MY_CUSTOM_ICON_CODE` as the key.

```lua
Config.Pictures = {
    ...
    MY_CUSTOM_ICON_CODE = "my_custom_icon_image.jpg" -- Add this
}
```

Then use the custom code in the notification call:

```lua
TriggerEvent("FeedM2:ShowAdvancedNotification", "Message", "Title", "Subject", "MY_CUSTOM_ICON_CODE")
```

## Formatting
FeedM `v2.0.0-alpha` supports the following standard formatting variables:

```lua
~r~ = Red
~b~ = Blue
~g~ = Green
~y~ = Yellow
~p~ = Purple
~o~ = Orange
~u~ = Black
~s~ / ~w~ = White
~h~ = Bold Text
```
