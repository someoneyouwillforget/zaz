-- zaz UI Framework Core Engine
local zaz = {}
zaz.__index = zaz

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function applyStroke(parent, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1.5
    stroke.Transparency = transparency or 0.4
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function applyLiquidGloss(parent, cornerRadius)
    -- High-contrast upper reflection shine
    local glossTop = Instance.new("Frame")
    glossTop.Name = "LiquidGlossTop"
    glossTop.Size = UDim2.new(1, 0, 0.45, 0)
    glossTop.Position = UDim2.new(0, 0, 0, 0)
    glossTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glossTop.BorderSizePixel = 0
    glossTop.ZIndex = parent.ZIndex + 2
    
    local gradTop = Instance.new("UIGradient")
    gradTop.Rotation = 90
    gradTop.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.65),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradTop.Parent = gradTop
    
    local cornerTop = Instance.new("UICorner")
    cornerTop.CornerRadius = UDim.new(0, cornerRadius)
    cornerTop.Parent = glossTop
    glossTop.Parent = parent

    -- Sharp bottom rim highlight reflection
    local glossBottom = Instance.new("Frame")
    glossBottom.Name = "LiquidGlossBottom"
    glossBottom.Size = UDim2.new(1, 0, 0.1, 0)
    glossBottom.Position = UDim2.new(0, 0, 0.9, 0)
    glossBottom.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glossBottom.BorderSizePixel = 0
    glossBottom.ZIndex = parent.ZIndex + 2
    
    local gradBottom = Instance.new("UIGradient")
    gradBottom.Rotation = 270
    gradBottom.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradBottom.Parent = glossBottom
    
    local cornerBottom = Instance.new("UICorner")
    cornerBottom.CornerRadius = UDim.new(0, cornerRadius)
    cornerBottom.Parent = glossBottom
    glossBottom.Parent = parent
end

local function createSplashEffect(element)
    local mousePos = UserInputService:GetMouseLocation()
    local elementPos = element.AbsolutePosition
    local relativeX = mousePos.X - elementPos.X
    local relativeY = (mousePos.Y - 36) - elementPos.Y

    local wave = Instance.new("Frame")
    wave.Name = "WaveSplash"
    wave.AnchorPoint = Vector2.new(0.5, 0.5)
    wave.Position = UDim2.new(0, relativeX, 0, relativeY)
    wave.Size = UDim2.new(0, 0, 0, 0)
    wave.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    wave.BackgroundTransparency = 0.4
    wave.ZIndex = element.ZIndex + 4
    wave.Parent = element

    local waveCorner = Instance.new("UICorner")
    waveCorner.CornerRadius = UDim.new(1, 0)
    waveCorner.Parent = wave

    local targetSize = math.max(element.AbsoluteSize.X, element.AbsoluteSize.Y) * 2.2

    TweenService:Create(wave, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, targetSize, 0, targetSize),
        BackgroundTransparency = 1
    }):Play()
    
    task.delay(0.45, function() wave:Destroy() end)
end

