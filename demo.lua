TriggerEvent('chat:addSuggestion', '/FShowNotification', 'Shows a standard notification', {
    { name="message", help="The message" },
    { name="timeout", help="Timeout in ms" },
    { name="position", help="Position to show notification" },
    { name="progress", help="Show the progress bar" },
    { name="theme", help="The theme to use" }
}) 

TriggerEvent('chat:addSuggestion', '/FShowAdvancedNotification', 'Shows an advanced notification', {
    { name="message", help="The message" },
    { name="title", help="The title" },
    { name="subject", help="The subject" },
    { name="timeout", help="Timeout in ms" },
    { name="position", help="Position to show notification" },
    { name="progress", help="Show the progress bar" }
}) 

RegisterCommand('FShowNotification', function(source, args)
    local message   = args[1]
    local timeout   = args[2] or Config.Timeout
    local position  = args[3] or Config.Position
    local progress  = args[4] or Config.Progress
    local theme     = args[5]

    ShowNotification(message, timeout, position, progress, theme)
end)

RegisterCommand('FShowAdvancedNotification', function(source, args)

    local message   = args[1]
    local title     = args[2] or "This is a title"
    local subject   = args[3] or "This is a subject"
    local timeout   = args[4] or Config.Timeout
    local position  = args[5] or Config.Position
    local progress  = args[6] or Config.Progress
    local icon, _   = selectRandomAssociative(Config.Pictures)
    
    ShowAdvancedNotification(message, title, subject, icon, timeout, position, progress)    
end)


RegisterCommand('FShowNotificationThemes', function(source, args)

    math.randomseed(GetGameTimer())

    Citizen.CreateThread(function()
        local themes = { "default", "success", "danger" }

        for _, theme in ipairs(themes) do
            ShowNotification(theme, 5000, "bottomleft", false, theme)
            Citizen.Wait(500)
        end
    end)

end)

RegisterCommand('FShowNotificationFlood', function(source, args)
    math.randomseed(GetGameTimer())

    Citizen.CreateThread(function()
        for i = 1, 5 do
            CommandNotification("bottomleft")
            Citizen.Wait(250)
            CommandNotification("bottomright")
            Citizen.Wait(250)
            CommandNotification("topleft")
            Citizen.Wait(250)
            CommandNotification("topright")
            Citizen.Wait(250)
            CommandNotification("top")
            Citizen.Wait(250)
            CommandNotification("bottom")
            Citizen.Wait(250)
        end
    end)
end)

RegisterCommand('FShowNotificationQueued', function(source, args)
    math.randomseed(GetGameTimer())

    Citizen.CreateThread(function()
        for i = 1, 15 do
            CommandNotification("bottomleft", "normal")
            Citizen.Wait(250)
        end
    end)
end)

RegisterCommand('FShowUneven', function(source, args)
    math.randomseed(GetGameTimer())

    Citizen.CreateThread(function()
        for i = 1, 6 do
            local timeout = math.random(1000, 10000)
            ShowNotification("Random Timeout: ~b~" .. timeout, timeout, "bottomleft", true)
            -- Citizen.Wait(25)
        end
    end)
end)



function CommandNotification(position, type)
    math.randomseed(GetGameTimer())

    local types     = { "normal", "advanced" }
    local positions = { "bottomleft", "bottomright", "topleft", "topright", "top", "bottom" }
    local title     = "This is the ~g~title"
    local subject   = "This is the ~r~subject"
    local message   = "~b~Lorem ~w~ipsum dolor sit amet, consectetur ~g~adipiscing elit, ~r~sed do eiusmod ~w~tempor inci."
    local timeout   = Config.Timeout

    if position == nil then
        position = selectRandom(positions)
    end
    
    if type == nil then
        type = selectRandom(types)
    end    
    
    if type == "normal" then
        ShowNotification(message, timeout, position, true)
    else
        local key, value = selectRandomAssociative(Config.Pictures)
        ShowAdvancedNotification(message, title, subject, key, timeout, position, true)
    end     
end

function selectRandom(arr)
    return arr[ math.random( #arr ) ]
end

function selectRandomAssociative(arr)
    -- Insert the keys of the table into an array
    local keys = {}

    for key, _ in pairs(arr) do
        table.insert(keys, key)
    end

    -- Get the amount of possible values
    local max = #keys
    local number = math.random(1, max)
    local selectedKey = keys[number]

    -- Return the value
    return selectedKey, arr[selectedKey]
end