-- 🧠 thanhtaipro - đẹp, gọn,  tab,  màu nhạt

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local CoreGui = game:GetService("CoreGui")

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "thanhtai💤"
gui.ResetOnSpawn = false

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0.5, -20)
openBtn.Text = "💤"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextScaled = true
openBtn.BackgroundColor3 = Color3.fromRGB(100, 70, 150)
openBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", openBtn)

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 280, 0, 330)
mainFrame.Position = UDim2.new(0, 60, 0.5, -165)
mainFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 34)
title.Text = "THANH TAI💤"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.BackgroundColor3 = Color3.fromRGB(90, 70, 140)
Instance.new("UICorner", title)

local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 30, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 3)
closeBtn.Text = "✖"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", closeBtn)

openBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)
closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

local currentTab
local tabs = {}

local function createTab(name, posX)
	local btn = Instance.new("TextButton", mainFrame)
	btn.Size = UDim2.new(0, 120, 0, 28)
	btn.Position = UDim2.new(0, posX, 0, 38)
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(90, 90, 140)
	btn.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", btn)

	local frame = Instance.new("Frame", mainFrame)
	frame.Size = UDim2.new(1, -20, 1, -80)
	frame.Position = UDim2.new(0, 10, 0, 70)
	frame.BackgroundTransparency = 1
	frame.Visible = false

	local y = 0
	local function addToggle(text, callback)
		local btn = Instance.new("TextButton", frame)
		btn.Size = UDim2.new(1, 0, 0, 30)
		btn.Position = UDim2.new(0, 0, 0, y)
		btn.Text = "◻ " .. text
		btn.Font = Enum.Font.Gotham
		btn.TextScaled = true
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.BackgroundColor3 = Color3.fromRGB(100, 100, 160)
		Instance.new("UICorner", btn)
		y += 34

		local state = false
		btn.MouseButton1Click:Connect(function()
			state = not state
			btn.Text = (state and "✅ " or "◻ ") .. text
			btn.BackgroundColor3 = state and Color3.fromRGB(100, 220, 140) or Color3.fromRGB(100, 100, 160)
			callback(state)
		end)
	end

	tabs[name] = {button = btn, frame = frame, addToggle = addToggle}
	btn.MouseButton1Click:Connect(function()
		if currentTab then currentTab.frame.Visible = false end
		currentTab = tabs[name]
		currentTab.frame.Visible = true
	end)
	return tabs[name]
end

local fixLag = createTab("🎉 Fix Lag", 10)
local combat = createTab("🔪 Combat", 150)

-- ✅ Fix Lag Tab
fixLag.addToggle("Xoá hiệu ứng", function(state)
	if state then
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") then
				pcall(function() v:Destroy() end)
			end
		end
	end
end)

fixLag.addToggle("Ẩn Decal", function(state)
	if state then
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Decal") then
				pcall(function() v:Destroy() end)
			end
		end
	end
end)

fixLag.addToggle("Tắt ánh sáng phụ", function(state)
	for _, v in pairs(Lighting:GetChildren()) do
		if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
			pcall(function() v.Enabled = not state end)
		end
	end
end)

-- ✅ Combat Tab
combat.addToggle("Attack👹", function(state)
	if state then
		task.spawn(function()
			while state do
				local tool = Character:FindFirstChildOfClass("Tool")
				if tool then tool:Activate() end
				wait(0.1)
			end
		end)
	end
end)

combat.addToggle("Tăng tốc đánh👹", function(state)
	local conn
	if state then
		conn = RunService.Heartbeat:Connect(function()
			local hum = Character:FindFirstChildOfClass("Humanoid")
			if hum then
				for _, anim in pairs(hum:GetPlayingAnimationTracks()) do
					anim:AdjustSpeed(1000)
				end
			end
		end)
	else
		if conn then conn:Disconnect() end
	end
end)

combat.addToggle("Hitbox👹", function(state)
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			for _, part in ipairs({"Head", "Torso", "HumanoidRootPart"}) do
				local partObj = p.Character:FindFirstChild(part)
				if partObj then
					partObj.Size = state and Vector3.new(6, 6, 6) or Vector3.new(2, 2, 1)
					partObj.Material = state and Enum.Material.Neon or Enum.Material.Plastic
					partObj.Transparency = state and 0.5 or 0
					partObj.BrickColor = state and BrickColor.new("Bright red") or BrickColor.new("Medium stone grey")
				end
			end
		end
	end
end)

-- ✅ FPS hiển thị
local fpsLabel = Instance.new("TextLabel", gui)
fpsLabel.Size = UDim2.new(0, 100, 0, 30)
fpsLabel.Position = UDim2.new(1, -110, 0, 10)
fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fpsLabel.TextColor3 = Color3.new(0, 1, 0)
fpsLabel.TextScaled = true
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Text = ""
fpsLabel.Visible = false
Instance.new("UICorner", fpsLabel)

fixLag.addToggle("FPS", function(state)
	local last = tick()
	local frame = 0
	local conn
	fpsLabel.Visible = state
	if state then
		conn = RunService.RenderStepped:Connect(function()
			frame += 1
			if tick() - last >= 1 then
				fpsLabel.Text = "FPS: " .. frame
				frame = 0
				last = tick()
			end
		end)
	else
		if conn then conn:Disconnect() end
	end
end)

fixLag.button:Invoke()
