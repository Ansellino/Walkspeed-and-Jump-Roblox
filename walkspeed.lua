-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

-- Mobile Detection
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Variables
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local DefaultWalkspeed = 1
local CurrentWalkspeed = DefaultWalkspeed
local UIVisible = true

-- Membuat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WalkspeedGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame - Responsive untuk mobile
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
-- Ukuran responsif: lebih besar di mobile
MainFrame.Size = IsMobile and UDim2.new(0, 350, 0, 220) or UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, IsMobile and -175 or -150, 0.5, IsMobile and -110 or -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Membuat rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Shadow Effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 10, 10)
Shadow.ZIndex = -1
Shadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Fix untuk rounded corner di bottom
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 10)
TitleFix.Position = UDim2.new(0, 0, 1, -10)
TitleFix.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Walkspeed Controller"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextScaled = true
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.SourceSansBold
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Speed Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Current Speed: " .. CurrentWalkspeed
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextScaled = true
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.Parent = ContentFrame

-- Slider Background
local SliderBG = Instance.new("Frame")
SliderBG.Name = "SliderBackground"
SliderBG.Size = UDim2.new(1, 0, 0, 20)
SliderBG.Position = UDim2.new(0, 0, 0, 40)
SliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderBG.BorderSizePixel = 0
SliderBG.Parent = ContentFrame

local SliderBGCorner = Instance.new("UICorner")
SliderBGCorner.CornerRadius = UDim.new(0, 10)
SliderBGCorner.Parent = SliderBG

-- Slider Fill
local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new((CurrentWalkspeed - 0) / 200, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBG

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(0, 10)
SliderFillCorner.Parent = SliderFill

-- Slider Button
local SliderButton = Instance.new("Frame")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new((CurrentWalkspeed - 0) / 200, -10, 0.5, -10)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.BorderSizePixel = 0
SliderButton.Parent = SliderBG

local SliderButtonCorner = Instance.new("UICorner")
SliderButtonCorner.CornerRadius = UDim.new(1, 0)
SliderButtonCorner.Parent = SliderButton

-- Speed Control Buttons
-- Decrease Speed Button (-)
local DecreaseButton = Instance.new("TextButton")
DecreaseButton.Name = "DecreaseButton"
-- Ukuran lebih besar untuk mobile
DecreaseButton.Size = IsMobile and UDim2.new(0, 40, 0, 40) or UDim2.new(0, 30, 0, 30)
DecreaseButton.Position = UDim2.new(0, 0, 0, 70)
DecreaseButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
DecreaseButton.Text = "−"
DecreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseButton.TextSize = IsMobile and 24 or 20
DecreaseButton.Font = Enum.Font.SourceSansBold
DecreaseButton.BorderSizePixel = 0
DecreaseButton.Parent = ContentFrame

local DecreaseCorner = Instance.new("UICorner")
DecreaseCorner.CornerRadius = UDim.new(0, 8)
DecreaseCorner.Parent = DecreaseButton

-- Increase Speed Button (+)
local IncreaseButton = Instance.new("TextButton")
IncreaseButton.Name = "IncreaseButton"
-- Ukuran lebih besar untuk mobile
IncreaseButton.Size = IsMobile and UDim2.new(0, 40, 0, 40) or UDim2.new(0, 30, 0, 30)
IncreaseButton.Position = IsMobile and UDim2.new(1, -40, 0, 70) or UDim2.new(1, -30, 0, 70)
IncreaseButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
IncreaseButton.Text = "+"
IncreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseButton.TextSize = IsMobile and 24 or 20
IncreaseButton.Font = Enum.Font.SourceSansBold
IncreaseButton.BorderSizePixel = 0
IncreaseButton.Parent = ContentFrame

local IncreaseCorner = Instance.new("UICorner")
IncreaseCorner.CornerRadius = UDim.new(0, 8)
IncreaseCorner.Parent = IncreaseButton

-- Reset Button
local ResetButton = Instance.new("TextButton")
ResetButton.Name = "ResetButton"
ResetButton.Size = UDim2.new(0.45, 0, 0, 35)
ResetButton.Position = UDim2.new(0, 0, 0, 80)
ResetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ResetButton.Text = "Reset"
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.TextScaled = true
ResetButton.Font = Enum.Font.SourceSans
ResetButton.BorderSizePixel = 0
ResetButton.Parent = ContentFrame

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 8)
ResetCorner.Parent = ResetButton

-- Apply Button
local ApplyButton = Instance.new("TextButton")
ApplyButton.Name = "ApplyButton"
ApplyButton.Size = UDim2.new(0.45, 0, 0, 35)
ApplyButton.Position = UDim2.new(0.55, 0, 0, 80)
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ApplyButton.Text = "Apply"
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.TextScaled = true
ApplyButton.Font = Enum.Font.SourceSans
ApplyButton.BorderSizePixel = 0
ApplyButton.Parent = ContentFrame

local ApplyCorner = Instance.new("UICorner")
ApplyCorner.CornerRadius = UDim.new(0, 8)
ApplyCorner.Parent = ApplyButton

-- Hide Button (di dalam UI)
local HideButton = Instance.new("TextButton")
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 80, 0, 30)
HideButton.Position = UDim2.new(0.5, -40, 1, -35)
HideButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
HideButton.Text = "Hide UI"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextScaled = true
HideButton.Font = Enum.Font.SourceSans
HideButton.BorderSizePixel = 0
HideButton.Parent = MainFrame

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 8)
HideCorner.Parent = HideButton

