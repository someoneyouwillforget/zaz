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
    splashLabel.TextSize = 48
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
    -- 1. Main Island
    local island = Instance.new("TextButton")
    island.Name = "zaz_island"
    island.Size = UDim2.fromOffset(320, 50)
    island.Position = UDim2.new(0.5, 0, 0, 40)
    island.AnchorPoint = Vector2.new(0.5, 0)
    island.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    island.BackgroundTransparency = 0.85 
    island.Text = ""
    island.AutoButtonColor = false
    
    local glassBorder = Instance.new("UIStroke")
    glassBorder.Color = Color3.fromRGB(255, 255, 255)
    glassBorder.Transparency = 0.6
    glassBorder.Thickness = 1
    glassBorder.Parent = island

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 25)
    corner.Parent = island
    island.Parent = self.Root
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.fromScale(1, 1)
    title.BackgroundTransparency = 1
    title.Text = "zaz says open sesame"
    title.Font = Enum.Font.FredokaOne
    title.TextColor3 = Color3.fromRGB(240, 240, 240)
    title.TextSize = 16
    title.Parent = island

    -- 2. Lock Bubble
    local lockBubble = Instance.new("TextButton")
    lockBubble.Size = UDim2.fromOffset(20, 20)
    lockBubble.Position = UDim2.new(1, -15, 0, -5)
    lockBubble.BackgroundColor3 = Color3.fromRGB(50, 150, 50) 
    lockBubble.Text = "U"
    lockBubble.TextSize = 10
    lockBubble.Font = Enum.Font.FredokaOne
    lockBubble.TextColor3 = Color3.fromRGB(255, 255, 255)
    lockBubble.Parent = island
    
    local bubbleCorner = Instance.new("UICorner")
    bubbleCorner.CornerRadius = UDim.new(1, 0)
    bubbleCorner.Parent = lockBubble
    
    lockBubble.MouseButton1Click:Connect(function()
        self.IslandLocked = not self.IslandLocked
        if self.IslandLocked then
            lockBubble.Text = "L"
            lockBubble.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        else
            lockBubble.Text = "U"
            lockBubble.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        end
    end)

    -- 3. Decorative Guillemet Arrow
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.fromOffset(320, 20)
    arrow.Position = UDim2.new(0.5, 0, 0, 95)
    arrow.AnchorPoint = Vector2.new(0.5, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "︾"
    arrow.Font = Enum.Font.FredokaOne
    arrow.TextColor3 = Color3.fromHex("#808080")
    arrow.TextSize = 14
    arrow.Parent = self.Root

    -- 4. The Separator Line
    local separator = Instance.new("Frame")
    separator.Name = "zaz_separator"
    separator.Size = UDim2.new(0, 300, 0, 1)
    separator.Position = UDim2.new(0.5, 0, 0, 125)
    separator.AnchorPoint = Vector2.new(0.5, 0)
    separator.BackgroundColor3 = Color3.fromHex("#808080")
    separator.BackgroundTransparency = 0.5
    separator.Visible = false
    separator.Parent = self.Root

    -- 5. Card Deck Container (The Tray)
    local deckFrame = Instance.new("Frame")
    deckFrame.Name = "zaz_deck"
    deckFrame.Size = UDim2.fromOffset(320, 0) 
    deckFrame.Position = UDim2.new(0.5, 0, 0, 135)
    deckFrame.AnchorPoint = Vector2.new(0.5, 0)
    deckFrame.BackgroundTransparency = 1
    deckFrame.ClipsDescendants = true
    deckFrame.Parent = self.Root

    island.MouseButton1Click:Connect(function()
        self.IsOpen = not self.IsOpen
        
        local targetDeckHeight = self.IsOpen and 300 or 0
        local arrowRotation = self.IsOpen and 180 or 0
        
        separator.Visible = self.IsOpen
        
        TweenService:Create(deckFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(320, targetDeckHeight)}):Play()
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
    -- Elements rendering logic will go here
end

return zaz
