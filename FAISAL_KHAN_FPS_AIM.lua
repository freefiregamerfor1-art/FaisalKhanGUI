--========================================================
-- FAISAL KHAN | FPS AIM TEST
-- PART 1/4
-- Mobile Responsive GUI + Minimize
--========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Settings = {
    AimAssist = false,
    TargetLock = false,
    ESP = false,
    Chams = false,
    Names = true,
    Health = true,
    Distance = true,

    FOV = 150,
    Smoothness = 35
}

local LockedTarget = nil
local HadLock = false
local LockLost = false

local ESPObjects = {}
local TeamCache = {}

local Old = PlayerGui:FindFirstChild("FAISAL_KHAN")
if Old then
    Old:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FAISAL_KHAN"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--========================================================
-- MAIN
--========================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0,0.5)
Main.Position = UDim2.new(0.02,0,0.5,0)
Main.Size = UDim2.new(0.72,0,0.62,0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainLimit = Instance.new("UISizeConstraint")
MainLimit.MinSize = Vector2.new(220,260)
MainLimit.MaxSize = Vector2.new(340,520)
MainLimit.Parent = Main

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,10)
MainCorner.Parent = Main

--========================================================
-- TITLE BAR
--========================================================

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1,0,0,42)
TitleBar.BackgroundColor3 = Color3.fromRGB(28,28,28)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-55,1,0)
Title.Position = UDim2.new(0,12,0,0)
Title.BackgroundTransparency = 1
Title.Text = "FAISAL KHAN"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0,34,0,30)
Minimize.Position = UDim2.new(1,-40,0,6)
Minimize.BackgroundColor3 = Color3.fromRGB(45,45,45)
Minimize.BorderSizePixel = 0
Minimize.Text = "−"
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.TextSize = 20
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = TitleBar

Instance.new("UICorner",Minimize).CornerRadius = UDim.new(0,6)

--========================================================
-- CONTENT
--========================================================

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1,-10,1,-52)
Content.Position = UDim2.new(0,5,0,47)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.CanvasSize = UDim2.new(0,0,0,0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ScrollingDirection = Enum.ScrollingDirection.Y
Content.Parent = Main

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0,5)
Padding.PaddingRight = UDim.new(0,5)
Padding.PaddingTop = UDim.new(0,4)
Padding.PaddingBottom = UDim.new(0,8)
Padding.Parent = Content

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,7)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

--========================================================
-- MINIMIZE
--========================================================

local Minimized = false

Minimize.MouseButton1Click:Connect(function()
    Minimized = not Minimized

    Content.Visible = not Minimized

    if Minimized then
        Main.Size = UDim2.new(0.72,0,0,48)
        Minimize.Text = "+"
    else
        Main.Size = UDim2.new(0.72,0,0.62,0)
        Minimize.Text = "−"
    end
end)

--========================================================
-- DRAG / MOBILE TOUCH
--========================================================

local Dragging = false
local DragStart
local StartPosition

TitleBar.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if not Dragging then
        return
    end

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

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = false
    end
end)

--========================================================
-- TOGGLE
--========================================================

local function CreateToggle(Text,Name)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,0,0,36)
    Button.BackgroundColor3 = Color3.fromRGB(32,32,32)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Content

    Instance.new("UICorner",Button).CornerRadius = UDim.new(0,7)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,-65,1,0)
    Label.Position = UDim2.new(0,10,0,0)
    Label.BackgroundTransparency = 1
    Label.Text = Text
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0,50,1,0)
    Status.Position = UDim2.new(1,-55,0,0)
    Status.BackgroundTransparency = 1
    Status.TextSize = 12
    Status.Font = Enum.Font.GothamBold
    Status.Parent = Button

    local function Refresh()
        if Settings[Name] then
            Status.Text = "ON"
            Status.TextColor3 = Color3.fromRGB(60,255,100)
        else
            Status.Text = "OFF"
            Status.TextColor3 = Color3.fromRGB(255,80,80)
        end
    end

    Button.MouseButton1Click:Connect(function()
        Settings[Name] = not Settings[Name]
        Refresh()
    end)

    Refresh()
