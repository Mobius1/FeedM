Messages    = {}
WaitTime    = 500
Counter     = 1
Queue       = 0
Queued      = {}
Top         = string.match(Config.Position, "top")

------------------------------------------------------------
--                        THREADS                         --
------------------------------------------------------------

function InitThreads()

    Citizen.CreateThread(function()
        while true do

            DrawRect(
                Config.Positions[Config.Position].x, 
                Config.Positions[Config.Position].y, 
                Config.Width, 
                1 / 1080,
                255,
                255,
                255,
                255
            )

            Citizen.Wait(0)
        end
    end)

    -- MAIN RENDER THREAD
    Citizen.CreateThread(function()
        while true do

            local PosX = Config.Positions[Config.Position].x - (Config.Width / 2)
            local PosY = 0
            local X1 = PosX + Config.Padding
            local X2 = (Config.Positions[Config.Position].x + (Config.Width / 2)) - Config.Padding

            for i,Message in ipairs(Messages) do
                if not Message.Hidden then
                    -- START FADE OUT AFTER INTERVAL
                    if not Message.Ready then
                        Message.Ready = true
                        Citizen.SetTimeout(Message.Interval, function()
                            Message.StartHiding = true
                        end)
                    end

                    -- FADE OUT
                    if Message.StartHiding then
                        Message.Opacity.Box.Current = math.ceil(Message.Opacity.Box.Current - Message.Opacity.Box.Increment)
                        Message.Opacity.Text.Current = math.ceil(Message.Opacity.Text.Current - Message.Opacity.Text.Increment)

                        if Message.Opacity.Box.Current <= 0 or Message.Opacity.Text.Current <= 0 then
                            Message.Opacity.Box.Current = 0
                            Message.Opacity.Text.Current = 0

                            Message.Hidden = true
                        end                                
                    end

                    Message.Offset = Message.y + PosY

                    if Top then
                        if Message.ny <= Message.Offset then
                            Message.ny = Message.ny + 0.008
                        end

                        if Message.ny > Message.Offset then
                            Message.ny = Message.Offset
                        end
                    else
                        if Message.ny >= Message.Offset then
                            Message.ny = Message.ny - 0.008
                        end
    
                        if Message.ny < Message.Offset then
                            Message.ny = Message.Offset
                        end
                    end                    
  
                    if Message.Advanced then -- ADVANCED NOTIFICATION   
                        -- DRAW BOX
                        DrawSprite(
                            'commonmenu',
                            'gradient_bgd',
                            Config.Positions[Config.Position].x, 
                            Message.ny, 
                            Config.Width, 
                            Message.BoxHeight,
                            -90.0,
                            Message.BG.r, 
                            Message.BG.g, 
                            Message.BG.b,
                            Message.Opacity.Box.Current
                        )                        
                        
                        if Message.Icon.Ready then               
                            -- DRAW ICON
                            DrawSprite(
                                Message.Icon.Thumb,
                                Message.Icon.Thumb,
                                PosX + (Message.Icon.W / 2), 
                                Message.ny - (Message.BoxHeight / 2) + (Message.Icon.H / 2), 
                                Message.Icon.W, 
                                Message.Icon.H, 
                                0.0, 255, 255, 255, Message.Opacity.Box.Current
                            )
                        end                       
                            
                        -- DRAW TITLE
                        RenderText(Message.Title,
                            (Config.Padding + Config.Positions[Config.Position].x - (Config.Width / 2)) + Message.Icon.W,
                            (Message.ny - (Message.BoxHeight / 2) + Config.Padding) - 0.004,
                            Message.Opacity.Text.Current, 
                            X1 + Message.Icon.W, 
                            X2
                        )   

                        -- DRAW SUBJECT
                        RenderText(Message.Subject,
                            (Config.Padding + Config.Positions[Config.Position].x - (Config.Width / 2)) + Message.Icon.W,
                            ((Message.ny - (Message.BoxHeight / 2) + Config.Padding) - 0.004) + TextHeight,
                            Message.Opacity.Text.Current, 
                            X1 + Message.Icon.W, 
                            X2
                        )                       

                        -- DRAW MESSAGE
                        RenderText(Message.text,
                            Config.Padding + Config.Positions[Config.Position].x - (Config.Width / 2),
                            (Message.ny - (Message.BoxHeight / 2)) + Message.Icon.H + Config.Padding,
                            Message.Opacity.Text.Current, 
                            X1, 
                            X2
                        )    

                        -- INCREMENT POSITION BY MESSAGE HEIGHT
                        if Top then
                            PosY = PosY + Message.BoxHeight + Config.Spacing
                        else
                            PosY = PosY - Message.BoxHeight - Config.Spacing
                        end

                    else  -- STANDARD NOTIFICATION
                        
                        -- DRAW BOX
                        DrawSprite(
                            'commonmenu',
                            'gradient_bgd',
                            Config.Positions[Config.Position].x, 
                            Message.ny, 
                            Config.Width, 
                            Message.Height,
                            -90.0, 
                            Message.BG.r, 
                            Message.BG.g, 
                            Message.BG.b, 
                            Message.Opacity.Box.Current
                        )                         

                        -- DRAW MESSAGE
                        RenderText(Message.text,
                            Config.Padding + Config.Positions[Config.Position].x - (Config.Width / 2),
                            ((Message.ny - (Message.Height / 2)) + Config.Padding) - 0.004,
                            Message.Opacity.Text.Current, 
                            X1, 
                            X2
                        )
                        
                        -- INCREMENT POSITION BY MESSAGE HEIGHT
                        if Top then
                            PosY = PosY + Message.Height + Config.Spacing
                        else
                            PosY = PosY - Message.Height - Config.Spacing
                        end
                    end

                    -- FLAG MESSAGE FOR REMOVAL
                    if Message.Hidden then
                        Citizen.SetTimeout(2000, function()
                            Message.Remove = true
                        end)
                    end                

                end
            end

            Citizen.Wait(WaitTime)
        end
    end)

    -- CLEAN-UP THREAD
    Citizen.CreateThread(function()
        while true do
            for i,Message in ipairs(Messages) do
                if Message.Hidden and Message.Remove then
                    Queue = Queue - 1
                    table.remove(Messages, i)
                end
            end

            -- INCREASE WAIT TIME IF NO MESSAGES ARE ACTIVE
            if #Messages > 0 then
                WaitTime = 0
            else
                WaitTime = 500
            end

            Citizen.Wait(WaitTime)
        end
    end)

    -- QUEUE THREAD
    Citizen.CreateThread(function()
        while true do
            for i,Message in ipairs(Queued) do
                if Queue < Config.Queue then
                    if Message.Advanced then
                        BuildMessage(Message.Message, Message.Interval, Message.Type, true, Message.Title, Message.Subject, Message.Icon)
                    else
                        BuildMessage(Message.Message, Message.Interval, Message.Type)
                    end

                    table.remove(Queued, i)
                end
            end

            -- INCREASE WAIT TIME IF NO MESSAGES ARE ACTIVE
            Citizen.Wait(WaitTime)
        end
    end)    
