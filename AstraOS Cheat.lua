--[================================================================]--
--  AstraOS Rivals Script By AstraBey
--[================================================================]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--------------------------------------------------------------------------------
-- TELEPORT / OYUN DEĞİŞTİRME ALGILAMA & OTOMATİK YENİDEN YÜKLEME
--------------------------------------------------------------------------------
if not _G.AstraOS_GlobalData then
    _G.AstraOS_GlobalData = {
        Settings = nil,
        Whitelist = nil,
        Keybinds = nil
    }
end

local savedSettings = _G.AstraOS_GlobalData.Settings
local savedWhitelist = _G.AstraOS_GlobalData.Whitelist
local savedKeybinds = _G.AstraOS_GlobalData.Keybinds

if not savedSettings then
    pcall(function()
        local teleportData = TeleportService:GetLocalPlayerTeleportData()
        if teleportData and type(teleportData) == "table" then
            if teleportData.Settings then savedSettings = teleportData.Settings end
            if teleportData.Whitelist then savedWhitelist = teleportData.Whitelist end
            if teleportData.Keybinds then savedKeybinds = teleportData.Keybinds end
        end
    end)
end

--------------------------------------------------------------------------------
-- WHITELIST & TAKIM SİSTEMİ
--------------------------------------------------------------------------------
local WhitelistPlayers = {
    "ArkadasininAdi1",
    "ArkadasininAdi2"
}

if savedWhitelist and type(savedWhitelist) == "table" then
    WhitelistPlayers = savedWhitelist
end

local function isWhitelisted(player)
    if not player then return false end
    for _, name in ipairs(WhitelistPlayers) do
        if string.lower(player.Name) == string.lower(name) or string.lower(player.DisplayName) == string.lower(name) then
            return true
        end
    end
    return false
end

local settingsLegit = {
    LegitAim = false,
    Smoothness = 5,
    FOVEnabled = true,
    FOVRadius = 150,
    WallCheck = true,
    LegitFOVVisible = true,
    ESPBox = true,
    Tracers = false,
    NameESP = true,
    DistanceESP = true,
    Chams = false,
    Skeleton = false,
    TeamCheck = true
}

local function isTeamMember(player)
    if not settingsLegit.TeamCheck then return false end
    if player == LocalPlayer then return true end
    
    if LocalPlayer.Team and player.Team then
        if LocalPlayer.Team == player.Team then return true end
    end

    pcall(function()
        if LocalPlayer.Character and player.Character then
            local myHighlight = LocalPlayer.Character:FindFirstChildOfClass("Highlight")
            local targetHighlight = player.Character:FindFirstChildOfClass("Highlight")
            if myHighlight and targetHighlight and myHighlight.FillColor == targetHighlight.FillColor then
                return true
            end
        end
    end)

    return false
end

-- SCREEN GUI KURULUMU
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraOS_Suite_Pro"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MobileScreenGui = Instance.new("ScreenGui")
MobileScreenGui.Name = "AstraOS_MobileOverlay"
MobileScreenGui.ResetOnSpawn = false
pcall(function() MobileScreenGui.Parent = CoreGui end)
if not MobileScreenGui.Parent then MobileScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- ÇİZİMLERİ TEMİZLEME (UNLOAD)
local activeDrawings = {}
local activeTracers = {}
local activeSkeletons = {}
local fovCircleLegit = Drawing.new("Circle")
local isScriptLoaded = true

local function unloadScript()
    isScriptLoaded = false
    pcall(function() fovCircleLegit:Remove() end)
    for _, drawings in pairs(activeDrawings) do
        pcall(function() drawings.Box:Remove(); drawings.Name:Remove(); drawings.Dist:Remove() end)
    end
    for _, line in pairs(activeTracers) do pcall(function() line:Remove() end) end
    for _, skel in pairs(activeSkeletons) do
        for _, boneLine in pairs(skel) do pcall(function() boneLine:Remove() end) end
    end
    pcall(function() ScreenGui:Destroy() end)
    pcall(function() MobileScreenGui:Destroy() end)
