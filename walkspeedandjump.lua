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
local DefaultJumpPower = 1
local CurrentJumpPower = DefaultJumpPower
local UIVisible = true
local JumpButtonVisible = true

-- Membuat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WalkspeedGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame - Responsive untuk mobile dengan tinggi yang disesuaikan
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
-- Ukuran responsif: lebih besar di mobile dengan tinggi yang disesuaikan untuk jump controls
MainFrame.Size = IsMobile and UDim2.new(0, 370, 0, 380) or UDim2.new(0, 320, 0, 360)
MainFrame.Position = UDim2.new(0.5, IsMobile and -185 or -160, 0.5, IsMobile and -190 or -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Membuat rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Gradient Background untuk main frame
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
}
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

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

-- Gradient untuk title bar
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

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
TitleText.Text = "Speed & Jump Controller"
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

-- Jump Power Section
-- Jump Label
local JumpLabel = Instance.new("TextLabel")
JumpLabel.Name = "JumpLabel"
JumpLabel.Size = UDim2.new(1, 0, 0, 25)
JumpLabel.Position = UDim2.new(0, 0, 0, 120)
JumpLabel.BackgroundTransparency = 1
JumpLabel.Text = "Jump Power: " .. CurrentJumpPower
JumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpLabel.TextScaled = true
JumpLabel.Font = Enum.Font.SourceSans
JumpLabel.Parent = ContentFrame

-- Jump Slider Background
local JumpSliderBG = Instance.new("Frame")
JumpSliderBG.Name = "JumpSliderBackground"
JumpSliderBG.Size = UDim2.new(1, 0, 0, 20)
JumpSliderBG.Position = UDim2.new(0, 0, 0, 150)
JumpSliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JumpSliderBG.BorderSizePixel = 0
JumpSliderBG.Parent = ContentFrame

local JumpSliderBGCorner = Instance.new("UICorner")
JumpSliderBGCorner.CornerRadius = UDim.new(0, 10)
JumpSliderBGCorner.Parent = JumpSliderBG

-- Jump Slider Fill
local JumpSliderFill = Instance.new("Frame")
JumpSliderFill.Name = "JumpSliderFill"
JumpSliderFill.Size = UDim2.new((CurrentJumpPower - 0) / 500, 0, 1, 0)
JumpSliderFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
JumpSliderFill.BorderSizePixel = 0
JumpSliderFill.Parent = JumpSliderBG

local JumpSliderFillCorner = Instance.new("UICorner")
JumpSliderFillCorner.CornerRadius = UDim.new(0, 10)
JumpSliderFillCorner.Parent = JumpSliderFill

-- Jump Slider Button
local JumpSliderButton = Instance.new("Frame")
JumpSliderButton.Name = "JumpSliderButton"
JumpSliderButton.Size = UDim2.new(0, 20, 0, 20)
JumpSliderButton.Position = UDim2.new((CurrentJumpPower - 0) / 500, -10, 0.5, -10)
JumpSliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
JumpSliderButton.BorderSizePixel = 0
JumpSliderButton.Parent = JumpSliderBG

local JumpSliderButtonCorner = Instance.new("UICorner")
JumpSliderButtonCorner.CornerRadius = UDim.new(1, 0)
JumpSliderButtonCorner.Parent = JumpSliderButton

-- Jump Control Buttons
local JumpControlFrame = Instance.new("Frame")
JumpControlFrame.Name = "JumpControlFrame"
JumpControlFrame.Size = UDim2.new(1, 0, 0, 40)
JumpControlFrame.Position = UDim2.new(0, 0, 0, 180)
JumpControlFrame.BackgroundTransparency = 1
JumpControlFrame.Parent = ContentFrame

-- Decrease Jump Button (-)
local DecreaseJumpButton = Instance.new("TextButton")
DecreaseJumpButton.Name = "DecreaseJumpButton"
DecreaseJumpButton.Size = IsMobile and UDim2.new(0, 45, 0, 40) or UDim2.new(0, 35, 0, 35)
DecreaseJumpButton.Position = UDim2.new(0, 0, 0.5, IsMobile and -20 or -17.5)
DecreaseJumpButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
DecreaseJumpButton.Text = "−"
DecreaseJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseJumpButton.TextSize = IsMobile and 24 or 20
DecreaseJumpButton.Font = Enum.Font.SourceSansBold
DecreaseJumpButton.BorderSizePixel = 0
DecreaseJumpButton.Parent = JumpControlFrame

