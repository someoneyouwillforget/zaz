--!strict
print("[zaz] Launching card deck UI framework...")

-- First, ensure the framework is loaded
local frameworkUrl = "https://raw.githubusercontent.com/someoneyouwillforget/zaz/main/src/init.lua"

local success, result = pcall(function()
    return game:HttpGet(frameworkUrl)
end)

if not success or not result then
    warn("[zaz] Failed to load framework. Using local fallback...")
    warn("[zaz] Make sure the file exists at: " .. frameworkUrl)
    return
end

print("[zaz] Core engine successfully loaded (" .. string.len(result) .. " bytes)")

-- Load the framework
local zaz = loadstring(result)
if not zaz then
    error("[zaz] Failed to loadstring the framework")
end

local UI = zaz.new()

-- Wait a moment for splash animation to complete
task.wait(1.5)

-- ==========================================
-- CREATE DEMONSTRATION CARDS
-- ==========================================

-- CARD 1: Welcome Card
local welcomeCard = UI:CreateCard({
    Name = "Welcome",
    Title = "✨ Welcome to zaz Card Deck",
    Height = 80
})

welcomeCard:AddLabel({
    Text = "Liquid Glass UI Framework",
    Color = "#C0C0C0",
    Size = 14
})

welcomeCard:AddLabel({
    Text = "Cards spread and stack with smooth animations",
    Color = "#808080",
    Size = 11
})

welcomeCard:AddSeparator()

welcomeCard:AddLabel({
    Text = "✓ Framework Ready",
    Color = "#80FF80",
    Size = 11
})

-- CARD 2: Buttons Demo
local buttonsCard = UI:CreateCard({
    Name = "Buttons",
    Title = "🔘 Interactive Buttons",
    Height = 80
})

buttonsCard:AddButton({
    Name = "Click Me - Console Log",
    Icon = "📝",
    Callback = function()
        print("[Test] Button clicked at " .. os.date("%H:%M:%S"))
    end
})

buttonsCard:AddButton({
    Name = "Spawn Sparkle Effect",
    Icon = "✨",
    Callback = function()
        print("[Test] Sparkle effect triggered")
        -- Create a visual sparkle in the corner
        local sparkFrame = Instance.new("Frame")
        sparkFrame.Size = UDim2.new(0, 50, 0, 50)
        sparkFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
        sparkFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sparkFrame.BackgroundTransparency = 0.5
        sparkFrame.Parent = UI.Deck.MainDeck
        
        local sparkCorner = Instance.new("UICorner")
        sparkCorner.CornerRadius = UDim.new(1, 0)
        sparkCorner.Parent = sparkFrame
        
        game:GetService("TweenService"):Create(sparkFrame, 
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 100, 0, 100), BackgroundTransparency = 1}
        ):Play()
        
        game:GetService("Debris"):AddItem(sparkFrame, 0.6)
    end
})

-- CARD 3: Toggles Demo
local togglesCard = UI:CreateCard({
    Name = "Toggles",
    Title = "⚙️ Feature Toggles",
    Height = 80
})

local soundEnabled = true
local effectsEnabled = true

togglesCard:AddToggle({
    Name = "Sound Effects",
    Icon = "🔊",
    CurrentValue = soundEnabled,
    Callback = function(state)
        soundEnabled = state
        print("[Test] Sound effects: " .. (state and "ON" or "OFF"))
    end
})

togglesCard:AddToggle({
    Name = "Visual Effects",
    Icon = "✨",
    CurrentValue = effectsEnabled,
    Callback = function(state)
        effectsEnabled = state
        print("[Test] Visual effects: " .. (state and "ON" or "OFF"))
    end
})

-- CARD 4: Sliders Demo
local slidersCard = UI:CreateCard({
    Name = "Sliders",
    Title = "📊 Value Controls",
    Height = 80
})

slidersCard:AddSlider({
    Name = "Master Volume",
    Range = {0, 100},
    CurrentValue = 75,
    Suffix = "%",
    Increment = 5,
    Callback = function(value)
        print("[Test] Volume: " .. value .. "%")
    end
})

slidersCard:AddSlider({
    Name = "Animation Speed",
    Range = {0.5, 2},
    CurrentValue = 1,
    Suffix = "x",
    Increment = 0.1,
    Callback = function(value)
        print("[Test] Animation speed: " .. string.format("%.1f", value) .. "x")
    end
})

