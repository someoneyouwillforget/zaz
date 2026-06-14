--!strict
print("[zaz] Launching async loader environment...")

local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/zaz/main/src/init.lua")
end)

if success and result then
    print("[zaz] Core engine successfully streamed.")
    
    local zaz = loadstring(result)()
    local uiInstance = zaz.new()
    
    -- Structure sample cards data safely
    uiInstance.Cards = {
        {
            Title = "Primary Engine Controls",
            Elements = {}
        },
        {
            Title = "Secondary Config Panel",
            Elements = {}
        }
    }
    
    -- Fires off completely asynchronously
    uiInstance:Start()
    
    -- Explicitly run a standard task wait loop matching the new timing block
    task.spawn(function()
        task.wait(7.0)
        print("[zaz] Rendering card deck system container...")
        
        local separator = uiInstance.Root:FindFirstChild("zaz_separator", true) :: Frame
        local arrow = uiInstance.Root:FindFirstChild("zaz_arrow", true) :: TextLabel
        
        uiInstance.IsOpen = true
        if separator then separator.Visible = true end
        
        local TweenService = game:GetService("TweenService")
        if uiInstance.DeckFrame then
            TweenService:Create(uiInstance.DeckFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(260, 280)}):Play()
        end
        if arrow then
            TweenService:Create(arrow, TweenInfo.new(0.5), {Rotation = 180}):Play()
        end
    end)
else
    warn("[zaz] Load execution failure encountered: " .. tostring(result))
end
