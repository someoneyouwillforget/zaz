--!strict
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local zaz = {}
zaz.__index = zaz

export type Card = {
    Title: string,
    Elements: {any},
    Frame: Frame?
}

function zaz.new()
    local self = setmetatable({}, zaz)
    
    local screen = Instance.new("ScreenGui")
    screen.Name = "zaz_framework"
    screen.ResetOnSpawn = false
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local success = pcall(function() screen.Parent = game:GetService("CoreGui") end)
    if not success then
        screen.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    self.Root = screen
    self.Cards = {} :: {Card}
    self.CurrentCardIndex = 1
    self.IslandLocked = false
    self.IsOpen = false
    
    return self
end

function zaz:Start()
    local splashLabel = Instance.new("TextLabel")
    splashLabel.Size = UDim2.fromScale(1, 1)
    splashLabel.BackgroundTransparency = 1
    splashLabel.Text = "zaz"
    splashLabel.Font = Enum.Font.FredokaOne
    splashLabel.TextColor3 = Color3.fromHex("#808080")
    splashLabel.TextSize = 44
    splashLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    splashLabel.Position = UDim2.fromScale(0.5, 0.5)
    splashLabel.Parent = self.Root

    -- Initial setup wait
    task.wait(1.5)
    
    -- Robust programmatic Heartbeat using direct numerical interpolation to avoid Tween yield freezes
    task.spawn(function()
        local startTime = os.clock()
        local totalDuration = 4.5
        
        while os.clock() - startTime < totalDuration do
            local elapsed = os.clock() - startTime
            -- Generates a clean, looping sine wave pulse pattern over time
            local wave = math.sin(elapsed * math.pi * 1.8) 
            splashLabel.TextSize = 44 + (wave * 8)
            RunService.RenderStepped:Wait()
        end
        
        -- Trigger final blast sizing immediately
        splashLabel.TextSize = 75
        local fadeTween = TweenService:Create(splashLabel, TweenInfo.new(0.5, Enum.EasingStyle.QuadOut), {TextTransparency = 1})
        fadeTween:Play()
        
        -- Non-blocking Sparkle Burst Generation
        for i = 1, 15 do
            task.spawn(function()
                local sparkle = Instance.new("Frame")
                sparkle.Size = UDim2.fromOffset(math.random(4, 8), math.random(4, 8))
                sparkle.BackgroundColor3 = Color3.fromHex("#808080")
                sparkle.Position = UDim2.fromScale(0.5, 0.5)
                sparkle.AnchorPoint = Vector2.new(0.5, 0.5)
                sparkle.Parent = self.Root
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = sparkle

                local angle = math.rad(math.random(0, 360))
                local distance = math.random(50, 150)
                local targetX = 0.5 + (math.cos(angle) * (distance / math.clamp(self.Root.AbsoluteSize.X, 1, 9999)))
                local targetY = 0.5 + (math.sin(angle) * (distance / math.clamp(self.Root.AbsoluteSize.Y, 1, 9999)))

                local fly = TweenService:Create(sparkle, TweenInfo.new(0.8, Enum.EasingStyle.QuadOut), {
                    Position = UDim2.fromScale(targetX, targetY),
                    Size = UDim2.fromOffset(0, 0),
                    BackgroundTransparency = 1
                })
                fly:Play()
                task.wait(0.8)
                sparkle:Destroy()
            end)
        end
        
        task.wait(0.5)
        splashLabel:Destroy()
        self:BuildInterface()
    end)
end

