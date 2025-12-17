--// Dit Fishing Panel - Fish It (FINAL + FPM + BIG TEXT)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")

--================ UI =================--

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "DitFishingPanel"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 330, 0, 260)
Frame.Position = UDim2.new(0.02, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15,20,35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,14)

-- TITLE (BIGGER)
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,-40,0,44)
Title.BackgroundTransparency = 1
Title.Text = "DIT FISHING PANEL"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 21
Title.TextStrokeTransparency = 0.55

-- CLOSE (LOWER)
local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0,32,0,32)
Close.Position = UDim2.new(1,-38,0,8)
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.BackgroundColor3 = Color3.fromRGB(35,45,70)
Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

-- INVENTORY (BIGGER)
local InventoryLabel = Instance.new("TextLabel", Frame)
InventoryLabel.Position = UDim2.new(0,0,0,60)
InventoryLabel.Size = UDim2.new(1,0,0,34)
InventoryLabel.BackgroundTransparency = 1
InventoryLabel.Text = "INVENTORY COUNT: 0 / 4500"
InventoryLabel.TextColor3 = Color3.fromRGB(255,255,255)
InventoryLabel.Font = Enum.Font.GothamBold
InventoryLabel.TextSize = 17
InventoryLabel.TextStrokeTransparency = 0.65

-- TOTAL (BIGGER)
local TotalLabel = Instance.new("TextLabel", Frame)
TotalLabel.Position = UDim2.new(0,0,0,100)
TotalLabel.Size = UDim2.new(1,0,0,34)
TotalLabel.BackgroundTransparency = 1
TotalLabel.Text = "TOTAL FISH CAUGHT: 0"
TotalLabel.TextColor3 = Color3.fromRGB(255,255,255)
TotalLabel.Font = Enum.Font.GothamBold
TotalLabel.TextSize = 17
TotalLabel.TextStrokeTransparency = 0.65

-- FISH / MIN (BIGGER)
local PerMin = Instance.new("TextLabel", Frame)
PerMin.Position = UDim2.new(0,0,0,140)
PerMin.Size = UDim2.new(1,0,0,30)
PerMin.BackgroundTransparency = 1
PerMin.Text = "FISH / MINUTE: 0.0"
PerMin.TextColor3 = Color3.fromRGB(180,210,255)
PerMin.Font = Enum.Font.GothamBold
PerMin.TextSize = 15

-- TOGGLE (LOWER)
local Toggle = Instance.new("TextButton", Frame)
Toggle.Position = UDim2.new(0.5,-70,0,180)
Toggle.Size = UDim2.new(0,140,0,32)
Toggle.Text = "TOGGLE FISH / MIN"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 14
Toggle.TextColor3 = Color3.fromRGB(255,255,255)
Toggle.BackgroundColor3 = Color3.fromRGB(35,45,70)
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,10)

--================ LOGIC =================--

local lastInventory
local totalFish = 0
local startTime
local showFPM = true

local function getFishCount()
    local max = 0
    for _,v in ipairs(PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") then
            local a = v.Text:match("(%d+)%s*/")
            max = math.max(max, tonumber(a) or 0)
        end
    end
    return max
end

RunService.RenderStepped:Connect(function()
    local current = getFishCount()
    if current > 0 then
        InventoryLabel.Text = "INVENTORY COUNT: "..current.." / 4500"

        if not lastInventory then
            lastInventory = current
            return
        end

        if current > lastInventory then
            totalFish += (current - lastInventory)
            TotalLabel.Text = "TOTAL FISH CAUGHT: "..totalFish
            startTime = startTime or os.clock()
        end

        if startTime and showFPM then
            PerMin.Text = string.format(
                "FISH / MINUTE: %.1f",
                (totalFish / (os.clock() - startTime)) * 60
            )
        end

        lastInventory = current
    end
end)

Toggle.MouseButton1Click:Connect(function()
    showFPM = not showFPM
    PerMin.Visible = showFPM
end)

--================ LOGO =================--

local Logo = Instance.new("TextButton", ScreenGui)
Logo.Size = UDim2.new(0,56,0,56)
Logo.Position = UDim2.new(0.02,0,0.3,0)
Logo.Text = "A"
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 24
Logo.TextColor3 = Color3.fromRGB(255,255,255)
Logo.BackgroundColor3 = Color3.fromRGB(25,35,60)
Logo.Visible = false
Logo.Active = true
Logo.Draggable = true
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1,0)

Close.MouseButton1Click:Connect(function()
    Frame.Visible = false
    Logo.Visible = true
end)

Logo.MouseButton1Click:Connect(function()
    Frame.Visible = true
    Logo.Visible = false
end)
