-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Mobile Detection
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Variables
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local DefaultWalkspeed = 16
local CurrentWalkspeed = DefaultWalkspeed
local DefaultJumpPower = 50
local CurrentJumpPower = DefaultJumpPower
local UIVisible = true
local JumpButtonVisible = true

-- UI Constants untuk konsistensi
local COLORS = {
    Background = Color3.fromRGB(28, 28, 32),
    Primary = Color3.fromRGB(42, 42, 48),
    Secondary = Color3.fromRGB(35, 35, 40),
    Accent = Color3.fromRGB(70, 130, 255),
    Success = Color3.fromRGB(52, 199, 89),
    Warning = Color3.fromRGB(255, 149, 0),
    Danger = Color3.fromRGB(255, 69, 58),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180)
}

local SIZES = {
    Mobile = {
        MainFrame = UDim2.new(0, 380, 0, 460),
        Button = UDim2.new(0, 50, 0, 45),
        JumpButton = UDim2.new(0, 90, 0, 90)
    },
    Desktop = {
        MainFrame = UDim2.new(0, 340, 0, 420),
        Button = UDim2.new(0, 40, 0, 35),
        JumpButton = UDim2.new(0, 80, 0, 80)
    }
}

-- Membuat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MovementController"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame dengan desain modern
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = IsMobile and SIZES.Mobile.MainFrame or SIZES.Desktop.MainFrame
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Modern rounded corners
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

-- Subtle gradient
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 42)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
}
MainGradient.Rotation = 135
MainGradient.Parent = MainFrame

-- Drop shadow dengan ImageLabel
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "DropShadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.8
Shadow.ZIndex = -1
Shadow.Parent = MainFrame

-- Header dengan design modern
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = COLORS.Primary
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 20)
HeaderCorner.Parent = Header

-- Header bottom fix untuk rounded corner
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 20)
HeaderFix.Position = UDim2.new(0, 0, 1, -20)
HeaderFix.BackgroundColor3 = COLORS.Primary
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- Title dengan icon dan layout yang lebih baik
local TitleContainer = Instance.new("Frame")
TitleContainer.Size = UDim2.new(1, -70, 1, 0)
TitleContainer.Position = UDim2.new(0, 20, 0, 0)
TitleContainer.BackgroundTransparency = 1
TitleContainer.Parent = Header

local TitleIcon = Instance.new("TextLabel")
TitleIcon.Size = UDim2.new(0, 35, 0, 35)
TitleIcon.Position = UDim2.new(0, 0, 0.5, -17.5)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Text = "⚡"
TitleIcon.TextColor3 = COLORS.Accent
TitleIcon.TextScaled = true
TitleIcon.Font = Enum.Font.SourceSans
TitleIcon.Parent = TitleContainer

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -45, 1, 0)
TitleText.Position = UDim2.new(0, 45, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Movement Controller"
TitleText.TextColor3 = COLORS.Text
TitleText.TextScaled = true
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleContainer

-- Close button dengan design yang lebih baik
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0.5, -20)
CloseButton.BackgroundColor3 = COLORS.Danger
CloseButton.Text = "✕"
CloseButton.TextColor3 = COLORS.Text
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

