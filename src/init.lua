-- zaz UI Framework Core Engine - Liquid Glass Spread Deck Edition
local zaz = {}
zaz.__index = zaz

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Sparkle effect creator
local function createSparkle(parent, position)
    local sparkle = Instance.new("Frame")
    sparkle.Size = UDim2.fromOffset(6, 6)
    sparkle.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    sparkle.BackgroundTransparency = 0.3
    sparkle.Position = position or UDim2.fromScale(0.5, 0.5)
    sparkle.AnchorPoint = Vector2.new(0.5, 0.5)
    sparkle.ZIndex = 50
    sparkle.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = sparkle
    
    local expand = TweenService:Create(sparkle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(12, 12),
        BackgroundTransparency = 0
    })
    expand:Play()
    
    expand.Completed:Connect(function()
        local fade = TweenService:Create(sparkle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1
        })
        fade:Play()
        fade.Completed:Connect(function()
            sparkle:Destroy()
        end)
    end)
end

function zaz:CreateWindow(config)
    local windowName = config.Name or "zaz"
    
    -- Main Core UI Layer
    local ZazUI = Instance.new("ScreenGui")
    ZazUI.Name = "ZazLiquidGlassInterface"
    ZazUI.ResetOnSpawn = false
    ZazUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if gethui then ZazUI.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(ZazUI); ZazUI.Parent = game:GetService("CoreGui")
    else ZazUI.Parent = game:GetService("CoreGui") end

    -- Main Deck Container (draggable)
    local MainDeckContainer = Instance.new("Frame")
    MainDeckContainer.Name = "MainDeckContainer"
    MainDeckContainer.Size = UDim2.new(0, 520, 0, 480)
    MainDeckContainer.Position = UDim2.new(0.5, -260, 0.5, -240)
    MainDeckContainer.BackgroundTransparency = 1
    MainDeckContainer.Active = true
    MainDeckContainer.Draggable = true
    MainDeckContainer.Visible = false
    MainDeckContainer.Parent = ZazUI
    
    -- Card Container
    local CardContainer = Instance.new("Frame")
    CardContainer.Name = "CardContainer"
    CardContainer.Size = UDim2.new(1, 0, 1, -60)
    CardContainer.Position = UDim2.new(0, 0, 0, 55)
    CardContainer.BackgroundTransparency = 1
    CardContainer.Parent = MainDeckContainer
    
    -- Liquid Glass Island Hub (smaller)
    local IslandHub = Instance.new("TextButton")
    IslandHub.Name = "IslandHub"
    IslandHub.Size = UDim2.fromOffset(260, 42)
    IslandHub.Position = UDim2.new(0.5, -130, 0, 40) 
    IslandHub.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    IslandHub.BackgroundTransparency = 0.25
    IslandHub.Text = ""
    IslandHub.AutoButtonColor = false
    IslandHub.Visible = false
    IslandHub.Parent = ZazUI
    
    -- Island blur effect
    local islandBlur = Instance.new("BlurEffect")
    islandBlur.Size = 12
    islandBlur.Parent = IslandHub
    
    local islandStroke = Instance.new("UIStroke")
    islandStroke.Color = Color3.fromHex("#C0C0C0")
    islandStroke.Thickness = 1.5
    islandStroke.Transparency = 0.3
    islandStroke.Parent = IslandHub
    
    local IslandCorner = Instance.new("UICorner")
    IslandCorner.CornerRadius = UDim.new(0, 21)
    IslandCorner.Parent = IslandHub
    
    -- Island gradient for glass effect
    local islandGradient = Instance.new("UIGradient")
    islandGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    islandGradient.Rotation = 90
    islandGradient.Parent = IslandHub
    
    local islandTitle = Instance.new("TextLabel")
    islandTitle.Size = UDim2.fromScale(1, 1)
    islandTitle.BackgroundTransparency = 1
    islandTitle.Text = "⧉  zaz spread deck  ⧉"
    islandTitle.Font = Enum.Font.FredokaOne
    islandTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
    islandTitle.TextSize = 13
    islandTitle.Parent = IslandHub
    
    -- Lock button (U/L)
    local LockBubble = Instance.new("TextButton")
    LockBubble.Name = "LockBubble"
    LockBubble.Size = UDim2.fromOffset(24, 24)
    LockBubble.Position = UDim2.new(1, -34, 0.5, -12)
    LockBubble.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    LockBubble.BackgroundTransparency = 0.4
    LockBubble.Text = "U"
    LockBubble.TextColor3 = Color3.fromRGB(220, 220, 240)
    LockBubble.TextSize = 11
    LockBubble.Font = Enum.Font.FredokaOne
    LockBubble.Parent = IslandHub
    
    local BubbleCorner = Instance.new("UICorner")
    BubbleCorner.CornerRadius = UDim.new(1, 0)
    BubbleCorner.Parent = LockBubble
    
    -- Header (also draggable)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 55)
    Header.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Header.BackgroundTransparency = 0.15
    Header.BorderSizePixel = 0
    Header.Active = true
    Header.Draggable = true
    Header.Parent = MainDeckContainer
    
    local headerBlur = Instance.new("BlurEffect")
    headerBlur.Size = 10
    headerBlur.Parent = Header
    
    local headerStroke = Instance.new("UIStroke")
    headerStroke.Color = Color3.fromHex("#A0A0A0")
    headerStroke.Thickness = 1
    headerStroke.Transparency = 0.4
    headerStroke.Parent = Header
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "📇  " .. windowName .. " spread deck"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 15 
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 32, 0, 32)
    MinimizeButton.Position = UDim2.new(1, -72, 0, 11.5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    MinimizeButton.BackgroundTransparency = 0.4
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(220, 220, 240)
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.FredokaOne
    MinimizeButton.Parent = Header
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeButton
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 32, 0, 32)
    CloseButton.Position = UDim2.new(1, -36, 0, 11.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(45, 35, 35)
    CloseButton.BackgroundTransparency = 0.4
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 150, 150)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.FredokaOne
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    -- Outro Splash Animation
    local function playOutroSplash(callback)
        local OutroSplash = Instance.new("TextLabel")
        OutroSplash.Size = UDim2.fromScale(1, 1)
        OutroSplash.BackgroundTransparency = 1
        OutroSplash.Text = "zaz"
        OutroSplash.TextColor3 = Color3.fromHex("#808080") 
        OutroSplash.Font = Enum.Font.FredokaOne
        OutroSplash.TextSize = 75
        OutroSplash.AnchorPoint = Vector2.new(0.5, 0.5)
        OutroSplash.Position = UDim2.fromScale(0.5, 0.5)
        OutroSplash.ZIndex = 100
        OutroSplash.Parent = ZazUI
        
        local viewSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
        
        for i = 1, 30 do
            task.spawn(function()
                local sparkle = Instance.new("Frame")
                sparkle.Size = UDim2.fromOffset(math.random(4, 10), math.random(4, 10))
                sparkle.BackgroundColor3 = Color3.fromHex("#808080")
                sparkle.Position = UDim2.fromScale(0.5, 0.5)
                sparkle.AnchorPoint = Vector2.new(0.5, 0.5)
                sparkle.ZIndex = 101
                sparkle.Parent = ZazUI
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = sparkle
                
                local angle = math.rad(math.random(0, 360))
                local distance = math.random(100, 300)
                local targetX = 0.5 + (math.cos(angle) * (distance / viewSize.X))
                local targetY = 0.5 + (math.sin(angle) * (distance / viewSize.Y))
                
                local fly = TweenService:Create(sparkle, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.fromScale(targetX, targetY),
                    Size = UDim2.fromOffset(0, 0),
                    BackgroundTransparency = 1
                })
                fly:Play()
                task.wait(1.2)
                sparkle:Destroy()
            end)
        end
        
        local shrink = TweenService:Create(OutroSplash, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            TextSize = 0,
            TextTransparency = 1
        })
        shrink:Play()
        shrink.Completed:Connect(function()
            OutroSplash:Destroy()
            if callback then callback() end
        end)
    end
    
    -- Prompt Modal
    local PromptModal = Instance.new("Frame")
    PromptModal.Size = UDim2.new(0, 320, 0, 160)
    PromptModal.Position = UDim2.new(0.5, -160, 0.5, -80)
    PromptModal.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    PromptModal.BackgroundTransparency = 0.1
    PromptModal.BorderSizePixel = 0
    PromptModal.ZIndex = 200
    PromptModal.Visible = false
    PromptModal.Parent = ZazUI
    
    local modalBlur = Instance.new("BlurEffect")
    modalBlur.Size = 15
    modalBlur.Parent = PromptModal
    
    local modalStroke = Instance.new("UIStroke")
    modalStroke.Color = Color3.fromHex("#C0C0C0")
    modalStroke.Thickness = 1.5
    modalStroke.Transparency = 0.3
    modalStroke.Parent = PromptModal
    
    local PromptCorner = Instance.new("UICorner")
    PromptCorner.CornerRadius = UDim.new(0, 12)
    PromptCorner.Parent = PromptModal
    
    local PromptTitle = Instance.new("TextLabel")
    PromptTitle.Size = UDim2.new(1, 0, 0, 45)
    PromptTitle.BackgroundTransparency = 1
    PromptTitle.Text = "Unload Spread Deck?"
    PromptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PromptTitle.TextSize = 16
    PromptTitle.Font = Enum.Font.FredokaOne
    PromptTitle.ZIndex = 201
    PromptTitle.Parent = PromptModal
    
    local PromptDesc = Instance.new("TextLabel")
    PromptDesc.Size = UDim2.new(1, -24, 0, 45)
    PromptDesc.Position = UDim2.new(0, 12, 0, 45)
    PromptDesc.BackgroundTransparency = 1
    PromptDesc.Text = "This will unload the entire UI with an outro animation."
    PromptDesc.TextColor3 = Color3.fromRGB(160, 160, 170)
    PromptDesc.TextSize = 12
    PromptDesc.Font = Enum.Font.FredokaOne
    PromptDesc.TextWrapped = true
    PromptDesc.ZIndex = 201
    PromptDesc.Parent = PromptModal
    
    local CancelBtn = Instance.new("TextButton")
    CancelBtn.Size = UDim2.new(0, 135, 0, 36)
    CancelBtn.Position = UDim2.new(0, 18, 1, -48)
    CancelBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    CancelBtn.BackgroundTransparency = 0.3
    CancelBtn.Text = "Cancel"
    CancelBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
    CancelBtn.TextSize = 13
    CancelBtn.Font = Enum.Font.FredokaOne
    CancelBtn.ZIndex = 201
    CancelBtn.Parent = PromptModal
    
    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 8)
    CancelCorner.Parent = CancelBtn
    
    local ConfirmBtn = Instance.new("TextButton")
    ConfirmBtn.Size = UDim2.new(0, 135, 0, 36)
    ConfirmBtn.Position = UDim2.new(1, -153, 1, -48)
    ConfirmBtn.BackgroundColor3 = Color3.fromRGB(55, 35, 35)
    ConfirmBtn.BackgroundTransparency = 0.3
    ConfirmBtn.Text = "Unload"
    ConfirmBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
    ConfirmBtn.TextSize = 13
    ConfirmBtn.Font = Enum.Font.FredokaOne
    ConfirmBtn.ZIndex = 201
    ConfirmBtn.Parent = PromptModal
    
    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 8)
    ConfirmCorner.Parent = ConfirmBtn
    
    local function addButtonSparkle(button)
        button.MouseButton1Click:Connect(function()
            createSparkle(button, UDim2.fromScale(0.5, 0.5))
        end)
    end
    
    addButtonSparkle(CancelBtn)
    addButtonSparkle(ConfirmBtn)
    addButtonSparkle(MinimizeButton)
    addButtonSparkle(CloseButton)
    addButtonSparkle(LockBubble)
    
    CancelBtn.MouseButton1Click:Connect(function()
        PromptModal.Visible = false
    end)
    
    ConfirmBtn.MouseButton1Click:Connect(function()
        PromptModal.Visible = false
        playOutroSplash(function()
            ZazUI:Destroy()
        end)
    end)
    
    -- Island dragging (smooth)
    local islandLocked = false
    local islandDragging = false
    local islandDragInput
    local islandDragStart
    local islandSavedPos = IslandHub.Position
    
    LockBubble.MouseButton1Click:Connect(function()
        islandLocked = not islandLocked
        LockBubble.Text = islandLocked and "L" or "U"
    end)
    
    IslandHub.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not islandLocked then
            islandDragging = true
            islandDragStart = input.Position
            islandSavedPos = IslandHub.Position
        end
    end)
    
    IslandHub.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            islandDragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == islandDragInput and islandDragging and not islandLocked then
            local delta = input.Position - islandDragStart
            IslandHub.Position = UDim2.new(
                islandSavedPos.X.Scale, 
                islandSavedPos.X.Offset + delta.X, 
                islandSavedPos.Y.Scale, 
                islandSavedPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            islandDragging = false
            islandSavedPos = IslandHub.Position
        end
    end)
    
    -- Intro Splash Animation
    local IntroSplash = Instance.new("TextLabel")
    IntroSplash.Size = UDim2.fromScale(1, 1)
    IntroSplash.BackgroundTransparency = 1
    IntroSplash.Text = "zaz"
    IntroSplash.TextColor3 = Color3.fromHex("#808080") 
    IntroSplash.Font = Enum.Font.FredokaOne
    IntroSplash.TextSize = 0
    IntroSplash.AnchorPoint = Vector2.new(0.5, 0.5)
    IntroSplash.Position = UDim2.fromScale(0.5, 0.5)
    IntroSplash.ZIndex = 10
    IntroSplash.Parent = ZazUI
    
    task.spawn(function()
        task.wait(0.3)
        
        local grow = TweenService:Create(IntroSplash, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextSize = 44})
        grow:Play()
        grow.Completed:Wait()
        
        local startTime = tick()
        local totalDuration = 3.5
        
        while tick() - startTime < totalDuration do
            local elapsed = tick() - startTime
            local wave = math.sin(elapsed * math.pi * 2.2) 
            IntroSplash.TextSize = math.round(44 + (wave * 6))
            RunService.RenderStepped:Wait()
        end
        
        IntroSplash.TextSize = 65
        local fadeTween = TweenService:Create(IntroSplash, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
        fadeTween:Play()
        fadeTween.Completed:Wait()
        
        local viewSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
        
        for i = 1, 25 do
            task.spawn(function()
                local sparkle = Instance.new("Frame")
                sparkle.Size = UDim2.fromOffset(math.random(3, 8), math.random(3, 8))
                sparkle.BackgroundColor3 = Color3.fromHex("#A0A0A0")
                sparkle.Position = UDim2.fromScale(0.5, 0.5)
                sparkle.AnchorPoint = Vector2.new(0.5, 0.5)
                sparkle.ZIndex = 11
                sparkle.Parent = ZazUI
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = sparkle
                
                local angle = math.rad(math.random(0, 360))
                local distance = math.random(60, 200)
                local targetX = 0.5 + (math.cos(angle) * (distance / viewSize.X))
                local targetY = 0.5 + (math.sin(angle) * (distance / viewSize.Y))
                
                local fly = TweenService:Create(sparkle, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.fromScale(targetX, targetY),
                    Size = UDim2.fromOffset(0, 0),
                    BackgroundTransparency = 1
                })
                fly:Play()
                task.wait(0.9)
                sparkle:Destroy()
            end)
        end
        
        task.wait(0.5)
        IntroSplash:Destroy()
        
        MainDeckContainer.Visible = true
        MainDeckContainer.Position = UDim2.new(0.5, -260, 1.2, 0)
        local slideUp = TweenService:Create(MainDeckContainer, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -260, 0.5, -240)
        })
        slideUp:Play()
    end)
    
    -- Card System
    local DeckSystem = {
        Cards = {},
        Container = CardContainer,
        IslandHub = IslandHub,
        MainDeck = MainDeckContainer
    }
    
    local currentYOffset = 10
    
    local function updateContainerSize()
        local totalHeight = 60 + (#DeckSystem.Cards * 45) + 50
        CardContainer.Size = UDim2.new(1, 0, 0, totalHeight)
    end
    
    function DeckSystem:CreateCard(cardConfig)
        local cardName = cardConfig.Name or "Card"
        local cardIndex = #DeckSystem.Cards + 1
        
        local Card = Instance.new("Frame")
        Card.Name = "Card_" .. cardName
        Card.Size = UDim2.new(0, 480, 0, cardConfig.Height or 120)
        Card.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        Card.BackgroundTransparency = 0.2
        Card.BorderSizePixel = 0
        Card.ClipsDescendants = true
        Card.Parent = CardContainer
        
        -- Liquid glass effect
        local cardBlur = Instance.new("BlurEffect")
        cardBlur.Size = 8
        cardBlur.Parent = Card
        
        local cardStroke = Instance.new("UIStroke")
        cardStroke.Color = Color3.fromHex("#A0A0A0")
        cardStroke.Thickness = 1.5
        cardStroke.Transparency = 0.4
        cardStroke.Parent = Card
        
        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 12)
        CardCorner.Parent = Card
        
        local cardGradient = Instance.new("UIGradient")
        cardGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
        })
        cardGradient.Rotation = 90
        cardGradient.Parent = Card
        
        -- Card Header
        if cardConfig.Title then
            local CardHeader = Instance.new("Frame")
            CardHeader.Name = "CardHeader"
            CardHeader.Size = UDim2.new(1, 0, 0, 38)
            CardHeader.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            CardHeader.BackgroundTransparency = 0.3
            CardHeader.BorderSizePixel = 0
            CardHeader.Parent = Card
            
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 12)
            headerCorner.Parent = CardHeader
            
            local TitleText = Instance.new("TextLabel")
            TitleText.Size = UDim2.new(1, -20, 1, 0)
            TitleText.Position = UDim2.new(0, 12, 0, 0)
            TitleText.BackgroundTransparency = 1
            TitleText.Text = cardConfig.Title
            TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
            TitleText.TextSize = 14
            TitleText.Font = Enum.Font.FredokaOne
            TitleText.TextXAlignment = Enum.TextXAlignment.Left
            TitleText.TextYAlignment = Enum.TextYAlignment.Center
            TitleText.Parent = CardHeader
            
            Card.ContentStart = 42
        else
            Card.ContentStart = 12
        end
        
        -- Content Container
        local Content = Instance.new("ScrollingFrame")
        Content.Name = "Content"
        Content.Size = UDim2.new(1, -16, 1, -(Card.ContentStart) - 10)
        Content.Position = UDim2.new(0, 8, 0, Card.ContentStart)
        Content.BackgroundTransparency = 1
        Content.ScrollBarThickness = 3
        Content.ScrollBarImageColor3 = Color3.fromHex("#808080")
        Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        Content.Parent = Card
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.FillDirection = Enum.FillDirection.Vertical
        ContentLayout.Padding = UDim.new(0, 6)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = Content
        
        -- Spread animation
        local startX = (cardIndex % 2 == 0) and -100 or 100
        Card.Position = UDim2.new(0.5, startX, 0, currentYOffset)
        Card.Rotation = (cardIndex % 2 == 0) and -15 or 15
        Card.BackgroundTransparency = 0.8
        
        local spreadIn = TweenService:Create(Card, TweenInfo.new(0.5 + (cardIndex * 0.05), Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -240, 0, currentYOffset),
            Rotation = (cardIndex - (#DeckSystem.Cards + 1) / 2) * 3,
            BackgroundTransparency = 0.2
        })
        spreadIn:Play()
        
        currentYOffset = currentYOffset + cardConfig.Height + 20
        
        local CardAPI = {}
        
        function CardAPI:AddButton(btnConfig)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            Btn.BackgroundTransparency = 0.3
            Btn.Text = "  " .. (btnConfig.Icon or "▸") .. "  " .. btnConfig.Name
            Btn.TextColor3 = Color3.fromRGB(230, 230, 240)
            Btn.TextSize = 13
            Btn.Font = Enum.Font.FredokaOne
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Content
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Color3.fromHex("#A0A0A0")
            btnStroke.Thickness = 1
            btnStroke.Transparency = 0.5
            btnStroke.Parent = Btn
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                createSparkle(Btn, UDim2.fromScale(0.5, 0.5))
                if btnConfig.Callback then btnConfig.Callback() end
            end)
            
            Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
            Card.Size = UDim2.new(0, 480, 0, Card.Size.Y.Offset + 44)
        end
        
        function CardAPI:AddToggle(toggleConfig)
            local toggled = toggleConfig.CurrentValue or false
            
            local TglFrame = Instance.new("TextButton")
            TglFrame.Size = UDim2.new(1, 0, 0, 38)
            TglFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            TglFrame.BackgroundTransparency = 0.3
            TglFrame.Text = "  " .. (toggleConfig.Icon or "◻") .. "  " .. toggleConfig.Name
            TglFrame.TextColor3 = Color3.fromRGB(230, 230, 240)
            TglFrame.TextSize = 13
            TglFrame.Font = Enum.Font.FredokaOne
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            TglFrame.Parent = Content
            
            local tglStroke = Instance.new("UIStroke")
            tglStroke.Color = Color3.fromHex("#A0A0A0")
            tglStroke.Thickness = 1
            tglStroke.Transparency = 0.5
            tglStroke.Parent = TglFrame
            
            local TglCorner = Instance.new("UICorner")
            TglCorner.CornerRadius = UDim.new(0, 8)
            TglCorner.Parent = TglFrame
            
            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 20, 0, 20)
            Indicator.Position = UDim2.new(1, -32, 0.5, -10)
            Indicator.BackgroundColor3 = toggled and Color3.fromHex("#808080") or Color3.fromRGB(50, 50, 60)
            Indicator.Parent = TglFrame
            
            local indStroke = Instance.new("UIStroke")
            indStroke.Color = Color3.fromHex("#A0A0A0")
            indStroke.Thickness = 1
            indStroke.Transparency = 0.4
            indStroke.Parent = Indicator
            
            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(0, 5)
            IndCorner.Parent = Indicator
            
            local function updateToggle()
                local targetColor = toggled and Color3.fromHex("#808080") or Color3.fromRGB(50, 50, 60)
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                if toggleConfig.Callback then toggleConfig.Callback(toggled) end
            end
            
            TglFrame.MouseButton1Click:Connect(function()
                createSparkle(TglFrame, UDim2.fromScale(0.5, 0.5))
                toggled = not toggled
                TglFrame.Text = "  " .. (toggled and "☒" or "◻") .. "  " .. toggleConfig.Name
                updateToggle()
            end)
            
            Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
            Card.Size = UDim2.new(0, 480, 0, Card.Size.Y.Offset + 46)
        end
        
        function CardAPI:AddSlider(sliderConfig)
            local min = sliderConfig.Range[1]
            local max = sliderConfig.Range[2]
            local current = sliderConfig.CurrentValue or min
            
            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(1, 0, 0, 65)
            SldFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            SldFrame.BackgroundTransparency = 0.3
            SldFrame.Parent = Content
            
            local sldStroke = Instance.new("UIStroke")
            sldStroke.Color = Color3.fromHex("#A0A0A0")
            sldStroke.Thickness = 1
            sldStroke.Transparency = 0.5
            sldStroke.Parent = SldFrame
            
            local SldCorner = Instance.new("UICorner")
            SldCorner.CornerRadius = UDim.new(0, 8)
            SldCorner.Parent = SldFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -80, 0, 22)
            Label.Position = UDim2.new(0, 12, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = sliderConfig.Name
            Label.TextColor3 = Color3.fromRGB(230, 230, 240)
            Label.TextSize = 13
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SldFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 70, 0, 22)
            ValueLabel.Position = UDim2.new(1, -82, 0, 6)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(current) .. (sliderConfig.Suffix or "")
            ValueLabel.TextColor3 = Color3.fromHex("#A0A0A0")
            ValueLabel.TextSize = 12
            ValueLabel.Font = Enum.Font.FredokaOne
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SldFrame
            
            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -24, 0, 6)
            Track.Position = UDim2.new(0, 12, 1, -16)
            Track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            Track.Text = ""
            Track.Parent = SldFrame
            
            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(0, 3)
            TrackCorner.Parent = Track
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((current - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromHex("#A0A0A0")
            Fill.BorderSizePixel = 0
            Fill.Parent = Track
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 3)
            FillCorner.Parent = Fill
            
            local holding = false
            
            local function updateSlider(input)
                local percentage = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local rawValue = min + (percentage * (max - min))
                local increment = sliderConfig.Increment or 1
                current = math.round(rawValue / increment) * increment
                current = math.clamp(current, min, max)
                
                TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new((current - min)/(max - min), 0, 1, 0)}):Play()
                ValueLabel.Text = tostring(current) .. (sliderConfig.Suffix or "")
                if sliderConfig.Callback then sliderConfig.Callback(current) end
            end
            
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    holding = true
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if holding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    holding = false
                end
            end)
            
            Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
            Card.Size = UDim2.new(0, 480, 0, Card.Size.Y.Offset + 73)
        end
        
        function CardAPI:AddDropdown(dropConfig)
            local DropFrame = Instance.new("TextButton")
            DropFrame.Size = UDim2.new(1, 0, 0, 38)
            DropFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            DropFrame.BackgroundTransparency = 0.3
            DropFrame.Text = "  ▼  " .. dropConfig.Name .. "  (" .. (dropConfig.CurrentOption or dropConfig.Options[1] or "None") .. ")"
            DropFrame.TextColor3 = Color3.fromRGB(230, 230, 240)
            DropFrame.TextSize = 13
            DropFrame.Font = Enum.Font.FredokaOne
            DropFrame.TextXAlignment = Enum.TextXAlignment.Left
            DropFrame.Parent = Content
            
            local dropStroke = Instance.new("UIStroke")
            dropStroke.Color = Color3.fromHex("#A0A0A0")
            dropStroke.Thickness = 1
            dropStroke.Transparency = 0.5
            dropStroke.Parent = DropFrame
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 8)
            DropCorner.Parent = DropFrame
            
            local open = false
            local itemButtons = {}
            local dropdownHeight = 0
            
            DropFrame.MouseButton1Click:Connect(function()
                createSparkle(DropFrame, UDim2.fromScale(0.5, 0.5))
                open = not open
                for _, btn in pairs(itemButtons) do
                    btn.Visible = open
                end
                if open then
                    Card.Size = UDim2.new(0, 480, 0, Card.Size.Y.Offset + (#dropConfig.Options * 32))
                else
                    Card.Size = UDim2.new(0, 480, 0, Card.Size.Y.Offset - (#dropConfig.Options * 32))
                end
            end)
            
            for i, option in pairs(dropConfig.Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                OptBtn.Text = "    •  " .. option
                OptBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
                OptBtn.TextSize = 12
                OptBtn.Font = Enum.Font.FredokaOne
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.Visible = false
                OptBtn.Parent = Content
                
                local optStroke = Instance.new("UIStroke")
                optStroke.Color = Color3.fromHex("#A0A0A0")
                optStroke.Thickness = 1
                optStroke.Transparency = 0.6
                optStroke.Parent = OptBtn
                
                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 6)
                OptCorner.Parent = OptBtn
                
                OptBtn.MouseButton1Click:Connect(function()
                    createSparkle(OptBtn, UDim2.fromScale(0.5, 0.5))
                    DropFrame.Text = "  ▼  " .. dropConfig.Name .. "  (" .. option .. ")"
                    open = false
                    for _, btn in pairs(itemButtons) do 
                        btn.Visible = false 
                    end
                    if dropConfig.Callback then dropConfig.Callback(option) end
                end)
                
                table.insert(itemButtons, OptBtn)
            end
            
            Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
            Card.Size = UDim2.new(0, 480, 0, Card.Size.Y.Offset + 46)
        end
        
        function CardAPI:AddSeparator()
            local Sep = Instance.new("Frame")
            Sep.Size = UDim2.new(0.9, 0, 0, 1.5)
            Sep.Position = UDim2.new(0.05, 0, 0, 0)
            Sep.BackgroundColor3 = Color3.fromHex("#A0A0A0")
            Sep.BackgroundTransparency = 0.6
            Sep.Parent = Content
            
            local SepPadding = Instance.new("UIPadding")
            SepPadding.PaddingTop = UDim.new(0, 6)
            SepPadding.PaddingBottom = UDim.new(0, 6)
            SepPadding.Parent = Sep
            
            Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
            Card.Size = UDim2.new(0, 480, 0, Card.Size.Y.Offset + 18)
        end
        
        function CardAPI:AddLabel(labelConfig)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 28)
            Label.BackgroundTransparency = 1
            Label.Text = labelConfig.Text
            Label.TextColor3 = Color3.fromHex(labelConfig.Color or "#A0A0A0")
            Label.TextSize = labelConfig.Size or 12
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Center
            Label.Parent = Content
            
            Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
            Card.Size = UDim2.new(0, 480, 0, Card.Size.Y.Offset + 36)
        end
        
        function CardAPI:AddTextbox(textConfig)
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Size = UDim2.new(1, 0, 0, 50)
            BoxFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            BoxFrame.BackgroundTransparency = 0.3
            BoxFrame.Parent = Content
            
            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Color3.fromHex("#A0A0A0")
            boxStroke.Thickness = 1
            boxStroke.Transparency = 0.5
            boxStroke.Parent = BoxFrame
            
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 8)
            BoxCorner.Parent = BoxFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -16, 0, 18)
            Label.Position = UDim2.new(0, 8, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Text = textConfig.Label
            Label.TextColor3 = Color3.fromRGB(200, 200, 210)
            Label.TextSize = 11
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = BoxFrame
            
            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -16, 0, 24)
            TextBox.Position = UDim2.new(0, 8, 1, -30)
            TextBox.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
            TextBox.Text = textConfig.Placeholder or ""
            TextBox.TextColor3 = Color3.fromRGB(230, 230, 240)
            TextBox.TextSize = 12
            TextBox.Font = Enum.Font.FredokaOne
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = BoxFrame
            
            local textStroke = Instance.new("UIStroke")
            textStroke.Color = Color3.fromHex("#A0A0A0")
            textStroke.Thickness = 1
            textStroke.Transparency = 0.5
            textStroke.Parent = TextBox
            
            local TextCorner = Instance.new("UICorner")
            TextCorner.CornerRadius = UDim.new(0, 6)
            TextCorner.Parent = TextBox
            
            TextBox.FocusLost:Connect(function()
                if textConfig.Callback then
                    textConfig.Callback(TextBox.Text)
                    createSparkle(TextBox, UDim2.fromScale(0.5, 0.5))
                end
            end)
            
            Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
            Card.Size = UDim2.new(0, 480, 0, Card.Size.Y.Offset + 58)
        end
        
        updateContainerSize()
        table.insert(DeckSystem.Cards, Card)
        return CardAPI
    end
    
    function DeckSystem:ClearAllCards()
        for _, card in pairs(DeckSystem.Cards) do
            if card and card.Parent then
                local fadeOut = TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, (math.random(0, 2) == 0 and -200 or 200), 0, card.Position.Y.Offset)
                })
                fadeOut:Play()
                fadeOut.Completed:Connect(function()
                    card:Destroy()
                end)
            end
        end
        task.wait(0.3)
        DeckSystem.Cards = {}
        currentYOffset = 10
        updateContainerSize()
    end
    
    local function toggleWindowState(minimize)
        if minimize then
            TweenService:Create(MainDeckContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, -260, 1.2, 0)
            }):Play()
            task.wait(0.2)
            IslandHub.Visible = true
            IslandHub.Position = islandSavedPos
            TweenService:Create(IslandHub, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = islandSavedPos
            }):Play()
        else
            TweenService:Create(IslandHub, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, -130, 0, -60)
            }):Play()
            task.wait(0.3)
            IslandHub.Visible = false
            TweenService:Create(MainDeckContainer, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -260, 0.5, -240)
            }):Play()
        end
    end
    
    MinimizeButton.MouseButton1Click:Connect(function() 
        createSparkle(MinimizeButton, UDim2.fromScale(0.5, 0.5))
        toggleWindowState(true) 
    end)
    
    IslandHub.MouseButton1Click:Connect(function() 
        toggleWindowState(false) 
    end)
    
    CloseButton.MouseButton1Click:Connect(function() 
        createSparkle(CloseButton, UDim2.fromScale(0.5, 0.5))
        PromptModal.Visible = true 
    end)
    
    return DeckSystem
end

function zaz.new()
    local self = setmetatable({}, zaz)
    self.Deck = zaz:CreateWindow({ Name = "zaz" })
    self.Cards = {}
    
    function self:CreateCard(config)
        local card = self.Deck:CreateCard(config)
        table.insert(self.Cards, card)
        return card
    end
    
    function self:ClearDeck()
        self.Deck:ClearAllCards()
        self.Cards = {}
    end
    
    return self
end

return zaz
