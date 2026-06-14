-- Test Script for zaz UI Framework
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local zaz = require(ReplicatedStorage:WaitForChild("zaz"))

-- 1. Create Main Window Frame
local Window = zaz:CreateWindow({
    Name = "zaz universal // test window"
})

-- 2. Create Tabs
local MainTab = Window:CreateTab("Main")
local CombatTab = Window:CreateTab("Combat")
local ConfigsTab = Window:CreateTab("Settings")

-- =========================================================
-- MAIN TAB ELEMENTS
-- =========================================================
MainTab:CreateSection("Player Tweaks")

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 150},
    CurrentValue = 16,
    Increment = 1,
    Suffix = " studs/s",
    Callback = function(value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end
})

MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    CurrentValue = 50,
    Increment = 5,
    Suffix = " power",
    Callback = function(value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            local hum = character:FindFirstChildOfClass("Humanoid")
            hum.UseJumpPower = true
            hum.JumpPower = value
        end
    end
})

MainTab:CreateSection("Automation Actions")

MainTab:CreateToggle({
    Name = "Auto Run Engine Loop",
    CurrentValue = false,
    Callback = function(state)
        print("Auto Run state changed to:", state)
    end
})

MainTab:CreateButton({
    Name = "Force Reset Character Space",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid").Health = 0
        end
    end
})


-- =========================================================
-- COMBAT TAB ELEMENTS
-- =========================================================
CombatTab:CreateSection("Targeting Matrices")

CombatTab:CreateToggle({
    Name = "Enable Aim Assist Vector",
    CurrentValue = false,
    Callback = function(state)
        print("Aim Assist toggled to:", state)
    end
})

CombatTab:CreateDropdown({
    Name = "Target Component Field",
    Options = {"Head", "HumanoidRootPart", "Torso"},
    CurrentOption = {"Head"},
    Callback = function(selected)
        print("Selected target location priority:", selected[1])
    end
})


-- =========================================================
-- CONFIGS/SETTINGS TAB ELEMENTS
-- =========================================================
ConfigsTab:CreateSection("Theme Overlay Management")

ConfigsTab:CreateButton({
    Name = "Print Execution Status Log",
    Callback = function()
        print("zaz Core Frame successfully checked. Dimensions and memory configurations operating safely.")
    end
})

ConfigsTab:CreateDropdown({
    Name = "Select UI Style Profile",
    Options = {"Universal Slate Gray", "Dark Mode Glass", "Legacy Matrix"},
    CurrentOption = {"Universal Slate Gray"},
    Callback = function(selected)
        print("Theme profile selection updated:", selected[1])
    end
})
