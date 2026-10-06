--==================================================
-- BONA JUMP BACK
-- FULL MOBILE JUMP RESTORE
-- NO RAYFIELD
--==================================================

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local ACTION_NAME = "BONA_JUMP_BACK"
local LoadingTime = 2

--==================================================
-- LOADING SCREEN
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "BONA_JUMP_BACK"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999999
Gui.Parent = PlayerGui

local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Size = UDim2.fromScale(1, 1)
Background.Position = UDim2.fromScale(0, 0)
Background.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Background.BorderSizePixel = 0
Background.Parent = Gui

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.Position = UDim2.fromScale(0.5, 0.42)
Title.Size = UDim2.new(0, 500, 0, 65)
Title.BackgroundTransparency = 1
Title.Text = "BONA JUMP BACK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Background

--==================================================
-- LOADING TEXT
--==================================================

local Loading = Instance.new("TextLabel")
Loading.Name = "Loading"
Loading.AnchorPoint = Vector2.new(0.5, 0.5)
Loading.Position = UDim2.fromScale(0.5, 0.51)
Loading.Size = UDim2.new(0, 350, 0, 40)
Loading.BackgroundTransparency = 1
Loading.Text = "Loading"
Loading.TextColor3 = Color3.fromRGB(180, 180, 180)
Loading.TextScaled = true
Loading.Font = Enum.Font.Gotham
Loading.Parent = Background

--==================================================
-- BONA BRAND
--==================================================

local Brand = Instance.new("TextLabel")
Brand.Name = "Brand"
Brand.AnchorPoint = Vector2.new(0.5, 0.5)
Brand.Position = UDim2.fromScale(0.5, 0.59)
Brand.Size = UDim2.new(0, 300, 0, 30)
Brand.BackgroundTransparency = 1
Brand.Text = "BONA"
Brand.TextColor3 = Color3.fromRGB(100, 100, 100)
Brand.TextScaled = true
Brand.Font = Enum.Font.GothamBold
Brand.Parent = Background

--==================================================
-- LOADING DOT ANIMATION
--==================================================

task.spawn(function()
    local DotCount = 0

    while Gui.Parent do
        DotCount += 1

        if DotCount > 3 then
            DotCount = 0
        end

        Loading.Text = "Loading" .. string.rep(".", DotCount)
        task.wait(0.3)
    end
end)

--==================================================
-- RESTORE ROBLOX CORE GUI
--==================================================

pcall(function()
    StarterGui:SetCoreGuiEnabled(
        Enum.CoreGuiType.All,
        true
    )
end)

--==================================================
-- RESTORE HUMANOID JUMP
--==================================================

local function RestoreHumanoid(Character)
    local Humanoid = Character:WaitForChild("Humanoid", 10)

    if not Humanoid then
        return
    end

    Humanoid:SetStateEnabled(
        Enum.HumanoidStateType.Jumping,
        true
    )

    Humanoid.JumpPower = 50
    Humanoid.JumpHeight = 7.2
    Humanoid.AutoJumpEnabled = true
end

-- Current character

if Player.Character then
    task.spawn(function()
        RestoreHumanoid(Player.Character)
    end)
end

-- Respawn

Player.CharacterAdded:Connect(function(Character)
    task.wait(0.2)
    RestoreHumanoid(Character)
end)

--==================================================
-- CUSTOM MOBILE JUMP
--==================================================

local function JumpAction(
    ActionName,
    InputState,
    InputObject
)
    if InputState ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass
    end

    local Character = Player.Character

    if not Character then
        return Enum.ContextActionResult.Pass
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return Enum.ContextActionResult.Pass
    end

    if Humanoid.Health <= 0 then
        return Enum.ContextActionResult.Pass
    end

    Humanoid:SetStateEnabled(
        Enum.HumanoidStateType.Jumping,
        true
    )

    Humanoid.Jump = true

    Humanoid:ChangeState(
        Enum.HumanoidStateType.Jumping
    )

    return Enum.ContextActionResult.Sink
end

--==================================================
-- BIND MOBILE JUMP
--==================================================

ContextActionService:BindAction(
    ACTION_NAME,
    JumpAction,
    true,
    Enum.KeyCode.Space,
    Enum.KeyCode.ButtonA
)

--==================================================
-- MOBILE BUTTON
--==================================================

ContextActionService:SetTitle(
    ACTION_NAME,
    "JUMP"
)

ContextActionService:SetPosition(
    ACTION_NAME,
    UDim2.new(0.82, 0, 0.72, 0)
)

--==================================================
-- LOADING WAIT
--==================================================

task.wait(LoadingTime)

--==================================================
-- COMPLETE
--==================================================

Loading.Text = "Jump Button Restored!"

task.wait(0.8)

--==================================================
-- FADE OUT
--==================================================

local FadeBackground = TweenService:Create(
    Background,
    TweenInfo.new(0.5),
    {
        BackgroundTransparency = 1
    }
)

local FadeTitle = TweenService:Create(
    Title,
    TweenInfo.new(0.5),
    {
        TextTransparency = 1
    }
)

local FadeLoading = TweenService:Create(
    Loading,
    TweenInfo.new(0.5),
    {
        TextTransparency = 1
    }
)

local FadeBrand = TweenService:Create(
    Brand,
    TweenInfo.new(0.5),
    {
        TextTransparency = 1
    }
)

FadeBackground:Play()
FadeTitle:Play()
FadeLoading:Play()
FadeBrand:Play()

FadeBackground.Completed:Wait()

--==================================================
-- REMOVE LOADING SCREEN
--==================================================

Gui:Destroy()
