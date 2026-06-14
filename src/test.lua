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
    
    uiInstance:Start()
else
    warn("[zaz] Core fetch exception thrown: " .. tostring(result))
end
