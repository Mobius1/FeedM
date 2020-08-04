# FeedM
Customisable native feed notifications for FiveM

## Features
* Designed to emulate the native GTA:O feed system
* Can be positioned anywhere on screen unlike the native GTA:O notifications
* Customisable colors, fonts, etc
* Standard and advanced notifications
* Animated stacking and fading
* Supports reverse stacking for positioning at top of screen
* Supports message formatting
* Supports queuing and duplicate notifications

## Demo Videos

* [Standard](https://streamable.com/05s12l)
* [Bottom-Right Positioned](https://streamable.com/kxx4gq)
* [Top-Right Positioned](https://streamable.com/6b8rgs)
* [Queued](https://streamable.com/idwk31)
* [No animation](https://streamable.com/fx1zmd)
## Requirements

* None

## Download & Installation

* Download and extract the package: https://github.com/Mobius1/FeedM/archive/master.zip
* Rename the `FeedM-master` directory to `FeedM`
* Drop the `FeedM` directory into your `resources` directory on your server
* Add `start FeedM` in your `server.cfg`
* Edit `config.lua` to your liking
* Start your server and rejoice!

## Configuration

The `config.lua` file is set to emulate GTA:O as close as possible, but can be changed to fit your own needs.

```lua
Config.Enabled = true       -- Enable / disable
Config.Font = 4             -- Font family
Config.Scale = 0.38         -- Font size
Config.Width = 0.145        -- Box width
Config.Padding = 0.006      -- Box padding
Config.Spacing = 0.005      -- Box margin / seperation
Config.Queue = 5            -- Message queue
Config.Position = "left"    -- Position
Config.Animation = true     -- Toggle animation (fade out, stacking, etc)
```

## Events

#### Trigger notification from client
```lua
TriggerEvent("FeedM:showNotification", Message, Interval, Type)
```

#### Trigger notification from server
```lua
TriggerClientEvent("FeedM:showNotification", source, Message, Interval, Type)
```

#### Trigger advanced notification from client
```lua
TriggerEvent("FeedM:showAdvancedNotification", Title, Subject, Message, Icon, Interval, Type)
```

#### Trigger advanced notification from server
```lua
TriggerClientEvent("FeedM:showAdvancedNotification", source, Title, Subject, Message, Icon, Interval, Type)
```

Available params
* `Message` - the main message text you want to display
* `Interval` - The duration in `ms` you want the notification to be displayed
* `Type` - Determines the bg color of the message box (`primary`, `success`, `warning`, `danger`)
* `Title` - The title of the notification (advanced only)
* `Subject` - The subject of the notification (advanced only)
* `Icon` - The icon to be used (advanced only)

## Client Functions

#### Show notification
```lua
exports.FeedM:ShowNotification(Message, Interval, Type)
```

#### Show advanced notification
```lua
exports.FeedM:ShowNotification(Title, Subject, Message, Icon, Interval, Type)
```

## To Do
- [x] ~~Support queuing~~
- [x] ~~Support duplicate notifications~~
- [x] ~~Remove ESX dependency~~
- [ ] Allow saving to `Info > Notifications` tab
- [ ] Allow notification sound
- [x] ~~Allow top-bottom stacking~~
- [ ] Allow overflow of large messages into another notification box

## Contributing
Pull requests welcome.

## Legal

### License

FeedM - Customisable native feed notifications for FiveM

Copyright (C) 2020 Karl Saunders

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.