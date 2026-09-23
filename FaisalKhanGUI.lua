-- FAISAL KHAN GUI
-- UI only. Replace YOUR_IMAGE_ID with your Roblox image asset ID.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local IMAGE_ID = "119422664257704"

local PURPLE = Color3.fromRGB(150,70,255)
local DARK = Color3.fromRGB(10,12,17)
local ROW = Color3.fromRGB(23,26,34)
local WHITE = Color3.fromRGB(245,245,250)

local Gui = Instance.new("ScreenGui")
Gui.Name = "FaisalKhanGUI"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(430,650)
Main.Position = UDim2.new(.5,-215,.5,-325)
Main.BackgroundColor3 = DARK
Main.BorderSizePixel = 0
Main.Parent = Gui

local MC = Instance.new("UICorner",Main)
MC.CornerRadius = UDim.new(0,18)

local MS = Instance.new("UIStroke",Main)
MS.Color = PURPLE
MS.Thickness = 1.5
MS.Transparency = .25

-- Drag
local dragging, dragStart, startPos = false,nil,nil
Main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging=true; dragStart=i.Position; startPos=Main.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragging=false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if not dragging then return end
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        local d=i.Position-dragStart
        Main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)

local Title=Instance.new("TextLabel",Main)
Title.BackgroundTransparency=1
Title.Position=UDim2.fromOffset(25,15)
Title.Size=UDim2.new(1,-90,0,55)
Title.Text="FAISAL KHAN"
Title.TextColor3=WHITE
Title.TextSize=30
Title.Font=Enum.Font.GothamBlack
Title.TextXAlignment=Enum.TextXAlignment.Left

local TG=Instance.new("UIGradient",Title)
TG.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,WHITE),
    ColorSequenceKeypoint.new(.65,WHITE),
    ColorSequenceKeypoint.new(1,PURPLE)
})

local Min=Instance.new("TextButton",Main)
Min.Name="Minimize"
Min.Size=UDim2.fromOffset(48,48)
Min.Position=UDim2.new(1,-63,0,17)
Min.BackgroundColor3=ROW
Min.Text="−"
Min.TextColor3=WHITE
Min.TextSize=30
Min.Font=Enum.Font.GothamBold
Min.AutoButtonColor=false

local MinC=Instance.new("UICorner",Min)
MinC.CornerRadius=UDim.new(0,12)

local Content=Instance.new("Frame",Main)
Content.BackgroundTransparency=1
Content.Position=UDim2.fromOffset(15,80)
Content.Size=UDim2.new(1,-30,1,-95)

local Layout=Instance.new("UIListLayout",Content)
Layout.Padding=UDim.new(0,8)

local Toggles={}
local function Toggle(name,default)
    local row=Instance.new("Frame",Content)
    row.Size=UDim2.new(1,0,0,58)
    row.BackgroundColor3=ROW
    row.BorderSizePixel=0

    local c=Instance.new("UICorner",row)
    c.CornerRadius=UDim.new(0,12)

    local label=Instance.new("TextLabel",row)
    label.BackgroundTransparency=1
    label.Position=UDim2.fromOffset(18,0)
    label.Size=UDim2.new(1,-90,1,0)
    label.Text=name
    label.TextColor3=WHITE
    label.TextSize=17
    label.Font=Enum.Font.GothamSemibold
    label.TextXAlignment=Enum.TextXAlignment.Left

    local b=Instance.new("TextButton",row)
    b.Size=UDim2.fromOffset(54,30)
    b.Position=UDim2.new(1,-70,.5,-15)
    b.Text=""
    b.AutoButtonColor=false

    local bc=Instance.new("UICorner",b)
    bc.CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",b)
    knob.Size=UDim2.fromOffset(24,24)
    knob.BackgroundColor3=WHITE
    knob.BorderSizePixel=0

    local kc=Instance.new("UICorner",knob)
    kc.CornerRadius=UDim.new(1,0)

    local state=default
    local function update()
        b.BackgroundColor3=state and PURPLE or Color3.fromRGB(55,58,68)
        TweenService:Create(knob,TweenInfo.new(.15),{
            Position=state and UDim2.new(1,-27,.5,-12) or UDim2.new(0,3,.5,-12)
        }):Play()
    end
    b.MouseButton1Click:Connect(function()
        state=not state
        update()
    end)
    update()

    Toggles[name]={Get=function() return state end,Set=function(v) state=v;update() end}
