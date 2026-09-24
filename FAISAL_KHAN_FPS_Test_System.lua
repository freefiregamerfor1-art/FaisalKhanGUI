--========================================================
--                 FAISAL KHAN
--              FPS AIM TEST SYSTEM
--========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local TEAM_COLOR = Color3.fromRGB(60,255,100)
local ENEMY_COLOR = Color3.fromRGB(255,70,70)
local NPC_COLOR = Color3.fromRGB(255,255,255)
local WHITE = Color3.fromRGB(255,255,255)

local LockedTarget = nil
local ESPObjects = {}
local TeamCache = {}
local Minimized = false

local Gui = Instance.new("ScreenGui")
Gui.Name = "FAISAL_KHAN"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(235,390)
Main.Position = UDim2.new(.5,-117,.5,-195)
Main.BackgroundColor3 = Color3.fromRGB(22,22,27)
Main.BorderSizePixel = 0
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,9)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-50,0,32)
Title.Position = UDim2.fromOffset(10,4)
Title.BackgroundTransparency = 1
Title.Text = "FAISAL KHAN"
Title.TextColor3 = WHITE
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(30,30)
Minimize.Position = UDim2.new(1,-35,0,5)
Minimize.BackgroundColor3 = Color3.fromRGB(42,42,50)
Minimize.BorderSizePixel = 0
Minimize.Text = "−"
Minimize.TextColor3 = WHITE
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Main

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0,7)
MinCorner.Parent = Minimize

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,0,1,-38)
Content.Position = UDim2.fromOffset(0,38)
Content.BackgroundTransparency = 1
Content.Parent = Main

local function MakeToggle(Name,Y)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,-20,0,31)
    Button.Position = UDim2.fromOffset(10,Y)
    Button.BackgroundColor3 = Color3.fromRGB(38,38,46)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.Parent = Content

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0,7)
    C.Parent = Button

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,-55,1,0)
    Label.Position = UDim2.fromOffset(10,0)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.TextColor3 = WHITE
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.fromOffset(36,18)
    Switch.Position = UDim2.new(1,-45,.5,-9)
    Switch.BackgroundColor3 = Color3.fromRGB(65,65,72)
    Switch.BorderSizePixel = 0
    Switch.Parent = Button

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(1,0)
    SC.Parent = Switch

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.fromOffset(14,14)
    Knob.Position = UDim2.fromOffset(2,2)
    Knob.BackgroundColor3 = WHITE
    Knob.BorderSizePixel = 0
    Knob.Parent = Switch

    local KC = Instance.new("UICorner")
    KC.CornerRadius = UDim.new(1,0)
    KC.Parent = Knob

    local State = false

    Button.MouseButton1Click:Connect(function()

        State = not State

        if State then
            Switch.BackgroundColor3 =
                Color3.fromRGB(90,170,255)

            Knob.Position =
                UDim2.new(1,-16,0,2)

        else
            Switch.BackgroundColor3 =
                Color3.fromRGB(65,65,72)

            Knob.Position =
                UDim2.fromOffset(2,2)
        end
    end)

    return function()
        return State
    end
end

local GetAim = MakeToggle("Aim Assist",0)
local GetLock = MakeToggle("Target Lock",36)
local GetESP = MakeToggle("ESP",72)
local GetChams = MakeToggle("Chams",108)
local GetNames = MakeToggle("Names",144)
local GetHealth = MakeToggle("Health",180)
local GetDistance = MakeToggle("Distance",216)

