--!strict
print("[zaz] Launching spread deck UI framework...")

local frameworkUrl = "https://raw.githubusercontent.com/someoneyouwillforget/zaz/main/src/init.lua"

local success, result = pcall(function()
    return game:HttpGet(frameworkUrl)
end)

if not success or not result then
    warn("[zaz] Failed to load framework: " .. tostring(result))
    return
end

print("[zaz] Framework loaded (" .. string.len(result) .. " bytes)")

local zaz = loadstring(result)
if not zaz then
    error("[zaz] Failed to loadstring")
end

local UI = zaz.new()
print("[zaz] UI created - liquid glass spread deck ready")

task.wait(2)

-- Card 1: Welcome
local welcomeCard = UI:CreateCard({
    Name = "Welcome",
    Title = "✨ Liquid Glass Spread Deck",
    Height = 100
})

welcomeCard:AddLabel({
    Text = "Cards fan out like a real deck!",
    Color = "#C0C0C0",
    Size = 13
})

welcomeCard:AddLabel({
    Text = "Drag the top bar or the island",
    Color = "#808080",
    Size = 11
})

welcomeCard:AddSeparator()

welcomeCard:AddLabel({
    Text = "✓ Framework Ready",
    Color = "#80FF80",
    Size = 11
})

-- Card 2: Buttons
local buttonsCard = UI:CreateCard({
    Name = "Buttons",
    Title = "🔘 Interactive Buttons",
    Height = 100
})

buttonsCard:AddButton({
    Name = "Click Me",
    Icon = "📝",
    Callback = function()
        print("[Test] Button clicked at " .. os.date("%H:%M:%S"))
    end
})

buttonsCard:AddButton({
    Name = "Test Sparkles",
    Icon = "✨",
    Callback = function()
        print("[Test] ✨ Sparkle effect triggered!")
    end
})

-- Card 3: Toggles
local togglesCard = UI:CreateCard({
    Name = "Toggles",
    Title = "⚙️ Feature Toggles",
    Height = 100
})

local soundEnabled = true

togglesCard:AddToggle({
    Name = "Sound Effects",
    Icon = "🔊",
    CurrentValue = soundEnabled,
    Callback = function(state)
        soundEnabled = state
        print("[Test] Sound: " .. (state and "ON" or "OFF"))
    end
})

-- Card 4: Sliders
local slidersCard = UI:CreateCard({
    Name = "Sliders",
    Title = "📊 Value Controls",
    Height = 110
})

slidersCard:AddSlider({
    Name = "Volume",
    Range = {0, 100},
    CurrentValue = 75,
    Suffix = "%",
    Increment = 5,
    Callback = function(value)
        print("[Test] Volume: " .. value .. "%")
    end
})

-- Card 5: Dropdowns
local dropdownsCard = UI:CreateCard({
    Name = "Dropdowns",
    Title = "▼ Selection Menus",
    Height = 100
})

dropdownsCard:AddDropdown({
    Name = "Theme",
    Options = {"Glass", "Dark", "Neon", "Light"},
    CurrentOption = "Glass",
    Callback = function(option)
        print("[Test] Theme: " .. option)
    end
})

-- Card 6: Text Input
local textCard = UI:CreateCard({
    Name = "TextInput",
    Title = "⌨️ User Input",
    Height = 100
})

textCard:AddTextbox({
    Label = "Enter your name",
    Placeholder = "Type here...",
    Callback = function(text)
        if text and text ~= "" then
            print("[Test] Name entered: " .. text)
        end
    end
})

-- Card 7: System
local systemCard = UI:CreateCard({
    Name = "System",
    Title = "⚙️ System Controls",
    Height = 100
})

systemCard:AddButton({
    Name = "Clear All Cards",
    Icon = "🗑️",
    Callback = function()
        print("[Test] Clearing deck...")
        UI:ClearDeck()
    end
})

systemCard:AddLabel({
    Text = "zaz Liquid Glass Framework",
    Color = "#808080",
    Size = 10
})

print("[Test] All 7 cards created - they should fan out!")
