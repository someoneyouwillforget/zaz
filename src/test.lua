--!strict
-- Loadstring runner for the zaz framework

print("[zaz] Pulling interface module from production branch...")

local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/zaz/main/src/init.lua")
end)

if success and result then
    print("[zaz] Core engine downloaded successfully. Booting instance...")
    
    -- Compile raw script string into active Luau runtime
    local zaz = loadstring(result)()
    local uiInstance = zaz.new()
    
    -- Inject test configurations
    uiInstance.Cards = {
        {
            Title = "Default Deck",
            Elements = {}
        }
    }
    
    -- Start sequence
    uiInstance:Start()
else
    warn("[zaz] Critical initialization error: " .. tostring(result))
end
