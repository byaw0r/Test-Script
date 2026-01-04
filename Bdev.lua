local BdevLib = {}

function BdevLib:CreateWindow(options)
    local window = {}
    
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    local Camera = workspace.CurrentCamera
    local ContextActionService = game:GetService("ContextActionService")
    
    local BdevUI = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local Dev = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local Window = Instance.new("Frame")
    local IconBtn = Instance.new("ImageButton")
    local UICorner_7 = Instance.new("UICorner")

    BdevUI.Name = "Bdev UI"
    BdevUI.Parent = player:WaitForChild("PlayerGui")
    BdevUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BdevUI.ResetOnSpawn = false

    Main.Name = "Main"
    Main.Parent = BdevUI
    Main.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.373697907, 0, 0.240938172, 0)
    Main.Size = UDim2.new(0, 193, 0, 242)
    Main.Visible = false

    UICorner.CornerRadius = UDim.new(0, 9)
    UICorner.Parent = Main

    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(0, 193, 0, 37)

    UICorner_2.CornerRadius = UDim.new(0, 9)
    UICorner_2.Parent = TopBar

    Dev.Name = "Dev"
    Dev.Parent = TopBar
    Dev.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dev.BackgroundTransparency = 1.000
    Dev.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Dev.BorderSizePixel = 0
    Dev.Size = UDim2.new(0, 96, 0, 37)

    TextLabel.Parent = Dev
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Position = UDim2.new(0.0729166642, 0, 0, 0)
    TextLabel.Size = UDim2.new(0, 186, 0, 37)
    TextLabel.Font = Enum.Font.Fondamento
    TextLabel.Text = options.Name or "Bdev"
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextSize = 30
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    Window.Name = "Window"
    Window.Parent = Main
    Window.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Window.BackgroundTransparency = 1.000
    Window.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Window.BorderSizePixel = 0
    Window.Position = UDim2.new(0, 0, 0.15289256, 0)
    Window.Size = UDim2.new(0, 193, 0, 205)

    IconBtn.Name = "IconBtn"
    IconBtn.Parent = BdevUI
    IconBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    IconBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    IconBtn.BorderSizePixel = 0
    IconBtn.Position = UDim2.new(0.21875, 0, 0.272921115, 0)
    IconBtn.Size = UDim2.new(0, 51, 0, 51)
    IconBtn.Image = "rbxassetid://136075515627576"

    UICorner_7.CornerRadius = UDim.new(1.5, 0)
    UICorner_7.Parent = IconBtn

    local draggingMain = false
    local draggingIcon = false
    
    local mainDragOffset = Vector2.new(0, 0)
    local iconDragOffset = Vector2.new(0, 0)
    
    local mainRenderConnection
    local iconRenderConnection
    
    local function blockCamera()
        if UserInputService.TouchEnabled then
            ContextActionService:BindAction(
                "BlockCameraWhileDragging",
                function() return Enum.ContextActionResult.Sink end,
                false,
                Enum.UserInputType.Touch
            )
            
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
            end
        end
    end
    
    local function unblockCamera()
        if UserInputService.TouchEnabled then
            ContextActionService:UnbindAction("BlockCameraWhileDragging")
        end
    end
    
    local function updateMainPosition()
        if draggingMain then
            local mousePos = UserInputService:GetMouseLocation()
            local screenSize = BdevUI.AbsoluteSize
            
            local newX = mousePos.X - mainDragOffset.X
            local newY = mousePos.Y - mainDragOffset.Y
            
            newX = math.clamp(newX, 0, screenSize.X - Main.AbsoluteSize.X)
            newY = math.clamp(newY, 0, screenSize.Y - Main.AbsoluteSize.Y)
            
            Main.Position = UDim2.new(0, newX, 0, newY)
        end
    end
    
    local function updateIconPosition()
        if draggingIcon then
            local mousePos = UserInputService:GetMouseLocation()
            local screenSize = BdevUI.AbsoluteSize
            
            local newX = mousePos.X - iconDragOffset.X
            local newY = mousePos.Y - iconDragOffset.Y
            
            newX = math.clamp(newX, 0, screenSize.X - IconBtn.AbsoluteSize.X)
            newY = math.clamp(newY, 0, screenSize.Y - IconBtn.AbsoluteSize.Y)
            
            IconBtn.Position = UDim2.new(0, newX, 0, newY)
        end
    end
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            if input.UserInputType == Enum.UserInputType.Touch then
                blockCamera()
            end
            
            local mousePos = UserInputService:GetMouseLocation()
            local elementPos = Main.AbsolutePosition
            mainDragOffset = Vector2.new(mousePos.X - elementPos.X, mousePos.Y - elementPos.Y)
            
            draggingMain = true
            
            if not mainRenderConnection then
                mainRenderConnection = RunService.RenderStepped:Connect(updateMainPosition)
            end
        end
    end)
    
    TopBar.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
            input.UserInputType == Enum.UserInputType.Touch) and draggingMain then
            draggingMain = false
            
            if mainRenderConnection then
                mainRenderConnection:Disconnect()
                mainRenderConnection = nil
            end
            
            if input.UserInputType == Enum.UserInputType.Touch then
                unblockCamera()
            end
        end
    end)
    
    IconBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            if input.UserInputType == Enum.UserInputType.Touch then
                blockCamera()
            end
            
            local mousePos = UserInputService:GetMouseLocation()
            local elementPos = IconBtn.AbsolutePosition
            iconDragOffset = Vector2.new(mousePos.X - elementPos.X, mousePos.Y - elementPos.Y)
            
            draggingIcon = true
            
            if not iconRenderConnection then
                iconRenderConnection = RunService.RenderStepped:Connect(updateIconPosition)
            end
        end
    end)
    
    IconBtn.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
            input.UserInputType == Enum.UserInputType.Touch) and draggingIcon then
            draggingIcon = false
            
            if iconRenderConnection then
                iconRenderConnection:Disconnect()
                iconRenderConnection = nil
            end
            
            if input.UserInputType == Enum.UserInputType.Touch then
                unblockCamera()
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if draggingMain and (input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch) then
            draggingMain = false
            
            if mainRenderConnection then
                mainRenderConnection:Disconnect()
                mainRenderConnection = nil
            end
            
            if input.UserInputType == Enum.UserInputType.Touch then
                unblockCamera()
            end
        end
        
        if draggingIcon and (input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch) then
            draggingIcon = false
            
            if iconRenderConnection then
                iconRenderConnection:Disconnect()
                iconRenderConnection = nil
            end
            
            if input.UserInputType == Enum.UserInputType.Touch then
                unblockCamera()
            end
        end
    end)

    local isOpen = false
    
    local function toggleMenu()
        isOpen = not isOpen
        Main.Visible = isOpen
    end
    
    IconBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            local startTime = tick()
            local startPos = input.Position
            local wasDragged = false
            
            local function onInputChanged()
                if not wasDragged then
                    local currentPos = UserInputService:GetMouseLocation()
                    local distance = (currentPos - startPos).Magnitude
                    if distance > 5 then
                        wasDragged = true
                    end
                end
            end
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    connection:Disconnect()
                    
                    local endTime = tick()
                    
                    if (endTime - startTime < 0.3) and not wasDragged then
                        toggleMenu()
                    end
                else
                    onInputChanged()
                end
            end)
        end
    end)

    local currentYOffset = 8

    function window:CreateButton(options)
        local Button = Instance.new("Frame")
        local UIListLayout_2 = Instance.new("UIListLayout")
        local UIPadding_2 = Instance.new("UIPadding")
        local ClickBtn = Instance.new("TextButton")
        local UICorner_6 = Instance.new("UICorner")
        local FunText = Instance.new("TextLabel")
        
        Button.Name = "Button"
        Button.Parent = Window
        Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Button.BackgroundTransparency = 1.000
        Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Button.BorderSizePixel = 0
        Button.Position = UDim2.new(0.00420162221, 0, 0, currentYOffset)
        Button.Size = UDim2.new(0, 192, 0, 27)

        UIListLayout_2.Parent = Button
        UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_2.Padding = UDim.new(0, 8)

        UIPadding_2.Parent = Button
        UIPadding_2.PaddingLeft = UDim.new(0.800000012, -12)

        ClickBtn.Name = "ClickBtn"
        ClickBtn.Parent = Button
        ClickBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ClickBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ClickBtn.BorderSizePixel = 0
        ClickBtn.Position = UDim2.new(-6.0550758e-07, 0, 0, 0)
        ClickBtn.Size = UDim2.new(0, 38, 0, 22)
        ClickBtn.Font = Enum.Font.SourceSans
        ClickBtn.Text = ""
        ClickBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        ClickBtn.TextSize = 14.000
        ClickBtn.AutoButtonColor = true

        UICorner_6.CornerRadius = UDim.new(1, 0)
        UICorner_6.Parent = ClickBtn

        FunText.Name = "FunText"
        FunText.Parent = ClickBtn
        FunText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        FunText.BackgroundTransparency = 1.000
        FunText.BorderColor3 = Color3.fromRGB(0, 0, 0)
        FunText.BorderSizePixel = 0
        FunText.Position = UDim2.new(-3.56926203, 0, -0.0389612354, 0)
        FunText.Size = UDim2.new(0, 72, 0, 20)
        FunText.Font = Enum.Font.Jura
        FunText.Text = options.Name or "Click"
        FunText.TextColor3 = Color3.fromRGB(255, 255, 255)
        FunText.TextScaled = true
        FunText.TextSize = 16
        FunText.TextWrapped = true

        local function handleButtonClick()
            if options.Callback then
                options.Callback()
            end
        end
        
        local function animateButtonColor()
            local originalColor = Color3.fromRGB(255, 255, 255)
            local greenColor = Color3.fromRGB(50, 255, 50)
            
            local toGreenTween = TweenService:Create(
                ClickBtn,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = greenColor}
            )
            
            local toWhiteTween = TweenService:Create(
                ClickBtn,
                TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = originalColor}
            )
            
            toGreenTween:Play()
            
            wait(2.5)
            
            toWhiteTween:Play()
        end
        
        ClickBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                if input.UserInputType == Enum.UserInputType.Touch then
                    blockCamera()
                end
                
                local callbackCalled = false
                local animationStarted = false
                
                local connection
                connection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        connection:Disconnect()
                        
                        if not animationStarted then
                            animationStarted = true
                            task.spawn(animateButtonColor)
                        end
                        
                        if not callbackCalled then
                            callbackCalled = true
                            handleButtonClick()
                        end
                        
                        if input.UserInputType == Enum.UserInputType.Touch then
                            unblockCamera()
                        end
                    end
                end)
            end
        end)
        
        currentYOffset = currentYOffset + 35
        
        return {
            Button = Button,
            Click = ClickBtn,
            SetColor = function(color)
                local tween = TweenService:Create(
                    ClickBtn,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = color}
                )
                tween:Play()
            end,
            FlashGreen = function()
                animateButtonColor()
            end,
            FlashRed = function()
                animateButtonColor()
            end
        }
    end

    function window:CreateToggle(options)
        local Tbutton = Instance.new("Frame")
        local UIListLayout = Instance.new("UIListLayout")
        local UIPadding = Instance.new("UIPadding")
        local ToggleBtn = Instance.new("TextButton")
        local UICorner_3 = Instance.new("UICorner")
        local Background = Instance.new("Frame")
        local UICorner_4 = Instance.new("UICorner")
        local Circle = Instance.new("Frame")
        local UICorner_5 = Instance.new("UICorner")
        local NameFunction = Instance.new("TextLabel")

        local toggled = options.Default or false

        Tbutton.Name = "Tbutton"
        Tbutton.Parent = Window
        Tbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Tbutton.BackgroundTransparency = 1.000
        Tbutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Tbutton.BorderSizePixel = 0
        Tbutton.Position = UDim2.new(0, 0, 0, currentYOffset)
        Tbutton.Size = UDim2.new(0, 192, 0, 17)

        UIListLayout.Parent = Tbutton
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 8)

        UIPadding.Parent = Tbutton
        UIPadding.PaddingLeft = UDim.new(0.800000012, -12)

        ToggleBtn.Name = "ToggleBtn"
        ToggleBtn.Parent = Tbutton
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ToggleBtn.BorderSizePixel = 0
        ToggleBtn.Position = UDim2.new(1.19108284, 0, 0, 0)
        ToggleBtn.Size = UDim2.new(0, 39, 0, 16)
        ToggleBtn.Font = Enum.Font.SourceSans
        ToggleBtn.Text = ""
        ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        ToggleBtn.TextSize = 14.000
        ToggleBtn.AutoButtonColor = true

        UICorner_3.CornerRadius = UDim.new(1, 2)
        UICorner_3.Parent = ToggleBtn

        Background.Name = "Background"
        Background.Parent = ToggleBtn
        Background.BackgroundColor3 = toggled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
        Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Background.BorderSizePixel = 0
        Background.Position = UDim2.new(-0.00180601457, 0, 0, 0)
        Background.Size = UDim2.new(0, 39, 0, 16)

        UICorner_4.CornerRadius = UDim.new(1, 2)
        UICorner_4.Parent = Background

        Circle.Name = "Circle"
        Circle.Parent = Background
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Circle.BorderSizePixel = 0
        Circle.Size = UDim2.new(0, 16, 0, 16)
        
        Circle.Position = toggled and UDim2.new(0.59, 0, 0, 0) or UDim2.new(0.025, 0, 0, 0)

        UICorner_5.CornerRadius = UDim.new(1, 2)
        UICorner_5.Parent = Circle

        NameFunction.Name = "NameFunction"
        NameFunction.Parent = ToggleBtn
        NameFunction.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NameFunction.BackgroundTransparency = 1.000
        NameFunction.BorderColor3 = Color3.fromRGB(0, 0, 0)
        NameFunction.BorderSizePixel = 0
        NameFunction.Position = UDim2.new(-3.4777832, 0, -0.125, 0)
        NameFunction.Size = UDim2.new(0, 72, 0, 20)
        NameFunction.Font = Enum.Font.Jura
        NameFunction.Text = options.Name or "Toggle"
        NameFunction.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameFunction.TextScaled = true
        NameFunction.TextSize = 16
        NameFunction.TextWrapped = true

        local function updateToggle()
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            if toggled then
                local circleTween = TweenService:Create(Circle, tweenInfo, {
                    Position = UDim2.new(0.59, 0, 0, 0)
                })
                local bgTween = TweenService:Create(Background, tweenInfo, {
                    BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                })
                
                circleTween:Play()
                bgTween:Play()
            else
                local circleTween = TweenService:Create(Circle, tweenInfo, {
                    Position = UDim2.new(0.025, 0, 0, 0)
                })
                local bgTween = TweenService:Create(Background, tweenInfo, {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                })
                
                circleTween:Play()
                bgTween:Play()
            end
            
            if options.Callback then
                options.Callback(toggled)
            end
        end

        updateToggle()

        local function toggleFunction()
            toggled = not toggled
            updateToggle()
        end

        ToggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                if input.UserInputType == Enum.UserInputType.Touch then
                    blockCamera()
                end
                
                local connection
                connection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        connection:Disconnect()
                        
                        toggleFunction()
                        
                        if input.UserInputType == Enum.UserInputType.Touch then
                            unblockCamera()
                        end
                    end
                end)
            end
        end)
        
        currentYOffset = currentYOffset + 25
        
        return {
            Toggle = Tbutton,
            Set = function(state)
                toggled = state
                updateToggle()
            end,
            Get = function()
                return toggled
            end
        }
    end

    return window
end

return BdevLib
