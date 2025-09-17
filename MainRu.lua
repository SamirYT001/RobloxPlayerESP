local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Создаем главный GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerListGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Основное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Тень
local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.Size = UDim2.new(1, 20, 1, 20)
DropShadow.Position = UDim2.new(0, -10, 0, -10)
DropShadow.BackgroundTransparency = 1
DropShadow.Image = "rbxassetid://1316045217"
DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
DropShadow.ImageTransparency = 0.5
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(10, 10, 118, 118)
DropShadow.Parent = MainFrame
DropShadow.ZIndex = 0

-- Заголовок
local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "TitleFrame"
TitleFrame.Size = UDim2.new(1, 0, 0, 50)
TitleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TitleFrame.BorderSizePixel = 0
TitleFrame.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "Список Игроков"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = TitleFrame

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = TitleFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Контейнер для списка игроков
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, -70)
ScrollFrame.Position = UDim2.new(0, 10, 0, 60)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollFrame

-- Кнопка открытия/закрытия
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Position = UDim2.new(0, 20, 0, 20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
ToggleButton.Text = "👥"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 24
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 30)
ToggleCorner.Parent = ToggleButton

local ToggleShadow = Instance.new("ImageLabel")
ToggleShadow.Name = "ToggleShadow"
ToggleShadow.Size = UDim2.new(1, 20, 1, 20)
ToggleShadow.Position = UDim2.new(0, -10, 0, -10)
ToggleShadow.BackgroundTransparency = 1
ToggleShadow.Image = "rbxassetid://1316045217"
ToggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
ToggleShadow.ImageTransparency = 0.5
ToggleShadow.ScaleType = Enum.ScaleType.Slice
ToggleShadow.SliceCenter = Rect.new(10, 10, 118, 118)
ToggleShadow.Parent = ToggleButton
ToggleShadow.ZIndex = 0

-- Переменные состояния
local isWindowVisible = false
local playerFrames = {}

-- Анимации
function TweenFrame(frame, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(frame, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Функция показа/скрытия окна
function ToggleWindow()
    isWindowVisible = not isWindowVisible
    
    if isWindowVisible then
        MainFrame.Visible = true
        TweenFrame(MainFrame, {Size = UDim2.new(0, 400, 0, 500)}, 0.3)
        TweenFrame(MainFrame, {BackgroundTransparency = 0}, 0.3)
        UpdatePlayerList()
    else
        TweenFrame(MainFrame, {Size = UDim2.new(0, 400, 0, 0)}, 0.3)
        TweenFrame(MainFrame, {BackgroundTransparency = 1}, 0.3)
        wait(0.3)
        MainFrame.Visible = false
    end
end

-- Функция создания карточки игрока
function CreatePlayerFrame(player)
    local frame = Instance.new("Frame")
    frame.Name = player.Name
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 10)
    layout.Parent = frame
    
    -- Аватар
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 40, 0, 40)
    avatar.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    avatar.BorderSizePixel = 0
    avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    avatar.Parent = frame
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 20)
    avatarCorner.Parent = avatar
    
    -- Загружаем настоящий аватар
    pcall(function()
        avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
    end)
    
    -- Информация об игроке
    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Size = UDim2.new(0, 280, 1, 0)
    infoFrame.BackgroundTransparency = 1
    infoFrame.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 24)
    nameLabel.Position = UDim2.new(0, 0, 0, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = infoFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0, 18)
    statusLabel.Position = UDim2.new(0, 0, 0, 32)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "В игре"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 14
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = infoFrame
    
    return frame
end

-- Функция обновления списка игроков
function UpdatePlayerList()
    -- Очищаем текущий список
    for _, frame in pairs(playerFrames) do
        frame:Destroy()
    end
    playerFrames = {}
    
    -- Получаем всех игроков
    local players = Players:GetPlayers()
    
    -- Создаем карточки для каждого игрока
    for _, player in ipairs(players) do
        if player ~= Players.LocalPlayer then
            local playerFrame = CreatePlayerFrame(player)
            playerFrame.Parent = ScrollFrame
            table.insert(playerFrames, playerFrame)
            
            -- Анимация появления
            playerFrame.Size = UDim2.new(1, 0, 0, 0)
            TweenFrame(playerFrame, {Size = UDim2.new(1, 0, 0, 60)}, 0.2)
        end
    end
end

-- Обработчики событий
ToggleButton.MouseButton1Click:Connect(ToggleWindow)
CloseButton.MouseButton1Click:Connect(ToggleWindow)

-- Drag functionality
local dragStart = nil
local startPos = nil

TitleFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragStart = nil
            end
        end)
    end
end)

TitleFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Обработка подключения/отключения игроков
Players.PlayerAdded:Connect(function(player)
    if isWindowVisible then
        UpdatePlayerList()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if isWindowVisible then
        UpdatePlayerList()
    end
end)

-- Инициализация
MainFrame.Visible = false
MainFrame.Size = UDim2.new(0, 400, 0, 0)
MainFrame.BackgroundTransparency = 1

print("Игра загружена! Нажмите на синюю кнопку, чтобы увидеть список игроков.")