end

local keybinds = {
    ToggleMenu = Enum.KeyCode.RightShift,
    AimKey = Enum.UserInputType.MouseButton2
}

if savedSettings and type(savedSettings) == "table" then
    for k, v in pairs(savedSettings) do if settingsLegit[k] ~= nil then settingsLegit[k] = v end end
end
if savedKeybinds and type(savedKeybinds) == "table" then
    for k, v in pairs(savedKeybinds) do if keybinds[k] ~= nil then keybinds[k] = v end end
end

-- Teleport Kaydı
LocalPlayer.OnTeleport:Connect(function(teleportState)
    if teleportState == Enum.TeleportState.Started then
        pcall(function()
            local currentData = {
                Settings = settingsLegit,
                Whitelist = WhitelistPlayers,
                Keybinds = keybinds
            }
            _G.AstraOS_GlobalData.Settings = settingsLegit
            _G.AstraOS_GlobalData.Whitelist = WhitelistPlayers
            _G.AstraOS_GlobalData.Keybinds = keybinds
            TeleportService:SetTeleportSetting("AstraOS_PersistentData", currentData)
        end)
    end
end)

if not savedSettings then
    local globalSaved = nil
    pcall(function() globalSaved = TeleportService:GetTeleportSetting("AstraOS_PersistentData") end)
    if globalSaved and type(globalSaved) == "table" then
        savedSettings = globalSaved.Settings
        savedWhitelist = globalSaved.Whitelist
        savedKeybinds = globalSaved.Keybinds
    end
end

local aimKeyPressed = false
local mobileAimToggled = false

-- MOBİL KONTROL BUTONLARI
local ToggleMenuMobBtn = Instance.new("TextButton")
ToggleMenuMobBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleMenuMobBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleMenuMobBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
ToggleMenuMobBtn.Text = "⚙️"
ToggleMenuMobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuMobBtn.TextSize = 16
ToggleMenuMobBtn.Active = true
ToggleMenuMobBtn.Draggable = true
ToggleMenuMobBtn.Parent = MobileScreenGui

local MobMenuCorner = Instance.new("UICorner")
MobMenuCorner.CornerRadius = UDim.new(1, 0)
MobMenuCorner.Parent = ToggleMenuMobBtn

local MobMenuStroke = Instance.new("UIStroke")
MobMenuStroke.Color = Color3.fromRGB(80, 120, 255)
MobMenuStroke.Thickness = 1.5
MobMenuStroke.Parent = ToggleMenuMobBtn

local AimMobBtn = Instance.new("TextButton")
AimMobBtn.Size = UDim2.new(0, 56, 0, 56)
AimMobBtn.Position = UDim2.new(1, -70, 0.5, -28)
AimMobBtn.BackgroundColor3 = settingsLegit.LegitAim and Color3.fromRGB(15, 55, 30) or Color3.fromRGB(20, 25, 38)
AimMobBtn.Text = "🎯"
AimMobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimMobBtn.TextSize = 18
AimMobBtn.Font = Enum.Font.GothamBold
AimMobBtn.Active = true
AimMobBtn.Draggable = true
AimMobBtn.Parent = MobileScreenGui

local MobAimCorner = Instance.new("UICorner")
MobAimCorner.CornerRadius = UDim.new(1, 0)
MobAimCorner.Parent = AimMobBtn

local MobAimStroke = Instance.new("UIStroke")
MobAimStroke.Color = Color3.fromRGB(80, 120, 255)
MobAimStroke.Thickness = 1.5
MobAimStroke.Parent = AimMobBtn

-- FOV ÇEMBERİ
fovCircleLegit.Visible = false
fovCircleLegit.Transparency = 0.5
fovCircleLegit.Color = Color3.fromRGB(80, 140, 255)
fovCircleLegit.Thickness = 1.5
fovCircleLegit.NumSides = 48
fovCircleLegit.Radius = settingsLegit.FOVRadius
fovCircleLegit.Filled = false

