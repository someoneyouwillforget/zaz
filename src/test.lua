--!strict
print("[zaz] Initializing remote loader script...")

local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/zaz/main/src/init.lua")
end)

if success and result then
    print("[zaz] Core framework ready.")
    
    local zaz = loadstring(result)()
    local uiInstance = zaz.new()
    
    -- Inject sample card configurations to render once the tray is opened
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
    
    -- Wait for splash screen to end (1.5s wait + 0.5s fade + 0.3s burst)
    task.wait(2.5)
    
    -- Force open the island programmatically so you can see the cards instantly
    if uiInstance.IsOpen == false then
        print("[zaz] Simulating click to display deck...")
        -- We trigger the click sequence logic manually for testing
        local island = uiInstance.Root:FindFirstChild("zaz_island", true) :: TextButton
        if island then
            -- Force a click simulation
            local connections = getconnections or nil
            if connections then
                for _, connection in ipairs(connections(island.MouseButton1Click)) do
                    connection:Fire()
                end
            else
                -- Fallback: call the open state toggle directly if getconnections isn't supported
                uiInstance.IsOpen = true
                local separator = uiInstance.Root:FindFirstChild("zaz_separator", true) :: Frame
                local arrow = uiInstance.Root:FindFirstChild("TextLabel", true) :: TextLabel -- Arrow element
                
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
