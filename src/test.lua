--!strict
print("[zaz] Launching card deck UI framework...")

local success, result = pcall(function()
    -- Stream the zaz framework from main branch
    return game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/zaz/main/src/init.lua")
end)

if success and result then
    print("[zaz] Core engine successfully loaded.")
    
    local zaz = loadstring(result)()
    
    -- Initialize the Deck system
    local UI = zaz.new()
    
    -- ==========================================
    -- CARD 1: SHOWCASE - ALL COMPONENTS
    -- ==========================================
    local showcaseCard = UI:CreateCard({
        Name = "Components",
        Title = "🎨 Component Showcase",
        Height = 100
    })
    
    showcaseCard:AddLabel({
        Text = "zaz UI Framework - Full Component Demo",
        Color = "#E0E0E0",
        Size = 14
    })
    
    showcaseCard:AddSeparator()
    
    showcaseCard:AddLabel({
        Text = "This card demonstrates all available UI components",
        Color = "#A0A0A0",
        Size = 11
    })
    
    -- ==========================================
    -- CARD 2: BUTTONS & TOGGLES
    -- ==========================================
    local controlsCard = UI:CreateCard({
        Name = "Controls",
        Title = "🔘 Buttons & Toggles",
        Height = 80
    })
    
    controlsCard:AddButton({
        Name = "Test Button Action",
        Icon = "▶",
        Callback = function()
            print("[zaz] ✓ Button clicked! This is a basic action button.")
        end
    })
    
    controlsCard:AddButton({
        Name = "Another Test Button",
        Icon = "⚙",
        Callback = function()
            print("[zaz] ✓ Second button clicked! Buttons can perform any action.")
        end
    })
    
    local toggleState = false
    controlsCard:AddToggle({
        Name = "Enable Feature",
        Icon = "◻",
        CurrentValue = false,
        Callback = function(state)
            toggleState = state
            print("[zaz] Toggle state: " .. (state and "ON ✓" or "OFF ✗"))
        end
    })
    
    -- ==========================================
    -- CARD 3: SLIDERS
    -- ==========================================
    local sliderCard = UI:CreateCard({
        Name = "Sliders",
        Title = "📊 Sliders & Value Controls",
        Height = 80
    })
    
    sliderCard:AddSlider({
        Name = "Volume Level",
        Range = {0, 100},
        CurrentValue = 50,
        Suffix = "%",
        Increment = 5,
        Callback = function(value)
            print("[zaz] Volume set to: " .. value .. "%")
        end
    })
    
    sliderCard:AddSlider({
        Name = "Opacity",
        Range = {0.1, 1},
        CurrentValue = 0.8,
        Suffix = "",
        Increment = 0.1,
        Callback = function(value)
            print("[zaz] Opacity: " .. string.format("%.1f", value))
        end
    })
    
    -- ==========================================
    -- CARD 4: DROPDOWNS
    -- ==========================================
    local dropdownCard = UI:CreateCard({
        Name = "Dropdowns",
        Title = "▼ Dropdown Menus",
        Height = 80
    })
    
    dropdownCard:AddDropdown({
        Name = "Theme Selection",
        Options = {"Light", "Dark", "Neon", "Glass", "Retro"},
        CurrentOption = "Glass",
        Callback = function(option)
            print("[zaz] Theme changed to: " .. option)
        end
    })
    
    dropdownCard:AddDropdown({
        Name = "Quality Settings",
        Options = {"Low", "Medium", "High", "Ultra"},
        CurrentOption = "High",
        Callback = function(option)
            print("[zaz] Quality set to: " .. option)
        end
    })
    
    -- ==========================================
    -- CARD 5: TEXTBOX INPUT
    -- ==========================================
    local textCard = UI:CreateCard({
        Name = "TextInput",
        Title = "⌨️ Text Input & Labels",
        Height = 80
    })
    
    textCard:AddTextbox({
        Label = "Enter Your Name",
        Placeholder = "Type something...",
        Callback = function(text)
            print("[zaz] User entered: " .. text)
        end
    })
    
    textCard:AddLabel({
        Text = "Labels are great for displaying info or status",
        Color = "#C0C0C0",
        Size = 11
    })
    
    -- ==========================================
    -- CARD 6: SEPARATORS & LABELS
    -- ==========================================
    local infoCard = UI:CreateCard({
        Name = "Info",
        Title = "ℹ️ Information & Organization",
        Height = 80
    })
    
    infoCard:AddLabel({
        Text = "Section 1: Status Information",
        Color = "#E0E0E0",
        Size = 13
    })
    
    infoCard:AddLabel({
        Text = "✓ UI Framework Loaded",
        Color = "#80FF80",
        Size = 11
    })
    
    infoCard:AddSeparator()
    
    infoCard:AddLabel({
        Text = "Section 2: Additional Details",
        Color = "#E0E0E0",
        Size = 13
    })
    
    infoCard:AddLabel({
        Text = "Use separators to organize content logically",
        Color = "#A0A0A0",
        Size = 10
    })
    
    -- ==========================================
    -- CARD 7: REAL-WORLD EXAMPLE
    -- ==========================================
    local exampleCard = UI:CreateCard({
        Name = "Example",
        Title = "🚀 Practical Example",
        Height = 80
    })
    
    local fpsCounter = false
    exampleCard:AddToggle({
        Name = "FPS Display",
        Icon = "📈",
        CurrentValue = false,
        Callback = function(state)
            fpsCounter = state
            if state then
                print("[zaz] FPS counter enabled")
            else
                print("[zaz] FPS counter disabled")
            end
        end
    })
    
    exampleCard:AddSlider({
        Name = "Update Rate",
        Range = {10, 60},
        CurrentValue = 30,
        Suffix = " Hz",
        Increment = 5,
        Callback = function(value)
            print("[zaz] Update rate set to: " .. value .. " Hz")
        end
    })
    
    exampleCard:AddButton({
        Name = "Apply Settings",
        Icon = "✓",
        Callback = function()
            if fpsCounter then
                print("[zaz] ✓ Settings applied: FPS Display enabled")
            else
                print("[zaz] ✓ Settings applied")
            end
        end
    })
    
    -- ==========================================
    -- CARD 8: SYSTEM INFO
    -- ==========================================
    local systemCard = UI:CreateCard({
        Name = "System",
        Title = "⚡ Framework Info",
        Height = 80
    })
    
    systemCard:AddLabel({
        Text = "zaz Card Deck Framework",
        Color = "#808080",
        Size = 14
    })
    
    systemCard:AddLabel({
        Text = "Liquid Glass UI with Spread Deck Layout",
        Color = "#A0A0A0",
        Size = 11
    })
    
    systemCard:AddSeparator()
    
    systemCard:AddLabel({
        Text = "Status: ✓ Ready",
        Color = "#80FF80",
        Size = 11
    })
    
    systemCard:AddButton({
        Name = "Clear All Cards",
        Icon = "🗑️",
        Callback = function()
            print("[zaz] Clearing deck...")
            UI:ClearDeck()
        end
    })
    
    -- ==========================================
    -- STARTUP MESSAGES
    -- ==========================================
    task.spawn(function()
        task.wait(1)
        print("")
        print("╔═══════════════════════════════════════════╗")
        print("║        zaz Card Deck UI Framework         ║")
        print("╠═══════════════════════════════════════════╣")
        print("║ ✓ Framework loaded successfully           ║")
        print("║ ✓ 8 example cards created                 ║")
        print("║ ✓ All components showcased                ║")
        print("╠═══════════════════════════════════════════╣")
        print("║ Features:                                 ║")
        print("║  • Buttons with callbacks                 ║")
        print("║  • Toggle switches                        ║")
        print("║  • Sliders with ranges                    ║")
        print("║  • Dropdown menus                         ║")
        print("║  • Text input boxes                       ║")
        print("║  • Labels & separators                    ║")
        print("║  • Liquid glass effect                    ║")
        print("║  • Spread deck animation                  ║")
        print("╠═══════════════════════════════════════════╣")
        print("║ Tips:                                     ║")
        print("║  • Drag the island to move the deck       ║")
        print("║  • Click U/L button to lock/unlock        ║")
        print("║  • Click − to minimize to island          ║")
        print("║  • Click × to unload with outro           ║")
        print("╚═══════════════════════════════════════════╝")
        print("")
    end)
    
else
    warn("[zaz] Failed to load framework: " .. tostring(result))
end