end

if Config.Enabled then
    InitThreads()
end

------------------------------------------------------------
--                       FUNCTIONS                        --
------------------------------------------------------------

function BuildMessage(Text, Interval, Type, Advanced, Title, Subject, Icon)

    WaitTime = 0

    Interval = Interval or 5000


    if Text == nil then
        Text = '~r~ERROR : ~s~The text of the notification is nil.'
    end

    local BG = Config.Types.primary

    if Type ~= nil then
        BG = Config.Types[Type]

        if BG == nil then
            print("======================================================")
            print("FeedM ERROR: Invalid notification type (".. Type ..")!")
            print("======================================================")
            return
        end
    end

    -- ADD MESSAGE TO RENDER THREAD
    -- if Config.Queue > 0 then
        -- QUEUED
        -- Citizen.CreateThread(function()
        --     while Queue > Config.Queue - 1 do
        --         Citizen.Wait(0)
        --     end
        --     AddMessage(Text, Interval, BG, Advanced, Title, Subject, Icon)      
        -- end)
    -- else
        -- NON-QUEUED
        AddMessage(Text, Interval, BG, Advanced, Title, Subject, Icon) 
    -- end
end

function QueueMessage(Message, Interval, Type)
    local Data = {
        Message = Message, Interval = Interval, Type = Type
    }

    table.insert(Queued, Data)
