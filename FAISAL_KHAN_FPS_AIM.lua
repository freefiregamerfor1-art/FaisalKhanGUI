--========================================================
-- FAISAL KHAN | FPS AIM TEST SYSTEM
-- PART 1/4 - BASE + GUI
--========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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
local AimFrozen = false
local FrozenCFrame = nil
local PreviousLockState = false

local ESPObjects = {}
local TeamCache = {}

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local OldGui = PlayerGui:FindFirstChild("FAISAL_KHAN")
if OldGui then OldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FAISAL_KHAN"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,260,0,500)
Main.Position = UDim2.new(0,30,0.5,-250)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-50,0,40)
Title.Position = UDim2.new(0,12,0,5)
Title.BackgroundTransparency = 1
Title.Text = "FAISAL KHAN"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0,30,0,30)
Minimize.Position = UDim2.new(1,-38,0,8)
Minimize.BackgroundColor3 = Color3.fromRGB(35,35,35)
Minimize.Text = "-"
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Main

Instance.new("UICorner",Minimize).CornerRadius = UDim.new(0,6)

local Hidden = false

Minimize.MouseButton1Click:Connect(function()
    Hidden = not Hidden

    for _,v in ipairs(Main:GetChildren()) do
        if v ~= Title and v ~= Minimize then
            v.Visible = not Hidden
        end
    end

    Main.Size = Hidden
        and UDim2.new(0,260,0,50)
        or UDim2.new(0,260,0,500)

    Minimize.Text = Hidden and "+" or "-"
end)

local Dragging = false
local DragStart
local StartPosition

Title.InputBegan:Connect(function(Input)
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

local Y = 50

local function CreateToggle(Text,Name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,-20,0,32)
    Button.Position = UDim2.new(0,10,0,Y)
    Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.Parent = Main

    Instance.new("UICorner",Button).CornerRadius = UDim.new(0,7)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,-60,1,0)
    Label.Position = UDim2.new(0,10,0,0)
    Label.BackgroundTransparency = 1
    Label.Text = Text
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0,45,1,0)
    Status.Position = UDim2.new(1,-50,0,0)
    Status.BackgroundTransparency = 1
    Status.TextSize = 12
    Status.Font = Enum.Font.GothamBold
    Status.Parent = Button

    local function Refresh()
        Status.Text = Settings[Name] and "ON" or "OFF"
        Status.TextColor3 = Settings[Name]
            and Color3.fromRGB(60,255,100)
            or Color3.fromRGB(255,80,80)
    end

    Button.MouseButton1Click:Connect(function()
        Settings[Name] = not Settings[Name]
        Refresh()
    end)

    Refresh()
    Y += 38
end

CreateToggle("Aim Assist","AimAssist")
CreateToggle("Target Lock","TargetLock")
CreateToggle("ESP","ESP")
CreateToggle("Chams","Chams")
CreateToggle("Names","Names")
CreateToggle("Health","Health")
CreateToggle("Distance","Distance")--========================================================
-- PART 2/4 - FOV + SMOOTHNESS + CROSSHAIR
--========================================================