function zaz:BuildInterface()
    -- 1. Main Island 
    local island = Instance.new("TextButton")
    island.Name = "zaz_island"
    island.Size = UDim2.fromOffset(260, 38)
    island.Position = UDim2.new(0.5, 0, 0, 40)
    island.AnchorPoint = Vector2.new(0.5, 0)
    island.BackgroundColor3 = Color3.fromHex("#808080")
    island.BackgroundTransparency = 0.85 
    island.Text = ""
    island.AutoButtonColor = false
    
    local glassBorder = Instance.new("UIStroke")
    glassBorder.Color = Color3.fromHex("#808080")
    glassBorder.Transparency = 0.5
    glassBorder.Thickness = 1
    glassBorder.Parent = island

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 19)
    corner.Parent = island
    island.Parent = self.Root
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.fromScale(1, 1)
    title.BackgroundTransparency = 1
    title.Text = "zaz says open sesame"
    title.Font = Enum.Font.FredokaOne
    title.TextColor3 = Color3.fromHex("#808080")
    title.TextSize = 13
    title.Parent = island

    -- 2. Lock Bubble 
    local lockBubble = Instance.new("TextButton")
    lockBubble.Size = UDim2.fromOffset(16, 16)
    lockBubble.Position = UDim2.new(1, -10, 0, -3)
    lockBubble.BackgroundColor3 = Color3.fromHex("#808080")
    lockBubble.BackgroundTransparency = 0.4
    lockBubble.Text = "U"
    lockBubble.TextSize = 9
    lockBubble.Font = Enum.Font.FredokaOne
    lockBubble.TextColor3 = Color3.fromHex("#808080")
    lockBubble.Parent = island
    
    local bubbleCorner = Instance.new("UICorner")
    bubbleCorner.CornerRadius = UDim.new(1, 0)
    bubbleCorner.Parent = lockBubble
    
    local bubbleStroke = Instance.new("UIStroke")
    bubbleStroke.Color = Color3.fromHex("#808080")
    bubbleStroke.Transparency = 0.2
    bubbleStroke.Parent = lockBubble
    
    lockBubble.MouseButton1Click:Connect(function()
        self.IslandLocked = not self.IslandLocked
        lockBubble.Text = self.IslandLocked and "L" or "U"
    end)

    -- 3. Decorative Guillemet Arrow
    local arrow = Instance.new("TextLabel")
    arrow.Name = "zaz_arrow"
    arrow.Size = UDim2.fromOffset(260, 20)
    arrow.Position = UDim2.new(0.5, 0, 0, 85)
    arrow.AnchorPoint = Vector2.new(0.5, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "︾"
    arrow.Font = Enum.Font.FredokaOne
    arrow.TextColor3 = Color3.fromHex("#808080")
    arrow.TextSize = 12
    arrow.Parent = self.Root

    -- 4. The Separator Line
    local separator = Instance.new("Frame")
    separator.Name = "zaz_separator"
    separator.Size = UDim2.new(0, 240, 0, 1)
    separator.Position = UDim2.new(0.5, 0, 0, 110)
    separator.AnchorPoint = Vector2.new(0.5, 0)
    separator.BackgroundColor3 = Color3.fromHex("#808080")
    separator.BackgroundTransparency = 0.5
    separator.Visible = false
    separator.Parent = self.Root

    -- 5. Card Deck Container
    local deckFrame = Instance.new("Frame")
    deckFrame.Name = "zaz_deck"
    deckFrame.Size = UDim2.fromOffset(260, 0) 
    deckFrame.Position = UDim2.new(0.5, 0, 0, 120)
    deckFrame.AnchorPoint = Vector2.new(0.5, 0)
    deckFrame.BackgroundTransparency = 1
    deckFrame.ClipsDescendants = true
    deckFrame.Parent = self.Root

    island.MouseButton1Click:Connect(function()
        self.IsOpen = not self.IsOpen
        
        local targetDeckHeight = self.IsOpen and 280 or 0
        local arrowRotation = self.IsOpen and 180 or 0
        
        separator.Visible = self.IsOpen
        
        TweenService:Create(deckFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(260, targetDeckHeight)}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.5), {Rotation = arrowRotation}):Play()
    end)

    self:EnableDragging(island, {arrow, separator, deckFrame})
    self.DeckFrame = deckFrame
    self:RenderCards()
end

function zaz:NavigateToCard(index: number)
    if index < 1 or index > #self.Cards then return end
    self.CurrentCardIndex = index
    
    for i, card in ipairs(self.Cards) do
        if card.Frame then
            local targetPosition = UDim2.fromScale((i - index), 0)
            TweenService:Create(card.Frame, TweenInfo.new(0.6, Enum.EasingStyle.QuadOut), {Position = targetPosition}):Play()
        end
    end
end

function zaz:EnableDragging(frame, dependents)
    local dragging, dragInput, dragStart, startPos
    local dependentStarts = {}

    frame.InputBegan:Connect(function(input)
        if self.IslandLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            for i, dep in ipairs(dependents) do
                dependentStarts[dep] = dep.Position
            end
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newX = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            frame.Position = newX
            
            for dep, depStart in pairs(dependentStarts) do
                dep.Position = UDim2.new(depStart.X.Scale, depStart.X.Offset + delta.X, depStart.Y.Scale, depStart.Y.Offset + delta.Y)
            end
        end
    end)
end

function zaz:RenderCards()
    if not self.DeckFrame then return end
    
    for _, child in ipairs(self.DeckFrame:GetChildren()) do
        child:Destroy()
    end

    for i, cardData in ipairs(self.Cards) do
        local cardFrame = Instance.new("Frame")
        cardFrame.Name = "Card_" .. cardData.Title
        cardFrame.Size = UDim2.fromScale(1, 1)
        cardFrame.Position = UDim2.fromScale(i - self.CurrentCardIndex, 0)
        cardFrame.BackgroundColor3 = Color3.fromHex("#808080")
        cardFrame.BackgroundTransparency = 0.85
        cardFrame.Parent = self.DeckFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 14)
        corner.Parent = cardFrame
        
        local cardStroke = Instance.new("UIStroke")
        cardStroke.Color = Color3.fromHex("#808080")
        cardStroke.Transparency = 0.6
        cardStroke.Parent = cardFrame

        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, 0, 0, 30)
        header.BackgroundTransparency = 1
        header.Text = cardData.Title
        header.Font = Enum.Font.FredokaOne
        header.TextColor3 = Color3.fromHex("#808080")
        header.TextSize = 13
        header.Parent = cardFrame
        
        cardData.Frame = cardFrame
    end
end

return zaz