local DecreaseJumpCorner = Instance.new("UICorner")
DecreaseJumpCorner.CornerRadius = UDim.new(0, 8)
DecreaseJumpCorner.Parent = DecreaseJumpButton

-- Jump Power Display
local JumpDisplay = Instance.new("TextLabel")
JumpDisplay.Name = "JumpDisplay"
JumpDisplay.Size = IsMobile and UDim2.new(1, -110, 0, 30) or UDim2.new(1, -90, 0, 25)
JumpDisplay.Position = IsMobile and UDim2.new(0, 55, 0.5, -15) or UDim2.new(0, 45, 0.5, -12.5)
JumpDisplay.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
JumpDisplay.Text = "Jump: " .. math.floor(CurrentJumpPower)
JumpDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpDisplay.TextScaled = true
JumpDisplay.Font = Enum.Font.SourceSansBold
JumpDisplay.BorderSizePixel = 0
JumpDisplay.Parent = JumpControlFrame

local JumpDisplayCorner = Instance.new("UICorner")
JumpDisplayCorner.CornerRadius = UDim.new(0, 6)
JumpDisplayCorner.Parent = JumpDisplay

-- Increase Jump Button (+)
local IncreaseJumpButton = Instance.new("TextButton")
IncreaseJumpButton.Name = "IncreaseJumpButton"
IncreaseJumpButton.Size = IsMobile and UDim2.new(0, 45, 0, 40) or UDim2.new(0, 35, 0, 35)
IncreaseJumpButton.Position = IsMobile and UDim2.new(1, -45, 0.5, -20) or UDim2.new(1, -35, 0.5, -17.5)
IncreaseJumpButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
IncreaseJumpButton.Text = "+"
IncreaseJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseJumpButton.TextSize = IsMobile and 24 or 20
IncreaseJumpButton.Font = Enum.Font.SourceSansBold
IncreaseJumpButton.BorderSizePixel = 0
IncreaseJumpButton.Parent = JumpControlFrame

local IncreaseJumpCorner = Instance.new("UICorner")
IncreaseJumpCorner.CornerRadius = UDim.new(0, 8)
IncreaseJumpCorner.Parent = IncreaseJumpButton

-- Speed Control Buttons dengan layout yang lebih rapi
-- Container untuk speed control buttons
local SpeedControlFrame = Instance.new("Frame")
SpeedControlFrame.Name = "SpeedControlFrame"
SpeedControlFrame.Size = UDim2.new(1, 0, 0, 40)
SpeedControlFrame.Position = UDim2.new(0, 0, 0, 70)
SpeedControlFrame.BackgroundTransparency = 1
SpeedControlFrame.Parent = ContentFrame

-- Decrease Speed Button (-)
local DecreaseButton = Instance.new("TextButton")
DecreaseButton.Name = "DecreaseButton"
DecreaseButton.Size = IsMobile and UDim2.new(0, 45, 0, 40) or UDim2.new(0, 35, 0, 35)
DecreaseButton.Position = UDim2.new(0, 0, 0.5, IsMobile and -20 or -17.5)
DecreaseButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
DecreaseButton.Text = "−"
DecreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseButton.TextSize = IsMobile and 24 or 20
DecreaseButton.Font = Enum.Font.SourceSansBold
DecreaseButton.BorderSizePixel = 0
DecreaseButton.Parent = SpeedControlFrame

local DecreaseCorner = Instance.new("UICorner")
DecreaseCorner.CornerRadius = UDim.new(0, 8)
DecreaseCorner.Parent = DecreaseButton

-- Speed Display dalam speed control
local SpeedDisplay = Instance.new("TextLabel")
SpeedDisplay.Name = "SpeedDisplay"
SpeedDisplay.Size = IsMobile and UDim2.new(1, -110, 0, 30) or UDim2.new(1, -90, 0, 25)
SpeedDisplay.Position = IsMobile and UDim2.new(0, 55, 0.5, -15) or UDim2.new(0, 45, 0.5, -12.5)
SpeedDisplay.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedDisplay.Text = "Speed: " .. math.floor(CurrentWalkspeed)
SpeedDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedDisplay.TextScaled = true
SpeedDisplay.Font = Enum.Font.SourceSansBold
SpeedDisplay.BorderSizePixel = 0
SpeedDisplay.Parent = SpeedControlFrame

local SpeedDisplayCorner = Instance.new("UICorner")
SpeedDisplayCorner.CornerRadius = UDim.new(0, 6)
SpeedDisplayCorner.Parent = SpeedDisplay

