-- zaz UI Framework Core Engine
local zaz = {}
zaz.__index = zaz

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Universal stroke styling rules
local function applyStroke(parent)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromHex("#808080")
    stroke.Thickness = 1.5 
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- Touch motion press animation handler (Glow & Flick Effect)
local function applyTouchFlick(instance, isLiquidGlass)
    instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local originalColor = instance.BackgroundColor3
            
            -- Glow styling definition (Lighter highlight color mix for glass)
            local glowColor = isLiquidGlass and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(80, 80, 80)
            
            -- Flick action sequence
            TweenService:Create(instance, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = glowColor
            }):Play()
            
            local releaseConn
            releaseConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    TweenService:Create(instance, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        BackgroundColor3 = originalColor
                    }):Play()
                    releaseConn:Disconnect()
                end
            end)
        end
    end)
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

    -- 2. iOS Island Style Minimized Hub
    local IslandHub = Instance.new("TextButton")
    IslandHub.Name = "IslandHub"
    IslandHub.Size = UDim2.new(0, 140, 0, 32)
    IslandHub.Position = UDim2.new(0.5, -70, 0, -50)
    IslandHub.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    IslandHub.BackgroundTransparency = 0.35
    IslandHub.Text = "zaz // expand"
    IslandHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    IslandHub.Font = Enum.Font.FredokaOne
    IslandHub.TextSize = 12
    IslandHub.Visible = false
    IslandHub.Parent = ZazUI
    applyStroke(IslandHub)

    local IslandCorner = Instance.new("UICorner")
    IslandCorner.CornerRadius = UDim.new(0, 12)
    IslandCorner.Parent = IslandHub
    
    local islandLocked = false
    local islandDragging = false
    local islandDragInput
    local islandDragStart
    local islandSavedPos = UDim2.new(0.5, -70, 0, 15)

    local LockBubble = Instance.new("TextButton")
    LockBubble.Name = "LockBubble"
    LockBubble.Size = UDim2.new(0, 16, 0, 16)
    LockBubble.Position = UDim2.new(1, -22, 0.5, -8)
    LockBubble.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    LockBubble.Text = "U"
    LockBubble.TextColor3 = Color3.fromRGB(255, 255, 255)
    LockBubble.TextSize = 10
    LockBubble.Font = Enum.Font.FredokaOne
    LockBubble.Parent = IslandHub

    LockBubble.MouseButton1Click:Connect(function()
        islandLocked = not islandLocked
        LockBubble.Text = islandLocked and "L" or "U"
        LockBubble.BackgroundColor3 = islandLocked and Color3.fromHex("#808080") or Color3.fromRGB(40, 40, 40)
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
            IslandHub.Position = UDim2.new(islandSavedPos.X.Scale, islandSavedPos.X.Offset + delta.X, islandSavedPos.Y.Scale, islandSavedPos.Y.Offset + delta.Y)
        end
    end)

    -- 3. Main Window Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 520, 0, 340) 
    MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BackgroundTransparency = 0.35 
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ZazUI
    applyStroke(MainFrame)

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    -- 4. Header Panel
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Header.BackgroundTransparency = 0.4
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16 
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    -- Minimize & Close Window Buttons
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
    MinimizeButton.Position = UDim2.new(1, -64, 0.5, -12)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    MinimizeButton.BackgroundTransparency = 0.3
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinimizeButton.TextSize = 14
    MinimizeButton.Font = Enum.Font.FredokaOne
    MinimizeButton.Parent = Header
    applyStroke(MinimizeButton)
    applyTouchFlick(MinimizeButton, true)

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 4)
    MinCorner.Parent = MinimizeButton

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Position = UDim2.new(1, -34, 0.5, -12)
    CloseButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    CloseButton.BackgroundTransparency = 0.3
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.FredokaOne
    CloseButton.Parent = Header
    applyStroke(CloseButton)
    applyTouchFlick(CloseButton, true)

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = CloseButton

    -- 5. Slideable Horizontal Navigation Window Bar (Top)
    local Navbar = Instance.new("ScrollingFrame")
    Navbar.Name = "Navbar"
    Navbar.Size = UDim2.new(1, -24, 0, 36)
    Navbar.Position = UDim2.new(0, 12, 0, 55) 
    Navbar.BackgroundTransparency = 1
    Navbar.ScrollBarThickness = 0
    Navbar.ScrollingDirection = Enum.ScrollingDirection.X
    Navbar.ElasticBehavior = Enum.ElasticBehavior.Always
    Navbar.Parent = MainFrame

    local NavbarLayout = Instance.new("UIListLayout")
    NavbarLayout.FillDirection = Enum.FillDirection.Horizontal
    NavbarLayout.Padding = UDim.new(0, 8)
    NavbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavbarLayout.Parent = Navbar

    -- 6. Content Container System Floor (Main Center Panel)
    local ContainerPanel = Instance.new("Frame")
    ContainerPanel.Name = "ContainerPanel"
    ContainerPanel.Size = UDim2.new(1, -24, 1, -115) 
    ContainerPanel.Position = UDim2.new(0, 12, 0, 100) 
    ContainerPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ContainerPanel.BackgroundTransparency = 0.5
    ContainerPanel.Parent = MainFrame
    applyStroke(ContainerPanel)

    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 6)
    ContainerCorner.Parent = ContainerPanel

    -- 7. Prompt Modal Setup
    local PromptModal = Instance.new("Frame")
    PromptModal.Name = "PromptModal"
    PromptModal.Size = UDim2.new(0, 280, 0, 140)
    PromptModal.Position = UDim2.new(0.5, -140, 0.5, -70)
    PromptModal.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    PromptModal.BackgroundTransparency = 0.25
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

    local CancelBtn = Instance.new("TextButton")
    CancelBtn.Size = UDim2.new(0, 115, 0, 32)
    CancelBtn.Position = UDim2.new(0, 18, 1, -44)
    CancelBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    CancelBtn.BackgroundTransparency = 0.3
    CancelBtn.Text = "Cancel"
    CancelBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    CancelBtn.TextSize = 13
    CancelBtn.Font = Enum.Font.FredokaOne
    CancelBtn.ZIndex = 21
    CancelBtn.Parent = PromptModal
    applyStroke(CancelBtn)
    applyTouchFlick(CancelBtn, true)

    local ConfirmBtn = Instance.new("TextButton")
    ConfirmBtn.Size = UDim2.new(0, 115, 0, 32)
    ConfirmBtn.Position = UDim2.new(1, -133, 1, -44)
    ConfirmBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 20)
    ConfirmBtn.BackgroundTransparency = 0.3
    ConfirmBtn.Text = "Unload"
    ConfirmBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    ConfirmBtn.TextSize = 13
    ConfirmBtn.Font = Enum.Font.FredokaOne
    ConfirmBtn.ZIndex = 21
    ConfirmBtn.Parent = PromptModal
    applyStroke(ConfirmBtn)
    applyTouchFlick(ConfirmBtn, true)

    CancelBtn.MouseButton1Click:Connect(function() PromptModal.Visible = false end)
    ConfirmBtn.MouseButton1Click:Connect(function() ZazUI:Destroy() end)

    local WindowState = {
        Tabs = {},
        CurrentTabIdx = 1,
        ContainerPanel = ContainerPanel,
        Navbar = Navbar
    }

    local function evaluateNavbarInteractions()
        local count = #WindowState.Tabs
        if count <= 3 then
            Navbar.ScrollingDirection = Enum.ScrollingDirection.None
        else
            Navbar.ScrollingDirection = Enum.ScrollingDirection.X
        end
    end

    NavbarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Navbar.CanvasSize = UDim2.new(0, NavbarLayout.AbsoluteContentSize.X + 10, 0, 0)
        evaluateNavbarInteractions()
    end)

    local function toggleWindowState(minimize)
        if minimize then
            MainFrame.Visible = false
            IslandHub.Visible = true
        else
            IslandHub.Visible = false
            MainFrame.Visible = true
        end
    end

    MinimizeButton.MouseButton1Click:Connect(function() toggleWindowState(true) end)
    IslandHub.MouseButton1Click:Connect(function() toggleWindowState(false) end)
    CloseButton.MouseButton1Click:Connect(function() PromptModal.Visible = true end)

    -- TAB CREATION LOGIC ARCHITECTURE
    function WindowState:CreateTab(tabName)
        local tabIndex = #WindowState.Tabs + 1

        -- Main Page Vertical Scrolling Display Frame
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, -34, 1, -12) 
        TabContent.Position = UDim2.new(0, 6, 0, 6)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 0 
        TabContent.Visible = false
        TabContent.ScrollingDirection = Enum.ScrollingDirection.Y
        TabContent.Parent = ContainerPanel

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.FillDirection = Enum.FillDirection.Vertical
        ContentLayout.Padding = UDim.new(0, 6)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = TabContent

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 15)
        end)

        -- Dynamic Right-Side Track with Custom Guillemet Controls
        local ScrollTrack = Instance.new("Frame")
        ScrollTrack.Name = tabName .. "ScrollTrack"
        ScrollTrack.Size = UDim2.new(0, 22, 1, -12)
        ScrollTrack.Position = UDim2.new(1, -26, 0, 6)
        ScrollTrack.BackgroundTransparency = 1
        ScrollTrack.Visible = false
        ScrollTrack.Parent = ContainerPanel

        local UpScrollBtn = Instance.new("TextButton")
        UpScrollBtn.Size = UDim2.new(1, 0, 0, 22)
        UpScrollBtn.Position = UDim2.new(0, 0, 0, 0)
        UpScrollBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        UpScrollBtn.BackgroundTransparency = 0.3
        UpScrollBtn.Text = "«"
        UpScrollBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        UpScrollBtn.Font = Enum.Font.FredokaOne
        UpScrollBtn.TextSize = 12
        UpScrollBtn.Parent = ScrollTrack
        applyStroke(UpScrollBtn)
        applyTouchFlick(UpScrollBtn, true)

        local DownScrollBtn = Instance.new("TextButton")
        DownScrollBtn.Size = UDim2.new(1, 0, 0, 22)
        DownScrollBtn.Position = UDim2.new(0, 0, 1, -22)
        DownScrollBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        DownScrollBtn.BackgroundTransparency = 0.3
        DownScrollBtn.Text = "»"
        DownScrollBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        DownScrollBtn.Font = Enum.Font.FredokaOne
        DownScrollBtn.TextSize = 12
        DownScrollBtn.Parent = ScrollTrack
        applyStroke(DownScrollBtn)
        applyTouchFlick(DownScrollBtn, true)

        local scrollSpeed = 40
        UpScrollBtn.MouseButton1Click:Connect(function()
            local target = math.max(0, TabContent.CanvasPosition.Y - scrollSpeed)
            TweenService:Create(TabContent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, target)}):Play()
        end)

        DownScrollBtn.MouseButton1Click:Connect(function()
            local maxScroll = math.max(0, TabContent.CanvasSize.Y.Offset - TabContent.AbsoluteWindowSize.Y)
            local target = math.min(maxScroll, TabContent.CanvasPosition.Y + scrollSpeed)
            TweenService:Create(TabContent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, target)}):Play()
        end)

        -- Top Navbar Window Item Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Btn"
        TabButton.Size = UDim2.new(0, 110, 1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        TabButton.BackgroundTransparency = 0.4
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(160, 160, 160)
        TabButton.TextSize = 12
        TabButton.Font = Enum.Font.FredokaOne
        TabButton.Parent = Navbar
        applyStroke(TabButton)
        applyTouchFlick(TabButton, true)

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 4)
        TabBtnCorner.Parent = TabButton

        -- Dynamic expansion rule scaling for window matrices <= 3 instances
        TabButton.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and #WindowState.Tabs <= 3 then
                TweenService:Create(TabButton, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 125, 1, 0)
                }):Play()
                
                local dragTracker
                dragTracker = UserInputService.InputChanged:Connect(function(changedInput)
                    if changedInput.UserInputType == Enum.UserInputType.Touch or changedInput.UserInputType == Enum.UserInputType.MouseMovement then
                        local distance = (changedInput.Position - input.Position).X
                        if math.abs(distance) > 50 then
                            dragTracker:Disconnect()
                            TweenService:Create(TabButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 110, 1, 0)}):Play()
                            
                            local targetIdx = (distance > 0) and (tabIndex - 1) or (tabIndex + 1)
                            if WindowState.Tabs[targetIdx] then
                                WindowState.Tabs[targetIdx].Select()
                            end
                        end
                    end
                end)
                
                local endTracker
                endTracker = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if dragTracker then dragTracker:Disconnect() end
                        endTracker:Disconnect()
                        TweenService:Create(TabButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 110, 1, 0)}):Play()
                    end
                end)
            end
        end)

        local function selectThisTab()
            for _, t in pairs(WindowState.Tabs) do
                t.Content.Visible = false
                t.Track.Visible = false
                TweenService:Create(t.Button, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(160, 160, 160), BackgroundColor3 = Color3.fromRGB(26, 26, 26)}):Play()
            end
            TabContent.Visible = true
            ScrollTrack.Visible = true
            WindowState.CurrentTabIdx = tabIndex
            TweenService:Create(TabButton, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end

        TabButton.MouseButton1Click:Connect(selectThisTab)
        table.insert(WindowState.Tabs, {Button = TabButton, Content = TabContent, Track = ScrollTrack, Select = selectThisTab})
        
        evaluateNavbarInteractions()
        if #WindowState.Tabs == 1 then selectThisTab() end

        -- Component Factory
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
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Btn.BackgroundTransparency = 0.3
            Btn.Text = "  " .. btnConfig.Name
            Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            Btn.TextSize = 13
            Btn.Font = Enum.Font.FredokaOne
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = TabContent
            applyStroke(Btn)
            applyTouchFlick(Btn, true)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 4)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                if btnConfig.Callback then btnConfig.Callback() end
            end)
        end

        function TabMethods:CreateToggle(toggleConfig)
            local toggled = toggleConfig.CurrentValue or false

            local TglFrame = Instance.new("TextButton")
            TglFrame.Size = UDim2.new(1, 0, 0, 36)
            TglFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            TglFrame.BackgroundTransparency = 0.3
            TglFrame.Text = "  " .. toggleConfig.Name
            TglFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
            TglFrame.TextSize = 13
            TglFrame.Font = Enum.Font.FredokaOne
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            TglFrame.Parent = TabContent
            applyStroke(TglFrame)
            applyTouchFlick(TglFrame, true)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 4)
            Corner.Parent = TglFrame

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 16, 0, 16)
            Indicator.Position = UDim2.new(1, -26, 0.5, -8)
            Indicator.BackgroundColor3 = toggled and Color3.fromHex("#808080") or Color3.fromRGB(40, 40, 40)
            Indicator.Parent = TglFrame
            applyStroke(Indicator)

            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(0, 4)
            IndCorner.Parent = Indicator

            TglFrame.MouseButton1Click:Connect(function()
                toggled = not toggled
                local targetColor = toggled and Color3.fromHex("#808080") or Color3.fromRGB(40, 40, 40)
                TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
                if toggleConfig.Callback then toggleConfig.Callback(toggled) end
            end)
        end

        function TabMethods:CreateSlider(sliderConfig)
            local min = sliderConfig.Range[1]
            local max = sliderConfig.Range[2]
            local current = sliderConfig.CurrentValue or min

            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(1, 0, 0, 46)
            SldFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            SldFrame.BackgroundTransparency = 0.3
            SldFrame.Parent = TabContent
            applyStroke(SldFrame)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 4)
            Corner.Parent = SldFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -70, 0, 20)
            Label.Position = UDim2.new(0, 12, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Text = sliderConfig.Name
            Label.TextColor3 = Color3.fromRGB(230, 230, 230)
            Label.TextSize = 13
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SldFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 60, 0, 20)
            ValueLabel.Position = UDim2.new(1, -72, 0, 4)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(current) .. (sliderConfig.Suffix or "")
            ValueLabel.TextColor3 = Color3.fromHex("#808080")
            ValueLabel.TextSize = 13
            ValueLabel.Font = Enum.Font.FredokaOne
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SldFrame

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -24, 0, 6)
            Track.Position = UDim2.new(0, 12, 1, -12)
            Track.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Track.Text = ""
            Track.Parent = SldFrame
            applyStroke(Track)
            applyTouchFlick(Track, true)

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(0, 3)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((current - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromHex("#808080")
            Fill.BorderSizePixel = 0
            Fill.Parent = Track

            local holding = false

            local function updateSlider(input)
                local percentage = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local rawValue = min + (percentage * (max - min))
                local increment = sliderConfig.Increment or 1
                current = math.round(rawValue / increment) * increment
                current = math.clamp(current, min, max)

                TweenService:Create(Fill, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new((current - min)/(max - min), 0, 1, 0)}):Play()
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
            DropFrame.Size = UDim2.new(1, 0, 0, 36)
            DropFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            DropFrame.BackgroundTransparency = 0.3
            DropFrame.Text = "  " .. dropConfig.Name .. " (" .. (dropConfig.CurrentOption[1] or "None") .. ")"
            DropFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
            DropFrame.TextSize = 13
            DropFrame.Font = Enum.Font.FredokaOne
            DropFrame.TextXAlignment = Enum.TextXAlignment.Left
            DropFrame.Parent = TabContent
            applyStroke(DropFrame)
            applyTouchFlick(DropFrame, true)

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
                OptBtn.Size = UDim2.new(1, 0, 0, 28)
                OptBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
                OptBtn.BackgroundTransparency = 0.3
                OptBtn.Text = "    " .. option
                OptBtn.TextColor3 = Color3.fromRGB(190, 190, 190)
                OptBtn.TextSize = 12
                OptBtn.Font = Enum.Font.FredokaOne
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.Visible = false
                OptBtn.Parent = TabContent
                applyStroke(OptBtn)
                applyTouchFlick(OptBtn, true)

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

return zaz