end

function QueueAdvancedMessage(Title, Subject, Message, Icon, Interval, Type)
    local Data = {
        Title = Title, Subject = Subject, Icon = Icon, Message = Message, Interval = Interval, Type = Type, Advanced = true
    }

    table.insert(Queued, Data)
end

function AddMessage(Message, Interval, BG, Advanced, Title, Subject, Icon)

    local Data = {
        Advanced = Advanced,
        Title = Title,
        Subject = Subject,
        Icon = {
            Thumb = Icon,
            Ready = false,
            W = 0,
            H = 0
        },
        Index = Counter,
        text = Message,
        Interval = Interval,
        BG = BG,
        Hiding = false,
        y = Config.Positions[Config.Position].y,
        ny = Config.Positions[Config.Position].y,
        Opacity = {
            Text = { Current = 255, Increment = 255 / 20},
            Box = { Current = BG.a, Increment = BG.a / 20},
        }
    }

    -- GET MESSAGE HEIGHT
    Data.Height = GetMessageHeight(Data, Config.Padding + Config.Positions[Config.Position].x - (Config.Width / 2), Config.Positions[Config.Position].y)   

    -- ADVANCED NOTIFICATION ICON
    if Advanced then
        local width, height = GetActiveScreenResolution()
        local size = 0.028
        Data.Icon.W = (size * width) / width
        Data.Icon.H = (size * width) / height 
        
        Data.BoxHeight = Data.Icon.H + Data.Height + Config.Padding

        -- LOAD ICON
        if not HasStreamedTextureDictLoaded(Icon) then
            RequestStreamedTextureDict(Icon)

            while not HasStreamedTextureDictLoaded(Icon) do
                Citizen.Wait(1)
            end
        end

        Data.Icon.Ready = true

        if Top then
            Data.y = Data.y + (Data.BoxHeight / 2)
            Data.ny = Data.ny + (Data.BoxHeight / 2)
        else
            Data.y = Data.y - (Data.BoxHeight / 2)
            Data.ny = Data.ny - (Data.BoxHeight / 2)
        end 
    else
        if Top then
            Data.y = Data.y + (Data.Height / 2)
            Data.ny = Data.ny + (Data.Height / 2)
        else
            Data.y = Data.y - (Data.Height / 2)
            Data.ny = Data.ny - (Data.Height / 2)
        end      
    end


    -- ENABLE MESSAGE DISPLAY
    table.insert(Messages, 1, Data)

    Queue = Queue + 1    
    Counter = Counter + 1    

    -- Need to find the correct feed message sound to play here
    -- PlaySoundFrontend(-1, "FestiveGift", "Feed_Message_Sounds", 0)
end

function ShowNotification(Message, Interval, Type)
    if Config.Enabled then

        if Config.Queue > 0 and Queue > Config.Queue - 1 then
            QueueMessage(Message, Interval, Type)
        else
            BuildMessage(Message, Interval, Type)
        end
    end
end

function ShowAdvancedNotification(Title, Subject, Message, Icon, Interval, Type)
    if Config.Enabled then
        if not Icon then
            Icon = 'CHAR_BLANK_ENTRY'
        end
        if Config.Queue > 0 and Queue > Config.Queue - 1 then
            QueueAdvancedMessage(Title, Subject, Message, Icon, Interval, Type)
        else
            BuildMessage(Message, Interval, Type, true, Title, Subject, Icon)
        end        
    end
end


------------------------------------------------------------
--                        EXPORTS                         --
------------------------------------------------------------

exports('ShowNotification', ShowNotification)
exports('ShowAdvancedNotification', ShowAdvancedNotification)


------------------------------------------------------------
--                         EVENTS                         --
------------------------------------------------------------

RegisterNetEvent('feedM:showNotification')
AddEventHandler("feedM:showNotification", function(Message, Interval, Type)
    ShowNotification(Message, Interval, Type)
end)

RegisterNetEvent('feedM:showAdvancedNotification')
AddEventHandler("feedM:showAdvancedNotification", function(Title, Subject, Message, Icon, Interval, Type)
    ShowAdvancedNotification(Title, Subject, Message, Icon, Interval, Type)
end)