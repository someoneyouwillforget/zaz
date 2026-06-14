local zaz = {}
zaz.__index = zaz

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Helper function to apply high-contrast sleek liquid glass rim reflections
local function applyStroke(parent, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = transparency or 0.45
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- Helper to apply a gloss overlay to simulate reflective liquid glass surface
local function applyGlossOverlay(parent, cornerRadius)
    local gloss = Instance.new("Frame")
    gloss.Name = "GlossOverlay"
    gloss.Size = UDim2.new(1, 0, 0.5, 0)
    gloss.Position = UDim2.new(0, 0, 0, 0)
    gloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    gloss.BorderSizePixel = 0
    gloss.ZIndex = parent.ZIndex + 2
    
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.82),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradient.Parent = gloss
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = gloss
    
    gloss.Parent = parent
    return gloss
end

-- Abstract Wavefront Splash Animation (No text, just pure liquid energy expansion)
local function createSplashEffect(element)
    local mousePos = UserInputService:GetMouseLocation()
    local elementPos = element.AbsolutePosition
    local relativeX = mousePos.X - elementPos.X
    local relativeY = (mousePos.Y - 36) - elementPos.Y -- Account for top-bar inset if necessary

    local wave = Instance.new("Frame")
    wave.Name = "WaveSplash"
    wave.AnchorPoint = Vector2.new(0.5, 0.5)
    wave.Position = UDim2.new(0, relativeX, 0, relativeY)
    wave.Size = UDim2.new(0, 0, 0, 0)
    wave.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    wave.BackgroundTransparency = 0.5
    wave.ZIndex = element.ZIndex + 3
    wave.Parent = element

    local waveCorner = Instance.new("UICorner")
    waveCorner.CornerRadius = UDim.new(1, 0)
    waveCorner.Parent = wave

    -- Calculate maximum expansion radius dynamically
    local targetSize = math.max(element.AbsoluteSize.X, element.AbsoluteSize.Y) * 2

    local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local anim = TweenService:Create(wave, tweenInfo, {
        Size = UDim2.new(0, targetSize, 0, targetSize),
        BackgroundTransparency = 1
    })
    anim:Play()
    anim.Completed:Connect(function()
        wave:Destroy()
    end)
end

