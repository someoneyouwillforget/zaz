--!strict
print("[zaz] Launching async loader environment...")

local success, result = pcall(function()
    -- Dynamically stream the source raw file code directly
    -- NOTE: Update this URL to where you host your new card-based UI code
    return game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/zaz/main/src/init.lua")
end)

if success and result then
    print("[zaz] Core engine successfully streamed.")
    
    local zaz = loadstring(result)()
    
    -- Initialize the Deck system
    local UI = zaz.new()
    
    -- ==========================================
    -- CARD 1: GAME CONTROLS CARD
    -- ==========================================
    local gameControlsCard = UI:CreateCard({
        Name = "GameControls",
        Title = "🎮 Game Controls",
        Height = 100 -- Starting height, will auto-expand
    })
    
    -- Add a teleport button
    gameControlsCard:AddButton({
        Name = "Teleport to Center",
        Icon = "📍",
        Callback = function()
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local originalPos = player.Character.HumanoidRootPart.Position
                player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
                print("[zaz] Teleported to center! Original position: " .. tostring(originalPos))
                
                -- Visual feedback effect
                local effect = Instance.new("Part")
                effect.Shape = Enum.PartType.Ball
                effect.Size = Vector3.new(2, 2, 2)
                effect.Position = Vector3.new(0, 5, 0)
                effect.Anchored = true
                effect.CanCollide = false
                effect.Material = Enum.Material.Neon
                effect.Color = Color3.fromHex("#808080")
                effect.Parent = workspace
                game:GetService("Debris"):AddItem(effect, 1)
            else
                print("[zaz] Cannot teleport - character not loaded!")
            end
        end
    })
    
    -- Add kill button (for testing)
    gameControlsCard:AddButton({
        Name = "Kill Character",
        Icon = "💀",
        Callback = function()
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                    print("[zaz] Character eliminated!")
                end
            end
        end
    })
    
    -- Add respawn button
    gameControlsCard:AddButton({
        Name = "Respawn",
        Icon = "🔄",
        Callback = function()
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character then
                player.Character:BreakJoints()
                print("[zaz] Respawning...")
            end
        end
    })
    
    -- ==========================================
    -- CARD 2: AUTO FARM TOGGLE CARD
    -- ==========================================
    local farmCard = UI:CreateCard({
        Name = "AutoFarm",
        Title = "⚡ Auto Farm System",
        Height = 80
    })
    
    local autoFarmEnabled = false
    local farmLoop = nil
    
    farmCard:AddToggle({
        Name = "Enable Auto Farm",
        Icon = "🤖",
        CurrentValue = false,
        Callback = function(state)
            autoFarmEnabled = state
            
            if autoFarmEnabled then
                print("[zaz] Auto-farm ENABLED - Farming every 2 seconds")
                
                -- Start farming loop
                farmLoop = task.spawn(function()
                    while autoFarmEnabled do
                        task.wait(2)
                        if autoFarmEnabled then
                            print("[zaz] 🌾 Farming resources... (simulated)")
                            -- Add your actual farming logic here
                        end
                    end
                end)
            else
                print("[zaz] Auto-farm DISABLED")
                if farmLoop then
                    task.cancel(farmLoop)
                    farmLoop = nil
                end
            end
        end
    })
    
    farmCard:AddSlider({
        Name = "Farm Interval (seconds)",
        Range = {0.5, 10},
        CurrentValue = 2,
        Suffix = "s",
        Increment = 0.5,
        Callback = function(value)
            print("[zaz] Farm interval set to: " .. value .. " seconds")
            -- Note: You would need to restart the loop to apply new interval
        end
    })
    
    -- ==========================================
    -- CARD 3: VISUAL SETTINGS CARD
    -- ==========================================
    local visualCard = UI:CreateCard({
        Name = "VisualSettings",
        Title = "🎨 Visual Settings",
        Height = 80
    })
    
    visualCard:AddToggle({
        Name = "Show FPS Counter",
        Icon = "📊",
        CurrentValue = false,
        Callback = function(state)
            print("[zaz] FPS Counter: " .. (state and "ON" or "OFF"))
            -- You could implement an actual FPS counter here
        end
    })
    
    visualCard:AddToggle({
        Name = "Fullbright Mode",
        Icon = "☀️",
        CurrentValue = false,
        Callback = function(state)
            local lighting = game:GetService("Lighting")
            if state then
                lighting.Brightness = 2
                lighting.ClockTime = 14
                lighting.FogEnd = 100000
                print("[zaz] Fullbright ENABLED")
            else
                lighting.Brightness = 1
                lighting.ClockTime = 12
                lighting.FogEnd = 1000
                print("[zaz] Fullbright DISABLED")
            end
        end
    })
    
    visualCard:AddSlider({
        Name = "Camera Zoom Distance",
        Range = {1, 50},
        CurrentValue = 20,
        Suffix = " studs",
        Callback = function(value)
            local camera = workspace.CurrentCamera
            if camera then
                -- Note: This requires a camera script modification
                print("[zaz] Camera zoom set to: " .. value .. " studs")
            end
        end
    })
    
    -- ==========================================
    -- CARD 4: SERVER SELECTION CARD
    -- ==========================================
    local serverCard = UI:CreateCard({
        Name = "ServerSelect",
        Title = "🌍 Server Selection",
        Height = 80
    })
    
    serverCard:AddDropdown({
        Name = "Preferred Region",
        Options = {"Auto", "US West", "US East", "Europe", "Asia", "Australia"},
        CurrentOption = "Auto",
        Callback = function(option)
            print("[zaz] Server region set to: " .. option)
            -- Implement server teleport logic here
            if option ~= "Auto" then
                print("[zaz] Note: Server switching requires a rejoin or teleport")
            end
        end
    })
    
    -- ==========================================
    -- CARD 5: MISC TOOLS CARD
    -- ==========================================
    local toolsCard = UI:CreateCard({
        Name = "MiscTools",
        Title = "🛠️ Miscellaneous Tools",
        Height = 80
    })
    
    toolsCard:AddButton({
        Name = "Get Current Position",
        Icon = "📌",
        Callback = function()
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos = player.Character.HumanoidRootPart.Position
                print(string.format("[zaz] Current Position - X: %.2f, Y: %.2f, Z: %.2f", pos.X, pos.Y, pos.Z))
                
                -- Copy to clipboard if available
                if setclipboard then
                    setclipboard(string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z))
                    print("[zaz] Position copied to clipboard!")
                end
            end
        end
    })
    
    toolsCard:AddButton({
        Name = "List All Players",
        Icon = "👥",
        Callback = function()
            local players = game:GetService("Players"):GetPlayers()
            print("[zaz] Players in server (" .. #players .. "):")
            for i, player in ipairs(players) do
                print(string.format("  %d. %s", i, player.Name))
            end
        end
    })
    
    toolsCard:AddTextbox({
        Label = "Custom Command",
        Placeholder = "Enter command...",
        Callback = function(text)
            print("[zaz] Custom command executed: " .. text)
            -- Add your command parsing logic here
            if text:lower() == "help" then
                print("[zaz] Available commands: help, clear, pos")
            elseif text:lower() == "clear" then
                print("[zaz] Clearing console...")
                -- Clear console if possible
            end
        end
    })
    
    -- ==========================================
    -- CARD 6: INFORMATION CARD
    -- ==========================================
    local infoCard = UI:CreateCard({
        Name = "Information",
        Title = "ℹ️ System Information",
        Height = 80
    })
    
    infoCard:AddLabel({
        Text = "✨ zaz UI Framework - Card Deck Edition ✨",
        Color = "#808080",
        Size = 12
    })
    
    infoCard:AddSeparator()
    
    infoCard:AddLabel({
        Text = "Loaded: " .. os.date("%Y-%m-%d %H:%M:%S"),
        Color = "#666666",
        Size = 10
    })
    
    infoCard:AddButton({
        Name = "Clear All Cards",
        Icon = "🗑️",
        Callback = function()
            print("[zaz] Clearing all cards from deck...")
            UI:ClearDeck()
            print("[zaz] Deck cleared! You can now close and reopen the UI to reset.")
        end
    })
    
    -- ==========================================
    -- CARD 7: WALKSPEED/JUMPOWER CONTROLS
    -- ==========================================
    local movementCard = UI:CreateCard({
        Name = "Movement",
        Title = "🏃 Movement Modifiers",
        Height = 80
    })
    
    movementCard:AddSlider({
        Name = "Walkspeed",
        Range = {16, 250},
        CurrentValue = 16,
        Suffix = " speed",
        Increment = 1,
        Callback = function(value)
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = value
                print("[zaz] Walkspeed set to: " .. value)
            end
        end
    })
    
    movementCard:AddSlider({
        Name = "Jump Power",
        Range = {50, 200},
        CurrentValue = 50,
        Suffix = " power",
        Increment = 5,
        Callback = function(value)
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = value
                print("[zaz] Jump power set to: " .. value)
            end
        end
    })
    
    movementCard:AddButton({
        Name = "Reset Movement",
        Icon = "⟳",
        Callback = function()
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
                player.Character.Humanoid.JumpPower = 50
                print("[zaz] Movement values reset to default")
            end
        end
    })
    
    -- ==========================================
    -- SYSTEM STATUS MESSAGES
    -- ==========================================
    task.spawn(function()
        task.wait(1)
        print("[zaz] ✓ Card deck UI loaded successfully!")
        print("[zaz] ✓ Total cards created: 7")
        print("[zaz] ✓ UI is now ready for interaction")
        print("[zaz] 💡 Tip: Click the minimize button (🗕) to collapse to island mode")
        print("[zaz] 💡 Tip: Drag the island by its body, lock with 🔓/🔒 button")
    end)
    
else
    warn("[zaz] Load execution failure encountered: " .. tostring(result))
    warn("[zaz] Make sure the URL points to your card-based UI code")
end