-- Floating Show Button (selalu visible)
local ShowButton = Instance.new("TextButton")
ShowButton.Name = "ShowButton"
ShowButton.Size = UDim2.new(0, 100, 0, 40)
ShowButton.Position = UDim2.new(0, 10, 0.5, -20)
ShowButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ShowButton.Text = "Show UI"
ShowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowButton.TextScaled = true
ShowButton.Font = Enum.Font.SourceSansBold
ShowButton.BorderSizePixel = 0
ShowButton.Visible = false
ShowButton.Active = true
ShowButton.Draggable = true
ShowButton.Parent = ScreenGui

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(0, 10)
ShowCorner.Parent = ShowButton

-- Shadow untuk Show Button
local ShowShadow = Instance.new("Frame")
ShowShadow.Name = "ShowShadow"
ShowShadow.Size = UDim2.new(1, 4, 1, 4)
ShowShadow.Position = UDim2.new(0, 2, 0, 2)
ShowShadow.BackgroundColor3 = Color3.new(0, 0, 0)
ShowShadow.BackgroundTransparency = 0.5
ShowShadow.ZIndex = -1
ShowShadow.Parent = ShowButton

local ShowShadowCorner = Instance.new("UICorner")
ShowShadowCorner.CornerRadius = UDim.new(0, 10)
ShowShadowCorner.Parent = ShowShadow

-- Functions
local function UpdateWalkspeed(speed)
    CurrentWalkspeed = math.clamp(speed, 0, 200)
    SpeedLabel.Text = "Current Speed: " .. math.floor(CurrentWalkspeed)
    
    local percentage = (CurrentWalkspeed - 0) / 200
    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    SliderButton.Position = UDim2.new(percentage, -10, 0.5, -10)
end

local function ApplyWalkspeed()
    if Humanoid then
        Humanoid.WalkSpeed = CurrentWalkspeed
    end
end

local function ResetWalkspeed()
    UpdateWalkspeed(DefaultWalkspeed)
    ApplyWalkspeed()
end

local function IncreaseSpeed()
    local newSpeed = CurrentWalkspeed + 10
    UpdateWalkspeed(newSpeed)
    ApplyWalkspeed()
end

local function DecreaseSpeed()
    local newSpeed = CurrentWalkspeed - 10
    UpdateWalkspeed(newSpeed)
    ApplyWalkspeed()
end

local function HideUI()
    UIVisible = false
    MainFrame.Visible = false
    ShowButton.Visible = true
    
    -- Animasi fade in untuk show button
    ShowButton.BackgroundTransparency = 1
    ShowButton.TextTransparency = 1
    TweenService:Create(ShowButton, TweenInfo.new(0.3), {
        BackgroundTransparency = 0,
        TextTransparency = 0
    }):Play()
end

local function ShowUI()
    UIVisible = true
    MainFrame.Visible = true
    ShowButton.Visible = false
    
    -- Animasi fade in untuk main frame
    MainFrame.BackgroundTransparency = 1
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = 0
    }):Play()
end

local function ToggleUI()
    if UIVisible then
        HideUI()
    else
        ShowUI()
    end
end

-- Slider functionality
local dragging = false

-- Mouse/Touch input untuk slider
SliderBG.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        -- Update posisi langsung saat klik/touch
        local mouse = input.Position
        local relativeX = mouse.X - SliderBG.AbsolutePosition.X
        local percentage = math.clamp(relativeX / SliderBG.AbsoluteSize.X, 0, 1)
        local speed = percentage * 200
        UpdateWalkspeed(speed)
    end
end)

SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mouse = input.Position
        local relativeX = mouse.X - SliderBG.AbsolutePosition.X
        local percentage = math.clamp(relativeX / SliderBG.AbsoluteSize.X, 0, 1)
        local speed = percentage * 200
        UpdateWalkspeed(speed)
    end
end)

-- Button connections
ResetButton.MouseButton1Click:Connect(ResetWalkspeed)
ApplyButton.MouseButton1Click:Connect(ApplyWalkspeed)
CloseButton.MouseButton1Click:Connect(ToggleUI)
HideButton.MouseButton1Click:Connect(HideUI)
ShowButton.MouseButton1Click:Connect(ShowUI)
IncreaseButton.MouseButton1Click:Connect(IncreaseSpeed)
DecreaseButton.MouseButton1Click:Connect(DecreaseSpeed)

-- Toggle UI dengan RightShift (hanya untuk PC)
if not IsMobile then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
            ToggleUI()
        end
    end)
end

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    ApplyWalkspeed()
end)

-- Button hover effects
local function ButtonHover(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

ButtonHover(ResetButton, Color3.fromRGB(60, 60, 60), Color3.fromRGB(80, 80, 80))
ButtonHover(ApplyButton, Color3.fromRGB(0, 170, 255), Color3.fromRGB(0, 150, 230))
ButtonHover(CloseButton, Color3.fromRGB(255, 50, 50), Color3.fromRGB(255, 80, 80))
ButtonHover(HideButton, Color3.fromRGB(100, 100, 100), Color3.fromRGB(120, 120, 120))
ButtonHover(ShowButton, Color3.fromRGB(0, 170, 255), Color3.fromRGB(0, 150, 230))
ButtonHover(IncreaseButton, Color3.fromRGB(100, 255, 100), Color3.fromRGB(120, 255, 120))
ButtonHover(DecreaseButton, Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 120, 120))

-- Initial setup
UpdateWalkspeed(DefaultWalkspeed)

-- Notification
local notificationText = IsMobile and 
    "Successfully loaded! Mobile-friendly UI. Use Hide/Show buttons to toggle." or
    "Successfully loaded! Works on Mobile & PC. Use Hide/Show buttons or RightShift to toggle UI"

game.StarterGui:SetCore("SendNotification", {
    Title = "Walkspeed Script",
    Text = notificationText,
    Duration = 5
})