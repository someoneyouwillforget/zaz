-- zaz UI Framework Core Engine - Card Deck Edition
local zaz = {}
zaz.__index = zaz

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Helper function to apply thick universal stroke styling rules
local function applyStroke(parent, thickness, transparency)
    thickness = thickness or 2.5
    transparency = transparency or 0
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromHex("#808080")
    stroke.Thickness = thickness
    stroke.Transparency = transparency
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

function zaz:CreateWindow(config)
    local windowName = config.Name or "zaz"
    
    -- Main Core UI Layer
    local ZazUI = Instance.new("ScreenGui")
    ZazUI.Name = "ZazUniversalInterface"
    ZazUI.ResetOnSpawn = false
    ZazUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if gethui then ZazUI.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(ZazUI); ZazUI.Parent = game:GetService("CoreGui")
    else ZazUI.Parent = game:GetService("CoreGui") end

    -- Main Deck Frame (holds all cards)
    local MainDeck = Instance.new("Frame")
    MainDeck.Name = "MainDeck"
    MainDeck.Size = UDim2.new(0, 500, 0, 400)
    MainDeck.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainDeck.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainDeck.BorderSizePixel = 0
    MainDeck.BackgroundTransparency = 1
    MainDeck.Visible = false
    MainDeck.Parent = ZazUI
    
    -- Card Container (ScrollingFrame for cards)
    local CardContainer = Instance.new("ScrollingFrame")
    CardContainer.Name = "CardContainer"
    CardContainer.Size = UDim2.new(1, 0, 1, -50)
    CardContainer.Position = UDim2.new(0, 0, 0, 45)
    CardContainer.BackgroundTransparency = 1
    CardContainer.ScrollBarThickness = 4
    CardContainer.ScrollBarImageColor3 = Color3.fromHex("#808080")
    CardContainer.ScrollBarImageTransparency = 0.5
    CardContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    CardContainer.Parent = MainDeck
    
    local CardLayout = Instance.new("UIListLayout")
    CardLayout.FillDirection = Enum.FillDirection.Vertical
    CardLayout.Padding = UDim.new(0, 12)
    CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CardLayout.Parent = CardContainer
    
    local CardPadding = Instance.new("UIPadding")
    CardPadding.PaddingTop = UDim.new(0, 10)
    CardPadding.PaddingBottom = UDim.new(0, 10)
    CardPadding.PaddingLeft = UDim.new(0, 10)
    CardPadding.PaddingRight = UDim.new(0, 10)
    CardPadding.Parent = CardContainer
    
    -- Glass Island Hub (minimized state)
    local IslandHub = Instance.new("TextButton")
    IslandHub.Name = "IslandHub"
    IslandHub.Size = UDim2.fromOffset(260, 42)
    IslandHub.Position = UDim2.new(0.5, -130, 0, 40) 
    IslandHub.BackgroundColor3 = Color3.fromHex("#808080")
    IslandHub.BackgroundTransparency = 0.85
    IslandHub.Text = ""
    IslandHub.AutoButtonColor = false
    IslandHub.Visible = false
    IslandHub.Parent = ZazUI
    
    local glassBorder = Instance.new("UIStroke")
    glassBorder.Color = Color3.fromHex("#808080")
    glassBorder.Transparency = 0.5
    glassBorder.Thickness = 1.5
    glassBorder.Parent = IslandHub

    local IslandCorner = Instance.new("UICorner")
    IslandCorner.CornerRadius = UDim.new(0, 21)
    IslandCorner.Parent = IslandHub
    
    local islandTitle = Instance.new("TextLabel")
    islandTitle.Size = UDim2.fromScale(1, 1)
    islandTitle.BackgroundTransparency = 1
    islandTitle.Text = "⧉  zaz deck  ⧉"
    islandTitle.Font = Enum.Font.FredokaOne
    islandTitle.TextColor3 = Color3.fromHex("#808080")
    islandTitle.TextSize = 14
    islandTitle.Parent = IslandHub
    
    -- Separator Line (between cards and island)
    local Separator = Instance.new("Frame")
    Separator.Name = "Separator"
    Separator.Size = UDim2.new(0.8, 0, 0, 2)
    Separator.Position = UDim2.new(0.1, 0, 0, 0)
    Separator.BackgroundColor3 = Color3.fromHex("#808080")
    Separator.BackgroundTransparency = 0.6
    Separator.Visible = false
    Separator.Parent = MainDeck
    
    local islandLocked = false
    local islandDragging = false
    local islandDragInput
    local islandDragStart
    local islandSavedPos = UDim2.new(0.5, -130, 0, 40)

    local LockBubble = Instance.new("TextButton")
    LockBubble.Name = "LockBubble"
    LockBubble.Size = UDim2.fromOffset(18, 18)
    LockBubble.Position = UDim2.new(1, -26, 0.5, -9)
    LockBubble.BackgroundColor3 = Color3.fromHex("#808080")
    LockBubble.BackgroundTransparency = 0.4
    LockBubble.Text = "🔓"
    LockBubble.TextColor3 = Color3.fromHex("#808080")
    LockBubble.TextSize = 10
    LockBubble.Font = Enum.Font.FredokaOne
    LockBubble.Parent = IslandHub

    local BubbleCorner = Instance.new("UICorner")
    BubbleCorner.CornerRadius = UDim.new(1, 0)
    BubbleCorner.Parent = LockBubble
    
    local bubbleStroke = Instance.new("UIStroke")
    bubbleStroke.Color = Color3.fromHex("#808080")
    bubbleStroke.Transparency = 0.2
    bubbleStroke.Parent = LockBubble

    LockBubble.MouseButton1Click:Connect(function()
        islandLocked = not islandLocked
        LockBubble.Text = islandLocked and "🔒" or "🔓"
    end)

    IslandHub.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not islandLocked then
            islandDragging = true
            islandDragStart = input.Position
            islandSavedPos = IslandHub.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    islandDragging = false
                    islandSavedPos = IslandHub.Position 
                end
            end)
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
            local newPos = UDim2.new(
                islandSavedPos.X.Scale, 
                islandSavedPos.X.Offset + delta.X, 
                islandSavedPos.Y.Scale, 
                islandSavedPos.Y.Offset + delta.Y
            )
            TweenService:Create(IslandHub, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos}):Play()
        end
    end)

    -- Header with controls
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Header.BorderSizePixel = 0
    Header.Parent = MainDeck
    applyStroke(Header, 2.5, 0)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "📇  " .. windowName .. " deck"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16 
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
    MinimizeButton.Position = UDim2.new(1, -68, 0, 8.5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    MinimizeButton.Text = "🗕"
    MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinimizeButton.TextSize = 14
    MinimizeButton.Font = Enum.Font.FredokaOne
    MinimizeButton.Parent = Header
    applyStroke(MinimizeButton, 2, 0)

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 4)
    MinCorner.Parent = MinimizeButton

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -36, 0, 8.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    CloseButton.Text = "🗙"
    CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.FredokaOne
    CloseButton.Parent = Header
    applyStroke(CloseButton, 2, 0)

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton

    -- Prompt Modal
    local PromptModal = Instance.new("Frame")
    PromptModal.Name = "PromptModal"
    PromptModal.Size = UDim2.new(0, 300, 0, 150)
    PromptModal.Position = UDim2.new(0.5, -150, 0.5, -75)
    PromptModal.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    PromptModal.BorderSizePixel = 0
    PromptModal.ZIndex = 20
    PromptModal.Visible = false
    PromptModal.Parent = ZazUI
    applyStroke(PromptModal, 2.5, 0)

    local PromptCorner = Instance.new("UICorner")
    PromptCorner.CornerRadius = UDim.new(0, 8)
    PromptCorner.Parent = PromptModal

    local PromptTitle = Instance.new("TextLabel")
    PromptTitle.Size = UDim2.new(1, 0, 0, 45)
    PromptTitle.BackgroundTransparency = 1
    PromptTitle.Text = "Close Deck?"
    PromptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PromptTitle.TextSize = 16
    PromptTitle.Font = Enum.Font.FredokaOne
    PromptTitle.ZIndex = 21
    PromptTitle.Parent = PromptModal

    local PromptDesc = Instance.new("TextLabel")
    PromptDesc.Size = UDim2.new(1, -24, 0, 45)
    PromptDesc.Position = UDim2.new(0, 12, 0, 40)
    PromptDesc.BackgroundTransparency = 1
    PromptDesc.Text = "Remove all cards from the deck?"
    PromptDesc.TextColor3 = Color3.fromRGB(160, 160, 160)
    PromptDesc.TextSize = 12
    PromptDesc.Font = Enum.Font.FredokaOne
    PromptDesc.TextWrapped = true
    PromptDesc.ZIndex = 21
    PromptDesc.Parent = PromptModal

    local CancelBtn = Instance.new("TextButton")
    CancelBtn.Size = UDim2.new(0, 125, 0, 34)
    CancelBtn.Position = UDim2.new(0, 18, 1, -46)
    CancelBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    CancelBtn.Text = "Cancel"
    CancelBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    CancelBtn.TextSize = 13
    CancelBtn.Font = Enum.Font.FredokaOne
    CancelBtn.ZIndex = 21
    CancelBtn.Parent = PromptModal
    applyStroke(CancelBtn, 2, 0)

    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 4)
    CancelCorner.Parent = CancelBtn

    local ConfirmBtn = Instance.new("TextButton")
    ConfirmBtn.Size = UDim2.new(0, 125, 0, 34)
    ConfirmBtn.Position = UDim2.new(1, -143, 1, -46)
    ConfirmBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 20)
    ConfirmBtn.Text = "Clear Deck"
    ConfirmBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    ConfirmBtn.TextSize = 13
    ConfirmBtn.Font = Enum.Font.FredokaOne
    ConfirmBtn.ZIndex = 21
    ConfirmBtn.Parent = PromptModal
    applyStroke(ConfirmBtn, 2, 0)

    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 4)
    ConfirmCorner.Parent = ConfirmBtn

    CancelBtn.MouseButton1Click:Connect(function()
        PromptModal.Visible = false
    end)

    ConfirmBtn.MouseButton1Click:Connect(function()
        -- Clear all cards
        for _, card in pairs(CardContainer:GetChildren()) do
            if card:IsA("Frame") and card.Name:find("Card_") then
                card:Destroy()
            end
        end
        CardContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        PromptModal.Visible = false
    end)

    -- Splash Animation
    local IntroSplash = Instance.new("TextLabel")
    IntroSplash.Name = "IntroSplash"
    IntroSplash.Size = UDim2.fromScale(1, 1)
    IntroSplash.BackgroundTransparency = 1
    IntroSplash.Text = "zaz"
    IntroSplash.TextColor3 = Color3.fromHex("#808080") 
    IntroSplash.Font = Enum.Font.FredokaOne
    IntroSplash.TextSize = 44
    IntroSplash.AnchorPoint = Vector2.new(0.5, 0.5)
    IntroSplash.Position = UDim2.fromScale(0.5, 0.5)
    IntroSplash.ZIndex = 10
    IntroSplash.Parent = ZazUI

    task.spawn(function()
        task.wait(0.5)
        
        local startTime = tick()
        local totalDuration = 4.5
        
        while tick() - startTime < totalDuration do
            local elapsed = tick() - startTime
            local wave = math.sin(elapsed * math.pi * 1.8) 
            IntroSplash.TextSize = math.round(44 + (wave * 8))
            RunService.RenderStepped:Wait()
        end
        
        IntroSplash.TextSize = 75
        local fadeTween = TweenService:Create(IntroSplash, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1})
        fadeTween:Play()
        fadeTween.Completed:Wait()
        
        local viewSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
        local screenWidth = math.max(viewSize.X, 1)
        local screenHeight = math.max(viewSize.Y, 1)

        for i = 1, 20 do
            task.spawn(function()
                local sparkle = Instance.new("Frame")
                sparkle.Size = UDim2.fromOffset(math.random(3, 7), math.random(3, 7))
                sparkle.BackgroundColor3 = Color3.fromHex("#808080")
                sparkle.Position = UDim2.fromScale(0.5, 0.5)
                sparkle.AnchorPoint = Vector2.new(0.5, 0.5)
                sparkle.ZIndex = 11
                sparkle.Parent = ZazUI
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = sparkle

                local angle = math.rad(math.random(0, 360))
                local distance = math.random(50, 200)
                local targetX = 0.5 + (math.cos(angle) * (distance / screenWidth))
                local targetY = 0.5 + (math.sin(angle) * (distance / screenHeight))

                local fly = TweenService:Create(sparkle, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
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
        IntroSplash:Destroy()
        
        -- Animate deck in
        local originalPos = MainDeck.Position
        MainDeck.Position = originalPos + UDim2.new(0, 0, 0, 50)
        MainDeck.Visible = true
        local slideUp = TweenService:Create(MainDeck, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = originalPos})
        slideUp:Play()
    end)

    -- Card System
    local DeckSystem = {
        Cards = {},
        Container = CardContainer,
        Layout = CardLayout,
        Separator = Separator,
        IslandHub = IslandHub,
        MainDeck = MainDeck
    }

    local function updateCanvasSize()
        task.wait()
        local totalHeight = 10
        for _, child in pairs(CardContainer:GetChildren()) do
            if child:IsA("Frame") and child.Name:find("Card_") then
                totalHeight = totalHeight + child.Size.Y.Offset + 12
            end
        end
        CardContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
    end

    local function toggleWindowState(minimize)
        if minimize then
            MainDeck:TweenPosition(UDim2.new(0.5, -250, 1.2, 0), "Out", "Quint", 0.4, true)
            task.wait(0.2)
            IslandHub.Visible = true
            IslandHub:TweenPosition(islandSavedPos, "Out", "Back", 0.4, true)
            Separator.Visible = false
        else
            IslandHub:TweenPosition(UDim2.new(0.5, -130, 0, -60), "In", "Quint", 0.3, true, function()
                IslandHub.Visible = false
            end)
            MainDeck:TweenPosition(UDim2.new(0.5, -250, 0.5, -200), "Out", "Quint", 0.4, true)
            Separator.Visible = true
        end
    end

    MinimizeButton.MouseButton1Click:Connect(function() toggleWindowState(true) end)
    IslandHub.MouseButton1Click:Connect(function() toggleWindowState(false) end)
    CloseButton.MouseButton1Click:Connect(function() PromptModal.Visible = true end)

    -- Card Creation API
    function DeckSystem:CreateCard(cardConfig)
        local cardName = cardConfig.Name or "Card"
        local cardColor = cardConfig.Color or Color3.fromRGB(22, 22, 22)
        
        -- Card Frame
        local Card = Instance.new("Frame")
        Card.Name = "Card_" .. cardName
        Card.Size = UDim2.new(1, -20, 0, cardConfig.Height or 120)
        Card.BackgroundColor3 = cardColor
        Card.BorderSizePixel = 0
        Card.Parent = CardContainer
        applyStroke(Card, 2, 0)
        
        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 8)
        CardCorner.Parent = Card
        
        -- Card Header (optional)
        if cardConfig.Title then
            local CardHeader = Instance.new("Frame")
            CardHeader.Name = "CardHeader"
            CardHeader.Size = UDim2.new(1, 0, 0, 35)
            CardHeader.BackgroundColor3 = Color3.fromRGB(cardColor.R * 0.8, cardColor.G * 0.8, cardColor.B * 0.8)
            CardHeader.BackgroundTransparency = 0.3
            CardHeader.BorderSizePixel = 0
            CardHeader.Parent = Card
            
            local HeaderCorner = Instance.new("UICorner")
            HeaderCorner.CornerRadius = UDim.new(0, 8)
            HeaderCorner.Parent = CardHeader
            
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
            
            local contentStart = 40
            Card.ContentStart = contentStart
        else
            Card.ContentStart = 10
        end
        
        -- Content Container
        local Content = Instance.new("Frame")
        Content.Name = "Content"
        Content.Size = UDim2.new(1, -20, 1, -(Card.ContentStart or 10) - 10)
        Content.Position = UDim2.new(0, 10, 0, Card.ContentStart or 10)
        Content.BackgroundTransparency = 1
        Content.Parent = Card
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.FillDirection = Enum.FillDirection.Vertical
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = Content
        
        local CardAPI = {}
        
        function CardAPI:AddButton(btnConfig)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Btn.Text = "  " .. (btnConfig.Icon or "▸") .. "  " .. btnConfig.Name
            Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            Btn.TextSize = 13
            Btn.Font = Enum.Font.FredokaOne
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = Content
            applyStroke(Btn, 1.5, 0)
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                local push = TweenService:Create(Btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), 
                    {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
                push:Play()
                push.Completed:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
                end)
                if btnConfig.Callback then btnConfig.Callback() end
            end)
            
            -- Update card height if needed
            Card.Size = UDim2.new(1, -20, 0, Card.Size.Y.Offset + 44)
            updateCanvasSize()
        end
        
        function CardAPI:AddToggle(toggleConfig)
            local toggled = toggleConfig.CurrentValue or false
            
            local TglFrame = Instance.new("TextButton")
            TglFrame.Size = UDim2.new(1, 0, 0, 40)
            TglFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            TglFrame.Text = "  " .. (toggleConfig.Icon or "☐") .. "  " .. toggleConfig.Name
            TglFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
            TglFrame.TextSize = 13
            TglFrame.Font = Enum.Font.FredokaOne
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            TglFrame.Parent = Content
            applyStroke(TglFrame, 1.5, 0)
            
            local TglCorner = Instance.new("UICorner")
            TglCorner.CornerRadius = UDim.new(0, 6)
            TglCorner.Parent = TglFrame
            
            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 20, 0, 20)
            Indicator.Position = UDim2.new(1, -32, 0.5, -10)
            Indicator.BackgroundColor3 = toggled and Color3.fromHex("#808080") or Color3.fromRGB(40, 40, 40)
            Indicator.Parent = TglFrame
            applyStroke(Indicator, 1.5, 0)
            
            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(0, 4)
            IndCorner.Parent = Indicator
            
            local function updateToggle()
                local targetColor = toggled and Color3.fromHex("#808080") or Color3.fromRGB(40, 40, 40)
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                if toggleConfig.Callback then toggleConfig.Callback(toggled) end
            end
            
            TglFrame.MouseButton1Click:Connect(function()
                toggled = not toggled
                TglFrame.Text = "  " .. (toggled and "☒" or "☐") .. "  " .. toggleConfig.Name
                updateToggle()
            end)
            
            Card.Size = UDim2.new(1, -20, 0, Card.Size.Y.Offset + 48)
            updateCanvasSize()
        end
        
        function CardAPI:AddSlider(sliderConfig)
            local min = sliderConfig.Range[1]
            local max = sliderConfig.Range[2]
            local current = sliderConfig.CurrentValue or min
            
            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(1, 0, 0, 65)
            SldFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            SldFrame.Parent = Content
            applyStroke(SldFrame, 1.5, 0)
            
            local SldCorner = Instance.new("UICorner")
            SldCorner.CornerRadius = UDim.new(0, 6)
            SldCorner.Parent = SldFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -70, 0, 22)
            Label.Position = UDim2.new(0, 12, 0, 8)
            Label.BackgroundTransparency = 1
            Label.Text = sliderConfig.Name
            Label.TextColor3 = Color3.fromRGB(230, 230, 230)
            Label.TextSize = 13
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SldFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 70, 0, 22)
            ValueLabel.Position = UDim2.new(1, -82, 0, 8)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(current) .. (sliderConfig.Suffix or "")
            ValueLabel.TextColor3 = Color3.fromHex("#808080")
            ValueLabel.TextSize = 12
            ValueLabel.Font = Enum.Font.FredokaOne
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SldFrame
            
            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -24, 0, 8)
            Track.Position = UDim2.new(0, 12, 1, -18)
            Track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Track.Text = ""
            Track.Parent = SldFrame
            applyStroke(Track, 1, 0)
            
            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(0, 4)
            TrackCorner.Parent = Track
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((current - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromHex("#808080")
            Fill.BorderSizePixel = 0
            Fill.Parent = Track
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 4)
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
            
            Card.Size = UDim2.new(1, -20, 0, Card.Size.Y.Offset + 73)
            updateCanvasSize()
        end
        
        function CardAPI:AddDropdown(dropConfig)
            local DropFrame = Instance.new("TextButton")
            DropFrame.Size = UDim2.new(1, 0, 0, 40)
            DropFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            DropFrame.Text = "  ▼  " .. dropConfig.Name .. "  (" .. (dropConfig.CurrentOption or dropConfig.Options[1] or "None") .. ")"
            DropFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
            DropFrame.TextSize = 13
            DropFrame.Font = Enum.Font.FredokaOne
            DropFrame.TextXAlignment = Enum.TextXAlignment.Left
            DropFrame.Parent = Content
            applyStroke(DropFrame, 1.5, 0)
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 6)
            DropCorner.Parent = DropFrame
            
            local open = false
            local itemButtons = {}
            local dropdownHeight = 40
            
            DropFrame.MouseButton1Click:Connect(function()
                open = not open
                for _, btn in pairs(itemButtons) do
                    btn.Visible = open
                end
                if open then
                    dropdownHeight = 40 + (#dropConfig.Options * 34)
                    Card.Size = UDim2.new(1, -20, 0, Card.Size.Y.Offset + (#dropConfig.Options * 34))
                else
                    Card.Size = UDim2.new(1, -20, 0, Card.Size.Y.Offset - (#dropConfig.Options * 34))
                end
                updateCanvasSize()
            end)
            
            for i, option in pairs(dropConfig.Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 32)
                OptBtn.Position = UDim2.new(0, 0, 0, dropdownHeight + ((i-1) * 32))
                OptBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
                OptBtn.Text = "    •  " .. option
                OptBtn.TextColor3 = Color3.fromRGB(190, 190, 190)
                OptBtn.TextSize = 12
                OptBtn.Font = Enum.Font.FredokaOne
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.Visible = false
                OptBtn.Parent = Content
                applyStroke(OptBtn, 1, 0)
                
                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 4)
                OptCorner.Parent = OptBtn
                
                OptBtn.MouseButton1Click:Connect(function()
                    DropFrame.Text = "  ▼  " .. dropConfig.Name .. "  (" .. option .. ")"
                    open = false
                    for _, btn in pairs(itemButtons) do 
                        btn.Visible = false 
                    end
                    Card.Size = UDim2.new(1, -20, 0, Card.Size.Y.Offset - (#dropConfig.Options * 34))
                    updateCanvasSize()
                    if dropConfig.Callback then dropConfig.Callback(option) end
                end)
                
                table.insert(itemButtons, OptBtn)
            end
            
            Card.Size = UDim2.new(1, -20, 0, Card.Size.Y.Offset + 48)
            updateCanvasSize()
        end
        
        function CardAPI:AddSeparator()
            local Sep = Instance.new("Frame")
            Sep.Size = UDim2.new(1, 0, 0, 2)
            Sep.BackgroundColor3 = Color3.fromHex("#808080")
            Sep.BackgroundTransparency = 0.5
            Sep.Parent = Content
            
            local SepPadding = Instance.new("UIPadding")
            SepPadding.PaddingTop = UDim.new(0, 4)
            SepPadding.PaddingBottom = UDim.new(0, 4)
            SepPadding.Parent = Sep
            
            Card.Size = UDim2.new(1, -20, 0, Card.Size.Y.Offset + 14)
            updateCanvasSize()
        end
        
        function CardAPI:AddLabel(labelConfig)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundTransparency = 1
            Label.Text = labelConfig.Text
            Label.TextColor3 = Color3.fromHex(labelConfig.Color or "#808080")
            Label.TextSize = labelConfig.Size or 12
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Center
            Label.Parent = Content
            
            Card.Size = UDim2.new(1, -20, 0, Card.Size.Y.Offset + 38)
            updateCanvasSize()
        end
        
        function CardAPI:AddTextbox(textConfig)
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Size = UDim2.new(1, 0, 0, 50)
            BoxFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            BoxFrame.Parent = Content
            applyStroke(BoxFrame, 1.5, 0)
            
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 6)
            BoxCorner.Parent = BoxFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -16, 0, 20)
            Label.Position = UDim2.new(0, 8, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Text = textConfig.Label
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 11
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = BoxFrame
            
            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -16, 0, 24)
            TextBox.Position = UDim2.new(0, 8, 1, -30)
            TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            TextBox.Text = textConfig.Placeholder or ""
            TextBox.TextColor3 = Color3.fromRGB(230, 230, 230)
            TextBox.TextSize = 12
            TextBox.Font = Enum.Font.FredokaOne
            TextBox.ClearTextOnFocus = false
            TextBox.Parent = BoxFrame
            applyStroke(TextBox, 1, 0)
            
            local TextCorner = Instance.new("UICorner")
            TextCorner.CornerRadius = UDim.new(0, 4)
            TextCorner.Parent = TextBox
            
            TextBox.FocusLost:Connect(function(enterPressed)
                if textConfig.Callback then
                    textConfig.Callback(TextBox.Text)
                end
            end)
            
            Card.Size = UDim2.new(1, -20, 0, Card.Size.Y.Offset + 58)
            updateCanvasSize()
        end
        
        updateCanvasSize()
        table.insert(DeckSystem.Cards, Card)
        return CardAPI
    end
    
    function DeckSystem:ClearAllCards()
        for _, card in pairs(DeckSystem.Cards) do
            if card and card.Parent then
                card:Destroy()
            end
        end
        DeckSystem.Cards = {}
        updateCanvasSize()
    end
    
    -- Show/hide separator based on card presence
    local function updateSeparator()
        if #DeckSystem.Cards > 0 and not IslandHub.Visible then
            Separator.Visible = true
            Separator:TweenSize(UDim2.new(0.8, 0, 0, 2), "Out", "Quad", 0.3, true)
        else
            Separator.Visible = false
        end
    end
    
    -- Initial separator state
    updateSeparator()
    
    return DeckSystem
end

-- Wrapper for easy use
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