-- Content area dengan padding yang lebih baik
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -40, 1, -90)
ContentFrame.Position = UDim2.new(0, 20, 0, 70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Speed Section dengan modern card design
local SpeedCard = Instance.new("Frame")
SpeedCard.Name = "SpeedCard"
SpeedCard.Size = UDim2.new(1, 0, 0, 120)
SpeedCard.Position = UDim2.new(0, 0, 0, 0)
SpeedCard.BackgroundColor3 = COLORS.Secondary
SpeedCard.BorderSizePixel = 0
SpeedCard.Parent = ContentFrame

local SpeedCardCorner = Instance.new("UICorner")
SpeedCardCorner.CornerRadius = UDim.new(0, 15)
SpeedCardCorner.Parent = SpeedCard

-- Speed header dengan icon
local SpeedHeader = Instance.new("Frame")
SpeedHeader.Size = UDim2.new(1, -20, 0, 35)
SpeedHeader.Position = UDim2.new(0, 10, 0, 10)
SpeedHeader.BackgroundTransparency = 1
SpeedHeader.Parent = SpeedCard

local SpeedIcon = Instance.new("TextLabel")
SpeedIcon.Size = UDim2.new(0, 25, 0, 25)
SpeedIcon.Position = UDim2.new(0, 0, 0.5, -12.5)
SpeedIcon.BackgroundTransparency = 1
SpeedIcon.Text = "🏃"
SpeedIcon.TextScaled = true
SpeedIcon.Font = Enum.Font.SourceSans
SpeedIcon.Parent = SpeedHeader

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -120, 1, 0)
SpeedLabel.Position = UDim2.new(0, 30, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Movement Speed"
SpeedLabel.TextColor3 = COLORS.Text
SpeedLabel.TextScaled = true
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Font = Enum.Font.GothamMedium
SpeedLabel.Parent = SpeedHeader

-- Speed value display dengan design yang lebih baik
local SpeedValue = Instance.new("TextLabel")
SpeedValue.Size = UDim2.new(0, 80, 0, 25)
SpeedValue.Position = UDim2.new(1, -85, 0.5, -12.5)
SpeedValue.BackgroundColor3 = COLORS.Accent
SpeedValue.Text = tostring(math.floor(CurrentWalkspeed))
SpeedValue.TextColor3 = COLORS.Text
SpeedValue.TextScaled = true
SpeedValue.Font = Enum.Font.GothamBold
SpeedValue.BorderSizePixel = 0
SpeedValue.Parent = SpeedHeader

local SpeedValueCorner = Instance.new("UICorner")
SpeedValueCorner.CornerRadius = UDim.new(0, 8)
SpeedValueCorner.Parent = SpeedValue

-- Modern slider dengan design yang lebih halus
local SpeedSliderBG = Instance.new("Frame")
SpeedSliderBG.Size = UDim2.new(1, -20, 0, 10)
SpeedSliderBG.Position = UDim2.new(0, 10, 0, 55)
SpeedSliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
SpeedSliderBG.BorderSizePixel = 0
SpeedSliderBG.Parent = SpeedCard

local SpeedSliderBGCorner = Instance.new("UICorner")
SpeedSliderBGCorner.CornerRadius = UDim.new(0, 5)
SpeedSliderBGCorner.Parent = SpeedSliderBG

local SpeedSliderFill = Instance.new("Frame")
SpeedSliderFill.Size = UDim2.new(CurrentWalkspeed / 200, 0, 1, 0)
SpeedSliderFill.BackgroundColor3 = COLORS.Accent
SpeedSliderFill.BorderSizePixel = 0
SpeedSliderFill.Parent = SpeedSliderBG

local SpeedSliderFillCorner = Instance.new("UICorner")
SpeedSliderFillCorner.CornerRadius = UDim.new(0, 5)
SpeedSliderFillCorner.Parent = SpeedSliderFill

local SpeedSliderThumb = Instance.new("Frame")
SpeedSliderThumb.Size = UDim2.new(0, 20, 0, 20)
SpeedSliderThumb.Position = UDim2.new(CurrentWalkspeed / 200, -10, 0.5, -10)
SpeedSliderThumb.BackgroundColor3 = COLORS.Text
SpeedSliderThumb.BorderSizePixel = 0
SpeedSliderThumb.Parent = SpeedSliderBG

local SpeedThumbCorner = Instance.new("UICorner")
SpeedThumbCorner.CornerRadius = UDim.new(1, 0)
SpeedThumbCorner.Parent = SpeedSliderThumb

-- Speed controls dengan layout yang lebih baik
local SpeedControls = Instance.new("Frame")
SpeedControls.Size = UDim2.new(1, -20, 0, 40)
SpeedControls.Position = UDim2.new(0, 10, 0, 75)
SpeedControls.BackgroundTransparency = 1
SpeedControls.Parent = SpeedCard

local SpeedDecrease = Instance.new("TextButton")
SpeedDecrease.Size = IsMobile and UDim2.new(0, 55, 1, 0) or UDim2.new(0, 45, 1, 0)
SpeedDecrease.Position = UDim2.new(0, 0, 0, 0)
SpeedDecrease.BackgroundColor3 = COLORS.Danger
SpeedDecrease.Text = "−"
SpeedDecrease.TextColor3 = COLORS.Text
SpeedDecrease.TextSize = 22
SpeedDecrease.Font = Enum.Font.GothamBold
SpeedDecrease.BorderSizePixel = 0
SpeedDecrease.Parent = SpeedControls

local SpeedDecreaseCorner = Instance.new("UICorner")
SpeedDecreaseCorner.CornerRadius = UDim.new(0, 10)
SpeedDecreaseCorner.Parent = SpeedDecrease

-- Speed display di tengah
local SpeedDisplay = Instance.new("TextLabel")
SpeedDisplay.Size = IsMobile and UDim2.new(1, -130, 1, 0) or UDim2.new(1, -110, 1, 0)
SpeedDisplay.Position = IsMobile and UDim2.new(0, 65, 0, 0) or UDim2.new(0, 55, 0, 0)
SpeedDisplay.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
SpeedDisplay.Text = "Speed: " .. math.floor(CurrentWalkspeed)
SpeedDisplay.TextColor3 = COLORS.Text
SpeedDisplay.TextScaled = true
SpeedDisplay.Font = Enum.Font.GothamMedium
SpeedDisplay.BorderSizePixel = 0
SpeedDisplay.Parent = SpeedControls

local SpeedDisplayCorner = Instance.new("UICorner")
SpeedDisplayCorner.CornerRadius = UDim.new(0, 10)
SpeedDisplayCorner.Parent = SpeedDisplay

local SpeedIncrease = Instance.new("TextButton")
SpeedIncrease.Size = IsMobile and UDim2.new(0, 55, 1, 0) or UDim2.new(0, 45, 1, 0)
SpeedIncrease.Position = IsMobile and UDim2.new(1, -55, 0, 0) or UDim2.new(1, -45, 0, 0)
SpeedIncrease.BackgroundColor3 = COLORS.Success
SpeedIncrease.Text = "+"
SpeedIncrease.TextColor3 = COLORS.Text
SpeedIncrease.TextSize = 22
SpeedIncrease.Font = Enum.Font.GothamBold
SpeedIncrease.BorderSizePixel = 0
SpeedIncrease.Parent = SpeedControls

local SpeedIncreaseCorner = Instance.new("UICorner")
SpeedIncreaseCorner.CornerRadius = UDim.new(0, 10)
SpeedIncreaseCorner.Parent = SpeedIncrease

-- Jump Section dengan design yang sama
local JumpCard = Instance.new("Frame")
JumpCard.Name = "JumpCard"
JumpCard.Size = UDim2.new(1, 0, 0, 120)
JumpCard.Position = UDim2.new(0, 0, 0, 135)
JumpCard.BackgroundColor3 = COLORS.Secondary
JumpCard.BorderSizePixel = 0
JumpCard.Parent = ContentFrame

local JumpCardCorner = Instance.new("UICorner")
JumpCardCorner.CornerRadius = UDim.new(0, 15)
JumpCardCorner.Parent = JumpCard

-- Jump header dengan icon
local JumpHeader = Instance.new("Frame")
JumpHeader.Size = UDim2.new(1, -20, 0, 35)
JumpHeader.Position = UDim2.new(0, 10, 0, 10)
JumpHeader.BackgroundTransparency = 1
JumpHeader.Parent = JumpCard

local JumpIcon = Instance.new("TextLabel")
JumpIcon.Size = UDim2.new(0, 25, 0, 25)
JumpIcon.Position = UDim2.new(0, 0, 0.5, -12.5)
JumpIcon.BackgroundTransparency = 1
JumpIcon.Text = "🦘"
JumpIcon.TextScaled = true
JumpIcon.Font = Enum.Font.SourceSans
JumpIcon.Parent = JumpHeader

local JumpLabel = Instance.new("TextLabel")
JumpLabel.Size = UDim2.new(1, -120, 1, 0)
JumpLabel.Position = UDim2.new(0, 30, 0, 0)
JumpLabel.BackgroundTransparency = 1
JumpLabel.Text = "Jump Power"
JumpLabel.TextColor3 = COLORS.Text
JumpLabel.TextScaled = true
JumpLabel.TextXAlignment = Enum.TextXAlignment.Left
JumpLabel.Font = Enum.Font.GothamMedium
JumpLabel.Parent = JumpHeader

-- Jump value display
local JumpValue = Instance.new("TextLabel")
JumpValue.Size = UDim2.new(0, 80, 0, 25)
JumpValue.Position = UDim2.new(1, -85, 0.5, -12.5)
JumpValue.BackgroundColor3 = COLORS.Warning
JumpValue.Text = tostring(math.floor(CurrentJumpPower))
JumpValue.TextColor3 = COLORS.Text
JumpValue.TextScaled = true
JumpValue.Font = Enum.Font.GothamBold
JumpValue.BorderSizePixel = 0
JumpValue.Parent = JumpHeader

local JumpValueCorner = Instance.new("UICorner")
JumpValueCorner.CornerRadius = UDim.new(0, 8)
JumpValueCorner.Parent = JumpValue

-- Jump slider
local JumpSliderBG = Instance.new("Frame")
JumpSliderBG.Size = UDim2.new(1, -20, 0, 10)
JumpSliderBG.Position = UDim2.new(0, 10, 0, 55)
JumpSliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
JumpSliderBG.BorderSizePixel = 0
JumpSliderBG.Parent = JumpCard

local JumpSliderBGCorner = Instance.new("UICorner")
JumpSliderBGCorner.CornerRadius = UDim.new(0, 5)
JumpSliderBGCorner.Parent = JumpSliderBG

local JumpSliderFill = Instance.new("Frame")
JumpSliderFill.Size = UDim2.new(CurrentJumpPower / 500, 0, 1, 0)
JumpSliderFill.BackgroundColor3 = COLORS.Warning
JumpSliderFill.BorderSizePixel = 0
JumpSliderFill.Parent = JumpSliderBG

local JumpSliderFillCorner = Instance.new("UICorner")
JumpSliderFillCorner.CornerRadius = UDim.new(0, 5)
JumpSliderFillCorner.Parent = JumpSliderFill

local JumpSliderThumb = Instance.new("Frame")
JumpSliderThumb.Size = UDim2.new(0, 20, 0, 20)
JumpSliderThumb.Position = UDim2.new(CurrentJumpPower / 500, -10, 0.5, -10)
JumpSliderThumb.BackgroundColor3 = COLORS.Text
JumpSliderThumb.BorderSizePixel = 0
JumpSliderThumb.Parent = JumpSliderBG

local JumpThumbCorner = Instance.new("UICorner")
JumpThumbCorner.CornerRadius = UDim.new(1, 0)
JumpThumbCorner.Parent = JumpSliderThumb

-- Jump controls
local JumpControls = Instance.new("Frame")
JumpControls.Size = UDim2.new(1, -20, 0, 40)
JumpControls.Position = UDim2.new(0, 10, 0, 75)
JumpControls.BackgroundTransparency = 1
JumpControls.Parent = JumpCard

local JumpDecrease = Instance.new("TextButton")
JumpDecrease.Size = IsMobile and UDim2.new(0, 55, 1, 0) or UDim2.new(0, 45, 1, 0)
JumpDecrease.Position = UDim2.new(0, 0, 0, 0)
JumpDecrease.BackgroundColor3 = COLORS.Danger
JumpDecrease.Text = "−"
JumpDecrease.TextColor3 = COLORS.Text
JumpDecrease.TextSize = 22
JumpDecrease.Font = Enum.Font.GothamBold
JumpDecrease.BorderSizePixel = 0
JumpDecrease.Parent = JumpControls

local JumpDecreaseCorner = Instance.new("UICorner")
JumpDecreaseCorner.CornerRadius = UDim.new(0, 10)
JumpDecreaseCorner.Parent = JumpDecrease

local JumpDisplay = Instance.new("TextLabel")
JumpDisplay.Size = IsMobile and UDim2.new(1, -130, 1, 0) or UDim2.new(1, -110, 1, 0)
JumpDisplay.Position = IsMobile and UDim2.new(0, 65, 0, 0) or UDim2.new(0, 55, 0, 0)
JumpDisplay.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
JumpDisplay.Text = "Jump: " .. math.floor(CurrentJumpPower)
JumpDisplay.TextColor3 = COLORS.Text
JumpDisplay.TextScaled = true
JumpDisplay.Font = Enum.Font.GothamMedium
JumpDisplay.BorderSizePixel = 0
JumpDisplay.Parent = JumpControls

local JumpDisplayCorner = Instance.new("UICorner")
JumpDisplayCorner.CornerRadius = UDim.new(0, 10)
JumpDisplayCorner.Parent = JumpDisplay

local JumpIncrease = Instance.new("TextButton")
JumpIncrease.Size = IsMobile and UDim2.new(0, 55, 1, 0) or UDim2.new(0, 45, 1, 0)
JumpIncrease.Position = IsMobile and UDim2.new(1, -55, 0, 0) or UDim2.new(1, -45, 0, 0)
JumpIncrease.BackgroundColor3 = COLORS.Success
JumpIncrease.Text = "+"
JumpIncrease.TextColor3 = COLORS.Text
JumpIncrease.TextSize = 22
JumpIncrease.Font = Enum.Font.GothamBold
JumpIncrease.BorderSizePixel = 0
JumpIncrease.Parent = JumpControls

local JumpIncreaseCorner = Instance.new("UICorner")
JumpIncreaseCorner.CornerRadius = UDim.new(0, 10)
JumpIncreaseCorner.Parent = JumpIncrease

-- Action buttons dengan design yang lebih modern
local ActionFrame = Instance.new("Frame")
ActionFrame.Size = UDim2.new(1, 0, 0, 50)
ActionFrame.Position = UDim2.new(0, 0, 0, 270)
ActionFrame.BackgroundTransparency = 1
ActionFrame.Parent = ContentFrame

local ResetButton = Instance.new("TextButton")
ResetButton.Size = UDim2.new(0.32, -3, 1, 0)
ResetButton.Position = UDim2.new(0, 0, 0, 0)
ResetButton.BackgroundColor3 = Color3.fromRGB(120, 120, 130)
ResetButton.Text = "🔄 Reset"
ResetButton.TextColor3 = COLORS.Text
ResetButton.TextScaled = true
ResetButton.Font = Enum.Font.GothamMedium
ResetButton.BorderSizePixel = 0
ResetButton.Parent = ActionFrame

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 12)
ResetCorner.Parent = ResetButton