function zaz:CreateWindow(config)
    local windowName = config.Name or "zaz"
    
    -- 1. Main Core UI Layer
    local ZazUI = Instance.new("ScreenGui")
    ZazUI.Name = "ZazUniversalInterface"
    ZazUI.ResetOnSpawn = false
    ZazUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ZazUI.IgnoreGuiInset = true

    if gethui then ZazUI.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(ZazUI); ZazUI.Parent = game:GetService("CoreGui")
    else ZazUI.Parent = game:GetService("CoreGui") end

    -- 2. iOS Island Style Minimized Hub
    local IslandHub = Instance.new("TextButton")
    IslandHub.Name = "IslandHub"
    IslandHub.Size = UDim2.new(0, 140, 0, 32)
    IslandHub.Position = UDim2.new(0.5, -70, 0, -50)
    IslandHub.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    IslandHub.BackgroundTransparency = 0.25 
    IslandHub.Text = "zaz // expand"
    IslandHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    IslandHub.Font = Enum.Font.FredokaOne
    IslandHub.TextSize = 12
    IslandHub.Visible = false
    IslandHub.Parent = ZazUI
    applyStroke(IslandHub)
    applyGlossOverlay(IslandHub, 16)

    local IslandCorner = Instance.new("UICorner")
    IslandCorner.CornerRadius = UDim.new(0, 16)
    IslandCorner.Parent = IslandHub
    
    local islandLocked = false
    local islandDragging = false
    local islandDragInput
    local islandDragStart
    local islandSavedPos = UDim2.new(0.5, -70, 0, 20)

    -- Lock Bubble
    local LockBubble = Instance.new("TextButton")
    LockBubble.Name = "LockBubble"
    LockBubble.Size = UDim2.new(0, 16, 0, 16)
    LockBubble.Position = UDim2.new(1, -22, 0.5, -8)
    LockBubble.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    LockBubble.BackgroundTransparency = 0.2
    LockBubble.Text = "U"
    LockBubble.TextColor3 = Color3.fromRGB(255, 255, 255)
    LockBubble.TextSize = 10
    LockBubble.Font = Enum.Font.FredokaOne
    LockBubble.ZIndex = IslandHub.ZIndex + 4
    LockBubble.Parent = IslandHub

    local BubbleCorner = Instance.new("UICorner")
    BubbleCorner.CornerRadius = UDim.new(1, 0)
    BubbleCorner.Parent = LockBubble

    LockBubble.MouseButton1Click:Connect(function()
        createSplashEffect(LockBubble)
        islandLocked = not islandLocked
        if islandLocked then
            LockBubble.Text = "L"
            LockBubble.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        else
            LockBubble.Text = "U"
            LockBubble.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
    end)

    -- Draggable Logic for IslandHub
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
            TweenService:Create(IslandHub, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos}):Play()
        end
    end)

    -- 3. Shortened Window Frame (Liquid Glass Finish)
    local baseWidth = math.min(550, workspace.CurrentCamera.ViewportSize.X - 20)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, math.round(baseWidth * 0.988), 0, 290) 
    MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -135)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    MainFrame.BackgroundTransparency = 0.22 
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    MainFrame.Parent = ZazUI
    applyStroke(MainFrame, 0.35)
    applyGlossOverlay(MainFrame, 16)

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    -- 4. Expanded Header Panel
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Header.BackgroundTransparency = 0.35
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    applyStroke(Header, 0.4)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 16)
    HeaderCorner.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 19 
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = Header.ZIndex + 3
    TitleLabel.Parent = Header

    -- 5. Control Window Buttons
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 26, 0, 26)
    MinimizeButton.Position = UDim2.new(1, -72, 0, 17)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    MinimizeButton.BackgroundTransparency = 0.3
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.FredokaOne
    MinimizeButton.ZIndex = Header.ZIndex + 3
    MinimizeButton.Parent = Header
    applyStroke(MinimizeButton)

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeButton

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 26, 0, 26)
    CloseButton.Position = UDim2.new(1, -38, 0, 17)
    CloseButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    CloseButton.BackgroundTransparency = 0.3
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.FredokaOne
    CloseButton.ZIndex = Header.ZIndex + 3
    CloseButton.Parent = Header
    applyStroke(CloseButton)

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
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
    NavbarLayout.Padding = UDim.new(0, 8)
    NavbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavbarLayout.Parent = Navbar

    -- 7. Content Container Area
    local ContainerPanel = Instance.new("Frame")
    ContainerPanel.Name = "ContainerPanel"
    ContainerPanel.Size = UDim2.new(1, -26, 1, -140) 
    ContainerPanel.Position = UDim2.new(0, 12, 0, 123) 
    ContainerPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ContainerPanel.BackgroundTransparency = 0.4
    ContainerPanel.Parent = MainFrame
    applyStroke(ContainerPanel, 0.5)

    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 12)
    ContainerCorner.Parent = ContainerPanel

    -- Animated Startup Intro
    local IntroSplash = Instance.new("TextLabel")
    IntroSplash.Name = "IntroSplash"
    IntroSplash.Size = UDim2.new(0, 200, 0, 50)
    IntroSplash.Position = UDim2.new(0.5, -100, 0.5, -25)
    IntroSplash.BackgroundTransparency = 1
    IntroSplash.Text = "zaz"
    IntroSplash.TextColor3 = Color3.fromRGB(255, 255, 255)
    IntroSplash.Font = Enum.Font.FredokaOne
    IntroSplash.TextSize = 48
    IntroSplash.TextTransparency = 1
    IntroSplash.ZIndex = 10
    IntroSplash.Parent = ZazUI

    task.spawn(function()
        TweenService:Create(IntroSplash, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, Position = UDim2.new(0.5, -100, 0.5, -45)}):Play()
        task.wait(1.2)
        TweenService:Create(IntroSplash, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1, Position = UDim2.new(0.5, -100, 0.5, -65)}):Play()
        task.wait(0.5)
        IntroSplash:Destroy()
        
        local originalPos = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -135)
        MainFrame.Position = originalPos + UDim2.new(0, 0, 0, 40)
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = originalPos}):Play()
    end)

    -- Prompt Dialog Exit Panel Modal
    local PromptModal = Instance.new("Frame")
    PromptModal.Name = "PromptModal"
    PromptModal.Size = UDim2.new(0, 280, 0, 140)
    PromptModal.Position = UDim2.new(0.5, -140, 0.5, -70)
    PromptModal.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    PromptModal.BackgroundTransparency = 0.2
    PromptModal.BorderSizePixel = 0
    PromptModal.ZIndex = 20
    PromptModal.Visible = false
    PromptModal.Parent = ZazUI
    applyStroke(PromptModal)
    applyGlossOverlay(PromptModal, 16)

    local PromptCorner = Instance.new("UICorner")
    PromptCorner.CornerRadius = UDim.new(0, 16)
    PromptCorner.Parent = PromptModal

    local PromptTitle = Instance.new("TextLabel")
    PromptTitle.Size = UDim2.new(1, 0, 0, 45)
    PromptTitle.BackgroundTransparency = 1
    PromptTitle.Text = "Close Interface?"
    PromptTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PromptTitle.TextSize = 16
    PromptTitle.Font = Enum.Font.FredokaOne
    PromptTitle.ZIndex = 23
    PromptTitle.Parent = PromptModal

    local PromptDesc = Instance.new("TextLabel")
    PromptDesc.Size = UDim2.new(1, -24, 0, 35)
    PromptDesc.Position = UDim2.new(0, 12, 0, 40)
    PromptDesc.BackgroundTransparency = 1
    PromptDesc.Text = "This will completely unload the execution tree stack"
    PromptDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    PromptDesc.TextSize = 11
    PromptDesc.Font = Enum.Font.FredokaOne
    PromptDesc.TextWrapped = true
    PromptDesc.ZIndex = 23
    PromptDesc.Parent = PromptModal

    local CancelBtn = Instance.new("TextButton")
    CancelBtn.Size = UDim2.new(0, 115, 0, 32)
    CancelBtn.Position = UDim2.new(0, 18, 1, -44)
    CancelBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CancelBtn.BackgroundTransparency = 0.3
    CancelBtn.Text = "Cancel"
    CancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CancelBtn.TextSize = 13
    CancelBtn.Font = Enum.Font.FredokaOne
    CancelBtn.ZIndex = 23
    CancelBtn.Parent = PromptModal
    applyStroke(CancelBtn)

    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 8)
    CancelCorner.Parent = CancelBtn

    local ConfirmBtn = Instance.new("TextButton")
    ConfirmBtn.Size = UDim2.new(0, 115, 0, 32)
    ConfirmBtn.Position = UDim2.new(1, -133, 1, -44)
    ConfirmBtn.BackgroundColor3 = Color3.fromRGB(80, 25, 25)
    ConfirmBtn.BackgroundTransparency = 0.3
    ConfirmBtn.Text = "Unload"
    ConfirmBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
    ConfirmBtn.TextSize = 13
    ConfirmBtn.Font = Enum.Font.FredokaOne
    ConfirmBtn.ZIndex = 23
    ConfirmBtn.Parent = PromptModal
    applyStroke(ConfirmBtn)

    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 8)
    ConfirmCorner.Parent = ConfirmBtn

    CancelBtn.MouseButton1Click:Connect(function()
        createSplashEffect(CancelBtn)
        PromptModal.Visible = false
    end)

    ConfirmBtn.MouseButton1Click:Connect(function()
        createSplashEffect(ConfirmBtn)
        task.wait(0.2)
        ZazUI:Destroy()
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
            IslandHub:TweenPosition(UDim2.new(0.5, -70, 0, -50), "In", "Quint", 0.3, true, function()
                IslandHub.Visible = false
            end)
            MainFrame:TweenPosition(UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -135), "Out", "Quint", 0.4, true)
        end
    end

    MinimizeButton.MouseButton1Click:Connect(function() createSplashEffect(MinimizeButton); task.wait(0.1); toggleWindowState(true) end)
    IslandHub.MouseButton1Click:Connect(function() createSplashEffect(IslandHub); task.wait(0.1); toggleWindowState(false) end)
    CloseButton.MouseButton1Click:Connect(function() createSplashEffect(CloseButton); PromptModal.Visible = true end)

    -- TAB CREATION ENGINE
    function WindowState:CreateTab(tabName)
        -- The primary scrolling layer container
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, -20, 1, 0) -- Carve room out for the manual scroll controller track
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 0 -- Default track hidden to use the native physical track build
        TabContent.Visible = false
        TabContent.Parent = ContainerPanel

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = TabContent

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 6)
        ContentPadding.Parent = TabContent

        -- 8. PHYSICAL GLASS SCROLLBAR SYSTEM (Right Edge Alignment)
        local ScrollTrackFrame = Instance.new("Frame")
        ScrollTrackFrame.Name = tabName .. "_ScrollTrack"
        ScrollTrackFrame.Size = UDim2.new(0, 16, 1, -8)
        ScrollTrackFrame.Position = UDim2.new(1, -18, 0, 4)
        ScrollTrackFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ScrollTrackFrame.BackgroundTransparency = 0.95
        ScrollTrackFrame.Visible = false
        ScrollTrackFrame.Parent = ContainerPanel
        local trackStroke = applyStroke(ScrollTrackFrame, 0.8)
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(0, 8)
        trackCorner.Parent = ScrollTrackFrame

        -- Top Scroll Button (Guillemet Up)
        local UpScrollBtn = Instance.new("TextButton")
        UpScrollBtn.Name = "UpScroll"
        UpScrollBtn.Size = UDim2.new(1, 0, 0, 16)
        UpScrollBtn.Position = UDim2.new(0, 0, 0, 0)
        UpScrollBtn.BackgroundTransparency = 1
        UpScrollBtn.Text = "«"
        UpScrollBtn.TextDirection = Enum.TextDirection.LeftToRight
        UpScrollBtn.Rotation = 90 -- Rotated to point upwards natively
        UpScrollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        UpScrollBtn.TextSize = 11
        UpScrollBtn.Font = Enum.Font.FredokaOne
        UpScrollBtn.Parent = ScrollTrackFrame

        -- Bottom Scroll Button (Guillemet Down)
        local DownScrollBtn = Instance.new("TextButton")
        DownScrollBtn.Name = "DownScroll"
        DownScrollBtn.Size = UDim2.new(1, 0, 0, 16)
        DownScrollBtn.Position = UDim2.new(0, 0, 1, -16)
        DownScrollBtn.BackgroundTransparency = 1
        DownScrollBtn.Text = "»"
        DownScrollBtn.Rotation = 90 -- Rotated to point downwards natively
        DownScrollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        DownScrollBtn.TextSize = 11
        DownScrollBtn.Font = Enum.Font.FredokaOne
        DownScrollBtn.Parent = ScrollTrackFrame

        -- Center Drag Thumb Node (Middle Track Node)
        local ScrollThumb = Instance.new("TextButton")
        ScrollThumb.Name = "Thumb"
        ScrollThumb.Size = UDim2.new(1, -2, 0, 30)
        ScrollThumb.Position = UDim2.new(0, 1, 0, 18)
        ScrollThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ScrollThumb.BackgroundTransparency = 0.55
        ScrollThumb.Text = ""
        ScrollThumb.Parent = ScrollTrackFrame
        local thumbStroke = applyStroke(ScrollThumb, 0.4)
        local thumbCorner = Instance.new("UICorner")
        thumbCorner.CornerRadius = UDim.new(0, 6)
        thumbCorner.Parent = ScrollThumb
        applyGlossOverlay(ScrollThumb, 6)

        -- Scroll Track Dynamic Synchronization Logic
        local function updateThumbPosition()
            local totalCanvas = TabContent.CanvasSize.Y.Offset
            if totalCanvas <= 0 then 
                totalCanvas = ContentLayout.AbsoluteContentSize.Y 
            end
            local containerHeight = TabContent.AbsoluteSize.Y
            local scrollRange = totalCanvas - containerHeight
            
            if scrollRange <= 0 then
                ScrollThumb.Visible = false
                return
            else
                ScrollThumb.Visible = true
            end

            local trackAvailableHeight = ScrollTrackFrame.AbsoluteSize.Y - 36 - ScrollThumb.AbsoluteSize.Y
            local currentRatio = TabContent.CanvasPosition.Y / scrollRange
            local newYOffset = 18 + (currentRatio * trackAvailableHeight)
            
            ScrollThumb.Position = UDim2.new(0, 1, 0, math.clamp(newYOffset, 18, ScrollTrackFrame.AbsoluteSize.Y - 18 - ScrollThumb.AbsoluteSize.Y))
        end

        TabContent:GetPropertyChangedSignal("CanvasPosition"):Connect(updateThumbPosition)
        TabContent:GetPropertyChangedSignal("CanvasSize"):Connect(updateThumbPosition)

        -- Up/Down Click Interactions
        UpScrollBtn.MouseButton1Click:Connect(function()
            TweenService:Create(TabContent, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {CanvasPosition = Vector2.new(0, math.max(0, TabContent.CanvasPosition.Y - 45))}):Play()
        end)

        DownScrollBtn.MouseButton1Click:Connect(function()
            local maxScroll = TabContent.CanvasSize.Y.Offset - TabContent.AbsoluteSize.Y
            if maxScroll <= 0 then maxScroll = ContentLayout.AbsoluteContentSize.Y - TabContent.AbsoluteSize.Y end
            TweenService:Create(TabContent, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {CanvasPosition = Vector2.new(0, math.min(maxScroll, TabContent.CanvasPosition.Y + 45))}):Play()
        end)

        -- Dragging the Middle Track Thumb Node directly
        local thumbDragging = false
        local thumbDragStart = 0
        local thumbStartPos = 0

        ScrollThumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                thumbDragging = true
                thumbDragStart = input.Position.Y
                thumbStartPos = ScrollThumb.Position.Y.Offset
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if thumbDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local deltaY = input.Position.Y - thumbDragStart
                local trackAvailableHeight = ScrollTrackFrame.AbsoluteSize.Y - 36 - ScrollThumb.AbsoluteSize.Y
                local newYOffset = math.clamp(thumbStartPos + deltaY, 18, ScrollTrackFrame.AbsoluteSize.Y - 18 - ScrollThumb.AbsoluteSize.Y)
                
                ScrollThumb.Position = UDim2.new(0, 1, 0, newYOffset)
                
                local percentage = (newYOffset - 18) / trackAvailableHeight
                local totalCanvas = ContentLayout.AbsoluteContentSize.Y
                local scrollRange = totalCanvas - TabContent.AbsoluteSize.Y
                TabContent.CanvasPosition = Vector2.new(0, percentage * scrollRange)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                thumbDragging = false
            end
        end)

        -- Tab Base Header Buttons
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Btn"
        TabButton.Size = UDim2.new(0, 110, 1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TabButton.BackgroundTransparency = 0.5
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(160, 160, 165)
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.FredokaOne
        TabButton.Parent = Navbar
        
        local tabStroke = applyStroke(TabButton, 0.6)
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = TabButton
        applyGlossOverlay(TabButton, 8)

        Navbar.CanvasSize = UDim2.new(0, NavbarLayout.AbsoluteContentSize.X + 25, 0, 0)

        local function selectThisTab()
            for _, t in pairs(WindowState.Tabs) do
                t.Content.Visible = false
                t.Track.Visible = false
                t.Stroke.Color = Color3.fromRGB(255, 255, 255)
                t.Stroke.Thickness = 1.5
                t.Stroke.Transparency = 0.6
                TweenService:Create(t.Button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(160, 160, 165), BackgroundTransparency = 0.5}):Play()
            end
            TabContent.Visible = true
            ScrollTrackFrame.Visible = true
            
            -- High Blooming Gloss Glow Configuration Execution Rules
            tabStroke.Color = Color3.fromRGB(255, 255, 255)
            tabStroke.Thickness = 2.5
            tabStroke.Transparency = 0 -- Blooming full neon refraction glow look
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.15}):Play()
            task.defer(function() 
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20) 
                updateThumbPosition()
            end)
        end

        TabButton.MouseButton1Click:Connect(function()
            createSplashEffect(TabButton)
            selectThisTab()
        end)
        
        table.insert(WindowState.Tabs, {Button = TabButton, Content = TabContent, Track = ScrollTrackFrame, Stroke = tabStroke})
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
            SecLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
            SecLabel.TextSize = 11
            SecLabel.Font = Enum.Font.FredokaOne
            SecLabel.Parent = SecFrame
            
            task.defer(function() TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20) end)
        end

        function TabMethods:CreateButton(btnConfig)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 38)
            Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Btn.BackgroundTransparency = 0.4
            Btn.Text = "  " .. btnConfig.Name
            Btn.TextColor3 = Color3.fromRGB(240, 240, 245)
            Btn.TextSize = 13
            Btn.Font = Enum.Font.FredokaOne
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = TabContent
            applyStroke(Btn, 0.5)
            applyGlossOverlay(Btn, 8)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 8)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                createSplashEffect(Btn)
                local push = TweenService:Create(Btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {BackgroundTransparency = 0.2})
                push:Play()
                if btnConfig.Callback then btnConfig.Callback() end
            end)
            
            task.defer(function() TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20) end)
        end

        function TabMethods:CreateToggle(toggleConfig)
            local toggled = toggleConfig.CurrentValue or false

            local TglFrame = Instance.new("TextButton")
            TglFrame.Size = UDim2.new(1, 0, 0, 38)
            TglFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            TglFrame.BackgroundTransparency = 0.4
            TglFrame.Text = "  " .. toggleConfig.Name
            TglFrame.TextColor3 = Color3.fromRGB(240, 240, 245)
            TglFrame.TextSize = 13
            TglFrame.Font = Enum.Font.FredokaOne
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            TglFrame.Parent = TabContent
            applyStroke(TglFrame, 0.5)
            applyGlossOverlay(TglFrame, 8)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 8)
            Corner.Parent = TglFrame

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 18, 0, 18)
            Indicator.Position = UDim2.new(1, -28, 0.5, -9)
            Indicator.BackgroundColor3 = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 65)
            Indicator.BackgroundTransparency = 0.2
            Indicator.ZIndex = TglFrame.ZIndex + 3
            Indicator.Parent = TglFrame
            local indicatorStroke = applyStroke(Indicator, 0.5)
            if toggled then indicatorStroke.Transparency = 0 end

            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(0, 6)
            IndCorner.Parent = Indicator

            local function updateToggle()
                local targetColor = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 65)
                local targetTransparency = toggled and 0 or 0.55
                local targetGlow = toggled and 2.5 or 1.5
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                TweenService:Create(indicatorStroke, TweenInfo.new(0.2), {Transparency = targetTransparency, Thickness = targetGlow}):Play()
                if toggleConfig.Callback then toggleConfig.Callback(toggled) end
            end

            TglFrame.MouseButton1Click:Connect(function()
                createSplashEffect(TglFrame)
                toggled = not toggled
                updateToggle()
            end)
            
            task.defer(function() TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20) end)
        end

        function TabMethods:CreateSlider(sliderConfig)
            local min = sliderConfig.Range[1]
            local max = sliderConfig.Range[2]
            local current = sliderConfig.CurrentValue or min

            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(1, 0, 0, 48)
            SldFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            SldFrame.BackgroundTransparency = 0.4
            SldFrame.Parent = TabContent
            applyStroke(SldFrame, 0.5)
            applyGlossOverlay(SldFrame, 8)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 8)
            Corner.Parent = SldFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -70, 0, 20)
            Label.Position = UDim2.new(0, 12, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = sliderConfig.Name
            Label.TextColor3 = Color3.fromRGB(240, 240, 245)
            Label.TextSize = 13
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = SldFrame.ZIndex + 3
            Label.Parent = SldFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 60, 0, 20)
            ValueLabel.Position = UDim2.new(1, -72, 0, 6)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(current) .. (sliderConfig.Suffix or "")
            ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueLabel.TextSize = 13
            ValueLabel.Font = Enum.Font.FredokaOne
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.ZIndex = SldFrame.ZIndex + 3
            ValueLabel.Parent = SldFrame

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -24, 0, 8)
            Track.Position = UDim2.new(0, 12, 1, -14)
            Track.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            Track.BackgroundTransparency = 0.3
            Track.Text = ""
            Track.ZIndex = SldFrame.ZIndex + 3
            Track.Parent = SldFrame
            applyStroke(Track, 0.6)

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(0, 4)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((current - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
            
            task.defer(function() TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20) end)
        end

        function TabMethods:CreateDropdown(dropConfig)
            local DropFrame = Instance.new("TextButton")
            DropFrame.Size = UDim2.new(1, 0, 0, 38)
            DropFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            DropFrame.BackgroundTransparency = 0.4
            DropFrame.Text = "  " .. dropConfig.Name .. " (" .. (dropConfig.CurrentOption[1] or "None") .. ")"
            DropFrame.TextColor3 = Color3.fromRGB(240, 240, 245)
            DropFrame.TextSize = 13
            DropFrame.Font = Enum.Font.FredokaOne
            DropFrame.TextXAlignment = Enum.TextXAlignment.Left
            DropFrame.Parent = TabContent
            applyStroke(DropFrame, 0.5)
            applyGlossOverlay(DropFrame, 8)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 8)
            Corner.Parent = DropFrame

            local open = false
            local itemButtons = {}

            DropFrame.MouseButton1Click:Connect(function()
                createSplashEffect(DropFrame)
                open = not open
                for _, btn in pairs(itemButtons) do
                    btn.Visible = open
                end
                task.wait(0.05)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            end)

            for _, option in pairs(dropConfig.Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 30)
                OptBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
                OptBtn.BackgroundTransparency = 0.4
                OptBtn.Text = "    " .. option
                OptBtn.TextColor3 = Color3.fromRGB(210, 210, 215)
                OptBtn.TextSize = 12
                OptBtn.Font = Enum.Font.FredokaOne
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.Visible = false
                OptBtn.Parent = TabContent
                applyStroke(OptBtn, 0.6)
                applyGlossOverlay(OptBtn, 6)

                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 6)
                OptCorner.Parent = OptBtn

                OptBtn.MouseButton1Click:Connect(function()
                    createSplashEffect(OptBtn)
                    DropFrame.Text = "  " .. dropConfig.Name .. " (" .. option .. ")"
                    open = false
                    for _, btn in pairs(itemButtons) do btn.Visible = false end
                    if dropConfig.Callback then dropConfig.Callback({option}) end
                    task.wait(0.05)
                    TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
                end)

                table.insert(itemButtons, OptBtn)
            end
            
            task.defer(function() TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20) end)
        end

        return TabMethods
    end

    return WindowState
end

return zaz