end

CreateToggle("Aim Assist","AimAssist")
CreateToggle("Target Lock","TargetLock")
CreateToggle("ESP","ESP")
CreateToggle("Chams","Chams")
CreateToggle("Names","Names")
CreateToggle("Health","Health")
CreateToggle("Distance","Distance")--========================================================
-- PART 2/4
-- FOV + Smoothness + Target Detection
--========================================================

local function CreateSlider(Text,Min,Max,Default,Callback)

    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1,0,0,48)
    Holder.BackgroundTransparency = 1
    Holder.Parent = Content

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,0,0,20)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Holder

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1,0,0,7)
    Bar.Position = UDim2.new(0,0,0,28)
    Bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Bar.BorderSizePixel = 0
    Bar.Parent = Holder

    Instance.new("UICorner",Bar).CornerRadius = UDim.new(1,0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Default-Min)/(Max-Min),0,1,0)
    Fill.BackgroundColor3 = Color3.new(1,1,1)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    Instance.new("UICorner",Fill).CornerRadius = UDim.new(1,0)

    local DraggingSlider = false

    local function Update(X)

        local Ratio = math.clamp(
            (X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,
            0,
            1
        )

        local Value = math.floor(
            Min+(Max-Min)*Ratio
        )

        Fill.Size = UDim2.new(Ratio,0,1,0)
        Label.Text = Text..": "..Value

        Callback(Value)
    end

    Label.Text = Text..": "..Default

    Bar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

            DraggingSlider = true
            Update(Input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if not DraggingSlider then return end

        if Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch then

            Update(Input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

            DraggingSlider = false
        end
    end)
end

CreateSlider("FOV",50,500,Settings.FOV,function(Value)
    Settings.FOV = Value
end)

CreateSlider("Smoothness",1,100,Settings.Smoothness,function(Value)
    Settings.Smoothness = Value
end)

--========================================================
-- CROSSHAIR
--========================================================

local Crosshair = Instance.new("Frame")
Crosshair.Name = "Crosshair"
Crosshair.AnchorPoint = Vector2.new(.5,.5)
Crosshair.Position = UDim2.new(.5,0,.5,0)
Crosshair.Size = UDim2.new(0,4,0,4)
Crosshair.BackgroundColor3 = Color3.new(1,1,1)
Crosshair.BorderSizePixel = 0
Crosshair.ZIndex = 20
Crosshair.Parent = ScreenGui

Instance.new("UICorner",Crosshair).CornerRadius = UDim.new(1,0)

--========================================================
-- FOV CIRCLE
--========================================================

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(.5,.5)
FOVCircle.Position = UDim2.new(.5,0,.5,0)
FOVCircle.Size = UDim2.new(0,Settings.FOV*2,0,Settings.FOV*2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.ZIndex = 19
FOVCircle.Parent = ScreenGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = Color3.new(1,1,1)
FOVStroke.Thickness = 1
FOVStroke.Parent = FOVCircle

Instance.new("UICorner",FOVCircle).CornerRadius = UDim.new(1,0)

--========================================================
-- HELPERS
--========================================================

local function GetHumanoid(Character)
    return Character and Character:FindFirstChildOfClass("Humanoid")
end

local function IsAlive(Character)
    local Humanoid = GetHumanoid(Character)
    return Humanoid and Humanoid.Health > 0
end

local function GetAimPart(Character)

    for _,Name in ipairs({
        "Head",
        "UpperTorso",
        "HumanoidRootPart"
    }) do

        local Part = Character:FindFirstChild(Name)

        if Part and Part:IsA("BasePart") then
            return Part
        end
    end

    return nil
end

local RayParams = RaycastParams.new()
RayParams.FilterType = Enum.RaycastFilterType.Exclude

local function Visible(Part,Character)

    if not Part or not Character then
        return false
    end

    RayParams.FilterDescendantsInstances = {
        LocalPlayer.Character,
        Character
    }

    local Origin = Camera.CFrame.Position
    local Direction = Part.Position-Origin

    local Result = workspace:Raycast(
        Origin,
        Direction,
        RayParams
    )

    return Result == nil
end

local function InFOV(Part)

    if not Part then
        return false
    end

    local ScreenPos,OnScreen =
        Camera:WorldToViewportPoint(Part.Position)

    if not OnScreen or ScreenPos.Z <= 0 then
        return false
    end

    local Center = Vector2.new(
        Camera.ViewportSize.X/2,
        Camera.ViewportSize.Y/2
    )

    local Distance = (
        Vector2.new(ScreenPos.X,ScreenPos.Y)-Center
    ).Magnitude

    return Distance <= Settings.FOV
end

--========================================================
-- TEAM DETECTOR
--========================================================

local function HasGreenMarker(Character)

    if not Character then
        return false
    end

    for _,Object in ipairs(Character:GetDescendants()) do

        if Object:IsA("BillboardGui")
            and Object.Name ~= "ESPInfo" then

            for _,Child in ipairs(Object:GetDescendants()) do

                if Child:IsA("TextLabel")
                    and Child.Text
                    and Child.Text ~= "" then

                    return true
                end

                if Child:IsA("Frame") then

                    local C = Child.BackgroundColor3

                    if C.G > C.R*1.3
                        and C.G > C.B*1.2 then

                        return true
                    end
                end
            end
        end
    end

    return false
end

local function IsNPC(Character)
    return CollectionService:HasTag(
        Character,
        "AimTarget"
    )
end

local function IsTeammate(Player)

    if not Player or Player == LocalPlayer then
        return false
    end

    local Character = Player.Character

    if not Character then
        return false
    end

    if TeamCache[Player] == "TEAM" then
        return true
    end

    if HasGreenMarker(Character) then
        TeamCache[Player] = "TEAM"
        return true
    end

    return false
end

local function ValidCharacter(Character,Player)

    if not Character or not Character.Parent then
        return false
    end

    if not IsAlive(Character) then
        return false
    end

    if Player and IsTeammate(Player) then
        return false
    end

    local Root = Character:FindFirstChild(
        "HumanoidRootPart"
    )

    local Part = GetAimPart(Character)

    if not Root or not Part then
        return false
    end

    if not InFOV(Part) then
        return false
    end

    if not Visible(Part,Character) then
        return false
    end

    return true
end--========================================================
-- PART 3/4
-- Target Selection + Lock State
--========================================================

local function FindBestTarget()

    local BestTarget = nil
    local BestDistance = math.huge

    --====================================================
    -- PLAYERS
    --====================================================

    for _,Player in ipairs(Players:GetPlayers()) do

        if Player ~= LocalPlayer then

            local Character = Player.Character

            if ValidCharacter(Character,Player) then

                local Part = GetAimPart(Character)

                local Distance = (
                    Part.Position-Camera.CFrame.Position
                ).Magnitude

                if Distance < BestDistance then

                    BestDistance = Distance
                    BestTarget = Part
                end
            end
        end
    end

    --====================================================
    -- NPC
    --====================================================

    for _,Character in ipairs(
        CollectionService:GetTagged("AimTarget")
    ) do

        if ValidCharacter(Character,nil) then

            local Part = GetAimPart(Character)

            local Distance = (
                Part.Position-Camera.CFrame.Position
            ).Magnitude

            if Distance < BestDistance then

                BestDistance = Distance
                BestTarget = Part
            end
        end
    end

    return BestTarget
end

local function TargetStillUsable()

    if not LockedTarget then
        return false
    end

    local Character = LockedTarget.Parent

    if not Character then
        return false
    end

    local Humanoid = GetHumanoid(Character)

    if not Humanoid or Humanoid.Health <= 0 then
        return false
    end

    local Player =
        Players:GetPlayerFromCharacter(Character)

    if Player and IsTeammate(Player) then
        return false
    end

    -- IMPORTANT:
    -- Yahan FOV check intentionally nahi hai.
    --
    -- Target lock ho chuka hai to target ko follow
    -- karte waqt FOV ke bahar jaane se immediately
    -- camera reset nahi hoga.
    --
    -- Target actually invalid/dead/disappear hone par
    -- next target search hoga.

    local Part = GetAimPart(Character)

    if not Part then
        return false
    end

    if not Visible(Part,Character) then
        return false
    end

    return true
end

--========================================================
-- LOCK RESET
--========================================================

local function ResetLock()

    LockedTarget = nil
    HadLock = false
    LockLost = false
end

--========================================================
-- MAIN AIM
--========================================================

RunService.RenderStepped:Connect(function()

    FOVCircle.Position = UDim2.new(.5,0,.5,0)
    Crosshair.Position = UDim2.new(.5,0,.5,0)

    FOVCircle.Size = UDim2.new(
        0,
        Settings.FOV*2,
        0,
        Settings.FOV*2
    )

    local AimEnabled = Settings.AimAssist
    local LockEnabled = Settings.TargetLock

    --====================================================
    -- AIM OFF
    --====================================================

    if not AimEnabled or not LockEnabled then

        ResetLock()

        return
    end

    --====================================================
    -- FIND FIRST TARGET
    --====================================================

    if not LockedTarget then

        LockedTarget = FindBestTarget()

        if LockedTarget then
            HadLock = true
            LockLost = false
        end
    end

    --====================================================
    -- TARGET LOST
    --====================================================

    if LockedTarget and not TargetStillUsable() then

        -- IMPORTANT:
        -- Camera ko reset nahi karna.
        -- FrozenCFrame bhi nahi.
        --
        -- Is frame tak camera already target ko follow
        -- kar raha tha. Target disappear hote hi camera
        -- apni LAST CURRENT direction par naturally rahega.

        LockedTarget = nil
        LockLost = true
    end

    --====================================================
    -- AUTO RELOCK
    --====================================================

    if not LockedTarget then

        local NewTarget = FindBestTarget()

        if NewTarget then

            LockedTarget = NewTarget
            HadLock = true
            LockLost = false
        end
    end

    --====================================================
    -- AIM CURRENT TARGET
    --====================================================

    if LockedTarget then

        local Smooth = math.clamp(
            Settings.Smoothness/100,
            0.01,
            1
        )

        local Desired = CFrame.lookAt(
            Camera.CFrame.Position,
            LockedTarget.Position
        )

        -- IMPORTANT:
        -- Current Camera.CFrame se Lerp hota hai.
        -- Isliye target lost hone par old starting
        -- position par snap-back nahi hota.
        Camera.CFrame = Camera.CFrame:Lerp(
            Desired,
            Smooth
        )
    end
end)--========================================================
-- PART 4/4
-- ESP + Chams + Cleanup
--========================================================

local function RemoveESP(Character)

    local Data = ESPObjects[Character]

    if not Data then
        return
    end

    if Data.Highlight then
        Data.Highlight:Destroy()
    end

    if Data.Billboard then
        Data.Billboard:Destroy()
    end

    ESPObjects[Character] = nil
end

local function AddESP(Character,Player)

    if not Character or not Character.Parent then
        return
    end

    local Humanoid = GetHumanoid(Character)

    if not Humanoid or Humanoid.Health <= 0 then
        RemoveESP(Character)
        return
    end

    local IsEnemy = true

    if Player then
        IsEnemy = not IsTeammate(Player)
    end

    local TeamColor

    if IsNPC(Character) then
        TeamColor = Color3.fromRGB(255,255,255)
    elseif IsEnemy then
        TeamColor = Color3.fromRGB(255,70,70)
    else
        TeamColor = Color3.fromRGB(60,255,100)
    end

    local Data = ESPObjects[Character]

    if not Data then

        Data = {}

        local Highlight = Instance.new("Highlight")
        Highlight.Name = "TeamChams"
        Highlight.DepthMode =
            Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.FillTransparency = .65
        Highlight.OutlineTransparency = 0
        Highlight.Parent = Character

        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "ESPInfo"
        Billboard.Size = UDim2.new(0,180,0,40)
        Billboard.StudsOffset = Vector3.new(0,3,0)
        Billboard.AlwaysOnTop = true
        Billboard.Parent = Character

        local Text = Instance.new("TextLabel")
        Text.Name = "Info"
        Text.Size = UDim2.new(1,0,1,0)
        Text.BackgroundTransparency = 1
        Text.TextColor3 = Color3.new(1,1,1)
        Text.TextStrokeTransparency = .3
        Text.TextSize = 11
        Text.Font = Enum.Font.GothamBold
        Text.Parent = Billboard

        Data.Highlight = Highlight
        Data.Billboard = Billboard
        Data.Text = Text

        ESPObjects[Character] = Data
    end

    Data.Highlight.Enabled =
        Settings.ESP or Settings.Chams

    Data.Highlight.FillColor = TeamColor
    Data.Highlight.OutlineColor = TeamColor

    Data.Text.Visible = Settings.ESP

    local Root = Character:FindFirstChild(
        "HumanoidRootPart"
    )

    if Root then

        local Distance = (
            Root.Position-Camera.CFrame.Position
        ).Magnitude

        local Info = {}

        if Settings.Names then
            table.insert(
                Info,
                Player and Player.Name or "NPC"
            )
        end

        if Settings.Health then
            table.insert(
                Info,
                "HP: "..math.floor(Humanoid.Health)
            )
        end

        if Settings.Distance then
            table.insert(
                Info,
                "DIST: "..math.floor(Distance)
            )
        end

        Data.Text.Text = table.concat(Info," | ")
    end
end

--========================================================
-- UPDATE ESP
--========================================================

local function UpdateESP()

    if not Settings.ESP and not Settings.Chams then

        for Character in pairs(ESPObjects) do
            RemoveESP(Character)
        end

        return
    end

    local Seen = {}

    for _,Player in ipairs(Players:GetPlayers()) do

        if Player ~= LocalPlayer then

            local Character = Player.Character

            if Character and IsAlive(Character) then

                Seen[Character] = true
                AddESP(Character,Player)

            elseif Character then

                RemoveESP(Character)
            end
        end
    end

    for _,Character in ipairs(
        CollectionService:GetTagged("AimTarget")
    ) do

        if IsAlive(Character) then

            Seen[Character] = true
            AddESP(Character,nil)

        else

            RemoveESP(Character)
        end
    end

    for Character in pairs(ESPObjects) do

        if not Seen[Character]
            or not Character.Parent then

            RemoveESP(Character)
        end
    end
end

--========================================================
-- ESP LOOP
--========================================================

RunService.Heartbeat:Connect(function()
    UpdateESP()
end)

--========================================================
-- PLAYER CHARACTER RESET
--========================================================

Players.PlayerAdded:Connect(function(Player)

    Player.CharacterAdded:Connect(function()

        TeamCache[Player] = nil
    end)
end)

for _,Player in ipairs(Players:GetPlayers()) do

    if Player ~= LocalPlayer then

        Player.CharacterAdded:Connect(function()

            TeamCache[Player] = nil
        end)
    end
end

Players.PlayerRemoving:Connect(function(Player)

    TeamCache[Player] = nil

    if Player.Character then
        RemoveESP(Player.Character)
    end
end)

--========================================================
-- FINAL
--========================================================

print("================================")
print("FAISAL KHAN FPS AIM TEST")
print("Mobile GUI: READY")
print("Minimize: READY")
print("Auto Relock: READY")
print("No Snap-Back: READY")
print("================================")