-- ESP ÇİZİMLERİ
local function createDrawings(player)
    if activeDrawings[player] then return end
    local box = Drawing.new("Square")
    box.Visible = false; box.Color = Color3.fromRGB(80, 140, 255); box.Thickness = 1.5; box.Filled = false
    
    local nameText = Drawing.new("Text")
    nameText.Visible = false; nameText.Color = Color3.fromRGB(255, 255, 255); nameText.Size = 12; nameText.Center = true; nameText.Outline = true
    
    local distText = Drawing.new("Text")
    distText.Visible = false; distText.Color = Color3.fromRGB(180, 190, 210); distText.Size = 11; distText.Center = true; distText.Outline = true

    activeDrawings[player] = {Box = box, Name = nameText, Dist = distText}
end

local function removeDrawings(player)
    if activeDrawings[player] then
        pcall(function() activeDrawings[player].Box:Remove(); activeDrawings[player].Name:Remove(); activeDrawings[player].Dist:Remove() end)
        activeDrawings[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then createDrawings(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then createDrawings(p) end end)
Players.PlayerRemoving:Connect(removeDrawings)

-- TRACERS ÇİZİMLERİ
local function createTracer(player)
    if activeTracers[player] then return end
    local line = Drawing.new("Line")
    line.Visible = false; line.Color = Color3.fromRGB(80, 140, 255); line.Thickness = 1; line.Transparency = 0.6
    activeTracers[player] = line
end

local function removeTracer(player)
    if activeTracers[player] then activeTracers[player]:Remove(); activeTracers[player] = nil end
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then createTracer(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then createTracer(p) end end)
Players.PlayerRemoving:Connect(removeTracer)

-- SKELETON ÇİZİMLERİ
local function createSkeleton(player)
    if activeSkeletons[player] then return end
    local bones = {}
    local boneNames = {"Head_Neck", "Neck_UpperTorso", "UpperTorso_LowerTorso", "UpperTorso_LeftUpperArm", "LeftUpperArm_LeftLowerArm", "LeftLowerArm_LeftHand", "UpperTorso_RightUpperArm", "RightUpperArm_RightLowerArm", "RightLowerArm_RightHand", "LowerTorso_LeftUpperLeg", "LeftUpperLeg_LeftLowerLeg", "LeftLowerLeg_LeftFoot", "LowerTorso_RightUpperLeg", "RightUpperLeg_RightLowerLeg", "RightLowerLeg_RightFoot"}
    for _, _ in ipairs(boneNames) do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(80, 140, 255)
        line.Thickness = 1.2
        table.insert(bones, line)
    end
    activeSkeletons[player] = bones
end

local function removeSkeleton(player)
    if activeSkeletons[player] then
        for _, line in ipairs(activeSkeletons[player]) do pcall(function() line:Remove() end) end
        activeSkeletons[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then createSkeleton(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then createSkeleton(p) end end)
Players.PlayerRemoving:Connect(removeSkeleton)

-- GİRDİ KONTROLLERİ
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == keybinds.AimKey or input.UserInputType == keybinds.AimKey then
        aimKeyPressed = true
    elseif input.KeyCode == keybinds.ToggleMenu then
        local main = ScreenGui:FindFirstChild("AstraMainFrame")
        if main then main.Visible = not main.Visible end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == keybinds.AimKey or input.UserInputType == keybinds.AimKey then
        aimKeyPressed = false
    end
end)

ToggleMenuMobBtn.MouseButton1Click:Connect(function()
    local main = ScreenGui:FindFirstChild("AstraMainFrame")
    if main then main.Visible = not main.Visible end
end)

AimMobBtn.MouseButton1Click:Connect(function()
    mobileAimToggled = not mobileAimToggled
    settingsLegit.LegitAim = mobileAimToggled
    AimMobBtn.BackgroundColor3 = mobileAimToggled and Color3.fromRGB(15, 55, 30) or Color3.fromRGB(20, 25, 38)
end)

--------------------------------------------------------------------------------
-- ARAYÜZ (UI) TASARIMI
--------------------------------------------------------------------------------
local MainFrameLegit = Instance.new("Frame")
MainFrameLegit.Name = "AstraMainFrame"
MainFrameLegit.Size = UDim2.new(0, 580, 0, 460)
MainFrameLegit.Position = UDim2.new(0.5, -290, 0.5, -230)
MainFrameLegit.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrameLegit.BorderSizePixel = 0
MainFrameLegit.Active = true
MainFrameLegit.Draggable = true
MainFrameLegit.Visible = true
MainFrameLegit.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrameLegit

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(50, 60, 90)
MainStroke.Thickness = 1.8
MainStroke.Parent = MainFrameLegit

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(17, 18, 27)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrameLegit

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 12)
TopFix.Position = UDim2.new(0, 0, 1, -12)
TopFix.BackgroundColor3 = Color3.fromRGB(17, 18, 27)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ASTRA OS <font color='#5090FF'>// Rivals </font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(245, 245, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.Position = UDim2.new(0, 0, 1, 0)
AccentLine.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = TopBar

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -65)
Sidebar.Position = UDim2.new(0, 12, 0, 56)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrameLegit

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 10)
SideCorner.Parent = Sidebar

