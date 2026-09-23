--// FAISAL KHAN GUI
--// UI ONLY - Roblox Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local PURPLE = Color3.fromRGB(150, 70, 255)
local DARK = Color3.fromRGB(10, 12, 17)
local ROW = Color3.fromRGB(23, 26, 34)
local WHITE = Color3.fromRGB(245, 245, 250)

local Gui = Instance.new("ScreenGui")
Gui.Name = "FaisalKhanGUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0.92, 0, 0.82, 0)
Main.SizeConstraint = Enum.SizeConstraint.RelativeXY
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3 = DARK
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = PURPLE
Stroke.Thickness = 1.5
Stroke.Transparency = 0.25
Stroke.Parent = Main

-- DRAG
local Dragging = false
local DragStart
local StartPosition

Main.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then return end
    if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then
        local Delta = Input.Position - DragStart
        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

-- TITLE
local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(25, 15)
Title.Size = UDim2.new(1, -90, 0, 55)
Title.Text = "FAISAL KHAN"
Title.TextColor3 = WHITE
Title.TextSize = 30
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, WHITE),
    ColorSequenceKeypoint.new(0.65, WHITE),
    ColorSequenceKeypoint.new(1, PURPLE)
})
TitleGradient.Parent = Title

-- MINIMIZE
local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.Size = UDim2.fromOffset(48, 48)
Minimize.Position = UDim2.new(1, -63, 0, 17)
Minimize.BackgroundColor3 = ROW
Minimize.Text = "−"
Minimize.TextColor3 = WHITE
Minimize.TextSize = 30
Minimize.Font = Enum.Font.GothamBold
Minimize.AutoButtonColor = false
Minimize.Parent = Main

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 12)
MinCorner.Parent = Minimize

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Color3.fromRGB(70, 74, 85)
MinStroke.Thickness = 1
MinStroke.Parent = Minimize

-- CONTENT
local Content = Instance.new("Frame")
Content.BackgroundTransparency = 1
Content.Position = UDim2.fromOffset(15, 80)
Content.Size = UDim2.new(1, -30, 1, -95)
Content.Parent = Main

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 8)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Parent = Content

-- TOGGLES
local Toggles = {}

local function CreateToggle(Name, Default)
    local Row = Instance.new("Frame")
    Row.Name = Name
    Row.Size = UDim2.new(1, 0, 0, 58)
    Row.BackgroundColor3 = ROW
    Row.BorderSizePixel = 0
    Row.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.fromOffset(18, 0)
    Label.Size = UDim2.new(1, -90, 1, 0)
    Label.Text = Name
    Label.TextColor3 = WHITE
    Label.TextSize = 17
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.fromOffset(54, 30)
    Button.Position = UDim2.new(1, -70, 0.5, -15)
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Row

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = Button

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.fromOffset(24, 24)
    Knob.Position = UDim2.new(0, 3, 0.5, -12)
    Knob.BorderSizePixel = 0
    Knob.BackgroundColor3 = WHITE
    Knob.Parent = Button

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local State = Default

    local function Update()
        if State then
            Button.BackgroundColor3 = PURPLE
            TweenService:Create(Knob, TweenInfo.new(0.15), {
                Position = UDim2.new(1, -27, 0.5, -12)
            }):Play()
        else
            Button.BackgroundColor3 = Color3.fromRGB(55, 58, 68)
            TweenService:Create(Knob, TweenInfo.new(0.15), {
                Position = UDim2.new(0, 3, 0.5, -12)
            }):Play()
        end
    end

    Button.MouseButton1Click:Connect(function()
        State = not State
        Update()
    end)

    Update()

    Toggles[Name] = {
        Get = function() return State end,
        Set = function(Value) State = Value; Update() end
    }
end

CreateToggle("Aim Assist", true)
CreateToggle("Target Lock", true)
CreateToggle("ESP", true)
CreateToggle("Chams", true)
CreateToggle("Names", true)
CreateToggle("Health", true)
CreateToggle("Distance", true)

-- SLIDERS
local function CreateSlider(Name, Minimum, Maximum, Default)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 78)
    Frame.BackgroundColor3 = ROW
    Frame.BorderSizePixel = 0
    Frame.Parent = Content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.fromOffset(18, 7)
    Label.Size = UDim2.new(1, -36, 0, 25)
    Label.Text = Name
    Label.TextColor3 = WHITE
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Value = Instance.new("TextLabel")
    Value.BackgroundTransparency = 1
    Value.Position = UDim2.new(1, -70, 0, 7)
    Value.Size = UDim2.fromOffset(50, 25)
    Value.Text = tostring(Default)
    Value.TextColor3 = WHITE
    Value.TextSize = 15
    Value.Font = Enum.Font.GothamBold
    Value.TextXAlignment = Enum.TextXAlignment.Right
    Value.Parent = Frame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -36, 0, 7)
    Bar.Position = UDim2.fromOffset(18, 52)
    Bar.BackgroundColor3 = Color3.fromRGB(48, 51, 60)
    Bar.BorderSizePixel = 0
    Bar.Parent = Frame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    local DefaultPercent = (Default - Minimum) / (Maximum - Minimum)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(DefaultPercent, 0, 1, 0)
    Fill.BackgroundColor3 = PURPLE
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.fromOffset(18, 18)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new(DefaultPercent, 0, 0.5, 0)
    Knob.BackgroundColor3 = WHITE
    Knob.BorderSizePixel = 0
    Knob.Parent = Bar

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local ValueNumber = Default
    local Sliding = false

    local function SetValue(X)
        if Bar.AbsoluteSize.X <= 0 then return end
        local Percent = math.clamp(
            (X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
            0, 1
        )
        ValueNumber = math.floor(Minimum + (Maximum - Minimum) * Percent)
        Fill.Size = UDim2.new(Percent, 0, 1, 0)
        Knob.Position = UDim2.new(Percent, 0, 0.5, 0)
        Value.Text = tostring(ValueNumber)
    end

    Bar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then
            Sliding = true
            SetValue(Input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if not Sliding then return end
        if Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch then
            SetValue(Input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then
            Sliding = false
        end
    end)

    return {Get = function() return ValueNumber end}
end

local FOV = CreateSlider("FOV", 20, 250, 150)
local Smoothness = CreateSlider("Smoothness", 1, 100, 35)

-- FOOTER
local Footer = Instance.new("TextLabel")
Footer.BackgroundTransparency = 1
Footer.Size = UDim2.new(1, 0, 0, 30)
Footer.Text = "FAISAL KHAN  •  TEST UI"
Footer.TextColor3 = PURPLE
Footer.TextSize = 14
Footer.Font = Enum.Font.GothamBold
Footer.Parent = Content

-- SIMPLE MINIMIZED BUTTON: NO IMAGE / NO LOGO
local Mini = Instance.new("TextButton")
Mini.Name = "Mini"
Mini.Size = UDim2.fromOffset(48, 48)
Mini.Position = Main.Position
Mini.BackgroundColor3 = DARK
Mini.Text = ""
Mini.Visible = false
Mini.AutoButtonColor = false
Mini.Parent = Gui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 12)
MiniCorner.Parent = Mini

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = PURPLE
MiniStroke.Thickness = 2
MiniStroke.Parent = Mini

Minimize.MouseButton1Click:Connect(function()
    Mini.Position = Main.Position
    Main.Visible = false
    Mini.Visible = true
end)

Mini.MouseButton1Click:Connect(function()
    Main.Position = Mini.Position
    Mini.Visible = false
    Main.Visible = true
end)

print("FAISAL KHAN GUI loaded - no image / no logo")