local ApplyButton = Instance.new("TextButton")
ApplyButton.Size = UDim2.new(0.36, -3, 1, 0)
ApplyButton.Position = UDim2.new(0.34, 3, 0, 0)
ApplyButton.BackgroundColor3 = COLORS.Accent
ApplyButton.Text = "✓ Apply"
ApplyButton.TextColor3 = COLORS.Text
ApplyButton.TextScaled = true
ApplyButton.Font = Enum.Font.GothamMedium
ApplyButton.BorderSizePixel = 0
ApplyButton.Parent = ActionFrame

local ApplyCorner = Instance.new("UICorner")
ApplyCorner.CornerRadius = UDim.new(0, 12)
ApplyCorner.Parent = ApplyButton

local ToggleJumpButton = Instance.new("TextButton")
ToggleJumpButton.Size = UDim2.new(0.32, -3, 1, 0)
ToggleJumpButton.Position = UDim2.new(0.68, 3, 0, 0)
ToggleJumpButton.BackgroundColor3 = COLORS.Warning
ToggleJumpButton.Text = "👁️ Hide"
ToggleJumpButton.TextColor3 = COLORS.Text
ToggleJumpButton.TextScaled = true
ToggleJumpButton.Font = Enum.Font.GothamMedium
ToggleJumpButton.BorderSizePixel = 0
ToggleJumpButton.Parent = ActionFrame