local SideStroke = Instance.new("UIStroke")
SideStroke.Color = Color3.fromRGB(35, 40, 60)
SideStroke.Thickness = 1
SideStroke.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 8)
SideLayout.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -174, 1, -65)
ContentArea.Position = UDim2.new(0, 168, 0, 56)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrameLegit

local pages = {}
local tabButtons = {}

local function createTabContent(key)
    local sf = Instance.new("ScrollingFrame")
    sf.Size = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.CanvasSize = UDim2.new(0, 0, 0, 650)
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = Color3.fromRGB(70, 130, 255)
    sf.Visible = (key == "Legit")
    sf.Parent = ContentArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = sf

    pages[key] = sf
    return sf
end

local legitPage = createTabContent("Legit")
local visualsPage = createTabContent("Visuals")
local settingsPage = createTabContent("Settings")

local function createTabButton(name, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 40)
    btn.Position = UDim2.new(0, 6, 0, 0)
    btn.BackgroundColor3 = (key == "Legit") and Color3.fromRGB(45, 100, 210) or Color3.fromRGB(20, 21, 30)
    btn.BorderSizePixel = 0
    btn.Text = "   " .. name
    btn.TextColor3 = (key == "Legit") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 165, 190)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for k, page in pairs(pages) do page.Visible = (k == key) end
        for k, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(20, 21, 30)
            b.TextColor3 = Color3.fromRGB(160, 165, 190)
        end
        btn.BackgroundColor3 = Color3.fromRGB(45, 100, 210)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    tabButtons[key] = btn
end

createTabButton("🎯 Legit Bot", "Legit")
createTabButton("👁️ Görseller", "Visuals")
createTabButton("⚙️ Ayarlar", "Settings")

local toggleUpdateFuncs = {}

local function createToggle(parentPage, name, settingKey)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, 46)
    Card.BackgroundColor3 = Color3.fromRGB(17, 18, 27)
    Card.BorderSizePixel = 0
    Card.Parent = parentPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(32, 36, 50)
    Stroke.Thickness = 1
    Stroke.Parent = Card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 225, 240)
    Label.TextSize = 11.5
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 86, 0, 28)
    ToggleBtn.Position = UDim2.new(1, -96, 0.5, -14)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.TextSize = 10.5
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Parent = Card

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = ToggleBtn

    local function updateVisual()
        if settingsLegit[settingKey] then
            ToggleBtn.Text = "AKTİF"
            ToggleBtn.TextColor3 = Color3.fromRGB(90, 255, 150)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 55, 30)
        else
            ToggleBtn.Text = "KAPALI"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 32, 45)
        end
    end
    updateVisual()

    toggleUpdateFuncs[settingKey] = updateVisual

    ToggleBtn.MouseButton1Click:Connect(function()
        settingsLegit[settingKey] = not settingsLegit[settingKey]
        updateVisual()
    end)
