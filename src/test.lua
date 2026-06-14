--!strict
print("[zaz] Initializing remote loader script...")

local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/zaz/main/src/init.lua")
end)

if success and result then
    print("[zaz] Core framework ready.")
    
    local zaz = loadstring(result)()
    local uiInstance = zaz.new()
    
    -- Inject sample card configurations
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
    
    -- Start the intro sequence
    uiInstance:Start()
    
    -- Wait exactly 7 seconds for the splash sequence and explosion to complete
    task.wait(7.0)
    
    -- Force open the island programmatically to show the cards right away
    if uiInstance.IsOpen == false then
        print("[zaz] Displaying deck container...")
        local island = uiInstance.Root:FindFirstChild("zaz_island", true) :: TextButton
        if island then
            local connections = getconnections or nil
            if connections then
                for _, connection in ipairs(connections(island.MouseButton1Click)) do
                    connection:Fire()
                end
            else
                uiInstance.IsOpen = true
                local separator = uiInstance.Root:FindFirstChild("zaz_separator", true) :: Frame
                local arrow = uiInstance.Root:FindFirstChild("TextLabel", true) :: TextLabel
                
                if separator then separator.Visible = true end
                
                local TweenService = game:GetService("TweenService")
                TweenService:Create(uiInstance.DeckFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(260, 280)}):Play()
                if arrow then
                    TweenService:Create(arrow, TweenInfo.new(0.5), {Rotation = 180}):Play()
                end
            end
        end
    end
else
    warn("[zaz] Core fetch exception thrown: " .. tostring(result))
end