local function MakeSlider(Name,Y,Min,Max,Default)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,-20,0,17)
    Label.Position = UDim2.fromOffset(10,Y)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = WHITE
    Label.TextSize = 11
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Content

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1,-20,0,5)
    Bar.Position = UDim2.fromOffset(10,Y+21)
    Bar.BackgroundColor3 = Color3.fromRGB(55,55,65)
    Bar.BorderSizePixel = 0
    Bar.Parent = Content

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(1,0)
    BC.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.BackgroundColor3 = Color3.fromRGB(120,120,255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(1,0)
    FC.Parent = Fill

    local Value = Default
    local Dragging = false

    local function Update(X)

        local Percent =
            math.clamp(
                (X-Bar.AbsolutePosition.X) /
                Bar.AbsoluteSize.X,
                0,
                1
            )

        Value = Min+(Max-Min)*Percent

        Fill.Size =
            UDim2.new(Percent,0,1,0)

        Label.Text =
            Name..": "..math.floor(Value)
    end

    task.defer(function()

        Update(
            Bar.AbsolutePosition.X +
            Bar.AbsoluteSize.X *
            ((Default-Min)/(Max-Min))
        )

    end)

    Bar.InputBegan:Connect(function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging = true
            Update(Input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            Update(Input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging = false
        end
    end)

    return function()
        return Value
    end
end

local GetFOV =
    MakeSlider("FOV",260,40,300,150)

local GetSmoothness =
    MakeSlider("Smoothness",303,1,100,35)

local Crosshair = Instance.new("Frame")
Crosshair.Size = UDim2.fromOffset(4,4)
Crosshair.AnchorPoint = Vector2.new(.5,.5)
Crosshair.BackgroundColor3 = WHITE
Crosshair.BorderSizePixel = 0
Crosshair.Parent = Gui

local CrossCorner = Instance.new("UICorner")
CrossCorner.CornerRadius = UDim.new(1,0)
CrossCorner.Parent = Crosshair

local FOVCircle = Instance.new("Frame")
FOVCircle.AnchorPoint = Vector2.new(.5,.5)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Parent = Gui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1,0)
FOVCorner.Parent = FOVCircle

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = WHITE
Stroke.Parent = FOVCircle

local function GetAimPart(Character)

    if not Character then
        return nil
    end

    local Head = Character:FindFirstChild("Head")

    if Head and Head:IsA("BasePart") then
        return Head
    end

    local Torso =
        Character:FindFirstChild("UpperTorso")

    if Torso and Torso:IsA("BasePart") then
        return Torso
    end

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if Root and Root:IsA("BasePart") then
        return Root
    end

    return nil
end

local function ValidCharacter(Character)

    if not Character
        or not Character.Parent then
        return false
    end

    if Character == LocalPlayer.Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if Humanoid and Humanoid.Health <= 0 then
        return false
    end

    return GetAimPart(Character) ~= nil
end

-- Detects the game's existing overhead teammate marker.
-- It intentionally does not use Roblox Team/TeamColor.

local function DetectGameTeam(Character)

    if not Character then
        return nil
    end

    for _,Obj in ipairs(
        Character:GetDescendants()
    ) do

        if Obj:IsA("BillboardGui")
            and Obj.Name ~= "ESPInfo" then

            local HasText = false
            local HasGreenBar = false

            for _,Child in ipairs(
                Obj:GetDescendants()
            ) do

                if Child:IsA("TextLabel")
                    and Child.Text ~= "" then

                    HasText = true
                end

                if Child:IsA("Frame") then

                    local C =
                        Child.BackgroundColor3

                    if C.G > C.R * 1.3
                        and C.G > C.B * 1.2 then

                        HasGreenBar = true
                    end
                end
            end

            if HasText or HasGreenBar then
                return "TEAM"
            end
        end
    end

    return nil
end

local function GetPlayerTeamState(Player)

    if not Player
        or Player == LocalPlayer then
        return nil
    end

    local Character = Player.Character

    if not Character then
        return nil
    end

    if TeamCache[Player] == nil
        or TeamCache[Player].Character ~= Character then

        TeamCache[Player] = {
            Character = Character,
            Team = nil
        }
    end

    local Cache = TeamCache[Player]

    -- Once TEAM is detected, keep it for this character life.
    if Cache.Team == "TEAM" then
        return "TEAM"
    end

    local Detected =
        DetectGameTeam(Character)

    if Detected == "TEAM" then

        Cache.Team = "TEAM"

        return "TEAM"
    end

    return nil
end

local function IsEnemyPlayer(Player)

    if not Player
        or Player == LocalPlayer then
        return false
    end

    local Character = Player.Character

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if Humanoid
        and Humanoid.Health <= 0 then

        return false
    end

    return GetPlayerTeamState(Player) ~= "TEAM"
end

local function GetTeamColor(Character)

    local Player =
        Players:GetPlayerFromCharacter(Character)

    -- Tagged NPCs are white.
    if not Player then
        return NPC_COLOR
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if Humanoid
        and Humanoid.Health <= 0 then

        return WHITE
    end

    if GetPlayerTeamState(Player) == "TEAM" then
        return TEAM_COLOR
    end

    return ENEMY_COLOR
end

local function SetupPlayer(Player)

    if Player == LocalPlayer then
        return
    end

    Player.CharacterAdded:Connect(
        function(Character)

            -- Reset team state on respawn.
            TeamCache[Player] = {
                Character = Character,
                Team = nil
            }

            -- Give the game's overhead marker time to appear.
            task.spawn(function()

                for _ = 1,10 do

                    if not Player.Character
                        or not TeamCache[Player]
                        or TeamCache[Player].Character
                            ~= Player.Character then

                        break
                    end

                    if DetectGameTeam(Character)
                        == "TEAM" then

                        TeamCache[Player].Team =
                            "TEAM"

                        break
                    end

                    task.wait(.5)
                end
            end)
        end
    )

    if Player.Character then

        TeamCache[Player] = {
            Character = Player.Character,
            Team = nil
        }

    end
end

for _,Player in ipairs(
    Players:GetPlayers()
) do
    SetupPlayer(Player)
end

Players.PlayerAdded:Connect(SetupPlayer)

Players.PlayerRemoving:Connect(
    function(Player)
        TeamCache[Player] = nil
    end
)

local function IsVisibleTarget(
    Part,
    Character
)

    if not Part or not Character then
        return false
    end

    local Camera =
        workspace.CurrentCamera

    if not Camera then
        return false
    end

    local Origin =
        Camera.CFrame.Position

    local Direction =
        Part.Position-Origin

    local Params =
        RaycastParams.new()

    Params.FilterType =
        Enum.RaycastFilterType.Exclude

    Params.FilterDescendantsInstances = {
        LocalPlayer.Character
    }

    Params.IgnoreWater = true

    local Result =
        workspace:Raycast(
            Origin,
            Direction,
            Params
        )

    if not Result then
        return true
    end

    return Result.Instance:IsDescendantOf(
        Character
    )
end

local function GetScreenCenter()

    local Camera =
        workspace.CurrentCamera

    local Viewport =
        Camera.ViewportSize

    return Vector2.new(
        Viewport.X/2,
        Viewport.Y/2
    )
end

local function GetScreenDistance(Part)

    if not Part then
        return math.huge,false
    end

    local Camera =
        workspace.CurrentCamera

    local Position,Visible =
        Camera:WorldToViewportPoint(
            Part.Position
        )

    if not Visible
        or Position.Z <= 0 then

        return math.huge,false
    end

    local Center =
        GetScreenCenter()

    local Target =
        Vector2.new(
            Position.X,
            Position.Y
        )

    return
        (Target-Center).Magnitude,
        true
end

local function FindBestTarget()

    local BestTarget = nil
    local BestDistance = math.huge

    local Camera =
        workspace.CurrentCamera

    local CurrentFOV =
        GetFOV()

    -- Player targets
    for _,Player in ipairs(
        Players:GetPlayers()
    ) do

        if IsEnemyPlayer(Player) then

            local Character =
                Player.Character

            if ValidCharacter(Character) then

                local AimPart =
                    GetAimPart(Character)

                local Root =
                    Character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if AimPart and Root then

                    local ScreenDistance,Visible =
                        GetScreenDistance(AimPart)

                    if Visible
                        and ScreenDistance <= CurrentFOV
                        and IsVisibleTarget(
                            AimPart,
                            Character
                        ) then

                        local Distance =
                            (
                                Camera.CFrame.Position
                                - Root.Position
                            ).Magnitude

                        if Distance < BestDistance then

                            BestDistance =
                                Distance

                            BestTarget =
                                AimPart
                        end
                    end
                end
            end
        end
    end

    -- NPC targets tagged AimTarget
    for _,NPC in ipairs(
        CollectionService:GetTagged(
            "AimTarget"
        )
    ) do

        if ValidCharacter(NPC) then

            local AimPart =
                GetAimPart(NPC)

            local Root =
                NPC:FindFirstChild(
                    "HumanoidRootPart"
                )

            if AimPart and Root then

                local ScreenDistance,Visible =
                    GetScreenDistance(AimPart)

                if Visible
                    and ScreenDistance <= CurrentFOV
                    and IsVisibleTarget(
                        AimPart,
                        NPC
                    ) then

                    local Distance =
                        (
                            Camera.CFrame.Position
                            - Root.Position
                        ).Magnitude

                    if Distance < BestDistance then

                        BestDistance =
                            Distance

                        BestTarget =
                            AimPart
                    end
                end
            end
        end
    end

    return BestTarget
end

local function LockStillValid()

    if not LockedTarget
        or not LockedTarget.Parent then

        return false
    end

    local Character =
        LockedTarget.Parent

    if not ValidCharacter(Character) then
        return false
    end

    local TargetPlayer =
        Players:GetPlayerFromCharacter(
            Character
        )

    if TargetPlayer
        and not IsEnemyPlayer(TargetPlayer) then

        return false
    end

    local Distance,Visible =
        GetScreenDistance(
            LockedTarget
        )

    if not Visible
        or Distance > GetFOV() then

        return false
    end

    return IsVisibleTarget(
        LockedTarget,
        Character
    )
end

local function RemoveESP(Character)

    local Data =
        ESPObjects[Character]

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

local function UpdateESPText(
    Character,
    Name,
    Data
)

    if not Data
        or not Data.Label then

        return
    end

    local Text = ""

    if GetNames() then
        Text = Name
    end

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if GetHealth()
        and Humanoid then

        if Text ~= "" then
            Text = Text.."\n"
        end

        Text =
            Text..
            "HP: "..
            math.floor(Humanoid.Health)..
            "/"..
            math.floor(Humanoid.MaxHealth)
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    local Camera =
        workspace.CurrentCamera

    if GetDistance()
        and Root
        and Camera then

        local Distance =
            (
                Camera.CFrame.Position
                - Root.Position
            ).Magnitude

        if Text ~= "" then
            Text = Text.."\n"
        end

        Text =
            Text..
            "DIST: "..
            math.floor(Distance)..
            "m"
    end

    Data.Label.Text = Text
end

local function AddESP(
    Character,
    Name
)

    if not Character
        or not Character.Parent then

        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    -- Remove dead ESP immediately.
    if Humanoid
        and Humanoid.Health <= 0 then

        RemoveESP(Character)
        return
    end

    local Data =
        ESPObjects[Character]

    if not Data then

        Data = {}
        ESPObjects[Character] = Data

        local Highlight =
            Instance.new("Highlight")

        Highlight.Name =
            "TeamChams"

        Highlight.DepthMode =
            Enum.HighlightDepthMode.AlwaysOnTop

        Highlight.FillTransparency =
            .45

        Highlight.OutlineTransparency =
            0

        Highlight.Parent =
            Character

        Data.Highlight =
            Highlight

        local Billboard =
            Instance.new("BillboardGui")

        Billboard.Name =
            "ESPInfo"

        Billboard.Size =
            UDim2.fromOffset(170,60)

        Billboard.StudsOffset =
            Vector3.new(0,3.2,0)

        Billboard.AlwaysOnTop =
            true

        Billboard.Parent =
            Character

        local Label =
            Instance.new("TextLabel")

        Label.Size =
            UDim2.fromScale(1,1)

        Label.BackgroundTransparency =
            1

        Label.TextStrokeTransparency =
            0

        Label.TextSize =
            12

        Label.Font =
            Enum.Font.GothamBold

        Label.TextColor3 =
            WHITE

        Label.Parent =
            Billboard

        Data.Billboard =
            Billboard

        Data.Label =
            Label
    end

    local Color =
        GetTeamColor(Character)

    Data.Highlight.FillColor =
        Color

    Data.Highlight.OutlineColor =
        Color

    Data.Highlight.Enabled =
        GetESP() and GetChams()

    Data.Billboard.Enabled =
        GetESP()
        and (
            GetNames()
            or GetHealth()
            or GetDistance()
        )

    Data.Label.TextColor3 =
        Color

    UpdateESPText(
        Character,
        Name,
        Data
    )
end

local function UpdateESP()

    if not GetESP() then
        return
    end

    local Seen = {}

    -- Players
    for _,Player in ipairs(
        Players:GetPlayers()
    ) do

        if Player ~= LocalPlayer
            and Player.Character then

            local Character =
                Player.Character

            local Humanoid =
                Character:FindFirstChildOfClass(
                    "Humanoid"
                )

            if Humanoid
                and Humanoid.Health <= 0 then

                RemoveESP(Character)

            else

                Seen[Character] = true

                AddESP(
                    Character,
                    Player.DisplayName
                )
            end
        end
    end

    -- NPCs
    for _,NPC in ipairs(
        CollectionService:GetTagged(
            "AimTarget"
        )
    ) do

        if NPC:IsA("Model") then

            local Humanoid =
                NPC:FindFirstChildOfClass(
                    "Humanoid"
                )

            if Humanoid
                and Humanoid.Health <= 0 then

                RemoveESP(NPC)

            else

                Seen[NPC] = true

                AddESP(
                    NPC,
                    NPC.Name
                )
            end
        end
    end

    -- Remove stale ESP
    for Character in pairs(
        ESPObjects
    ) do

        if not Seen[Character]
            or not Character.Parent then

            RemoveESP(Character)
        end
    end
end

local function ClearESP()

    for Character in pairs(
        ESPObjects
    ) do

        RemoveESP(Character)
    end
endMinimize.MouseButton1Click:Connect(
    function()

        Minimized =
            not Minimized

        Content.Visible =
            not Minimized

        if Minimized then

            Main.Size =
                UDim2.fromOffset(
                    235,
                    40
                )

            Minimize.Text = "+"

        else

            Main.Size =
                UDim2.fromOffset(
                    235,
                    390
                )

            Minimize.Text = "−"
        end
    end
)

-- GUI dragging
local Dragging = false
local DragStart
local StartPosition

Title.InputBegan:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging = true
            DragStart = Input.Position
            StartPosition = Main.Position
        end
    end
)

UserInputService.InputChanged:Connect(
    function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            local Delta =
                Input.Position-DragStart

            Main.Position =
                UDim2.new(
                    StartPosition.X.Scale,
                    StartPosition.X.Offset+
                        Delta.X,

                    StartPosition.Y.Scale,
                    StartPosition.Y.Offset+
                        Delta.Y
                )
        end
    end
)

UserInputService.InputEnded:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging = false
        end
    end
)