end

Toggle("Aim Assist",true)
Toggle("Target Lock",true)
Toggle("ESP",true)
Toggle("Chams",true)
Toggle("Names",true)
Toggle("Health",true)
Toggle("Distance",true)

local function Slider(name,min,max,default)
    local f=Instance.new("Frame",Content)
    f.Size=UDim2.new(1,0,0,78)
    f.BackgroundColor3=ROW
    f.BorderSizePixel=0

    local c=Instance.new("UICorner",f)
    c.CornerRadius=UDim.new(0,12)

    local l=Instance.new("TextLabel",f)
    l.BackgroundTransparency=1
    l.Position=UDim2.fromOffset(18,7)
    l.Size=UDim2.new(1,-36,0,25)
    l.Text=name
    l.TextColor3=WHITE
    l.TextSize=16
    l.Font=Enum.Font.GothamSemibold
    l.TextXAlignment=Enum.TextXAlignment.Left

    local val=Instance.new("TextLabel",f)
    val.BackgroundTransparency=1
    val.Position=UDim2.new(1,-70,0,7)
    val.Size=UDim2.fromOffset(50,25)
    val.Text=tostring(default)
    val.TextColor3=WHITE
    val.TextSize=15
    val.Font=Enum.Font.GothamBold
    val.TextXAlignment=Enum.TextXAlignment.Right

    local bar=Instance.new("Frame",f)
    bar.Size=UDim2.new(1,-36,0,7)
    bar.Position=UDim2.fromOffset(18,52)
    bar.BackgroundColor3=Color3.fromRGB(48,51,60)
    bar.BorderSizePixel=0

    local bcorner=Instance.new("UICorner",bar)
    bcorner.CornerRadius=UDim.new(1,0)

    local p=(default-min)/(max-min)
    local fill=Instance.new("Frame",bar)
    fill.Size=UDim2.new(p,0,1,0)
    fill.BackgroundColor3=PURPLE
    fill.BorderSizePixel=0

    local fc=Instance.new("UICorner",fill)
    fc.CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",bar)
    knob.Size=UDim2.fromOffset(18,18)
    knob.AnchorPoint=Vector2.new(.5,.5)
    knob.Position=UDim2.new(p,0,.5,0)
    knob.BackgroundColor3=WHITE
    knob.BorderSizePixel=0

    local kc=Instance.new("UICorner",knob)
    kc.CornerRadius=UDim.new(1,0)

    local current=default
    local sliding=false

    local function setValue(x)
        if bar.AbsoluteSize.X<=0 then return end
        local q=math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
        current=math.floor(min+(max-min)*q)
        fill.Size=UDim2.new(q,0,1,0)
        knob.Position=UDim2.new(q,0,.5,0)
        val.Text=tostring(current)
    end

    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            sliding=true
            setValue(i.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if sliding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            setValue(i.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            sliding=false
        end
    end)

    return {Get=function() return current end}
end

Slider("FOV",20,250,150)
Slider("Smoothness",1,100,35)

local Footer=Instance.new("TextLabel",Content)
Footer.BackgroundTransparency=1
Footer.Size=UDim2.new(1,0,0,30)
Footer.Text="FAISAL KHAN  •  TEST UI"
Footer.TextColor3=PURPLE
Footer.TextSize=14
Footer.Font=Enum.Font.GothamBold

-- Minimized square image
local Mini=Instance.new("ImageButton",Gui)
Mini.Name="MiniImage"
Mini.Size=UDim2.fromOffset(72,72)
Mini.Position=Main.Position
Mini.BackgroundColor3=DARK
Mini.Image="rbxassetid://"..IMAGE_ID
Mini.ScaleType=Enum.ScaleType.Crop
Mini.Visible=false
Mini.AutoButtonColor=false

local MiniC=Instance.new("UICorner",Mini)
MiniC.CornerRadius=UDim.new(0,14)

local MiniS=Instance.new("UIStroke",Mini)
MiniS.Color=PURPLE
MiniS.Thickness=2

Min.MouseButton1Click:Connect(function()
    Mini.Position=Main.Position
    Main.Visible=false
    Mini.Visible=true
end)

Mini.MouseButton1Click:Connect(function()
    Main.Position=Mini.Position
    Mini.Visible=false
    Main.Visible=true
end)

print("FAISAL KHAN GUI loaded")