local function CreateSlider(Text,Min,Max,Default,Callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,-20,0,22)
    Label.Position = UDim2.new(0,10,0,Y)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Main

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1,-20,0,7)
    Bar.Position = UDim2.new(0,10,0,Y+24)
    Bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Bar.BorderSizePixel = 0
    Bar.Parent = Main

    Instance.new("UICorner",Bar).CornerRadius = UDim.new(1,0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Default-Min)/(Max-Min),0,1,0)
    Fill.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    Instance.new("UICorner",Fill).CornerRadius = UDim.new(1,0)

    local Drag = false

    local function Update(X)
        local Ratio = math.clamp(
            (X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,
            0,1
        )

        local Value = math.floor(Min+(Max-Min)*Ratio)
        Fill.Size = UDim2.new(Ratio,0,1,0)

        Label.Text = Text..": "..Value
        Callback(Value)
    end

    Label.Text = Text..": "..Default

    Bar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

            Drag = true
            Update(Input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if not Drag then return end

        if Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch then

            Update(Input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

            Drag = false
        end
    end)

    Y += 55
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
Crosshair.Size = UDim2.new(0,4,0,4)
Crosshair.AnchorPoint = Vector2.new(.5,.5)
Crosshair.Position = UDim2.new(.5,0,.5,0)
Crosshair.BackgroundColor3 = Color3.new(1,1,1)
Crosshair.BorderSizePixel = 0
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
FOVCircle.Parent = ScreenGui

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.new(1,1,1)
Stroke.Thickness = 1
Stroke.Parent = FOVCircle

Instance.new("UICorner",FOVCircle).CornerRadius = UDim.new(1,0)

--========================================================
-- AIM PART
--========================================================

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

local function GetHumanoid(Character)
    return Character and Character:FindFirstChildOfClass("Humanoid")
end

local function IsAlive(Character)
    local Humanoid = GetHumanoid(Character)
    return Humanoid and Humanoid.Health > 0
end--========================================================
-- PART 3/4 - TEAM DETECTION + TARGET SYSTEM
--========================================================

local function HasGreenMarker(Character)
    if not Character then
        return false
    end

    for _,Object in ipairs(Character:GetDescendants()) do
        if Object:IsA("BillboardGui")
            and Object.Name ~= "ESPInfo" then

            for _,Child in ipairs(Object:GetDescendants()) do

                if Child:IsA("TextLabel") then
                    if Child.Text and Child.Text ~= "" then
                        return true
                    end
                end

                if Child:IsA("Frame") then
                    local C = Child.BackgroundColor3

                    if C.G > C.R * 1.3
                        and C.G > C.B * 1.2 then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function IsNPC(Character)
    return CollectionService:HasTag(Character,"AimTarget")
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

local function GetTeamColor(Player,Character)
    if IsNPC(Character) then
        return Color3.fromRGB(255,255,255)
    end

    if IsTeammate(Player) then
        return Color3.fromRGB(60,255,100)
    end

    return Color3.fromRGB(255,70,70)
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

    local ScreenPos,OnScreen = Camera:WorldToViewportPoint(Part.Position)

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

local function ValidCharacter(Character,Player)
    if not Character or not Character.Parent then
        return false
    end

    if not IsAlive(Character) then
        return false
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    local AimPart = GetAimPart(Character)

    if not Root or not AimPart then
        return false
    end

    if Player and Player ~= LocalPlayer then
        if IsTeammate(Player) then
            return false
        end
    end

    if not InFOV(AimPart) then
        return false
    end

    if not Visible(AimPart,Character) then
        return false
    end

    return true
end

local function FindBestTarget()
    local BestPart = nil
    local BestDistance = math.huge

    -- PLAYER TARGETS
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
                    BestPart = Part
                end
            end
        end
    end

    -- NPC TARGETS
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
                BestPart = Part
            end
        end
    end

    return BestPart
end

local function LockStillValid()
    if not LockedTarget then
        return false
    end

    local Character = LockedTarget.Parent

    if not Character then
        return false
    end

    local Player = Players:GetPlayerFromCharacter(Character)

    return ValidCharacter(Character,Player)
end--========================================================
-- PART 4/4 - FREEZE AIM + ESP
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

    local Color = GetTeamColor(Player,Character)

    local Data = ESPObjects[Character]

    if not Data then
        Data = {}

        local Highlight = Instance.new("Highlight")
        Highlight.Name = "TeamChams"
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.FillTransparency = .65
        Highlight.OutlineTransparency = 0
        Highlight.Parent = Character

        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "ESPInfo"
        Billboard.Size = UDim2.new(0,180,0,45)
        Billboard.StudsOffset = Vector3.new(0,3,0)
        Billboard.AlwaysOnTop = true
        Billboard.Parent = Character

        local Text = Instance.new("TextLabel")
        Text.Name = "Info"
        Text.Size = UDim2.new(1,0,1,0)
        Text.BackgroundTransparency = 1
        Text.TextColor3 = Color3.new(1,1,1)
        Text.TextStrokeTransparency = .3
        Text.TextSize = 12
        Text.Font = Enum.Font.GothamBold
        Text.Parent = Billboard

        Data.Highlight = Highlight
        Data.Billboard = Billboard
        Data.Text = Text

        ESPObjects[Character] = Data
    end

    Data.Highlight.Enabled = Settings.Chams or Settings.ESP
    Data.Highlight.FillColor = Color
    Data.Highlight.OutlineColor = Color

    local Root = Character:FindFirstChild("HumanoidRootPart")

    if Root then
        local Distance = (
            Root.Position-Camera.CFrame.Position
        ).Magnitude

        local Lines = {}

        if Settings.Names then
            table.insert(
                Lines,
                Player and Player.Name or "NPC"
            )
        end

        if Settings.Health then
            table.insert(
                Lines,
                "HP: "..math.floor(Humanoid.Health)
            )
        end

        if Settings.Distance then
            table.insert(
                Lines,
                "DIST: "..math.floor(Distance)
            )
        end

        Data.Text.Text = table.concat(Lines," | ")
    end

    Data.Text.Visible = Settings.ESP
end

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

            if Character then
                local Humanoid = GetHumanoid(Character)

                if Humanoid and Humanoid.Health > 0 then
                    Seen[Character] = true
                    AddESP(Character,Player)
                else
                    RemoveESP(Character)
                end
            end
        end
    end

    for _,Character in ipairs(
        CollectionService:GetTagged("AimTarget")
    ) do
        local Humanoid = GetHumanoid(Character)

        if Humanoid and Humanoid.Health > 0 then
            Seen[Character] = true
            AddESP(Character,nil)
        else
            RemoveESP(Character)
        end
    end

    for Character in pairs(ESPObjects) do
        if not Seen[Character] or not Character.Parent then
            RemoveESP(Character)
        end
    end
end

--========================================================
-- CHARACTER RESET
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

--========================================================
-- MAIN AIM LOOP
--========================================================

RunService.RenderStepped:Connect(function()

    -- Update FOV
    FOVCircle.Size = UDim2.new(
        0,
        Settings.FOV*2,
        0,
        Settings.FOV*2
    )

    local AimEnabled = Settings.AimAssist
    local LockEnabled = Settings.TargetLock

    -- Target Lock OFF:
    -- normal camera, freeze reset.
    if not AimEnabled or not LockEnabled then
        LockedTarget = nil
        AimFrozen = false
        FrozenCFrame = nil
        PreviousLockState = LockEnabled
        return
    end

    -- Target Lock OFF -> ON:
    -- fresh lock allowed.
    if LockEnabled and not PreviousLockState then
        LockedTarget = nil
        AimFrozen = false
        FrozenCFrame = nil
    end

    PreviousLockState = LockEnabled

    --====================================================
    -- FREEZE MODE
    --====================================================

    if AimFrozen then
        if FrozenCFrame then
            Camera.CFrame = FrozenCFrame
        end

        return
    end

    --====================================================
    -- FIRST TARGET ACQUISITION
    --====================================================

    if not LockedTarget then
        LockedTarget = FindBestTarget()
    end

    --====================================================
    -- LOCK LOST
    --====================================================

    if LockedTarget and not LockStillValid() then

        -- Current camera is already at the last aimed
        -- direction, so save exactly that position.
        FrozenCFrame = Camera.CFrame

        LockedTarget = nil
        AimFrozen = true

        return
    end

    if not LockedTarget then
        return
    end

    --====================================================
    -- AIM
    --====================================================

    local Smooth = math.clamp(
        Settings.Smoothness / 100,
        .01,
        1
    )

    local Desired = CFrame.lookAt(
        Camera.CFrame.Position,
        LockedTarget.Position
    )

    Camera.CFrame = Camera.CFrame:Lerp(
        Desired,
        Smooth
    )
end)

--========================================================
-- ESP LOOP
--========================================================

RunService.Heartbeat:Connect(function()
    UpdateESP()
end)

--========================================================
-- CLEANUP
--========================================================

Players.PlayerRemoving:Connect(function(Player)
    TeamCache[Player] = nil

    if Player.Character then
        RemoveESP(Player.Character)
    end
end)

print("FAISAL KHAN FPS AIM TEST SYSTEM LOADED")
print("Freeze Aim: ENABLED")
print("Target Lock OFF -> ON = Re-lock")