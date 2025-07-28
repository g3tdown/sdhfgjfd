local oldGui = game.CoreGui:FindFirstChild("CheatMenu")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "CheatMenu"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 380)
frame.Position = UDim2.new(0.5, -150, 0.5, -190)
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
titleBar.BorderSizePixel = 0
titleBar.Text = "Cheat Hub"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 20
titleBar.Parent = frame

local function createButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -40, 0, 40)
	btn.Position = UDim2.new(0, 20, 0, yPos)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18
	btn.Parent = frame
	return btn
end

local result = Instance.new("TextLabel")
result.Size = UDim2.new(1, -40, 0, 40)
result.Position = UDim2.new(0, 20, 0, 330)
result.Text = ""
result.TextColor3 = Color3.new(1, 1, 1)
result.BackgroundTransparency = 1
result.Font = Enum.Font.SourceSansItalic
result.TextSize = 18
result.TextWrapped = true
result.TextXAlignment = Enum.TextXAlignment.Left
result.Parent = frame

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flyBtn = createButton("Fly", 40)
local partBtn = createButton("Create part", 90)
local speedBtn = createButton("Speed Boost", 140)
speedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
local jumpBtn = createButton("Jump Boost", 190)
jumpBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
local noclipBtn = createButton("NoClip [N]", 240)

local speedBoosted = false
local jumpBoosted = false
local flying = false
local noclip = false
local bodyVelocity

flyBtn.MouseButton1Click:Connect(function()
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
	flying = not flying
	if flying then
		result.Text = "🛫 Fly включён"
		local hrp = player.Character.HumanoidRootPart
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		humanoid.PlatformStand = true
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVelocity.Velocity = Vector3.new()
		bodyVelocity.Parent = hrp

		runService:BindToRenderStep("Fly", Enum.RenderPriority.Character.Value + 1, function()
			if not flying then return end
			local dir = Vector3.new()
			local camCF = workspace.CurrentCamera.CFrame
			if uis:IsKeyDown(Enum.KeyCode.W) then dir += camCF.LookVector end
			if uis:IsKeyDown(Enum.KeyCode.S) then dir -= camCF.LookVector end
			if uis:IsKeyDown(Enum.KeyCode.A) then dir -= camCF.RightVector end
			if uis:IsKeyDown(Enum.KeyCode.D) then dir += camCF.RightVector end
			if uis:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
			if uis:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
			bodyVelocity.Velocity = dir.Unit * 70
		end)
	else
		if bodyVelocity then bodyVelocity:Destroy() end
		if player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character.Humanoid.PlatformStand = false
		end
		runService:UnbindFromRenderStep("Fly")
		result.Text = "🛬 Fly выключен"
	end
end)

partBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local p = Instance.new("Part")
		p.Anchored = true
		p.Size = Vector3.new(5, 1, 5)
		p.Position = char.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
		p.BrickColor = BrickColor.new("Bright green")
		p.Parent = workspace
		result.Text = "✅ Блок создан"
	end
end)

speedBtn.MouseButton1Click:Connect(function()
	local hum = player.Character and player.Character:FindFirstChild("Humanoid")
	if not hum then return end
	speedBoosted = not speedBoosted
	if speedBoosted then
		hum.WalkSpeed = 32
		speedBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		result.Text = "🚀 Speed Boost включён"
	else
		hum.WalkSpeed = 16
		speedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		result.Text = "🐢 Speed Boost выключен"
	end
end)

jumpBtn.MouseButton1Click:Connect(function()
	local hum = player.Character and player.Character:FindFirstChild("Humanoid")
	if not hum then return end
	jumpBoosted = not jumpBoosted
	if jumpBoosted then
		hum.JumpPower = 100
		jumpBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
		result.Text = "🦘 Jump Boost включён"
	else
		hum.JumpPower = 50
		jumpBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
		result.Text = "🦘 Jump Boost выключен"
	end
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	result.Text = noclip and "🚪 NoClip включён (на клавишу N)" or "🚪 NoClip выключен"
end)

uis.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.N then
		noclip = not noclip
		result.Text = noclip and "🚪 NoClip включён (на клавишу N)" or "🚪 NoClip выключен"
	end
end)

runService.Stepped:Connect(function()
	if noclip and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") and part.CanCollide then
				part.CanCollide = false
			end
		end
	end
end)

local resizeHandle = Instance.new("Frame")
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
resizeHandle.BorderSizePixel = 0
resizeHandle.ZIndex = 2
resizeHandle.Parent = frame

local triangle = Instance.new("ImageLabel")
triangle.Size = UDim2.new(1, 0, 1, 0)
triangle.BackgroundTransparency = 1
triangle.Image = "rbxassetid://1095708"
triangle.ImageColor3 = Color3.fromRGB(200, 200, 200)
triangle.Parent = resizeHandle

local dragging = false
local startInputPosition
local startSize

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		startInputPosition = input.Position
		startSize = frame.Size
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

uis.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - startInputPosition
		frame.Size = UDim2.new(0, math.clamp(startSize.X.Offset + delta.X, 150, 600), 0, math.clamp(startSize.Y.Offset + delta.Y, 250, 600))
	end
end)
