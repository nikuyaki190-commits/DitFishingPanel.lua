--==================================================
-- SUPER ENTENG ALL-IN-ONE | FREEZE + BLACK SCREEN + FPS BOOST + PANEL
--==================================================

local P = game.Players.LocalPlayer
local L = game:GetService("Lighting")
local W = workspace
local R = game:GetService("RunService")
local S = game:GetService("StarterGui")

local MIN, MAX, SAFE = 60, 120, 35

-- =========================
-- PANEL FPS BOOST
-- =========================
local function createPanel()
    local g = Instance.new("ScreenGui")
    g.Name = "FPSBoostPanel"
    g.ResetOnSpawn = false
    g.Parent = P:WaitForChild("PlayerGui")

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 320, 0, 130)
    panel.Position = UDim2.new(0, 10, 0, 10)
    panel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    panel.BorderSizePixel = 0
    panel.Parent = g

    local corner = Instance.new("UICorner", panel)
    corner.CornerRadius = UDim.new(0, 16)

    local stroke = Instance.new("UIStroke", panel)
    stroke.Color = Color3.fromRGB(0, 255, 0)
    stroke.Thickness = 1.5

    local title = Instance.new("TextLabel", panel)
    title.Size = UDim2.new(1, 0, 0, 36)
    title.Position = UDim2.new(0, 0, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "FPS Boost Active"
    title.TextColor3 = Color3.fromRGB(0, 180, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20

    local timeLabel = Instance.new("TextLabel", panel)
    timeLabel.Size = UDim2.new(1, 0, 0, 60)
    timeLabel.Position = UDim2.new(0, 0, 0, 48)
    timeLabel.BackgroundTransparency = 1
    timeLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    timeLabel.Font = Enum.Font.SourceSansBold
    timeLabel.TextSize = 30
    timeLabel.Text = "0s"

    local startTime = tick()

    local function formatTime(d,h,m,s)
        local t = {}
        if d > 0 then table.insert(t, d.."d") end
        if h > 0 then table.insert(t, h.."h") end
        if m > 0 then table.insert(t, m.."m") end
        if s > 0 or #t == 0 then table.insert(t, s.."s") end
        return table.concat(t, " ")
    end

    R.RenderStepped:Connect(function()
        local e = math.floor(tick() - startTime)
        local d = math.floor(e / 86400)
        local h = math.floor((e % 86400) / 3600)
        local m = math.floor((e % 3600) / 60)
        local s = e % 60
        timeLabel.Text = formatTime(d,h,m,s)
    end)
end

-- =========================
-- TUNGGU 30 DETIK
-- =========================
task.spawn(function()
    task.wait(30)

    -- BLACK SCREEN & LOCK CAMERA
    local cam = W.CurrentCamera
    cam.CameraType = Enum.CameraType.Scriptable
    cam.CFrame = CFrame.new(0,100000,0)

    L.Brightness = 0
    L.FogEnd = 0
    L.GlobalShadows = false

    for _,v in ipairs(L:GetChildren()) do
        if v:IsA("PostEffect") then
            v.Enabled = false
        end
    end

    R.RenderStepped:Connect(function()
        if cam.CameraType ~= Enum.CameraType.Scriptable then
            cam.CameraType = Enum.CameraType.Scriptable
            cam.CFrame = CFrame.new(0,100000,0)
        end
    end)

    -- NOTIF ANIMASI
    local g = Instance.new("ScreenGui", P:WaitForChild("PlayerGui"))
    g.ResetOnSpawn = false

    local l1 = Instance.new("TextLabel", g)
    local l2 = Instance.new("TextLabel", g)

    l1.Size = UDim2.new(0,400,0,100)
    l1.Position = UDim2.new(0.5,-200,0.5,-50)
    l1.BackgroundTransparency = 1
    l1.TextColor3 = Color3.fromRGB(170,0,255)
    l1.Font = Enum.Font.Antique
    l1.TextScaled = true
    l1.Text = "FPS BOOST ON"
    l1.TextTransparency = 1

    l2.Size = UDim2.new(0,500,0,60)
    l2.Position = UDim2.new(0.5,-250,0.5,70)
    l2.BackgroundTransparency = 1
    l2.TextColor3 = Color3.fromRGB(255,255,255)
    l2.Font = Enum.Font.Antique
    l2.TextScaled = true
    l2.Text = "TERIMAKASIH SUDAH MEMAKAI SCRIPT INI 😁✌️"
    l2.TextTransparency = 1

    for i=0,1,0.05 do
        l1.TextTransparency = 1-i
        l2.TextTransparency = 1-i
        task.wait(0.03)
    end

    task.wait(5)

    for i=0,1,0.05 do
        l1.TextTransparency = i
        l2.TextTransparency = i
        task.wait(0.03)
    end
    g:Destroy()

    -- FREEZE PLAYER
    local function freezeChar(c)
        local h = c:WaitForChild("Humanoid")
        local hrp = c:WaitForChild("HumanoidRootPart")
        h.WalkSpeed = 0
        h.JumpPower = 0
        h.AutoRotate = false
        hrp.Anchored = true
    end
    freezeChar(P.Character or P.CharacterAdded:Wait())

    R.RenderStepped:Connect(function()
        local hrp = P.Character and P.Character:FindFirstChild("HumanoidRootPart")
        if hrp and not hrp.Anchored then
            hrp.Anchored = true
        end
    end)

    -- PHYSICS ENTENG
    settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
    settings().Physics.AllowSleep = true

    -- MAP ENTENG
    task.spawn(function()
        while task.wait(2.5) do
            local hrp = P.Character and P.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            for _,v in ipairs(W:GetDescendants()) do
                if v:IsA("BasePart") then
                    local d = (v.Position - hrp.Position).Magnitude
                    v.LocalTransparencyModifier = d > SAFE and 1 or 0
                    v.CastShadow = false
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                end
            end
        end
    end)

    -- MEMORY CLEAN
    task.spawn(function()
        while task.wait(15) do
            collectgarbage("step",120)
        end
    end)

    -- AKTIFKAN PANEL
    createPanel()
end)
