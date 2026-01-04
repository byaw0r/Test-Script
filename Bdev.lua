local BdevLib = {}

-- Основная функция для создания интерфейса
function BdevLib:CreateWindow(options)
    local window = {}
    
    -- Получаем сервисы
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    -- Получаем контроллер камеры для блокировки
    local Camera = workspace.CurrentCamera
    local ContextActionService = game:GetService("ContextActionService")
    
    -- Создаем основной GUI
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

    -- Настройка свойств из твоего кода
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

    -- Флаги для отслеживания перетаскивания
    local draggingMain = false
    local dragStartMain
    local startPosMain
    
    local draggingIcon = false
    local dragStartIcon
    local startPosIcon
    
    -- Функции для блокировки камеры
    local function blockCamera()
        -- Блокируем стандартное управление камерой на мобильных устройствах
        if UserInputService.TouchEnabled then
            ContextActionService:BindAction(
                "BlockCameraWhileDragging",
                function() return Enum.ContextActionResult.Sink end,
                false,
                Enum.UserInputType.Touch
            )
            
            -- Также блокируем сенсорное управление камерой
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
            end
        end
    end
    
    local function unblockCamera()
        -- Разблокируем управление камерой
        if UserInputService.TouchEnabled then
            ContextActionService:UnbindAction("BlockCameraWhileDragging")
        end
    end

    -- Функция для перетаскивания главного окна
    local function updateMain(input)
        local delta = input.Position - dragStartMain
        Main.Position = UDim2.new(
            startPosMain.X.Scale, 
            startPosMain.X.Offset + delta.X,
            startPosMain.Y.Scale, 
            startPosMain.Y.Offset + delta.Y
        )
    end
    
    -- Начинаем перетаскивание главного окна
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            -- Для тач-устройств блокируем камеру
            if input.UserInputType == Enum.UserInputType.Touch then
                blockCamera()
            end
            
            draggingMain = true
            dragStartMain = input.Position
            startPosMain = Main.Position
        end
    end)
    
    -- Обрабатываем перетаскивание главного окна
    UserInputService.InputChanged:Connect(function(input)
        if draggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch) then
            updateMain(input)
        end
    end)
    
    -- Завершаем перетаскивание главного окна
    TopBar.InputEnded:Connect(function(input)
        if draggingMain and (input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch) then
            draggingMain = false
            
            -- Для тач-устройств разблокируем камеру
            if input.UserInputType == Enum.UserInputType.Touch then
                unblockCamera()
            end
        end
    end)
    
    -- Функция для перетаскивания иконки
    local function updateIcon(input)
        local delta = input.Position - dragStartIcon
        IconBtn.Position = UDim2.new(
            startPosIcon.X.Scale,
            startPosIcon.X.Offset + delta.X,
            startPosIcon.Y.Scale,
            startPosIcon.Y.Offset + delta.Y
        )
    end
    
    -- Начинаем перетаскивание иконки
    IconBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            -- Для тач-устройств блокируем камеру
            if input.UserInputType == Enum.UserInputType.Touch then
                blockCamera()
            end
            
            draggingIcon = true
            dragStartIcon = input.Position
            startPosIcon = IconBtn.Position
        end
    end)
    
    -- Обрабатываем перетаскивание иконки
    UserInputService.InputChanged:Connect(function(input)
        if draggingIcon and (input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch) then
            updateIcon(input)
        end
    end)
    
    -- Завершаем перетаскивание иконки
    IconBtn.InputEnded:Connect(function(input)
        if draggingIcon and (input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch) then
            draggingIcon = false
            
            -- Для тач-устройств разблокируем камеру
            if input.UserInputType == Enum.UserInputType.Touch then
                unblockCamera()
            end
        end
    end)

    -- Функционал открытия/закрытия меню
    local isOpen = false
    
    -- Функция для открытия/закрытия меню
    local function toggleMenu()
        isOpen = not isOpen
        Main.Visible = isOpen
    end
    
    -- Универсальный обработчик клика для иконки (работает и на ПК, и на мобильных)
    IconBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            -- Не начинаем перетаскивание сразу, ждем немного
            local startTime = tick()
            local startPos = input.Position
            
            -- Обработчик конца ввода
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    connection:Disconnect()
                    
                    -- Проверяем, было ли это короткое нажатие (не перетаскивание)
                    local endTime = tick()
                    local endPos = input.Position
                    local distance = (endPos - startPos).Magnitude
                    
                    if (endTime - startTime < 0.3) and (distance < 10) then
                        -- Это был клик/тап, а не перетаскивание
                        toggleMenu()
                    end
                end
            end)
        end
    end)

    -- Счетчик для Y-позиции (будем увеличивать при создании новых элементов)
    local currentYOffset = 8

    -- Функция для создания кнопки
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

        -- UIListLayout внутри Button
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

        -- Текст кнопки с точными позициями из твоего кода
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

        -- Callback функция
        local function handleButtonClick()
            if options.Callback then
                options.Callback()
            end
        end
        
        -- Универсальный обработчик клика (работает и на ПК, и на мобильных)
        ClickBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                -- Визуальная обратная связь
                ClickBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                
                -- Для тач-устройств временно блокируем камеру
                if input.UserInputType == Enum.UserInputType.Touch then
                    blockCamera()
                end
                
                -- Обработчик конца ввода
                local connection
                connection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        connection:Disconnect()
                        
                        -- Возвращаем цвет и вызываем callback
                        ClickBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        handleButtonClick()
                        
                        -- Разблокируем камеру для тач-устройств
                        if input.UserInputType == Enum.UserInputType.Touch then
                            unblockCamera()
                        end
                    end
                end)
            end
        end)
        
        -- Увеличиваем Y-позицию для следующего элемента
        currentYOffset = currentYOffset + 35
        
        return {
            Button = Button,
            Click = ClickBtn
        }
    end

    -- Функция для создания переключателя
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

        -- UIListLayout внутри Tbutton
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
        
        -- Позиция круга в зависимости от состояния
        Circle.Position = toggled and UDim2.new(0.59, 0, 0, 0) or UDim2.new(0.025, 0, 0, 0)

        UICorner_5.CornerRadius = UDim.new(1, 2)
        UICorner_5.Parent = Circle

        -- Текст переключателя с точными позициями из твоего кода
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

        -- Функция переключения с анимацией круга
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

        -- Инициализируем начальное состояние
        updateToggle()

        -- Функция для переключения тоггла
        local function toggleFunction()
            toggled = not toggled
            updateToggle()
        end

        -- Универсальный обработчик клика (работает и на ПК, и на мобильных)
        ToggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                -- Визуальная обратная связь
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                
                -- Для тач-устройств временно блокируем камеру
                if input.UserInputType == Enum.UserInputType.Touch then
                    blockCamera()
                end
                
                -- Обработчик конца ввода
                local connection
                connection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        connection:Disconnect()
                        
                        -- Возвращаем цвет и переключаем
                        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        toggleFunction()
                        
                        -- Разблокируем камеру для тач-устройств
                        if input.UserInputType == Enum.UserInputType.Touch then
                            unblockCamera()
                        end
                    end
                end)
            end
        end)
        
        -- Увеличиваем Y-позицию для следующего элемента
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