local ToggleJumpCorner = Instance.new("UICorner")
ToggleJumpCorner.CornerRadius = UDim.new(0, 12)
ToggleJumpCorner.Parent = ToggleJumpButton

-- Hide/Show button dengan design yang lebih baik
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, 120, 0, 40)
HideButton.Position = UDim2.new(0.5, -60, 1, -50)
HideButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
HideButton.Text = "Hide UI"
HideButton.TextColor3 = COLORS.Text
HideButton.TextScaled = true
HideButton.Font = Enum.Font.GothamMedium
HideButton.BorderSizePixel = 0
HideButton.Parent = MainFrame

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 12)
HideCorner.Parent = HideButton

-- Show button (floating) dengan design yang lebih baik
local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0, 140, 0, 50)
ShowButton.Position = UDim2.new(0, 20, 0.5, -25)
ShowButton.BackgroundColor3 = COLORS.Accent
ShowButton.Text = "Show Controller"
ShowButton.TextColor3 = COLORS.Text
ShowButton.TextScaled = true
ShowButton.Font = Enum.Font.GothamBold
ShowButton.BorderSizePixel = 0
ShowButton.Visible = false
ShowButton.Active = true
ShowButton.Draggable = true
ShowButton.Parent = ScreenGui

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(0, 15)
ShowCorner.Parent = ShowButton