end

local sliderUpdateFuncs = {}

local function createSlider(parentPage, name, settingKey, minVal, maxVal)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, 56)
    Card.BackgroundColor3 = Color3.fromRGB(17, 18, 27)
    Card.BorderSizePixel = 0
    Card.Parent = parentPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(32, 36, 50)
    Stroke.Thickness = 1
    Stroke.Parent = Card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -24, 0, 20)
    Label.Position = UDim2.new(0, 14, 0, 8)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. tostring(settingsLegit[settingKey])
    Label.TextColor3 = Color3.fromRGB(220, 225, 240)
    Label.TextSize = 11.5
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -28, 0, 6)
    SliderBar.Position = UDim2.new(0, 14, 0, 36)
    SliderBar.BackgroundColor3 = Color3.fromRGB(28, 32, 45)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Card

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 3)
    BarCorner.Parent = SliderBar

    local SliderFill = Instance.new("Frame")
    local initPercent = (settingsLegit[settingKey] - minVal) / (maxVal - minVal)
    SliderFill.Size = UDim2.new(math.clamp(initPercent, 0, 1), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = SliderFill

    local function updateSliderVisual(val)
        settingsLegit[settingKey] = val
        local percent = math.clamp((val - minVal) / (maxVal - minVal), 0, 1)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        Label.Text = name .. ": " .. tostring(val)
    end

    sliderUpdateFuncs[settingKey] = updateSliderVisual

    local dragging = false
    SliderBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local val = math.floor(minVal + (maxVal - minVal) * percent + 0.5)
            updateSliderVisual(val)
        end
    end)
end

local function createKeybindButton(parentPage, name, keybindKey)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, 46)
    Card.BackgroundColor3 = Color3.fromRGB(17, 18, 27)
    Card.BorderSizePixel = 0
    Card.Parent = parentPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(32, 36, 50)
    Stroke.Thickness = 1
    Stroke.Parent = Card

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 225, 240)
    Label.TextSize = 11.5
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local currentVal = keybinds[keybindKey]
    local displayText = typeof(currentVal) == "EnumItem" and (currentVal.Name or tostring(currentVal)) or "Tuş"

    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Size = UDim2.new(0, 115, 0, 28)
    KeyBtn.Position = UDim2.new(1, -125, 0.5, -14)
    KeyBtn.BackgroundColor3 = Color3.fromRGB(26, 30, 42)
    KeyBtn.BorderSizePixel = 0
    KeyBtn.Text = displayText
    KeyBtn.TextColor3 = Color3.fromRGB(100, 180, 255)
    KeyBtn.TextSize = 10.5
    KeyBtn.Font = Enum.Font.GothamBold
    KeyBtn.Parent = Card

    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 6)
    KeyCorner.Parent = KeyBtn

    local listening = false
    KeyBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        KeyBtn.Text = "Tuşa Bas..."
        KeyBtn.TextColor3 = Color3.fromRGB(255, 200, 50)

        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton1 then
                local chosenKey = (input.UserInputType == Enum.UserInputType.Keyboard) and input.KeyCode or input.UserInputType
                keybinds[keybindKey] = chosenKey
                KeyBtn.Text = chosenKey.Name
                KeyBtn.TextColor3 = Color3.fromRGB(100, 180, 255)
                listening = false
                connection:Disconnect()
            end
        end)
    end)
end