-- Main render loop
RunService:BindToRenderStep(
    "FAISAL_KHAN_AIM",
    Enum.RenderPriority.Camera.Value+1,

    function()

        local Camera =
            workspace.CurrentCamera

        if not Camera then
            return
        end

        local Viewport =
            Camera.ViewportSize

        local CenterX =
            Viewport.X/2

        local CenterY =
            Viewport.Y/2

        -- Center crosshair
        Crosshair.Position =
            UDim2.fromOffset(
                CenterX,
                CenterY
            )

        -- FOV circle
        local FOV =
            GetFOV()

        FOVCircle.Size =
            UDim2.fromOffset(
                FOV*2,
                FOV*2
            )

        FOVCircle.Position =
            UDim2.fromOffset(
                CenterX,
                CenterY
            )

        FOVCircle.Visible =
            GetAim()

        -- ESP update
        if GetESP() then

            UpdateESP()

        else

            if next(ESPObjects) then
                ClearESP()
            end
        end

        -- Aim/Lock disabled
        if not GetAim()
            or not GetLock() then

            LockedTarget = nil
            return
        end

        -- Release dead target
        if LockedTarget then

            local TargetCharacter =
                LockedTarget.Parent

            local Humanoid =
                TargetCharacter
                and TargetCharacter:
                    FindFirstChildOfClass(
                        "Humanoid"
                    )

            if Humanoid
                and Humanoid.Health <= 0 then

                LockedTarget = nil
            end
        end

        -- Find/reacquire target
        if not LockStillValid() then

            LockedTarget =
                FindBestTarget()
        end

        if not LockedTarget then
            return
        end

        -- Smooth camera movement
        local Desired =
            CFrame.lookAt(
                Camera.CFrame.Position,
                LockedTarget.Position
            )

        local Smooth =
            math.clamp(
                GetSmoothness()/100,
                .05,
                1
            )

        Camera.CFrame =
            Camera.CFrame:Lerp(
                Desired,
                Smooth
            )
    end
)

print(
    "FAISAL KHAN FPS TEST SYSTEM LOADED"
)
