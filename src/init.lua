--!strict
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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
    splashLabel.Parent = self.Root

    task.wait(1.5)
    
    local tween = TweenService:Create(splashLabel, TweenInfo.new(0.5), {TextTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        splashLabel:Destroy()
        self:BuildInterface()
    end)
end

function zaz:BuildInterface()
    -- 1. Main Island (Downsized by 9% -> 291px width, 45px height)
    local island = Instance.new("TextButton")
    island.Name = "zaz_island"
    island.Size = UDim2.fromOffset(291, 45)
    island.Position = UDim2.new(0.5, 0, 0, 40)
    island.AnchorPoint = Vector2.new(0.5, 0)
    island.BackgroundColor3 = Color3.fromHex("#808080")
    island.BackgroundTransparency = 0.75 -- Darker translucent glass effect
    island.Text = ""
    island.AutoButtonColor = false
    
    local glassBorder = Instance.new("UIStroke")
    glassBorder.Color = Color3.fromHex("#808080")
    glassBorder.Transparency = 0.4
    glassBorder.Thickness = 1
    glassBorder.Parent = island

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 22)
    corner.Parent = island
    island.Parent = self.Root
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.fromScale(1, 1)
    title.BackgroundTransparency = 1
    title.Text = "zaz says open sesame"
    title.Font = Enum.Font.FredokaOne
    title.TextColor3 = Color3.fromHex("#808080")
    title.TextSize = 14
    title.Parent = island

    -- 2. Lock Bubble
    local lockBubble = Instance.new("TextButton")
    lockBubble.Size = UDim2.fromOffset(18, 18)
    lockBubble.Position = UDim2.new(1, -12, 0, -4)
    lockBubble.BackgroundColor3 = Color3.fromHex("#808080")
    lockBubble.BackgroundTransparency = 0.2
    lockBubble.Text = "U"
    lockBubble.TextSize = 9
    lockBubble.Font = Enum.Font.FredokaOne
    lockBubble.TextColor3 = Color3.fromHex("#808080")
    lockBubble.Parent = island
    
    local bubbleCorner = Instance.new("UICorner")
    bubbleCorner.CornerRadius = UDim.new(1, 0)
    bubbleCorner.Parent = lockBubble
    
    lockBubble.MouseButton1Click:Connect(function()
        self.IslandLocked = not self.IslandLocked
        if self.IslandLocked then
            lockBubble.Text = "L"
        else
            lockBubble.Text = "U"
        end
    end)

    -- 3. Decorative Guillemet Arrow
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.fromOffset(291, 20)
    arrow.Position = UDim2.new(0.5, 0, 0, 90)
    arrow.AnchorPoint = Vector2.new(0.5, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "︾"
    arrow.Font = Enum.Font.FredokaOne
    arrow.TextColor3 = Color3.fromHex("#808080")
    arrow.TextSize = 13
    arrow.Parent = self.Root

    -- 4. The Separator Line
    local separator = Instance.new("Frame")
    separator.Name = "zaz_separator"
    separator.Size = UDim2.new(0, 270, 0, 1)
    separator.Position = UDim2.new(0.5, 0, 0, 115)
    separator.AnchorPoint = Vector2.new(0.5, 0)
    separator.BackgroundColor3 = Color3.fromHex("#808080")
    separator.BackgroundTransparency = 0.5
    separator.Visible = false
    separator.Parent = self.Root

    -- 5. Card Deck Container (The Tray)
    local deckFrame = Instance.new("Frame")
    deckFrame.Name = "zaz_deck"
    deckFrame.Size = UDim2.fromOffset(291, 0) 
    deckFrame.Position = UDim2.new(0.5, 0, 0, 125)
    deckFrame.AnchorPoint = Vector2.new(0.5, 0)
    deckFrame.BackgroundTransparency = 1
    deckFrame.ClipsDescendants = true
    deckFrame.Parent = self.Root

    island.MouseButton1Click:Connect(function()
        self.IsOpen = not self.IsOpen
        
        local targetDeckHeight = self.IsOpen and 280 or 0
        local arrowRotation = self.IsOpen and 180 or 0
        
        separator.Visible = self.IsOpen
        
        TweenService:Create(deckFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(291, targetDeckHeight)}):Play()
        TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = arrowRotation}):Play()
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
            TweenService:Create(card.Frame, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {Position = targetPosition}):Play()
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
    
    -- Clean previous renders
    for _, child in ipairs(self.DeckFrame:GetChildren()) do
        child:Destroy()
    end

    for i, cardData in ipairs(self.Cards) do
        local cardFrame = Instance.new("Frame")
        cardFrame.Name = "Card_" .. cardData.Title
        cardFrame.Size = UDim2.fromScale(1, 1)
        -- Position sequentially sideways to enable swipe transitions
        cardFrame.Position = UDim2.fromScale(i - self.CurrentCardIndex, 0)
        cardFrame.BackgroundColor3 = Color3.fromHex("#808080")
        cardFrame.BackgroundTransparency = 0.8
        cardFrame.Parent = self.DeckFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 14)
        corner.Parent = cardFrame
        
        local cardStroke = Instance.new("UIStroke")
        cardStroke.Color = Color3.fromHex("#808080")
        cardStroke.Transparency = 0.5
        cardStroke.Parent = cardFrame

        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, 0, 0, 30)
        header.BackgroundTransparency = 1
        header.Text = cardData.Title
        header.Font = Enum.Font.FredokaOne
        header.TextColor3 = Color3.fromHex("#808080")
        header.TextSize = 14
        header.Parent = cardFrame
        
        cardData.Frame = cardFrame
    end
end

return zaz