-- Shadow untuk Show Button
local ShowShadow = Instance.new("Frame")
ShowShadow.Size = UDim2.new(1, 6, 1, 6)
ShowShadow.Position = UDim2.new(0, 3, 0, 3)
ShowShadow.BackgroundColor3 = Color3.new(0, 0, 0)
ShowShadow.BackgroundTransparency = 0.6
ShowShadow.ZIndex = -1
ShowShadow.Parent = ShowButton

local ShowShadowCorner = Instance.new("UICorner")
ShowShadowCorner.CornerRadius = UDim.new(0, 15)
ShowShadowCorner.Parent = ShowShadow

-- Floating Jump Button dengan design yang lebih modern
local JumpButton = Instance.new("TextButton")
JumpButton.Name = "JumpButton"
JumpButton.Size = IsMobile and SIZES.Mobile.JumpButton or SIZES.Desktop.JumpButton
JumpButton.Position = IsMobile and UDim2.new(1, -110, 1, -110) or UDim2.new(1, -100, 1, -100)
JumpButton.BackgroundColor3 = COLORS.Warning
JumpButton.Text = "JUMP"
JumpButton.TextColor3 = COLORS.Text
JumpButton.TextScaled = true
JumpButton.Font = Enum.Font.GothamBold
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
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 159, 10)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 149, 0))
}
JumpButtonGradient.Rotation = 45
JumpButtonGradient.Parent = JumpButton