-- HAZIR AYARLAR (PRESET) PANELİ
local function createPresetPanel(parentPage)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, 60)
    Card.BackgroundColor3 = Color3.fromRGB(17, 18, 27)
    Card.BorderSizePixel = 0
    Card.Parent = parentPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(50, 80, 150)
    Stroke.Thickness = 1
    Stroke.Parent = Card

    local PresetBtn = Instance.new("TextButton")
    PresetBtn.Size = UDim2.new(1, -24, 0, 38)
    PresetBtn.Position = UDim2.new(0, 12, 0.5, -19)
    PresetBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 200)
    PresetBtn.BorderSizePixel = 0
    PresetBtn.Text = "⚡ Hazır Ayarları Yükle (Smooth 1, Fov Max, Visuals & Aimbot)"
    PresetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    PresetBtn.TextSize = 11
    PresetBtn.Font = Enum.Font.GothamBold
    PresetBtn.Parent = Card

    local PresetCorner = Instance.new("UICorner")
    PresetCorner.CornerRadius = UDim.new(0, 6)
    PresetCorner.Parent = PresetBtn

    PresetBtn.MouseButton1Click:Connect(function()
        -- 1. Smooth 1
        settingsLegit.Smoothness = 1
        if sliderUpdateFuncs["Smoothness"] then sliderUpdateFuncs["Smoothness"](1) end

        -- 2. Fov En Yüksekte (Max 300)
        settingsLegit.FOVRadius = 300
        if sliderUpdateFuncs["FOVRadius"] then sliderUpdateFuncs["FOVRadius"](300) end

        -- 3. Visual Sekmesindeki Her Sistem Açık (ESPBox, Tracers, NameESP, DistanceESP, Skeleton, Chams)
        local visualKeys = {"ESPBox", "Tracers", "NameESP", "DistanceESP", "Skeleton", "Chams"}
        for _, key in ipairs(visualKeys) do
            settingsLegit[key] = true
            if toggleUpdateFuncs[key] then toggleUpdateFuncs[key]() end
        end

        -- 4. Aimbot Açık
        settingsLegit.LegitAim = true
        if toggleUpdateFuncs["LegitAim"] then toggleUpdateFuncs["LegitAim"]() end
    end)
end

local function createUnloadPanel(parentPage)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, 60)
    Card.BackgroundColor3 = Color3.fromRGB(17, 18, 27)
    Card.BorderSizePixel = 0
    Card.Parent = parentPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(50, 30, 30)
    Stroke.Thickness = 1
    Stroke.Parent = Card

    local UnloadBtn = Instance.new("TextButton")
    UnloadBtn.Size = UDim2.new(1, -24, 0, 38)
    UnloadBtn.Position = UDim2.new(0, 12, 0.5, -19)
    UnloadBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
    UnloadBtn.BorderSizePixel = 0
    UnloadBtn.Text = "Scripti Tamamen Kapat (Unload)"
    UnloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    UnloadBtn.TextSize = 11.5
    UnloadBtn.Font = Enum.Font.GothamBold
    UnloadBtn.Parent = Card

    local UnloadCorner = Instance.new("UICorner")
    UnloadCorner.CornerRadius = UDim.new(0, 6)
    UnloadCorner.Parent = UnloadBtn

    UnloadBtn.MouseButton1Click:Connect(function()
        unloadScript()
    end)
end

createToggle(legitPage, "Legit Aim Aktif", "LegitAim")
createKeybindButton(legitPage, "Aim Tuşu", "AimKey")
createToggle(legitPage, "Duvar Arkası (WallCheck)", "WallCheck")
createToggle(legitPage, "Takım Arkadaşını Hedefleme", "TeamCheck")
createToggle(legitPage, "FOV Çemberini Göster", "LegitFOVVisible")
createSlider(legitPage, "Smoothness (Yumuşatma)", "Smoothness", 1, 15)
createSlider(legitPage, "FOV Yarıçapı", "FOVRadius", 50, 300)

createToggle(visualsPage, "ESP Box (Kutu)", "ESPBox")
createToggle(visualsPage, "Tracers (Çizgi)", "Tracers")
createToggle(visualsPage, "Name ESP (İsimler)", "NameESP")
createToggle(visualsPage, "Distance ESP (Mesafe)", "DistanceESP")
createToggle(visualsPage, "Skeleton (İskelet)", "Skeleton")
createToggle(visualsPage, "Chams (Model Aydınlatma)", "Chams")