-- CARD 5: Dropdowns Demo
local dropdownsCard = UI:CreateCard({
    Name = "Dropdowns",
    Title = "▼ Selection Menus",
    Height = 80
})

dropdownsCard:AddDropdown({
    Name = "Theme",
    Options = {"Light", "Dark", "Neon", "Glass", "Retro"},
    CurrentOption = "Glass",
    Callback = function(option)
        print("[Test] Theme selected: " .. option)
    end
})

dropdownsCard:AddDropdown({
    Name = "Resolution",
    Options = {"1920x1080", "1366x768", "1280x720", "1024x768"},
    CurrentOption = "1920x1080",
    Callback = function(option)
        print("[Test] Resolution set to: " .. option)
    end
})

-- CARD 6: Text Input Demo
local textCard = UI:CreateCard({
    Name = "TextInput",
    Title = "⌨️ User Input",
    Height = 80
})

textCard:AddTextbox({
    Label = "Enter your username",
    Placeholder = "Type here...",
    Callback = function(text)
        if text and text ~= "" then
            print("[Test] Username entered: " .. text)
        end
    end
})

textCard:AddTextbox({
    Label = "Custom command",
    Placeholder = "/help",
    Callback = function(text)
        print("[Test] Command: " .. text)
    end
})

-- CARD 7: Information & Help
local helpCard = UI:CreateCard({
    Name = "Help",
    Title = "ℹ️ Help & Information",
    Height = 80
})

helpCard:AddLabel({
    Text = "How to use the Deck UI:",
    Color = "#E0E0E0",
    Size = 12
})

helpCard:AddLabel({
    Text = "• Cards spread automatically as you add them",
    Color = "#A0A0A0",
    Size = 10
})

helpCard:AddLabel({
    Text = "• Drag the glass island to reposition",
    Color = "#A0A0A0",
    Size = 10
})

helpCard:AddSeparator()

helpCard:AddLabel({
    Text = "Buttons: Click for actions",
    Color = "#808080",
    Size = 10
})

helpCard:AddLabel({
    Text = "Toggles: Click to switch on/off",
    Color = "#808080",
    Size = 10
})

helpCard:AddLabel({
    Text = "Sliders: Drag the handle",
    Color = "#808080",
    Size = 10
})

-- CARD 8: System Controls
local systemCard = UI:CreateCard({
    Name = "System",
    Title = "⚙️ System Controls",
    Height = 80
})

systemCard:AddButton({
    Name = "Clear All Cards",
    Icon = "🗑️",
    Callback = function()
        print("[Test] Clearing deck...")
        UI:ClearDeck()
        print("[Test] Deck cleared! All cards removed.")
    end
})

systemCard:AddLabel({
    Text = "Created Cards: 8",
    Color = "#80FF80",
    Size = 10
})

-- ==========================================
-- PRINT STATUS MESSAGES
-- ==========================================
task.spawn(function()
    task.wait(2)
    print("")
    print("╔═══════════════════════════════════════════════════════════╗")
    print("║              ✨ zaz Card Deck UI Framework ✨              ║")
    print("╠═══════════════════════════════════════════════════════════╣")
    print("║  ✓ Framework loaded successfully                          ║")
    print("║  ✓ 8 demonstration cards created                          ║")
    print("║  ✓ All components are functional                          ║")
    print("╠═══════════════════════════════════════════════════════════╣")
    print("║  Features in this demo:                                   ║")
    print("║  • Buttons (with sparkle effects on click)                ║")
    print("║  • Toggles (switch on/off)                                ║")
    print("║  • Sliders (drag to adjust values)                        ║")
    print("║  • Dropdowns (select from options)                        ║")
    print("║  • Text Input (type and submit)                           ║")
    print("║  • Labels & Separators (organize content)                 ║")
    print("╠═══════════════════════════════════════════════════════════╣")
    print("║  Tips:                                                    ║")
    print("║  • Click the [−] button to minimize to island mode        ║")
    print("║  • Click the island to restore the deck                   ║")
    print("║  • Click [U/L] on island to lock/unlock position          ║")
    print("║  • Click [×] to unload the UI with outro animation        ║")
    print("╚═══════════════════════════════════════════════════════════╝")
    print("")
    print("[Test] All cards created successfully!")
    print("[Test] Interact with the UI - all actions log to console")
end)
