local oldGui = game.CoreGui:FindFirstChild("CheatMenu")
if oldGui then oldGui:Destroy() end


local gui = Instance.new("ScreenGui")
gui.Name = "CheatMenu"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 430)
frame.Position = UDim2.new(0.5, -150, 0.5, -215)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = false
frame.Parent = gui

local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.Text = "Cheat Hub"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 20
titleBar.Parent = frame

local function createButton(text, y, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Parent = frame
    return btn
end

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local result = Instance.new("TextLabel")
result.Size = UDim2.new(1, -40, 0, 30)
result.Position = UDim2.new(0, 20, 0, 380)
result.Text = ""
result.TextColor3 = Color3.new(1, 1, 1)
result.BackgroundTransparency = 1
result.Font = Enum.Font.SourceSansItalic
result.TextSize = 18
result.TextXAlignment = Enum.TextXAlignment.Left
result.Parent = frame

local btnFly = createButton("Fly", 40, Color3.fromRGB(0, 170, 255))
local btnSpeed = createButton("Speed Boost", 90, Color3.fromRGB(0, 200, 0))
local btnJump = createButton("Jump Boost", 140, Color3.fromRGB(255, 170, 0))
local btnPart = createButton("Create Part", 190, Color3.fromRGB(100, 100, 255))
local btnESP = createButton("ESP", 240, Color3.fromRGB(255, 80, 80))
local btnTP = createButton("Click TP", 290, Color3.fromRGB(255, 200, 0))
local btnAimbot = createButton("Aimbot", 340, Color3.fromRGB(255, 100, 255))

local flying = false
local bodyVel
btnFly.MouseButton1Click:Connect(function()
    flying = not flying
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if flying then
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVel.Velocity = Vector3.zero
        bodyVel.Parent = hrp
        char.Humanoid.PlatformStand = true
        result.Text = "🛫 Fly enabled"
        RunService:BindToRenderStep("Fly", Enum.RenderPriority.Character.Value, function()
            if not flying then return end
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
            if dir.Magnitude > 0 then
                dir = dir.Unit * 70
                bodyVel.Velocity = dir
                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(workspace.CurrentCamera.CFrame.LookVector.X, 0, workspace.CurrentCamera.CFrame.LookVector.Z))
            else
                bodyVel.Velocity = Vector3.zero
            end
        end)
    else
        if bodyVel then bodyVel:Destroy() end
        if char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
        RunService:UnbindFromRenderStep("Fly")
        result.Text = "🛬 Fly disabled"
    end
end)

local speedOn = false
btnSpeed.MouseButton1Click:Connect(function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if not h then return end
    speedOn = not speedOn
    h.WalkSpeed = speedOn and 32 or 16
    btnSpeed.BackgroundColor3 = speedOn and Color3.fromRGB(0,255,0) or Color3.fromRGB(0,200,0)
    result.Text = speedOn and "🚀 Speed Boost enabled" or "🐢 Speed Boost disabled"
end)

local jumpOn = false
btnJump.MouseButton1Click:Connect(function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if not h then return end
    jumpOn = not jumpOn
    h.JumpPower = jumpOn and 100 or 50
    btnJump.BackgroundColor3 = jumpOn and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255,170,0)
    result.Text = jumpOn and "🦘 Jump Boost enabled" or "🦘 Jump Boost disabled"
end)

btnPart.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local p = Instance.new("Part", workspace)
        p.Anchored = true
        p.Size = Vector3.new(5,1,5)
        p.Position = hrp.Position - Vector3.new(0, 3, 0)
        p.BrickColor = BrickColor.new("Bright green")
        result.Text = "✅ Part created"
    end
end)

local espOn = false
btnESP.MouseButton1Click:Connect(function()
    espOn = not espOn
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if espOn then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Adornee = p.Character
                box.Size = Vector3.new(4, 6, 2)
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.Transparency = 0.5
                box.Parent = p.Character
                local label = Instance.new("BillboardGui", p.Character)
                label.Name = "ESPName"
                label.Size = UDim2.new(0, 100, 0, 20)
                label.StudsOffset = Vector3.new(0, 4, 0)
                label.AlwaysOnTop = true
                local txt = Instance.new("TextLabel", label)
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = p.Name
                txt.TextColor3 = Color3.new(1, 0, 0)
                txt.TextScaled = true
            else
                if p.Character:FindFirstChild("ESPBox") then p.Character.ESPBox:Destroy() end
                if p.Character:FindFirstChild("ESPName") then p.Character.ESPName:Destroy() end
            end
        end
    end
    result.Text = espOn and "🔍 ESP enabled" or "❌ ESP disabled"
end)

local tpOn = false
btnTP.MouseButton1Click:Connect(function()
    tpOn = not tpOn
    result.Text = tpOn and "🖱️ Click TP enabled" or "❌ Click TP disabled"
end)
mouse.Button1Down:Connect(function()
    if tpOn then
        local target = mouse.Hit
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
        end
    end
end)

local aimOn = false
btnAimbot.MouseButton1Click:Connect(function()
    aimOn = not aimOn
    result.Text = aimOn and "🎯 Aimbot enabled" or "❌ Aimbot disabled"
end)
RunService.RenderStepped:Connect(function()
    if not aimOn then return end
    local cam = workspace.CurrentCamera
    local closest = nil
    local minDist = math.huge
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local screenPos, onScreen = cam:WorldToScreenPoint(p.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = p
                end
            end
        end
    end
    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
        cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Character.Head.Position)
    end
end)
