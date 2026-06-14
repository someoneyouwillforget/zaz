--!strict
print("[zaz] Launching async loader environment...")

local success, result = pcall(function()
    -- Dynamically stream the source raw file code directly 
    return game:HttpGet("https://raw.githubusercontent.com/someoneyouwillforget/zaz/main/src/init.lua")
end)

if success and result then
    print("[zaz] Core engine successfully streamed.")
    
    local zaz = loadstring(result)()
    
    -- 1. Initialize the Window through CreateWindow matching the core API structure
    local Window = zaz:CreateWindow({
        Name = "zaz universal"
    })
    
    -- 2. Build custom tabs out safely for your structure 
    local PrimaryTab = Window:CreateTab("Controls")
    local SecondaryTab = Window:CreateTab("Config Panel")
    
    -- Example placeholder elements to populate the container spaces instantly
    PrimaryTab:CreateSection("Primary Engine Controls")
    SecondaryTab:CreateSection("Secondary Config Panel")
    
    -- 3. Asynchronous print sequence matching the 7-second splash runtime delay
    task.spawn(function()
        task.wait(7.0)
        print("[zaz] Splash animation complete. MainFrame and Island system fully operational.")
    end)
else
    warn("[zaz] Load execution failure encountered: " .. tostring(result))
end