function zaz:CreateWindow(config)
    local windowName = config.Name or "zaz"
    local initialPos = config.Position or UDim2.new(0.5, -270, 0.5, -135)
    
    local ZazUI = Instance.new("ScreenGui")
    ZazUI.Name = "ZazUI_" .. windowName
    ZazUI.ResetOnSpawn = false
    ZazUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ZazUI.IgnoreGuiInset = true

    if gethui then ZazUI.Parent = gethui()
    else ZazUI.Parent = game:GetService("CoreGui") end

    local baseWidth = 540
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, baseWidth, 0, 290) 
    MainFrame.Position = initialPos
    MainFrame.BackgroundColor3 = Color3.fromRGB(24, 26, 32)
    MainFrame.BackgroundTransparency = 0.15 
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ZazUI
    applyStroke(MainFrame, 2, 0.25)
    applyLiquidGloss(MainFrame, 16)

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame

    -- Press-down swelling physics logic
    local defaultSize = MainFrame.Size
    local expandedSize = UDim2.new(0, baseWidth * 1.03, 0, 290 * 1.03)

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = expandedSize}):Play()
        end
    end)

    MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Size = defaultSize}):Play()
        end
    end)

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 54)
    Header.BackgroundColor3 = Color3.fromRGB(32, 35, 45)
    Header.BackgroundTransparency = 0.3
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    applyStroke(Header, 1.5, 0.4)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 16)
    HeaderCorner.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = windowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18 
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = Header.ZIndex + 3
    TitleLabel.Parent = Header

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Position = UDim2.new(1, -36, 0, 15)
    CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    CloseButton.BackgroundTransparency = 0.3
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.FredokaOne
    CloseButton.ZIndex = Header.ZIndex + 3
    CloseButton.Parent = Header
    applyStroke(CloseButton)
    CloseButton.MouseButton1Click:Connect(function() createSplashEffect(CloseButton); task.wait(0.15); ZazUI:Destroy() end)

    local Navbar = Instance.new("ScrollingFrame")
    Navbar.Name = "Navbar"
    Navbar.Size = UDim2.new(1, -24, 0, 36)
    Navbar.Position = UDim2.new(0, 12, 0, 66) 
    Navbar.BackgroundTransparency = 1
    Navbar.ScrollBarThickness = 0
    Navbar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Navbar.ScrollingDirection = Enum.ScrollingDirection.X
    Navbar.Parent = MainFrame

    local NavbarLayout = Instance.new("UIListLayout")
    NavbarLayout.FillDirection = Enum.FillDirection.Horizontal
    NavbarLayout.Padding = UDim.new(0, 8)
    NavbarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavbarLayout.Parent = Navbar

    local ContainerPanel = Instance.new("Frame")
    ContainerPanel.Name = "ContainerPanel"
    ContainerPanel.Size = UDim2.new(1, -26, 1, -125) 
    ContainerPanel.Position = UDim2.new(0, 12, 0, 112) 
    ContainerPanel.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
    ContainerPanel.BackgroundTransparency = 0.35
    ContainerPanel.Parent = MainFrame
    applyStroke(ContainerPanel, 1.5, 0.4)

    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 12)
    ContainerCorner.Parent = ContainerPanel

    local WindowState = {
        Tabs = {},
        TabCount = 0,
        ContainerPanel = ContainerPanel,
        Navbar = Navbar,
        NavbarLayout = NavbarLayout
    }

    function WindowState:CreateTab(tabName)
        WindowState.TabCount = WindowState.TabCount + 1
        
        -- Apply swiping layout boundaries conditionally
        if WindowState.TabCount > 3 then
            Navbar.ScrollingEnabled = true
            Navbar.ElasticBehavior = Enum.ElasticBehavior.Always
        else
            Navbar.ScrollingEnabled = false
            Navbar.ElasticBehavior = Enum.ElasticBehavior.Never
        end

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, -20, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 0 
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

        local ScrollTrackFrame = Instance.new("Frame")
        ScrollTrackFrame.Name = tabName .. "_ScrollTrack"
        ScrollTrackFrame.Size = UDim2.new(0, 16, 1, -8)
        ScrollTrackFrame.Position = UDim2.new(1, -18, 0, 4)
        ScrollTrackFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ScrollTrackFrame.BackgroundTransparency = 0.96
        ScrollTrackFrame.Visible = false
        ScrollTrackFrame.Parent = ContainerPanel
        applyStroke(ScrollTrackFrame, 1, 0.8)
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(0, 8)
        trackCorner.Parent = ScrollTrackFrame

        local UpScrollBtn = Instance.new("TextButton")
        UpScrollBtn.Size = UDim2.new(1, 0, 0, 16)
        UpScrollBtn.BackgroundTransparency = 1
        UpScrollBtn.Text = "«"
        UpScrollBtn.Rotation = 90 
        UpScrollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        UpScrollBtn.TextSize = 11
        UpScrollBtn.Font = Enum.Font.FredokaOne
        UpScrollBtn.Parent = ScrollTrackFrame

        local DownScrollBtn = Instance.new("TextButton")
        DownScrollBtn.Size = UDim2.new(1, 0, 0, 16)
        DownScrollBtn.Position = UDim2.new(0, 0, 1, -16)
        DownScrollBtn.BackgroundTransparency = 1
        DownScrollBtn.Text = "»"
        DownScrollBtn.Rotation = 90 
        DownScrollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        DownScrollBtn.TextSize = 11
        DownScrollBtn.Font = Enum.Font.FredokaOne
        DownScrollBtn.Parent = ScrollTrackFrame

        local ScrollThumb = Instance.new("TextButton")
        ScrollThumb.Size = UDim2.new(1, -2, 0, 30)
        ScrollThumb.Position = UDim2.new(0, 1, 0, 18)
        ScrollThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ScrollThumb.BackgroundTransparency = 0.5
        ScrollThumb.Text = ""
        ScrollThumb.Parent = ScrollTrackFrame
        applyStroke(ScrollThumb, 1.5, 0.3)
        local thumbCorner = Instance.new("UICorner")
        thumbCorner.CornerRadius = UDim.new(0, 6)
        thumbCorner.Parent = ScrollThumb
        applyLiquidGloss(ScrollThumb, 6)

        local function updateThumbPosition()
            local totalCanvas = TabContent.CanvasSize.Y.Offset
            if totalCanvas <= 0 then totalCanvas = ContentLayout.AbsoluteContentSize.Y end
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

        UpScrollBtn.MouseButton1Click:Connect(function()
            TweenService:Create(TabContent, TweenInfo.new(0.2), {CanvasPosition = Vector2.new(0, math.max(0, TabContent.CanvasPosition.Y - 50))}):Play()
        end)

        DownScrollBtn.MouseButton1Click:Connect(function()
            local maxScroll = ContentLayout.AbsoluteContentSize.Y - TabContent.AbsoluteSize.Y
            TweenService:Create(TabContent, TweenInfo.new(0.2), {CanvasPosition = Vector2.new(0, math.min(maxScroll, TabContent.CanvasPosition.Y + 50))}):Play()
        end)

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
                local scrollRange = ContentLayout.AbsoluteContentSize.Y - TabContent.AbsoluteSize.Y
                TabContent.CanvasPosition = Vector2.new(0, percentage * scrollRange)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                thumbDragging = false
            end
        end)

        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Btn"
        TabButton.Size = UDim2.new(0, 110, 1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 42, 52)
        TabButton.BackgroundTransparency = 0.5
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(160, 160, 170)
        TabButton.TextSize = 12
        TabButton.Font = Enum.Font.FredokaOne
        TabButton.Parent = Navbar
        
        local tabStroke = applyStroke(TabButton, 1.5, 0.5)
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = TabButton
        applyLiquidGloss(TabButton, 8)

        local function recounter()
            local paddingOffset = (WindowState.TabCount - 1) * 8
            local calculatedWidth = (WindowState.TabCount * 110) + paddingOffset
            Navbar.CanvasSize = UDim2.new(0, calculatedWidth, 0, 0)
        end
        recounter()

        local function selectThisTab()
            for _, t in pairs(WindowState.Tabs) do
                t.Content.Visible = false
                t.Track.Visible = false
                t.Stroke.Color = Color3.fromRGB(255, 255, 255)
                t.Stroke.Thickness = 1.5
                t.Stroke.Transparency = 0.5
                TweenService:Create(t.Button, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(160, 160, 170), BackgroundTransparency = 0.5}):Play()
            end
            TabContent.Visible = true
            ScrollTrackFrame.Visible = true
            
            tabStroke.Color = Color3.fromRGB(255, 255, 255)
            tabStroke.Thickness = 2.5
            tabStroke.Transparency = 0 
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.15}):Play()
            task.defer(function() 
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20) 
                updateThumbPosition()
            end)
        end

        TabButton.MouseButton1Click:Connect(function() createSplashEffect(TabButton); selectThisTab() end)
        table.insert(WindowState.Tabs, {Button = TabButton, Content = TabContent, Track = ScrollTrackFrame, Stroke = tabStroke})
        if #WindowState.Tabs == 1 then selectThisTab() end

        local TabMethods = {}

        function TabMethods:CreateButton(btnConfig)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = Color3.fromRGB(48, 52, 64)
            Btn.BackgroundTransparency = 0.4
            Btn.Text = "  " .. btnConfig.Name
            Btn.TextColor3 = Color3.fromRGB(240, 240, 245)
            Btn.TextSize = 13
            Btn.Font = Enum.Font.FredokaOne
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.Parent = TabContent
            applyStroke(Btn, 1.5, 0.5)
            applyLiquidGloss(Btn, 8)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 8)
            Corner.Parent = Btn

            Btn.MouseButton1Click:Connect(function()
                createSplashEffect(Btn)
                if btnConfig.Callback then btnConfig.Callback() end
            end)
            task.defer(function() TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20) end)
        end

        function TabMethods:CreateToggle(toggleConfig)
            local toggled = toggleConfig.CurrentValue or false
            local TglFrame = Instance.new("TextButton")
            TglFrame.Size = UDim2.new(1, 0, 0, 36)
            TglFrame.BackgroundColor3 = Color3.fromRGB(48, 52, 64)
            TglFrame.BackgroundTransparency = 0.4
            TglFrame.Text = "  " .. toggleConfig.Name
            TglFrame.TextColor3 = Color3.fromRGB(240, 240, 245)
            TglFrame.TextSize = 13
            TglFrame.Font = Enum.Font.FredokaOne
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            TglFrame.Parent = TabContent
            applyStroke(TglFrame, 1.5, 0.5)
            applyLiquidGloss(TglFrame, 8)

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 16, 0, 16)
            Indicator.Position = UDim2.new(1, -26, 0.5, -8)
            Indicator.BackgroundColor3 = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(70, 75, 90)
            Indicator.BackgroundTransparency = 0.2
            Indicator.ZIndex = TglFrame.ZIndex + 3
            Indicator.Parent = TglFrame
            local indicatorStroke = applyStroke(Indicator, 1.5, 0.5)

            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(0, 5)
            IndCorner.Parent = Indicator

            local function updateToggle()
                local targetColor = toggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(70, 75, 90)
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                if toggleConfig.Callback then toggleConfig.Callback(toggled) end
            end

            TglFrame.MouseButton1Click:Connect(function() createSplashEffect(TglFrame); toggled = not toggled; updateToggle() end)
            task.defer(function() TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20) end)
        end

        function TabMethods:CreateSlider(sliderConfig)
            local min, max = sliderConfig.Range[1], sliderConfig.Range[2]
            local current = sliderConfig.CurrentValue or min

            local SldFrame = Instance.new("Frame")
            SldFrame.Size = UDim2.new(1, 0, 0, 46)
            SldFrame.BackgroundColor3 = Color3.fromRGB(48, 52, 64)
            SldFrame.BackgroundTransparency = 0.4
            SldFrame.Parent = TabContent
            applyStroke(SldFrame, 1.5, 0.5)
            applyLiquidGloss(SldFrame, 8)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -70, 0, 20)
            Label.Position = UDim2.new(0, 12, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Text = sliderConfig.Name
            Label.TextColor3 = Color3.fromRGB(240, 240, 245)
            Label.TextSize = 12
            Label.Font = Enum.Font.FredokaOne
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = SldFrame.ZIndex + 3
            Label.Parent = SldFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 60, 0, 20)
            ValueLabel.Position = UDim2.new(1, -72, 0, 4)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(current)
            ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueLabel.TextSize = 12
            ValueLabel.Font = Enum.Font.FredokaOne
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.ZIndex = SldFrame.ZIndex + 3
            ValueLabel.Parent = SldFrame

            local Track = Instance.new("TextButton")
            Track.Size = UDim2.new(1, -24, 0, 6)
            Track.Position = UDim2.new(0, 12, 1, -12)
            Track.BackgroundColor3 = Color3.fromRGB(70, 75, 90)
            Track.BackgroundTransparency = 0.3
            Track.Text = ""
            Track.ZIndex = SldFrame.ZIndex + 3
            Track.Parent = SldFrame

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((current - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Fill.BorderSizePixel = 0
            Fill.Parent = Track

            local holding = false
            local function updateSlider(input)
                local percentage = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                current = math.round(min + (percentage * (max - min)))
                Fill.Size = UDim2.new((current - min)/(max - min), 0, 1, 0)
                ValueLabel.Text = tostring(current)
                if sliderConfig.Callback then sliderConfig.Callback(current) end
            end

            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    holding = true; updateSlider(input)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if holding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then holding = false end
            end)
            task.defer(function() TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20) end)
        end

        return TabMethods
    end

    return WindowState
end

return zaz