-- Shadow untuk Jump Button
local JumpButtonShadow = Instance.new("Frame")
JumpButtonShadow.Size = UDim2.new(1, 8, 1, 8)
JumpButtonShadow.Position = UDim2.new(0, 4, 0, 4)
JumpButtonShadow.BackgroundColor3 = Color3.new(0, 0, 0)
JumpButtonShadow.BackgroundTransparency = 0.4
JumpButtonShadow.ZIndex = -1
JumpButtonShadow.Parent = JumpButton

local JumpButtonShadowCorner = Instance.new("UICorner")
JumpButtonShadowCorner.CornerRadius = UDim.new(0.5, 0)
JumpButtonShadowCorner.Parent = JumpButtonShadow

-- Functions yang telah diperbaiki
local function UpdateWalkspeed(speed)
    CurrentWalkspeed = math.clamp(speed, 0, 200)
    SpeedValue.Text = tostring(math.floor(CurrentWalkspeed))
    SpeedDisplay.Text = "Speed: " .. math.floor(CurrentWalkspeed)
    
    local percentage = CurrentWalkspeed / 200
    local tween = TweenService:Create(SpeedSliderFill, TweenInfo.new(0.2), {
        Size = UDim2.new(percentage, 0, 1, 0)
    })
    tween:Play()
    
    local thumbTween = TweenService:Create(SpeedSliderThumb, TweenInfo.new(0.2), {
        Position = UDim2.new(percentage, -10, 0.5, -10)
    })
    thumbTween:Play()
end

local function UpdateJumpPower(jumpPower)
    CurrentJumpPower = math.clamp(jumpPower, 0, 500)
    JumpValue.Text = tostring(math.floor(CurrentJumpPower))
    JumpDisplay.Text = "Jump: " .. math.floor(CurrentJumpPower)
    
    local percentage = CurrentJumpPower / 500
    local tween = TweenService:Create(JumpSliderFill, TweenInfo.new(0.2), {
        Size = UDim2.new(percentage, 0, 1, 0)
    })
    tween:Play()
    
    local thumbTween = TweenService:Create(JumpSliderThumb, TweenInfo.new(0.2), {
        Position = UDim2.new(percentage, -10, 0.5, -10)
    })
    thumbTween:Play()
end

local function ApplyWalkspeed()
    if Humanoid then
        Humanoid.WalkSpeed = CurrentWalkspeed
        -- Visual feedback
        local tween = TweenService:Create(SpeedValue, TweenInfo.new(0.3), {
            BackgroundColor3 = COLORS.Success
        })
        tween:Play()
        tween.Completed:Connect(function()
            TweenService:Create(SpeedValue, TweenInfo.new(0.3), {
                BackgroundColor3 = COLORS.Accent
            }):Play()
        end)
    end
end

local function ApplyJumpPower()
    if Humanoid then
        if Humanoid.UseJumpPower then
            Humanoid.JumpPower = CurrentJumpPower
        else
            Humanoid.JumpHeight = CurrentJumpPower * 0.35
        end
        -- Visual feedback
        local tween = TweenService:Create(JumpValue, TweenInfo.new(0.3), {
            BackgroundColor3 = COLORS.Success
        })
        tween:Play()
        tween.Completed:Connect(function()
            TweenService:Create(JumpValue, TweenInfo.new(0.3), {
                BackgroundColor3 = COLORS.Warning
            }):Play()
        end)
    end
