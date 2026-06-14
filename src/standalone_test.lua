--!strict
-- zaz UI Framework - Complete Standalone Test
-- Copy-paste this entire script into your mobile executor

local zaz = {}
zaz.__index = zaz

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Helper function to apply liquid glass effect
local function applyLiquidGlass(parent, transparency, thickness)
    transparency = transparency or 0.85
    thickness = thickness or 2
    
    local blur = Instance.new("BlurEffect")
    blur.Size = 8
    blur.Parent = parent
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromHex("#A8A8A8")
    stroke.Thickness = thickness
    stroke.Transparency = 0.3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    
    return stroke
end

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
    
    local glow = Instance.new("UIGradient")
    glow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#808080"))
    })
    glow.Rotation = 45
    glow.Parent = sparkle
    
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

-- Glow effect for buttons
local function addGlow(element)
    local glowFrame = Instance.new("Frame")
    glowFrame.Size = UDim2.new(1, 8, 1, 8)
    glowFrame.Position = UDim2.new(0, -4, 0, -4)
    glowFrame.BackgroundColor3 = Color3.fromHex("#808080")
    glowFrame.BackgroundTransparency = 0.8
    glowFrame.ZIndex = element.ZIndex - 1
    glowFrame.Parent = element
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 8)
    glowCorner.Parent = glowFrame
    
    local glowStroke = Instance.new("UIStroke")
    glowStroke.Color = Color3.fromHex("#A8A8A8")
    glowStroke.Thickness = 2
    glowStroke.Transparency = 0.5
    glowStroke.Parent = glowFrame
    
    return glowFrame
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
    MainDeck.Size = UDim2.new(0, 520, 0, 480)
    MainDeck.Position = UDim2.new(0.5, -260, 0.5, -240)
    MainDeck.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    MainDeck.BackgroundTransparency = 0.05
    MainDeck.BorderSizePixel = 0
    MainDeck.Visible = false
    MainDeck.Parent = ZazUI
    
    local deckBlur = Instance.new("BlurEffect")
    deckBlur.Size = 12
    deckBlur.Parent = MainDeck
    
    -- Card Container
    local CardContainer = Instance.new("ScrollingFrame")
    CardContainer.Name = "CardContainer"
    CardContainer.Size = UDim2.new(1, 0, 1, -55)
    CardContainer.Position = UDim2.new(0, 0, 0, 50)
    CardContainer.BackgroundTransparency = 1
    CardContainer.ScrollBarThickness = 0
    CardContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    CardContainer.Parent = MainDeck
    
    local CardLayout = Instance.new("UIListLayout")
    CardLayout.FillDirection = Enum.FillDirection.Vertical
    CardLayout.Padding = UDim.new(0, 16)
    CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CardLayout.Parent = CardContainer
    CardLayout.Enabled = false
    
    local CardPadding = Instance.new("UIPadding")
    CardPadding.PaddingTop = UDim.new(0, 12)
    CardPadding.PaddingBottom = UDim.new(0, 12)
    CardPadding.PaddingLeft = UDim.new(0, 16)
    CardPadding.PaddingRight = UDim.new(0, 16)
    CardPadding.Parent = CardContainer
    
    -- Island Hub
    local IslandHub = Instance.new("TextButton")
    IslandHub.Name = "IslandHub"
    IslandHub.Size = UDim2.fromOffset(280, 48)
    IslandHub.Position = UDim2.new(0.5, -140, 0, 40) 
    IslandHub.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    IslandHub.BackgroundTransparency = 0.3
    IslandHub.Text = ""
    IslandHub.AutoButtonColor = false
    IslandHub.Visible = false
    IslandHub.Parent = ZazUI
    
    local islandBlur = Instance.new("BlurEffect")
    islandBlur.Size = 15
    islandBlur.Parent = IslandHub
    
    local islandStroke = Instance.new("UIStroke")
    islandStroke.Color = Color3.fromHex("#C0C0C0")
    islandStroke.Thickness = 1.5
    islandStroke.Transparency = 0.4
    islandStroke.Parent = IslandHub
    
    local islandGradient = Instance.new("UIGradient")
    islandGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    islandGradient.Rotation = 90
    islandGradient.Parent = IslandHub

    local IslandCorner = Instance.new("UICorner")
    IslandCorner.CornerRadius = UDim.new(0, 24)
    IslandCorner.Parent = IslandHub
    
    local islandTitle = Instance.new("TextLabel")
    islandTitle.Size = UDim2.fromScale(1, 1)
    islandTitle.BackgroundTransparency = 1
    islandTitle.Text = "⧉  zaz deck  ⧉"
    islandTitle.Font = Enum.Font.FredokaOne
    islandTitle.TextColor3 = Color3.fromRGB(200, 200, 220)
    islandTitle.TextSize = 14
    islandTitle.Parent = IslandHub
    
    -- Lock button
    local LockBubble = Instance.new("TextButton")
    LockBubble.Name = "LockBubble"
    LockBubble.Size = UDim2.fromOffset(24, 24)
    LockBubble.Position = UDim2.new(1, -34, 0.5, -12)
    LockBubble.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    LockBubble.BackgroundTransparency = 0.5
    LockBubble.Text = "U"
    LockBubble.TextColor3 = Color3.fromRGB(200, 200, 220)
    LockBubble.TextSize = 11
    LockBubble.Font = Enum.Font.FredokaOne
    LockBubble.Parent = IslandHub

    local BubbleCorner = Instance.new("UICorner")
    BubbleCorner.CornerRadius = UDim.new(1, 0)
    BubbleCorner.Parent = LockBubble
    
    local bubbleStroke = Instance.new("UIStroke")
    bubbleStroke.Color = Color3.fromHex("#A0A0A0")
    bubbleStroke.Thickness = 1
    bubbleStroke.Transparency = 0.3
    bubbleStroke.Parent = LockBubble

    local islandLocked = false
    local islandDragging = false
    local islandDragInput
    local islandDragStart
    local islandSavedPos = UDim2.new(0.5, -140, 0, 40)

    LockBubble.MouseButton1Click:Connect(function()
        islandLocked = not islandLocked
        LockBubble.Text = islandLocked and "L" or "U"
        createSparkle(LockBubble, UDim2.fromScale(0.5, 0.5))
    end)

    IslandHub.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not islandLocked then
            islandDragging = true
            islandDragStart = input.Position
            islandSavedPos = IslandHub.Position
            
            TweenService:Create(IslandHub, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    islandDragging = false
                    islandSavedPos = IslandHub.Position
                    TweenService:Create(IslandHub, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
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
            TweenService:Create(IslandHub, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos}):Play()
        end
    end)

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Header.BackgroundTransparency = 0.2
    Header.BorderSizePixel = 0
    Header.Parent = MainDeck
    
    local headerBlur = Instance.new("BlurEffect")
    headerBlur.Size = 10
    headerBlur.Parent = Header
    
    local headerStroke = Instance.new("UIStroke")
    headerStroke.Color = Color3.fromHex("#A0A0A0")
    headerStroke.Thickness = 1
    headerStroke.Transparency = 0.5
    headerStroke.Parent = Header

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
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
    MinimizeButton.Size = UDim2.new(0, 32, 0, 32)
    MinimizeButton.Position = UDim2.new(1, -72, 0, 9)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    MinimizeButton.BackgroundTransparency = 0.5
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 220)
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.FredokaOne
    MinimizeButton.Parent = Header
    
    local minStroke = Instance.new("UIStroke")
    minStroke.Color = Color3.fromHex("#A0A0A0")
    minStroke.Thickness = 1
    minStroke.Transparency = 0.4
    minStroke.Parent = MinimizeButton

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeButton
    
    local minGlow = addGlow(MinimizeButton)

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 32, 0, 32)
    CloseButton.Position = UDim2.new(1, -36, 0, 9)
    CloseButton.BackgroundColor3 = Color3.fromRGB(45, 35, 35)
    CloseButton.BackgroundTransparency = 0.5
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 150, 150)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.FredokaOne
    CloseButton.Parent = Header
    
    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = Color3.fromHex("#A0A0A0")
    closeStroke.Thickness = 1
    closeStroke.Transparency = 0.4
    closeStroke.Parent = CloseButton

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    local closeGlow = addGlow(CloseButton)

    -- Intro Splash
    local IntroSplash = Instance.new("TextLabel")
    IntroSplash.Name = "IntroSplash"
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
        
        MainDeck.Position = UDim2.new(0.5, -260, 1.2, 0)
        MainDeck.Visible = true
        local slideUp = TweenService:Create(MainDeck, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -260, 0.5, -240)
        })
        slideUp:Play()
    end)

    local DeckSystem = {
        Cards = {},
        Container = CardContainer,
        Layout = CardLayout,
        IslandHub = IslandHub,
        MainDeck = MainDeck
    }

    local function updateCanvasSize()
        task.wait()
        local totalHeight = 0
        for _, child in pairs(CardContainer:GetChildren()) do
            if child:IsA("Frame") and child.Name:find("Card_") then
                totalHeight = totalHeight + child.Size.Y.Offset + 16
            end
        end
        CardContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 30)
    end

    local function toggleWindowState(minimize)
        if minimize then
            TweenService:Create(MainDeck, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
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
                Position = UDim2.new(0.5, -140, 0, -60)
            }):Play()
            task.wait(0.3)
            IslandHub.Visible = false
            TweenService:Create(MainDeck, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
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
        ZazUI:Destroy()
    end)

    function DeckSystem:CreateCard(cardConfig)
        local cardName = cardConfig.Name or "Card"
        
        local Card = Instance.new("Frame")
        Card.Name = "Card_" .. cardName
        Card.Size = UDim2.new(1, -32, 0, cardConfig.Height or 100)
        Card.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        Card.BackgroundTransparency = 0.15
        Card.BorderSizePixel = 0
        Card.Parent = CardContainer
        
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
        
        local cardIndex = #DeckSystem.Cards
        local angleSpread = 12
        local angle = (cardIndex - 2) * angleSpread - angleSpread
        local xOffset = (cardIndex * 8)
        local yOffset = 20 + (cardIndex * 5)
        
        Card.Rotation = angle
        Card.Position = UDim2.new(0, -100, 0, yOffset)
        Card.BackgroundTransparency = 0.5
        
        local spreadIn = TweenService:Create(Card, TweenInfo.new(0.4 + (cardIndex * 0.05), Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, xOffset, 0, yOffset),
            BackgroundTransparency = 0.15
        })
        spreadIn:Play()
        
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
        
        local Content = Instance.new("Frame")
        Content.Name = "Content"
        Content.Size = UDim2.new(1, -20, 1, -(Card.ContentStart) - 10)
        Content.Position = UDim2.new(0, 10, 0, Card.ContentStart)
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
            Btn.Size = UDim2.new(1, 0, 0, 38)
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
            
            local btnGlow = addGlow(Btn)
            
            Btn.MouseButton1Click:Connect(function()
                createSparkle(Btn, UDim2.fromScale(0.5, 0.5))
                local push = TweenService:Create(Btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), 
                    {BackgroundTransparency = 0.1})
                push:Play()
                push.Completed:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.08), {BackgroundTransparency = 0.3}):Play()
                end)
                if btnConfig.Callback then btnConfig.Callback() end
            end)
            
            Card.Size = UDim2.new(1, -32, 0, Card.Size.Y.Offset + 46)
            updateCanvasSize()
        end
        
        function CardAPI:AddToggle(toggleConfig)
            local toggled = toggleConfig.CurrentValue or false
            
            local TglFrame = Instance.new("TextButton")
            TglFrame.Size = UDim2.new(1, 0, 0, 40)
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
            Indicator.Size = UDim2.new(0, 22, 0, 22)
            Indicator.Position = UDim2.new(1, -34, 0.5, -11)
            Indicator.BackgroundColor3 = toggled and Color3.fromHex("#808080") or Color3.fromRGB(50, 50, 60)
            Indicator.Parent = TglFrame
            
            local indStroke = Instance.new("UIStroke")
            indStroke.Color = Color3.fromHex("#A0A0A0")
            indStroke.Thickness = 1
            indStroke.Transparency = 0.4
            indStroke.Parent = Indicator
            
            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(0, 6)
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
            
            Card.Size = UDim2.new(1, -32, 0, Card.Size.Y.Offset + 48)
            updateCanvasSize()
        end
        
        function CardAPI:AddSlider(sliderConfig)
            local min = sliderConfig.Range[1]
            local max = sliderConfig.Range[2]
            local current = sliderConfig.CurrentValue or min
            
            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(1, 0, 0, 68)
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
            Label.Position = UDim2.new(0, 12, 0, 8)
            Label.BackgroundTransparency = 1
            Label.Text = sliderConfig.Name
            Label.TextColor3 = Color3.fromRGB(230, 230, 240)
            Label.TextSize = 13
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SldFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 70, 0, 22)
            ValueLabel.Position = UDim2.new(1, -82, 0, 8)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(current) .. (sliderConfig.Suffix or "")
            ValueLabel.TextColor3 = Color3.fromHex("#A0A0A0")
            ValueLabel.TextSize = 12
            ValueLabel.Font = Enum.Font.FredokaOne
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SldFrame
            
            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -24, 0, 6)
            Track.Position = UDim2.new(0, 12, 1, -18)
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
            
            Card.Size = UDim2.new(1, -32, 0, Card.Size.Y.Offset + 76)
            updateCanvasSize()
        end
        
        function CardAPI:AddDropdown(dropConfig)
            local DropFrame = Instance.new("TextButton")
            DropFrame.Size = UDim2.new(1, 0, 0, 40)
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
            
            DropFrame.MouseButton1Click:Connect(function()
                createSparkle(DropFrame, UDim2.fromScale(0.5, 0.5))
                open = not open
                for _, btn in pairs(itemButtons) do
                    btn.Visible = open
                end
                if open then
                    Card.Size = UDim2.new(1, -32, 0, Card.Size.Y.Offset + (#dropConfig.Options * 34))
                else
                    Card.Size = UDim2.new(1, -32, 0, Card.Size.Y.Offset - (#dropConfig.Options * 34))
                end
                updateCanvasSize()
            end)
            
            for i, option in pairs(dropConfig.Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 32)
                OptBtn.Position = UDim2.new(0, 0, 0, 40 + ((i-1) * 32))
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
                    Card.Size = UDim2.new(1, -32, 0, Card.Size.Y.Offset - (#dropConfig.Options * 34))
                    updateCanvasSize()
                    if dropConfig.Callback then dropConfig.Callback(option) end
                end)
                
                table.insert(itemButtons, OptBtn)
            end
            
            Card.Size = UDim2.new(1, -32, 0, Card.Size.Y.Offset + 48)
            updateCanvasSize()
        end
        
        function CardAPI:AddLabel(labelConfig)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 32)
            Label.BackgroundTransparency = 1
            Label.Text = labelConfig.Text
            Label.TextColor3 = Color3.fromHex(labelConfig.Color or "#A0A0A0")
            Label.TextSize = labelConfig.Size or 12
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Center
            Label.Parent = Content
            
            Card.Size = UDim2.new(1, -32, 0, Card.Size.Y.Offset + 40)
            updateCanvasSize()
        end
        
        function CardAPI:AddSeparator()
            local Sep = Instance.new("Frame")
            Sep.Size = UDim2.new(0.9, 0, 0, 1.5)
            Sep.Position = UDim2.new(0.05, 0, 0, 0)
            Sep.BackgroundColor3 = Color3.fromHex("#A0A0A0")
            Sep.BackgroundTransparency = 0.6
            Sep.Parent = Content
            
            Card.Size = UDim2.new(1, -32, 0, Card.Size.Y.Offset + 18)
            updateCanvasSize()
        end
        
        function CardAPI:AddTextbox(textConfig)
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Size = UDim2.new(1, 0, 0, 52)
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
            Label.Size = UDim2.new(1, -16, 0, 20)
            Label.Position = UDim2.new(0, 8, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Text = textConfig.Label
            Label.TextColor3 = Color3.fromRGB(200, 200, 210)
            Label.TextSize = 11
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = BoxFrame
            
            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(1, -16, 0, 26)
            TextBox.Position = UDim2.new(0, 8, 1, -32)
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
            
            TextBox.FocusLost:Connect(function(enterPressed)
                if textConfig.Callback then
                    textConfig.Callback(TextBox.Text)
                    createSparkle(TextBox, UDim2.fromScale(0.5, 0.5))
                end
            end)
            
            Card.Size = UDim2.new(1, -32, 0, Card.Size.Y.Offset + 60)
            updateCanvasSize()
        end
        
        updateCanvasSize()
        table.insert(DeckSystem.Cards, Card)
        return CardAPI
    end
    
    function DeckSystem:ClearAllCards()
        for _, card in pairs(DeckSystem.Cards) do
            if card and card.Parent then
                TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = UDim2.new(0, -100, 0, 0),
                    BackgroundTransparency = 1
                }):Play()
                task.wait(0.05)
                card:Destroy()
            end
        end
        DeckSystem.Cards = {}
        updateCanvasSize()
    end
    
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

-- =============================================
-- DEMO TEST
-- =============================================

print("[zaz] Standalone framework loaded!")

local UI = zaz.new()

-- Card 1: Components
local card1 = UI:CreateCard({
    Name = "Components",
    Title = "🎨 UI Components",
    Height = 80
})

card1:AddLabel({
    Text = "zaz Card Deck Framework",
    Color = "#E0E0E0",
    Size = 14
})

card1:AddSeparator()

card1:AddLabel({
    Text = "Click elements to test them",
    Color = "#A0A0A0",
    Size = 11
})

-- Card 2: Buttons
local card2 = UI:CreateCard({
    Name = "Buttons",
    Title = "🔘 Buttons",
    Height = 80
})

card2:AddButton({
    Name = "Test Button",
    Icon = "▶",
    Callback = function()
        print("[zaz] Button clicked!")
    end
})

card2:AddButton({
    Name = "Another Button",
    Icon = "⚙",
    Callback = function()
        print("[zaz] Second button clicked!")
    end
})

-- Card 3: Toggles
local card3 = UI:CreateCard({
    Name = "Toggles",
    Title = "◻ Toggles",
    Height = 80
})

card3:AddToggle({
    Name = "Enable Feature",
    Icon = "◻",
    CurrentValue = false,
    Callback = function(state)
        print("[zaz] Toggle: " .. (state and "ON" or "OFF"))
    end
})

-- Card 4: Sliders
local card4 = UI:CreateCard({
    Name = "Sliders",
    Title = "📊 Sliders",
    Height = 80
})

card4:AddSlider({
    Name = "Volume",
    Range = {0, 100},
    CurrentValue = 50,
    Suffix = "%",
    Increment = 5,
    Callback = function(value)
        print("[zaz] Volume: " .. value .. "%")
    end
})

-- Card 5: Dropdowns
local card5 = UI:CreateCard({
    Name = "Dropdowns",
    Title = "▼ Dropdowns",
    Height = 80
})

card5:AddDropdown({
    Name = "Theme",
    Options = {"Light", "Dark", "Neon"},
    CurrentOption = "Dark",
    Callback = function(option)
        print("[zaz] Theme: " .. option)
    end
})

-- Card 6: Textbox
local card6 = UI:CreateCard({
    Name = "Input",
    Title = "⌨️ Text Input",
    Height = 80
})

card6:AddTextbox({
    Label = "Enter text",
    Placeholder = "Type here...",
    Callback = function(text)
        print("[zaz] You entered: " .. text)
    end
})

-- Startup message
print("")
print("╔════════════════════════════════════╗")
print("║  zaz Card Deck UI - FULLY LOADED  ║")
print("║         Ready to use! ✓           ║")
print("╚════════════════════════════════════╝")
print("")

return UI
