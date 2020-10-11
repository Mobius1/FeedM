function ShowNotification(message, timeout, position, progress)

    if message == nil then
        return PrintError("^1FEEDM2 ERROR: ^7Notification message is nil")
    end

    if not tonumber(timeout) then
        timeout = Config.Timeout
    end
    
    if position == nil then
        position = Config.Position
    end
    
    if progress == nil then
        progress = false
    end  

    AddNotification({
        type        = "standard",
        message     = message,
        timeout     = timeout,
        position    = position,
        progress    = progress
    })
end

function ShowAdvancedNotification(message, title, subject, icon, timeout, position, progress)

    if message == nil then
        return PrintError("^1FEEDM2 ERROR: ^7Notification message is nil")
    end

    if title == nil then
        return PrintError("^1FEEDM2 ERROR: ^7Notification title is nil")
    end
    
    if subject == nil then
        return PrintError("^1FEEDM2 ERROR: ^7Notification subject is nil")
    end    

    if not tonumber(timeout) then
        timeout = Config.Timeout
    end
    
    if position == nil then
        position = Config.Position
    end
    
    if progress == nil then
        progress = false
    end  

    AddNotification({
        type        = "advanced",
        message     = message,
        title       = title,
        subject     = subject,
        icon        = Config.Pictures[icon],
        timeout     = timeout,
        position    = position,
        progress    = progress
    })
end

function AddNotification(data)
    data.config = Config;
    SendNUIMessage(data)
end

function PrintError(message)
    local s = string.rep("=", string.len(message))
    print(s)
    print(message)
    print(s)  
end

AddEventHandler("FeedM2:ShowNotification", ShowNotification)
AddEventHandler("FeedM2:ShowAdvancedNotification", ShowAdvancedNotification)