-- Increase Speed Button (+)
local IncreaseButton = Instance.new("TextButton")
IncreaseButton.Name = "IncreaseButton"
IncreaseButton.Size = IsMobile and UDim2.new(0, 45, 0, 40) or UDim2.new(0, 35, 0, 35)
IncreaseButton.Position = IsMobile and UDim2.new(1, -45, 0.5, -20) or UDim2.new(1, -35, 0.5, -17.5)
IncreaseButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
IncreaseButton.Text = "+"
IncreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseButton.TextSize = IsMobile and 24 or 20
IncreaseButton.Font = Enum.Font.SourceSansBold
IncreaseButton.BorderSizePixel = 0
IncreaseButton.Parent = SpeedControlFrame

local IncreaseCorner = Instance.new("UICorner")
IncreaseCorner.CornerRadius = UDim.new(0, 8)
IncreaseCorner.Parent = IncreaseButton

-- Reset Button
local ResetButton = Instance.new("TextButton")
ResetButton.Name = "ResetButton"
ResetButton.Size = UDim2.new(0.45, -5, 0, 35)
ResetButton.Position = UDim2.new(0, 0, 0, 230)
ResetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ResetButton.Text = "Reset"
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.TextScaled = true
ResetButton.Font = Enum.Font.SourceSansBold
ResetButton.BorderSizePixel = 0
ResetButton.Parent = ContentFrame

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 8)
ResetCorner.Parent = ResetButton

-- Apply Button
local ApplyButton = Instance.new("TextButton")
ApplyButton.Name = "ApplyButton"
ApplyButton.Size = UDim2.new(0.45, -5, 0, 35)
ApplyButton.Position = UDim2.new(0.55, 5, 0, 230)
ApplyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ApplyButton.Text = "Apply"
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.TextScaled = true
ApplyButton.Font = Enum.Font.SourceSansBold
ApplyButton.BorderSizePixel = 0
ApplyButton.Parent = ContentFrame

local ApplyCorner = Instance.new("UICorner")
ApplyCorner.CornerRadius = UDim.new(0, 8)
ApplyCorner.Parent = ApplyButton

-- Toggle Jump Button
local ToggleJumpButton = Instance.new("TextButton")
ToggleJumpButton.Name = "ToggleJumpButton"
ToggleJumpButton.Size = UDim2.new(1, 0, 0, 30)
ToggleJumpButton.Position = UDim2.new(0, 0, 0, 275)
ToggleJumpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleJumpButton.Text = "Hide Jump Button"
ToggleJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleJumpButton.TextScaled = true
ToggleJumpButton.Font = Enum.Font.SourceSansBold
ToggleJumpButton.BorderSizePixel = 0
ToggleJumpButton.Parent = ContentFrame

local ToggleJumpCorner = Instance.new("UICorner")
ToggleJumpCorner.CornerRadius = UDim.new(0, 8)
ToggleJumpCorner.Parent = ToggleJumpButton

-- Hide Button (di dalam UI) dengan posisi yang lebih rapi
local HideButton = Instance.new("TextButton")
HideButton.Name = "HideButton"
HideButton.Size = UDim2.new(0, 90, 0, 30)
HideButton.Position = UDim2.new(0.5, -45, 1, -40)
HideButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
HideButton.Text = "Hide UI"
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HideButton.TextScaled = true
HideButton.Font = Enum.Font.SourceSansBold
HideButton.BorderSizePixel = 0
HideButton.Parent = MainFrame

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 8)
HideCorner.Parent = HideButton

-- Gradient untuk hide button
local HideGradient = Instance.new("UIGradient")
HideGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
}
HideGradient.Rotation = 90
HideGradient.Parent = HideButton

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

-- Floating Jump Button
local JumpButton = Instance.new("TextButton")
JumpButton.Name = "JumpButton"
JumpButton.Size = IsMobile and UDim2.new(0, 80, 0, 80) or UDim2.new(0, 70, 0, 70)
JumpButton.Position = IsMobile and UDim2.new(1, -100, 1, -100) or UDim2.new(1, -90, 1, -90)
JumpButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
JumpButton.Text = "JUMP"
JumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpButton.TextScaled = true
JumpButton.Font = Enum.Font.SourceSansBold
JumpButton.BorderSizePixel = 0
JumpButton.Active = true
JumpButton.Draggable = true
JumpButton.Parent = ScreenGui

local JumpButtonCorner = Instance.new("UICorner")
JumpButtonCorner.CornerRadius = UDim.new(0.5, 0)
JumpButtonCorner.Parent = JumpButton