createKeybindButton(settingsPage, "Menü Aç/Kapat Tuşu", "ToggleMenu")
createPresetPanel(settingsPage)
createUnloadPanel(settingsPage)

--------------------------------------------------------------------------------
-- HEDEF BULUCU VE WALLCHECK
--------------------------------------------------------------------------------
local function isVisible(targetPart)
    if not settingsLegit.WallCheck then return true end
    local camPos = Camera.CFrame.Position
    local direction = targetPart.Position - camPos
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    if LocalPlayer.Character then params.FilterDescendantsInstances = {LocalPlayer.Character} end
    params.IgnoreWater = true
    
    local result = workspace:Raycast(camPos, direction, params)
    if result then
        if result.Instance:FindFirstAncestorOfClass("Model") == targetPart.Parent then return true end
    else
        return true
    end
    return false
end

local function getLegitTarget()
    local bestTarget = nil
    local shortestDist = settingsLegit.FOVRadius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not isWhitelisted(player) and not isTeamMember(player) and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                if isVisible(head) then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if mouseDist < shortestDist then
                            shortestDist = mouseDist
                            bestTarget = head
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

-- RENDER DÖNGÜSÜ (AIMBOT)
RunService.RenderStepped:Connect(function()
    if not isScriptLoaded then return end

    if settingsLegit.FOVEnabled and settingsLegit.LegitFOVVisible then
        fovCircleLegit.Visible = true
        fovCircleLegit.Radius = settingsLegit.FOVRadius
        fovCircleLegit.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    else
        fovCircleLegit.Visible = false
    end

    if (settingsLegit.LegitAim and aimKeyPressed) or (mobileAimToggled and settingsLegit.LegitAim) then
        local target = getLegitTarget()
        if target then
            local targetCF = CFrame.lookAt(Camera.CFrame.Position, target.Position)
            local alpha = math.clamp(1 / settingsLegit.Smoothness, 0.05, 1)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, alpha)
        end
    end
end)

