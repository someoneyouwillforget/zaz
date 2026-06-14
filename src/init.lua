-- zaz UI Framework Core Engine
local zaz = {}
zaz.__index = zaz

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Helper function to apply thick universal stroke styling rules
local function applyStroke(parent)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromHex("#808080")
    stroke.Thickness = 2.5 
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

function zaz:CreateWindow(config)
    local windowName = config.Name or "zaz"
    
    -- 1. Main Core UI Layer
    local ZazUI = Instance.new("ScreenGui")
    ZazUI.Name = "ZazUniversalInterface"
    ZazUI.ResetOnSpawn = false
    ZazUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if gethui then ZazUI.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(ZazUI); ZazUI.Parent = game:GetService("CoreGui")
    else ZazUI.Parent = game:GetService("CoreGui") end

    -- 3. Shortened Window Frame (Reduced by 1.2% dynamically for better layout framing)
    local baseWidth = math.min(550, workspace.CurrentCamera.ViewportSize.X - 20)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, math.round(baseWidth * 0.988), 0, 290) 
    MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -145)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false -- Set to false initially to let the loading screen sequence run first
    MainFrame.Parent = ZazUI
    applyStroke(MainFrame)

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- 2. INTEGRATION: COMPACT GLASS ISLAND SYSTEM
    local IslandHub = Instance.new("TextButton")
    IslandHub.Name = "IslandHub"
    IslandHub.Size = UDim2.fromOffset(260, 38)
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
    glassBorder.Thickness = 1
    glassBorder.Parent = IslandHub

    local IslandCorner = Instance.new("UICorner")
    IslandCorner.CornerRadius = UDim.new(0, 19)
    IslandCorner.Parent = IslandHub
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.fromScale(1, 1)
    title.BackgroundTransparency = 1
    title.Text = "zaz says open sesame"
    title.Font = Enum.Font.FredokaOne
    title.TextColor3 = Color3.fromHex("#808080")
    title.TextSize = 13
    title.Parent = IslandHub
    
    local islandLocked = false
    local islandDragging = false
    local islandDragInput
    local islandDragStart
    local islandSavedPos = UDim2.new(0.5, -130, 0, 40)

    local LockBubble = Instance.new("TextButton")
    LockBubble.Name = "LockBubble"
    LockBubble.Size = UDim2.fromOffset(16, 16)
    LockBubble.Position = UDim2.new(1, -24, 0.5, -8)
    LockBubble.BackgroundColor3 = Color3.fromHex("#808080")
    LockBubble.BackgroundTransparency = 0.4
    LockBubble.Text = "U" 
    LockBubble.TextColor3 = Color3.fromHex("#808080")
    LockBubble.TextSize = 9
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
        LockBubble.Text = islandLocked and "L" or "U"
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

    -- 4. Expanded Header Panel
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    applyStroke(Header)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18 
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    -- 5. Control Window Buttons
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 26, 0, 26)
    MinimizeButton.Position = UDim2.new(1, -68, 0, 17)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.FredokaOne
    MinimizeButton.Parent = Header
    applyStroke(MinimizeButton)

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 4)
    MinCorner.Parent = MinimizeButton

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 26, 0, 26)
    CloseButton.Position = UDim2.new(1, -36, 0, 17)
    CloseButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.FredokaOne
    CloseButton.Parent = Header
    applyStroke(CloseButton)

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton

    -- 6. Swipeable Horizontal Navbar
    local Navbar = Instance.new("ScrollingFrame")
    Navbar.Name = "Navbar"
    Navbar.Size = UDim2.new(1, -24, 0, 38)
    Navbar.Position = UDim2.new(0, 12, 0, 75) 
    Navbar.BackgroundTransparency = 1
    Navbar.ScrollBarThickness = 0
    Navbar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Navbar.ScrollingDirection = Enum.ScrollingDirection.X
    Navbar.ElasticBehavior = Enum.ElasticBehavior.Always 
    Navbar.Parent = MainFrame

    local NavbarLayout = Instance.new("UIListLayout")
    NavbarLayout.FillDirection = Enum.FillDirection.Horizontal
    NavbarLayout.Padding = UDim.new(0, 6)
    NavbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavbarLayout.Parent = Navbar

    -- 7. Content Container Area
    local ContainerPanel = Instance.new("Frame")
    ContainerPanel.Name = "ContainerPanel"
    ContainerPanel.Size = UDim2.new(1, -26, 1, -140) 
    ContainerPanel.Position = UDim2.new(0, 12, 0, 123) 
    ContainerPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ContainerPanel.Parent = MainFrame
    applyStroke(ContainerPanel)

    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 6)
    ContainerCorner.Parent = ContainerPanel

    -- Compatibility Elements for your Test Script
    local zaz_separator = Instance.new("Frame")
    zaz_separator.Name = "zaz_separator"
    zaz_separator.Visible = false
    zaz_separator.Parent = MainFrame

    local zaz_arrow = Instance.new("TextLabel")
    zaz_arrow.Name = "zaz_arrow"
    zaz_arrow.Parent = MainFrame

    -- ==========================================
    -- INTEGRATION: ASYNC 7-SECOND SPLASH LABELS
    -- ==========================================
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
        task.wait(1.5)
        
        local startTime = os.clock()
        local totalDuration = 4.5
        
        while os.clock() - startTime < totalDuration do
            local elapsed = os.clock() - startTime
            local wave = math.sin(elapsed * math.pi * 1.8) 
            IntroSplash.TextSize = 44 + (wave * 8)
            game:GetService("RunService").RenderStepped:Wait()
        end
        
        IntroSplash.TextSize = 75
        local fadeTween = TweenService:Create(IntroSplash, TweenInfo.new(0.5, Enum.EasingStyle.QuadOut), {TextTransparency = 1})
        fadeTween:Play()
        
        for i = 1, 15 do
            task.spawn(function()
                local sparkle = Instance.new("Frame")
                sparkle.Size = UDim2.fromOffset(math.random(4, 8), math.random(4, 8))
                sparkle.BackgroundColor3 = Color3.fromHex("#808080")
                sparkle.Position = UDim2.fromScale(0.5, 0.5)
                sparkle.AnchorPoint = Vector2.new(0.5, 0.5)
                sparkle.ZIndex = 11
                sparkle.Parent = ZazUI
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = sparkle

                local angle = math.rad(math.random(0, 360))
                local distance = math.random(50, 150)
                local targetX = 0.5 + (math.cos(angle) * (distance / math.clamp(ZazUI.AbsoluteSize.X, 1, 9999)))
                local targetY = 0.5 + (math.sin(angle) * (distance / math.clamp(ZazUI.AbsoluteSize.Y, 1, 9999)))

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
        IntroSplash:Destroy()
        
        local originalPos = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -145)
        MainFrame.Position = originalPos + UDim2.new(0, 0, 0, 40)
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = originalPos}):Play()
    end)

    -- ==========================================
    -- ADDITION: PROMPT DIALOG EXIT PANEL MODAL
    -- ==========================================
    local PromptModal = Instance.new("Frame")
    PromptModal.Name = "PromptModal"
    PromptModal.Size = UDim2.new(0, 280, 0, 140)
    PromptModal.Position = UDim2.new(0.5, -140, 0.5, -70)
    PromptModal.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    PromptModal.BorderSizePixel = 0
    PromptModal.ZIndex = 20
    PromptModal.Visible = false
    PromptModal.Parent = ZazUI
    applyStroke(PromptModal)

    local PromptCorner = Instance.new("UICorner")
    PromptCorner.CornerRadius = UDim.new(0, 8)
    PromptCorner.Parent = PromptModal

    local PromptTitle = Instance.new("TextLabel")
    PromptTitle.Size = UDim2.new(1, 0, 0, 45)
    PromptTitle.BackgroundTransparency = 1
    PromptTitle.Text = "Close Interface?"
    PromptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PromptTitle.TextSize = 16
    PromptTitle.Font = Enum.Font.FredokaOne
    PromptTitle.ZIndex = 21
    PromptTitle.Parent = PromptModal

    local PromptDesc = Instance.new("TextLabel")
    PromptDesc.Size = UDim2.new(1, -24, 0, 35)
    PromptDesc.Position = UDim2.new(0, 12, 0, 40)
    PromptDesc.BackgroundTransparency = 1
    PromptDesc.Text = "This will completely unload the execution tree stack"
    PromptDesc.TextColor3 = Color3.fromRGB(160, 160, 160)
    PromptDesc.TextSize = 11
    PromptDesc.Font = Enum.Font.FredokaOne
    PromptDesc.TextWrapped = true
    PromptDesc.ZIndex = 21
    PromptDesc.Parent = PromptModal

    local CancelBtn = Instance.new("TextButton")
    CancelBtn.Size = UDim2.new(0, 115, 0, 32)
    CancelBtn.Position = UDim2.new(0, 18, 1, -44)
    CancelBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    CancelBtn.Text = "Cancel"
    CancelBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    CancelBtn.TextSize = 13
    CancelBtn.Font = Enum.Font.FredokaOne
    CancelBtn.ZIndex = 21
    CancelBtn.Parent = PromptModal
    applyStroke(CancelBtn)

    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 4)
    CancelCorner.Parent = CancelBtn

    local ConfirmBtn = Instance.new("TextButton")
    ConfirmBtn.Size = UDim2.new(0, 115, 0, 32)
    ConfirmBtn.Position = UDim2.new(1, -133, 1, -44)
    ConfirmBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 20)
    ConfirmBtn.Text = "Unload"
    ConfirmBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    ConfirmBtn.TextSize = 13
    ConfirmBtn.Font = Enum.Font.FredokaOne
    ConfirmBtn.ZIndex = 21
    ConfirmBtn.Parent = PromptModal
    applyStroke(ConfirmBtn)

    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 4)
    ConfirmCorner.Parent = ConfirmBtn

    CancelBtn.MouseButton1Click:Connect(function()
        PromptModal.Visible = false
    end)

    ConfirmBtn.MouseButton1Click:Connect(function()
        ZazUI:Destroy()
    end)

    -- =========================================================
    -- ADDITION: 2-MINUTE LOOP TRANSPARENT NOTIFIER SYSTEM
    -- =========================================================
    task.spawn(function()
        while true do
            task.wait(120)
            if not ZazUI or not ZazUI.Parent then break end
            
            local NotifFrame = Instance.new("Frame")
            NotifFrame.Name = "ZazDiscordNotification"
            NotifFrame.Size = UDim2.new(0, 240, 0, 65)
            NotifFrame.Position = UDim2.new(1, 30, 1, -185) 
            NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            NotifFrame.BackgroundTransparency = 0.35 
            NotifFrame.ZIndex = 30
            NotifFrame.Parent = ZazUI
            applyStroke(NotifFrame)

            local NotifCorner = Instance.new("UICorner")
            NotifCorner.CornerRadius = UDim.new(0, 6)
            NotifCorner.Parent = NotifFrame

            local NotifText = Instance.new("TextLabel")
            NotifText.Size = UDim2.new(1, -16, 0, 20)
            NotifText.Position = UDim2.new(0, 8, 0, 6)
            NotifText.BackgroundTransparency = 1
            NotifText.Text = "Join our support community!"
            NotifText.TextColor3 = Color3.fromRGB(220, 220, 220)
            NotifText.TextSize = 11
            NotifText.Font = Enum.Font.FredokaOne
            NotifText.ZIndex = 31
            NotifText.Parent = NotifFrame

            local HyperlinkBtn = Instance.new("TextButton")
            HyperlinkBtn.Size = UDim2.new(1, -16, 0, 26)
            HyperlinkBtn.Position = UDim2.new(0, 8, 1, -32)
            HyperlinkBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            HyperlinkBtn.BackgroundTransparency = 0.4
            HyperlinkBtn.Text = "zaz support server" 
            HyperlinkBtn.TextColor3 = Color3.fromRGB(114, 137, 218) 
            HyperlinkBtn.TextSize = 12
            HyperlinkBtn.Font = Enum.Font.FredokaOne
            HyperlinkBtn.ZIndex = 31
            HyperlinkBtn.Parent = NotifFrame
            applyStroke(HyperlinkBtn)

            local LinkCorner = Instance.new("UICorner")
            LinkCorner.CornerRadius = UDim.new(0, 4)
            LinkCorner.Parent = HyperlinkBtn

            HyperlinkBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard("https://discord.gg/EHUZgXysnq")
                end
                HyperlinkBtn.Text = "Link Copied!"
                task.wait(1.5)
                HyperlinkBtn.Text = "zaz support server"
            end)

            TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -260, 1, -185)}):Play()
            
            task.wait(10)
            
            local slideOut = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 30, 1, -185)})
            slideOut:Play()
            slideOut.Completed:Connect(function()
                NotifFrame:Destroy()
            end)
        end
    end)

    local WindowState = {
        Tabs = {},
        CurrentTab = nil,
        ContainerPanel = ContainerPanel,
        Navbar = Navbar
    }

    local function toggleWindowState(minimize)
        if minimize then
            MainFrame:TweenPosition(UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 1, 50), "Out", "Quint", 0.4, true)
            task.wait(0.2)
            IslandHub.Visible = true
            IslandHub:TweenPosition(islandSavedPos, "Out", "Back", 0.4, true) 
        else
            IslandHub:TweenPosition(UDim2.new(0.5, -130, 0, -50), "In", "Quint", 0.3, true, function()
                IslandHub.Visible = false
            end)
            MainFrame:TweenPosition(UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -145), "Out", "Quint", 0.4, true)
        end
    end

    MinimizeButton.MouseButton1Click:Connect(function() toggleWindowState(true) end)
    IslandHub.MouseButton1Click:Connect(function() toggleWindowState(false) end)
    
    CloseButton.MouseButton1Click:Connect(function() 
        PromptModal.Visible = true 
    end)

    -- TAB CREATION ENGINE
    function WindowState:CreateTab(tabName)
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Color3.fromHex("#808080")
        TabContent.Visible = false
        TabContent.Parent = ContainerPanel

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 6)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = TabContent

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 8)
        ContentPadding.PaddingLeft = UDim.new(0, 8)
        ContentPadding.PaddingRight = UDim.new(0, 8)
        ContentPadding.Parent = TabContent

        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Btn"
        TabButton.Size = UDim2.new(0, 110, 1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(160, 160, 160)
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.FredokaOne
        TabButton.Parent = Navbar
        applyStroke(TabButton)

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 4)
        TabBtnCorner.Parent = TabButton

        Navbar.CanvasSize = UDim2.new(0, NavbarLayout.AbsoluteContentSize.X + 25, 0, 0)

        local function selectThisTab()
            for _, t in pairs(WindowState.Tabs) do
                t.Content.Visible = false
                TweenService:Create(t.Button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(160, 160, 160), BackgroundColor3 = Color3.fromRGB(26, 26, 26)}):Play()
            end
            TabContent.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end

        TabButton.MouseButton1Click:Connect(selectThisTab)
        table.insert(WindowState.Tabs, {Button = TabButton, Content = TabContent})
        if #WindowState.Tabs == 1 then selectThisTab() end

        local TabMethods = {}

        function TabMethods:CreateSection(secName)
            local SecFrame = Instance.new("Frame")
            SecFrame.Size = UDim2.new(1, 0, 0, 24)
            SecFrame.BackgroundTransparency = 1
            SecFrame.Parent = TabContent

            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 1, 0)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Text = "— " .. secName .. " —"
            SecLabel.TextColor3 = Color3.fromHex("#808080")
            SecLabel.TextSize = 11
            SecLabel.Font = Enum.Font.FredokaOne
            SecLabel.Parent = SecFrame
        end

        function TabMethods:CreateButton(btnConfig)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 38)
            Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Btn.Text = "  " .. btnConfig.Name
            Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            Btn.TextSize = 13
            Btn.Font = Enum.Font.FredokaOne
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = TabContent
            applyStroke(Btn)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 4)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                local push = TweenService:Create(Btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
                push:Play()
                if btnConfig.Callback then btnConfig.Callback() end
            end)
        end

        function TabMethods:CreateToggle(toggleConfig)
            local toggled = toggleConfig.CurrentValue or false

            local TglFrame = Instance.new("TextButton")
            TglFrame.Size = UDim2.new(1, 0, 0, 38)
            TglFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            TglFrame.Text = "  " .. toggleConfig.Name
            TglFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
            TglFrame.TextSize = 13
            TglFrame.Font = Enum.Font.FredokaOne
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            TglFrame.Parent = TabContent
            applyStroke(TglFrame)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 4)
            Corner.Parent = TglFrame

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 18, 0, 18)
            Indicator.Position = UDim2.new(1, -28, 0.5, -9)
            Indicator.BackgroundColor3 = toggled and Color3.fromHex("#808080") or Color3.fromRGB(40, 40, 40)
            Indicator.Parent = TglFrame
            applyStroke(Indicator)

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
                updateToggle()
            end)
        end

        function TabMethods:CreateSlider(sliderConfig)
            local min = sliderConfig.Range[1]
            local max = sliderConfig.Range[2]
            local current = sliderConfig.CurrentValue or min

            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(1, 0, 0, 48)
            SldFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            SldFrame.Parent = TabContent
            applyStroke(SldFrame)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 4)
            Corner.Parent = SldFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -70, 0, 20)
            Label.Position = UDim2.new(0, 12, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = sliderConfig.Name
            Label.TextColor3 = Color3.fromRGB(230, 230, 230)
            Label.TextSize = 13
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SldFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 60, 0, 20)
            ValueLabel.Position = UDim2.new(1, -72, 0, 6)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(current) .. (sliderConfig.Suffix or "")
            ValueLabel.TextColor3 = Color3.fromHex("#808080")
            ValueLabel.TextSize = 13
            ValueLabel.Font = Enum.Font.FredokaOne
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SldFrame

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -24, 0, 8)
            Track.Position = UDim2.new(0, 12, 1, -14)
            Track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Track.Text = ""
            Track.Parent = SldFrame
            applyStroke(Track)

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(0, 3)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((current - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromHex("#808080")
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

                TweenService:Create(Fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new((current - min)/(max - min), 0, 1, 0)}):Play()
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
        end

        function TabMethods:CreateDropdown(dropConfig)
            local DropFrame = Instance.new("TextButton")
            DropFrame.Size = UDim2.new(1, 0, 0, 38)
            DropFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            DropFrame.Text = "  " .. dropConfig.Name .. " (" .. (dropConfig.CurrentOption[1] or "None") .. ")"
            DropFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
            DropFrame.TextSize = 13
            DropFrame.Font = Enum.Font.FredokaOne
            DropFrame.TextXAlignment = Enum.TextXAlignment.Left
            DropFrame.Parent = TabContent
            applyStroke(DropFrame)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 4)
            Corner.Parent = DropFrame

            local open = false
            local itemButtons = {}

            DropFrame.MouseButton1Click:Connect(function()
                open = not open
                for _, btn in pairs(itemButtons) do
                    btn.Visible = open
                end
            end)

            for _, option in pairs(dropConfig.Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
                OptBtn.Text = "    " .. option
                OptBtn.TextColor3 = Color3.fromRGB(190, 190, 190)
                OptBtn.TextSize = 12
                OptBtn.Font = Enum.Font.FredokaOne
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.Visible = false
                OptBtn.Parent = TabContent
                applyStroke(OptBtn)

                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 4)
                OptCorner.Parent = OptBtn

                OptBtn.MouseButton1Click:Connect(function()
                    DropFrame.Text = "  " .. dropConfig.Name .. " (" .. option .. ")"
                    open = false
                    for _, btn in pairs(itemButtons) do btn.Visible = false end
                    if dropConfig.Callback then dropConfig.Callback({option}) end
                end)

                table.insert(itemButtons, OptBtn)
            end
        end

        return TabMethods
    end

    return WindowState
end

-- ==========================================
-- WRAPPER COMPATIBILITY ENGINE FOR THE LOADER
-- ==========================================
function zaz.new()
    local self = setmetatable({}, zaz)
    
    local windowState = zaz:CreateWindow({ Name = "zaz universal" })
    
    self.Root = MainFrame
    self.DeckFrame = MainFrame
    self.IsOpen = false
    self.Cards = {}
    
    function self:Start()
        task.spawn(function()
            task.wait(7.1) -- Wait until the splash animation finishes
            if self.Cards then
                for _, card in ipairs(self.Cards) do
                    local newTab = windowState:CreateTab(card.Title or "Tab")
                    newTab:CreateSection(card.Title or "Section")
                end
            end
        end)
    end
    
    return self
end

return zaz
