--!strict
print("[zaz] Loading custom system files...")

local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/zaz/main/src/init.lua")
end)

if success and result then
    print("[zaz] Connected. Booting engine configuration...")
    
    local zaz = loadstring(result)()
    local uiInstance = zaz.new()
    
    -- Generating concrete test cards to populate the deck framework
    uiInstance.Cards = {
        {
            Title = "Primary Module",
            Elements = {}
        },
        {
            Title = "Secondary Utilities",
            Elements = {}
        }
    }
    
    uiInstance:Start()
else
    warn("[zaz] Build execution failed: " .. tostring(result))
end