-- Gradient untuk Jump Button
local JumpButtonGradient = Instance.new("UIGradient")
JumpButtonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 0))
}
JumpButtonGradient.Rotation = 45
JumpButtonGradient.Parent = JumpButton

-- Shadow untuk Jump Button
local JumpButtonShadow = Instance.new("Frame")
JumpButtonShadow.Name = "JumpButtonShadow"
JumpButtonShadow.Size = UDim2.new(1, 6, 1, 6)
JumpButtonShadow.Position = UDim2.new(0, 3, 0, 3)
JumpButtonShadow.BackgroundColor3 = Color3.new(0, 0, 0)
JumpButtonShadow.BackgroundTransparency = 0.3
JumpButtonShadow.ZIndex = -1
JumpButtonShadow.Parent = JumpButton

local JumpButtonShadowCorner = Instance.new("UICorner")
JumpButtonShadowCorner.CornerRadius = UDim.new(0.5, 0)
JumpButtonShadowCorner.Parent = JumpButtonShadow

-- Functions
local function UpdateWalkspeed(speed)
    CurrentWalkspeed = math.clamp(speed, 0, 200)
    SpeedLabel.Text = "Current Speed: " .. math.floor(CurrentWalkspeed)
    SpeedDisplay.Text = "Speed: " .. math.floor(CurrentWalkspeed)
    
    local percentage = (CurrentWalkspeed - 0) / 200
    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    SliderButton.Position = UDim2.new(percentage, -10, 0.5, -10)
end

local function UpdateJumpPower(jumpPower)
    CurrentJumpPower = math.clamp(jumpPower, 0, 500)
    JumpLabel.Text = "Jump Power: " .. math.floor(CurrentJumpPower)
    JumpDisplay.Text = "Jump: " .. math.floor(CurrentJumpPower)
    
    local percentage = (CurrentJumpPower - 0) / 500
    JumpSliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    JumpSliderButton.Position = UDim2.new(percentage, -10, 0.5, -10)
end

local function ApplyWalkspeed()
    if Humanoid then
        Humanoid.WalkSpeed = CurrentWalkspeed
    end
end

local function ApplyJumpPower()
    if Humanoid then
        -- Check if the humanoid uses JumpHeight (newer system) or JumpPower (older system)
        if Humanoid.UseJumpPower then
            Humanoid.JumpPower = CurrentJumpPower
        else
            -- Convert JumpPower to JumpHeight for newer system
            Humanoid.JumpHeight = CurrentJumpPower * 0.35 -- Conversion factor
        end
    end
end

local function ApplyAll()
    ApplyWalkspeed()
    ApplyJumpPower()
end

local function ResetWalkspeed()
    UpdateWalkspeed(DefaultWalkspeed)
    UpdateJumpPower(DefaultJumpPower)
    ApplyAll()
end

local function IncreaseSpeed()
    local newSpeed = CurrentWalkspeed + 2
    UpdateWalkspeed(newSpeed)
    ApplyWalkspeed()
end

local function DecreaseSpeed()
    local newSpeed = CurrentWalkspeed - 2
    UpdateWalkspeed(newSpeed)
    ApplyWalkspeed()
end

local function IncreaseJump()
    local newJumpPower = CurrentJumpPower + 10
    UpdateJumpPower(newJumpPower)
    ApplyJumpPower()
end

local function DecreaseJump()
    local newJumpPower = CurrentJumpPower - 10
    UpdateJumpPower(newJumpPower)
    ApplyJumpPower()
end

local function ToggleJumpButtonVisibility()
    JumpButtonVisible = not JumpButtonVisible
    JumpButton.Visible = JumpButtonVisible
    
    if JumpButtonVisible then
        ToggleJumpButton.Text = "Hide Jump Button"
        ToggleJumpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        -- Animasi fade in untuk jump button
        JumpButton.BackgroundTransparency = 1
        JumpButton.TextTransparency = 1
        TweenService:Create(JumpButton, TweenInfo.new(0.3), {
            BackgroundTransparency = 0,
            TextTransparency = 0
        }):Play()
    else
        ToggleJumpButton.Text = "Show Jump Button"
        ToggleJumpButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    end
end