-- ESP DÖNGÜSÜ
task.spawn(function()
    while isScriptLoaded do
        pcall(function()
            if not isScriptLoaded then return end

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local char = player.Character
                    local highlight = char:FindFirstChild("AstraHighlight")
                    if settingsLegit.Chams and not isTeamMember(player) and not isWhitelisted(player) then
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "AstraHighlight"
                            highlight.FillTransparency = 0.5
                            highlight.FillColor = Color3.fromRGB(70, 130, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.Parent = char
                        end
                    elseif highlight then
                        highlight:Destroy()
                    end
                end
            end

            -- 1. KUTU, İSİM VE MESAFE ESP
            for player, drawings in pairs(activeDrawings) do
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                
                local isValid = player ~= LocalPlayer and not isTeamMember(player) and not isWhitelisted(player)
                local boxAct = isScriptLoaded and settingsLegit.ESPBox and isValid
                local nameAct = isScriptLoaded and settingsLegit.NameESP and isValid
                local distAct = isScriptLoaded and settingsLegit.DistanceESP and isValid

                if hrp and humanoid and humanoid.Health > 0 and isScriptLoaded then
                    local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local head = char:FindFirstChild("Head")
                        local rootPart = hrp
                        if head and rootPart then
                            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local rootPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                            
                            local height = math.abs(headPos.Y - rootPos.Y)
                            local width = height / 2.2
                            local boxPosition = Vector2.new(vector.X - width / 2, headPos.Y)

                            if boxAct then
                                drawings.Box.Size = Vector2.new(width, height)
                                drawings.Box.Position = boxPosition
                                drawings.Box.Visible = true
                            else drawings.Box.Visible = false end

                            if nameAct then
                                drawings.Name.Text = player.Name
                                drawings.Name.Position = Vector2.new(boxPosition.X + (width / 2), boxPosition.Y - 16)
                                drawings.Name.Visible = true
                            else drawings.Name.Visible = false end

                            if distAct and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                                drawings.Dist.Text = "[" .. tostring(dist) .. "m]"
                                drawings.Dist.Position = Vector2.new(boxPosition.X + (width / 2), boxPosition.Y + height + 2)
                                drawings.Dist.Visible = true
                            else drawings.Dist.Visible = false end
                        else
                            drawings.Box.Visible = false; drawings.Name.Visible = false; drawings.Dist.Visible = false
                        end
                    else
                        drawings.Box.Visible = false; drawings.Name.Visible = false; drawings.Dist.Visible = false
                    end
                else
                    drawings.Box.Visible = false; drawings.Name.Visible = false; drawings.Dist.Visible = false
                end
            end

            -- 2. TRACERS ÇİZGİLERİ
            for player, line in pairs(activeTracers) do
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                local isValid = player ~= LocalPlayer and not isTeamMember(player) and not isWhitelisted(player)
                local tracerAct = isScriptLoaded and settingsLegit.Tracers and isValid

                if tracerAct and hrp and humanoid and humanoid.Health > 0 and isScriptLoaded then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        line.To = Vector2.new(screenPos.X, screenPos.Y)
                        line.Visible = true
                    else line.Visible = false end
                else line.Visible = false end
            end

            -- 3. SKELETON ESP
            for player, bones in pairs(activeSkeletons) do
                local char = player.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                local isValid = player ~= LocalPlayer and not isTeamMember(player) and not isWhitelisted(player)
                local skelAct = isScriptLoaded and settingsLegit.Skeleton and isValid

                if skelAct and humanoid and humanoid.Health > 0 and isScriptLoaded then
                    local head = char:FindFirstChild("Head")
                    local upperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                    local lowerTorso = char:FindFirstChild("LowerTorso") or upperTorso
                    local leftUpperArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                    local leftLowerArm = char:FindFirstChild("LeftLowerArm") or leftUpperArm
                    local leftHand = char:FindFirstChild("LeftHand") or leftLowerArm
                    local rightUpperArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                    local rightLowerArm = char:FindFirstChild("RightLowerArm") or rightUpperArm
                    local rightHand = char:FindFirstChild("RightHand") or rightLowerArm
                    local leftUpperLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                    local leftLowerLeg = char and char:FindFirstChild("LeftLowerLeg") or leftUpperLeg
                    local leftFoot = char:FindFirstChild("LeftFoot") or leftLowerLeg
                    local rightUpperLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                    local rightLowerLeg = char:FindFirstChild("RightLowerLeg") or rightUpperLeg
                    local rightFoot = char:FindFirstChild("RightFoot") or rightLowerLeg

                    local limbPairs = {
                        {head, upperTorso},
                        {upperTorso, lowerTorso},
                        {upperTorso, leftUpperArm},
                        {leftUpperArm, leftLowerArm},
                        {leftLowerArm, leftHand},
                        {upperTorso, rightUpperArm},
                        {rightUpperArm, rightLowerArm},
                        {rightLowerArm, rightHand},
                        {lowerTorso, leftUpperLeg},
                        {leftUpperLeg, leftLowerLeg},
                        {leftLowerLeg, leftFoot},
                        {lowerTorso, rightUpperLeg},
                        {rightUpperLeg, rightLowerLeg},
                        {rightLowerLeg, rightFoot}
                    }

                    for i, pair in ipairs(limbPairs) do
                        local partA, partB = pair[1], pair[2]
                        local boneLine = bones[i]
                        if partA and partB and boneLine then
                            local posA, onA = Camera:WorldToViewportPoint(partA.Position)
                            local posB, onB = Camera:WorldToViewportPoint(partB.Position)
                            if onA or onB then
                                boneLine.From = Vector2.new(posA.X, posA.Y)
                                boneLine.To = Vector2.new(posB.X, posB.Y)
                                boneLine.Visible = true
                            else
                                boneLine.Visible = false
                            end
                        else
                            if boneLine then boneLine.Visible = false end
                        end
                    end
                else
                    for _, boneLine in ipairs(bones) do boneLine.Visible = false end
                end
            end
        end)
        task.wait(0.03)
    end
end)