end

local function ApplyAll()
    ApplyWalkspeed()
    ApplyJumpPower()
end

local function ResetAll()
    UpdateWalkspeed(DefaultWalkspeed)
    UpdateJumpPower(DefaultJumpPower)
    ApplyAll()
end

local function IncreaseSpeed()
    local newSpeed = CurrentWalkspeed + 5
    UpdateWalkspeed(newSpeed)
    ApplyWalkspeed()
end

local function DecreaseSpeed()
    local newSpeed = CurrentWalkspeed - 5
    UpdateWalkspeed(newSpeed)
    ApplyWalkspeed()
end

local function IncreaseJump()
    local newJumpPower = CurrentJumpPower + 15
    UpdateJumpPower(newJumpPower)
    ApplyJumpPower()
end

local function DecreaseJump()
    local newJumpPower = CurrentJumpPower - 15
    UpdateJumpPower(newJumpPower)
    ApplyJumpPower()
end

local function ToggleJumpButtonVisibility()
    JumpButtonVisible = not JumpButtonVisible
    
    if JumpButtonVisible then
        ToggleJumpButton.Text = "👁️ Hide"
        ToggleJumpButton.BackgroundColor3 = COLORS.Warning
        
        JumpButton.Visible = true
        JumpButton.BackgroundTransparency = 1
        JumpButton.TextTransparency = 1
        
        TweenService:Create(JumpButton, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            BackgroundTransparency = 0,
            TextTransparency = 0
        }):Play()
    else
        ToggleJumpButton.Text = "👁️ Show"
        ToggleJumpButton.BackgroundColor3 = Color3.fromRGB(120, 120, 130)
        
        TweenService:Create(JumpButton, TweenInfo.new(0.3), {
            BackgroundTransparency = 1,
            TextTransparency = 1
        }):Play().Completed:Connect(function()
            JumpButton.Visible = false
        end)
    end
end

local function DoJump()
    if Humanoid and Humanoid.Parent and Humanoid.Parent:FindFirstChild("HumanoidRootPart") then
        ApplyJumpPower()
        Humanoid.Jump = true
        
        -- Enhanced visual feedback
        local originalSize = JumpButton.Size
        local scale1 = TweenService:Create(JumpButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = originalSize * 0.85
        })
        scale1:Play()
        
        scale1.Completed:Connect(function()
            local scale2 = TweenService:Create(JumpButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                Size = originalSize
            })
            scale2:Play()
        end)
    end
end

local function HideUI()
    UIVisible = false
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play().Completed:Connect(function()
        MainFrame.Visible = false
        ShowButton.Visible = true
        
        ShowButton.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(ShowButton, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 140, 0, 50)
        }):Play()
    end)
end

local function ShowUI()
    UIVisible = true
    MainFrame.Visible = true
    
    TweenService:Create(ShowButton, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play().Completed:Connect(function()
        ShowButton.Visible = false
        
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = IsMobile and SIZES.Mobile.MainFrame or SIZES.Desktop.MainFrame
        }):Play()
    end)
end

local function ToggleUI()
    if UIVisible then
        HideUI()
    else
        ShowUI()
    end
end

-- Enhanced slider functionality
local dragging = false
local jumpDragging = false

-- Speed slider functionality
SpeedSliderBG.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        local mouse = input.Position
        local relativeX = mouse.X - SpeedSliderBG.AbsolutePosition.X
        local percentage = math.clamp(relativeX / SpeedSliderBG.AbsoluteSize.X, 0, 1)
        local speed = percentage * 200
        UpdateWalkspeed(speed)
        ApplyWalkspeed()
    end
end)

SpeedSliderThumb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

-- Jump slider functionality
JumpSliderBG.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        jumpDragging = true
        local mouse = input.Position
        local relativeX = mouse.X - JumpSliderBG.AbsolutePosition.X
        local percentage = math.clamp(relativeX / JumpSliderBG.AbsoluteSize.X, 0, 1)
        local jumpPower = percentage * 500
        UpdateJumpPower(jumpPower)
        ApplyJumpPower()
    end
end)