local function DoJump()
    if Humanoid and Humanoid.Parent and Humanoid.Parent:FindFirstChild("HumanoidRootPart") then
        -- Apply current jump power before jumping
        ApplyJumpPower()
        
        -- Make the character jump
        Humanoid.Jump = true
        
        -- Visual feedback - button press effect
        local originalSize = JumpButton.Size
        TweenService:Create(JumpButton, TweenInfo.new(0.1), {
            Size = originalSize * 0.9
        }):Play()
        
        wait(0.1)
        TweenService:Create(JumpButton, TweenInfo.new(0.1), {
            Size = originalSize
        }):Play()
    end
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
local jumpDragging = false

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

-- Jump Slider functionality
JumpSliderBG.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        jumpDragging = true
        -- Update posisi langsung saat klik/touch
        local mouse = input.Position
        local relativeX = mouse.X - JumpSliderBG.AbsolutePosition.X
        local percentage = math.clamp(relativeX / JumpSliderBG.AbsoluteSize.X, 0, 1)
        local jumpPower = percentage * 500
        UpdateJumpPower(jumpPower)
    end
end)

JumpSliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        jumpDragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        jumpDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        if dragging then
            local mouse = input.Position
            local relativeX = mouse.X - SliderBG.AbsolutePosition.X
            local percentage = math.clamp(relativeX / SliderBG.AbsoluteSize.X, 0, 1)
            local speed = percentage * 200
            UpdateWalkspeed(speed)
        end
        
        if jumpDragging then
            local mouse = input.Position
            local relativeX = mouse.X - JumpSliderBG.AbsolutePosition.X
            local percentage = math.clamp(relativeX / JumpSliderBG.AbsoluteSize.X, 0, 1)
            local jumpPower = percentage * 500
            UpdateJumpPower(jumpPower)
        end
    end
end)

-- Button connections
ResetButton.MouseButton1Click:Connect(ResetWalkspeed)
ApplyButton.MouseButton1Click:Connect(ApplyAll)
CloseButton.MouseButton1Click:Connect(ToggleUI)
HideButton.MouseButton1Click:Connect(HideUI)
ShowButton.MouseButton1Click:Connect(ShowUI)
IncreaseButton.MouseButton1Click:Connect(IncreaseSpeed)
DecreaseButton.MouseButton1Click:Connect(DecreaseSpeed)
IncreaseJumpButton.MouseButton1Click:Connect(IncreaseJump)
DecreaseJumpButton.MouseButton1Click:Connect(DecreaseJump)
ToggleJumpButton.MouseButton1Click:Connect(ToggleJumpButtonVisibility)
JumpButton.MouseButton1Click:Connect(DoJump)

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
    ApplyAll()
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
ButtonHover(IncreaseJumpButton, Color3.fromRGB(255, 170, 0), Color3.fromRGB(255, 190, 30))
ButtonHover(DecreaseJumpButton, Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 160, 30))

-- Special hover effect untuk ToggleJumpButton
ToggleJumpButton.MouseEnter:Connect(function()
    local targetColor = JumpButtonVisible and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(255, 190, 30)
    TweenService:Create(ToggleJumpButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
end)

ToggleJumpButton.MouseLeave:Connect(function()
    local targetColor = JumpButtonVisible and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(255, 170, 0)
    TweenService:Create(ToggleJumpButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
end)

-- Hover effect untuk JumpButton
JumpButton.MouseEnter:Connect(function()
    TweenService:Create(JumpButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 190, 30)
    }):Play()
end)

JumpButton.MouseLeave:Connect(function()
    TweenService:Create(JumpButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 170, 0)
    }):Play()
end)

-- Hover effect untuk SpeedDisplay
SpeedDisplay.MouseEnter:Connect(function()
    TweenService:Create(SpeedDisplay, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    }):Play()
end)

SpeedDisplay.MouseLeave:Connect(function()
    TweenService:Create(SpeedDisplay, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }):Play()
end)

-- Hover effect untuk JumpDisplay
JumpDisplay.MouseEnter:Connect(function()
    TweenService:Create(JumpDisplay, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    }):Play()
end)

JumpDisplay.MouseLeave:Connect(function()
    TweenService:Create(JumpDisplay, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    }):Play()
end)

-- Initial setup
UpdateWalkspeed(DefaultWalkspeed)
UpdateJumpPower(DefaultJumpPower)

-- Notification
local notificationText = IsMobile and 
    "Successfully loaded! Mobile-friendly UI with Speed & Jump controls + Jump Button. Use Hide/Show buttons to toggle." or
    "Successfully loaded! Speed & Jump controls + Jump Button. Use Hide/Show buttons or RightShift to toggle UI"

game.StarterGui:SetCore("SendNotification", {
    Title = "Speed & Jump Script",
    Text = notificationText,
    Duration = 5
})