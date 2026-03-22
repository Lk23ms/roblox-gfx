-- GFX Optimizer Script cho Roblox
-- Tự làm bởi Claude | Chỉ tối ưu đồ họa

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Tạo GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GFXOptimizer"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 160)
frame.Position = UDim2.new(1, -220, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(30, 19, 50)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Hàm tạo toggle button
local function makeToggle(text, yPos, defaultOn, callback)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Position = UDim2.new(0, 12, 0, yPos)
    label.Size = UDim2.new(0.6, 0, 0, 28)
    label.TextColor3 = Color3.fromRGB(220, 210, 240)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 42, 0, 22)
    btn.Position = UDim2.new(1, -54, 0, yPos + 3)
    btn.BackgroundColor3 = defaultOn
        and Color3.fromRGB(124, 58, 237)
        or Color3.fromRGB(58, 45, 90)
    btn.Text = ""
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local on = defaultOn
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.BackgroundColor3 = on
            and Color3.fromRGB(124, 58, 237)
            or Color3.fromRGB(58, 45, 90)
        callback(on)
    end)
end

-- Low GFX
makeToggle("Low GFX", 35, true, function(on)
    settings().Rendering.QualityLevel = on
        and Enum.QualityLevel.Level01
        or Enum.QualityLevel.Automatic
    Lighting.GlobalShadows = not on
    Lighting.FogEnd = on and 9e9 or 1000
    -- thêm vào đây
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") then
            v.Material = on and Enum.Material.SmoothPlastic or v.Material
            v.CastShadow = not on
        end
        if v:IsA("ParticleEmitter") or v:IsA("Smoke")
            or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = not on
        end
    end
end)

-- No Shadows
makeToggle("No Shadows", 68, false, function(on)
    Lighting.GlobalShadows = not on
end)

-- No Fog
makeToggle("No Fog", 101, false, function(on)
    Lighting.FogEnd = on and 9e9 or 1000
    Lighting.FogStart = on and 9e9 or 0
end)

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Text = "GFX Optimizer"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 4)
title.TextColor3 = Color3.fromRGB(192, 132, 252)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

print("[GFX Optimizer] Loaded!")