JumpSliderThumb.InputBegan:Connect(function(input)
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local mouse = input.Position
            local relativeX = mouse.X - SpeedSliderBG.AbsolutePosition.X
            local percentage = math.clamp(relativeX / SpeedSliderBG.AbsoluteSize.X, 0, 1)
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
ResetButton.MouseButton1Click:Connect(ResetAll)
ApplyButton.MouseButton1Click:Connect(ApplyAll)
CloseButton.MouseButton1Click:Connect(ToggleUI)
HideButton.MouseButton1Click:Connect(HideUI)
ShowButton.MouseButton1Click:Connect(ShowUI)
SpeedIncrease.MouseButton1Click:Connect(IncreaseSpeed)
SpeedDecrease.MouseButton1Click:Connect(DecreaseSpeed)
JumpIncrease.MouseButton1Click:Connect(IncreaseJump)
JumpDecrease.MouseButton1Click:Connect(DecreaseJump)
ToggleJumpButton.MouseButton1Click:Connect(ToggleJumpButtonVisibility)
JumpButton.MouseButton1Click:Connect(DoJump)

-- Keyboard shortcuts
if not IsMobile then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if input.KeyCode == Enum.KeyCode.RightShift then
                ToggleUI()
            elseif input.KeyCode == Enum.KeyCode.Space then
                DoJump()
            end
        end
    end)
end

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    ApplyAll()
end)

-- Enhanced hover effects
local function CreateHoverEffect(button, normalColor, hoverColor, scaleEffect)
    scaleEffect = scaleEffect or false
    
    button.MouseEnter:Connect(function()
        local colorTween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor
        })
        colorTween:Play()
        
        if scaleEffect then
            TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = button.Size * 1.05
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        local colorTween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = normalColor
        })
        colorTween:Play()
        
        if scaleEffect then
            TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = button.Size / 1.05
            }):Play()
        end
    end)
end

-- Apply hover effects
CreateHoverEffect(ResetButton, Color3.fromRGB(120, 120, 130), Color3.fromRGB(140, 140, 150))
CreateHoverEffect(ApplyButton, COLORS.Accent, Color3.fromRGB(60, 120, 255))
CreateHoverEffect(CloseButton, COLORS.Danger, Color3.fromRGB(255, 89, 78))
CreateHoverEffect(HideButton, Color3.fromRGB(80, 80, 90), Color3.fromRGB(100, 100, 110))
CreateHoverEffect(ShowButton, COLORS.Accent, Color3.fromRGB(60, 120, 255), true)
CreateHoverEffect(SpeedIncrease, COLORS.Success, Color3.fromRGB(72, 219, 109))
CreateHoverEffect(SpeedDecrease, COLORS.Danger, Color3.fromRGB(255, 89, 78))
CreateHoverEffect(JumpIncrease, COLORS.Success, Color3.fromRGB(72, 219, 109))
CreateHoverEffect(JumpDecrease, COLORS.Danger, Color3.fromRGB(255, 89, 78))
CreateHoverEffect(ToggleJumpButton, COLORS.Warning, Color3.fromRGB(255, 169, 20))
CreateHoverEffect(JumpButton, COLORS.Warning, Color3.fromRGB(255, 169, 20), true)

-- Hover effects for displays
SpeedDisplay.MouseEnter:Connect(function()
    TweenService:Create(SpeedDisplay, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(70, 70, 78)
    }):Play()
end)

SpeedDisplay.MouseLeave:Connect(function()
    TweenService:Create(SpeedDisplay, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 58)
    }):Play()
end)

JumpDisplay.MouseEnter:Connect(function()
    TweenService:Create(JumpDisplay, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(70, 70, 78)
    }):Play()
end)

JumpDisplay.MouseLeave:Connect(function()
    TweenService:Create(JumpDisplay, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 58)
    }):Play()
end)

-- Initial setup
UpdateWalkspeed(DefaultWalkspeed)
UpdateJumpPower(DefaultJumpPower)

-- Entrance animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {
    Size = IsMobile and SIZES.Mobile.MainFrame or SIZES.Desktop.MainFrame
}):Play()

-- Enhanced notification
StarterGui:SetCore("SendNotification", {
    Title = "Movement Controller",
    Text = "Professional UI loaded successfully! " .. (IsMobile and "Mobile optimized." or "Desktop mode with keyboard shortcuts."),
    Duration = 4,
    Icon = "rbxasset://textures/ui/GuiImagePlaceholder.png"
})
