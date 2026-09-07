    --[================================================================]--
--  AstraOS Rivals Ultimate Legit Suite By AstraBey (Optimized & Cleaned)
--[================================================================]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

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
-- MODERN STATUS NOTIFICATION SYSTEM (BİLDİRİM SİSTEMİ)
--------------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AstraOS_Suite_Pro"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ActionNotificationHolder = Instance.new("Frame")
ActionNotificationHolder.Name = "ActionNotificationHolder"
ActionNotificationHolder.Size = UDim2.new(0, 300, 0, 400)
ActionNotificationHolder.Position = UDim2.new(1, -315, 1, -415)
ActionNotificationHolder.BackgroundTransparency = 1
ActionNotificationHolder.Parent = ScreenGui

local ActionNotifLayout = Instance.new("UIListLayout")
ActionNotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
ActionNotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ActionNotifLayout.Padding = UDim.new(0, 8)
ActionNotifLayout.Parent = ActionNotificationHolder

local function showActionNotification(featureName, state)
    task.spawn(function()
        local NotifCard = Instance.new("Frame")
        NotifCard.Size = UDim2.new(1, 0, 0, 50)
        NotifCard.BackgroundColor3 = Color3.fromRGB(15, 16, 24)
        NotifCard.BackgroundTransparency = 1
        NotifCard.BorderSizePixel = 0
        NotifCard.Parent = ActionNotificationHolder

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 10)
        CardCorner.Parent = NotifCard

        local CardStroke = Instance.new("UIStroke")
        CardStroke.Color = state and Color3.fromRGB(90, 255, 150) or Color3.fromRGB(255, 90, 90)
        CardStroke.Transparency = 1
        CardStroke.Thickness = 1.5
        CardStroke.Parent = NotifCard

        local AccentBar = Instance.new("Frame")
        AccentBar.Size = UDim2.new(0, 4, 1, -12)
        AccentBar.Position = UDim2.new(0, 6, 0, 6)
        AccentBar.BackgroundColor3 = state and Color3.fromRGB(90, 255, 150) or Color3.fromRGB(255, 90, 90)
        AccentBar.BackgroundTransparency = 1
        AccentBar.BorderSizePixel = 0
        AccentBar.Parent = NotifCard

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(0, 2)
        BarCorner.Parent = AccentBar

        local IconLabel = Instance.new("TextLabel")
        IconLabel.Size = UDim2.new(0, 35, 1, 0)
        IconLabel.Position = UDim2.new(0, 15, 0, 0)
        IconLabel.BackgroundTransparency = 1
        IconLabel.Text = state and "✅" or "❌"
        IconLabel.TextTransparency = 1
        IconLabel.TextSize = 18
        IconLabel.Parent = NotifCard

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -60, 0, 20)
        TitleLabel.Position = UDim2.new(0, 55, 0, 7)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = string.upper(featureName)
        TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
        TitleLabel.TextTransparency = 1
        TitleLabel.TextSize = 11
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = NotifCard

        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, -60, 0, 20)
        DescLabel.Position = UDim2.new(0, 55, 0, 23)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = state and "Durum: AKTIF EDILDI" or "Durum: KAPATILDI"
        DescLabel.TextColor3 = state and Color3.fromRGB(90, 255, 150) or Color3.fromRGB(255, 100, 100)
        DescLabel.TextTransparency = 1
        DescLabel.TextSize = 10
        DescLabel.Font = Enum.Font.GothamMedium
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = NotifCard

        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TweenService:Create(NotifCard, tweenInfo, {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(CardStroke, tweenInfo, {Transparency = 0.2}):Play()
        TweenService:Create(AccentBar, tweenInfo, {BackgroundTransparency = 0}):Play()
        TweenService:Create(IconLabel, tweenInfo, {TextTransparency = 0}):Play()
        TweenService:Create(TitleLabel, tweenInfo, {TextTransparency = 0}):Play()
        TweenService:Create(DescLabel, tweenInfo, {TextTransparency = 0}):Play()

        task.wait(2.2)

        local outTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        TweenService:Create(NotifCard, outTweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(CardStroke, outTweenInfo, {Transparency = 1}):Play()
        TweenService:Create(AccentBar, outTweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(IconLabel, outTweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(TitleLabel, outTweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(DescLabel, outTweenInfo, {TextTransparency = 1}):Play()

        task.wait(0.3)
        NotifCard:Destroy()
    end)
end

--------------------------------------------------------------------------------
-- AYARLAR VE YAPILANDIRMA
--------------------------------------------------------------------------------
local settingsLegit = {
    LegitAim = true,
    Smoothness = 1,
    FOVEnabled = true,
    FOVRadius = 200,
    WallCheck = true,
    TeamCheck = true,
    LegitFOVVisible = true,
    HitboxTarget = "Head",
    
    ESPBox = true,
    Tracers = true,
    NameESP = true,
    DistanceESP = true,
    HealthBar = true,
    Skeleton = true,
    Chams = true,
    
    AstraVisual = true
}

local keybinds = {
    MenuToggleKey = Enum.KeyCode.Insert,
    AimKey = Enum.UserInputType.MouseButton2
}

local WhitelistPlayers = {
    "ArkadasininAdi1",
    "ArkadasininAdi2"
}

if savedSettings and type(savedSettings) == "table" then
    for k, v in pairs(savedSettings) do if settingsLegit[k] ~= nil then settingsLegit[k] = v end end
end
if savedWhitelist and type(savedWhitelist) == "table" then WhitelistPlayers = savedWhitelist end

local function isWhitelisted(player)
    if not player then return false end
    for _, name in ipairs(WhitelistPlayers) do
        if string.lower(player.Name) == string.lower(name) or string.lower(player.DisplayName) == string.lower(name) then
            return true
        end
    end
    return false
end

local function isTeamMember(player)
    if not settingsLegit.TeamCheck then return false end
    if player == LocalPlayer then return true end
    if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then return true end
    return false
end

--------------------------------------------------------------------------------
-- ÇİZİMLER (ESP & FOV)
--------------------------------------------------------------------------------
local activeDrawings = {}
local activeTracers = {}
local activeSkeletons = {}
local fovCircleLegit = Drawing.new("Circle")
local isScriptLoaded = true

fovCircleLegit.Visible = false
fovCircleLegit.Transparency = 1
fovCircleLegit.Color = Color3.fromRGB(45, 100, 210)
fovCircleLegit.Thickness = 1.5
fovCircleLegit.NumSides = 64
fovCircleLegit.Radius = settingsLegit.FOVRadius
fovCircleLegit.Filled = false

local function unloadScript()
    isScriptLoaded = false
    print("[AstraOS Log] Script tamamen durduruldu ve temizlendi.")
    pcall(function() fovCircleLegit:Remove() end)
    for _, drawings in pairs(activeDrawings) do
        pcall(function() 
            drawings.Box:Remove() 
            drawings.Name:Remove() 
            drawings.Dist:Remove() 
            drawings.HealthBar:Remove()
            drawings.HealthBarOutline:Remove()
        end)
    end
    for _, line in pairs(activeTracers) do pcall(function() line:Remove() end) end
    for _, skel in pairs(activeSkeletons) do
        for _, boneLine in pairs(skel) do pcall(function() boneLine:Remove() end) end
    end
    pcall(function() ScreenGui:Destroy() end)
end

local function createDrawings(player)
    if activeDrawings[player] then return end
    local box = Drawing.new("Square")
    box.Visible = false; box.Color = Color3.fromRGB(45, 100, 210); box.Thickness = 1.5; box.Filled = false; box.Transparency = 1
    
    local nameText = Drawing.new("Text")
    nameText.Visible = false; nameText.Color = Color3.fromRGB(255, 255, 255); nameText.Size = 12; nameText.Center = true; nameText.Outline = true; nameText.Transparency = 1
    
    local distText = Drawing.new("Text")
    distText.Visible = false; distText.Color = Color3.fromRGB(180, 190, 210); distText.Size = 11; distText.Center = true; distText.Outline = true; distText.Transparency = 1

    local healthBarOutline = Drawing.new("Square")
    healthBarOutline.Visible = false; healthBarOutline.Color = Color3.fromRGB(0, 0, 0); healthBarOutline.Thickness = 1; healthBarOutline.Filled = true; healthBarOutline.Transparency = 1

    local healthBar = Drawing.new("Square")
    healthBar.Visible = false; healthBar.Color = Color3.fromRGB(0, 255, 100); healthBar.Thickness = 1; healthBar.Filled = true; healthBar.Transparency = 1

    activeDrawings[player] = {Box = box, Name = nameText, Dist = distText, HealthBar = healthBar, HealthBarOutline = healthBarOutline}
end

local function removeDrawings(player)
    if activeDrawings[player] then
        pcall(function() 
            activeDrawings[player].Box:Remove() 
            activeDrawings[player].Name:Remove() 
            activeDrawings[player].Dist:Remove() 
            activeDrawings[player].HealthBar:Remove()
            activeDrawings[player].HealthBarOutline:Remove()
        end)
        activeDrawings[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then createDrawings(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then createDrawings(p) end end)
Players.PlayerRemoving:Connect(removeDrawings)

local function createTracer(player)
    if activeTracers[player] then return end
    local line = Drawing.new("Line")
    line.Visible = false; line.Color = Color3.fromRGB(45, 100, 210); line.Thickness = 1; line.Transparency = 1
    activeTracers[player] = line
end

local function removeTracer(player)
    if activeTracers[player] then activeTracers[player]:Remove(); activeTracers[player] = nil end
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then createTracer(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then createTracer(p) end end)
Players.PlayerRemoving:Connect(removeTracer)

local function createSkeleton(player)
    if activeSkeletons[player] then return end
    local bones = {}
    for i = 1, 14 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(45, 100, 210)
        line.Thickness = 1.2
        line.Transparency = 1
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

--------------------------------------------------------------------------------
-- MOBİL KONTROL ARAYÜZÜ (OVERLAY)
--------------------------------------------------------------------------------
local MobileScreenGui = Instance.new("ScreenGui")
MobileScreenGui.Name = "AstraOS_MobileOverlay"
MobileScreenGui.ResetOnSpawn = false
pcall(function() MobileScreenGui.Parent = CoreGui end)
if not MobileScreenGui.Parent then MobileScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleMenuMobBtn = Instance.new("TextButton")
ToggleMenuMobBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleMenuMobBtn.Position = UDim2.new(0, 20, 0.35, 0)
ToggleMenuMobBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
ToggleMenuMobBtn.Text = "⚙️"
ToggleMenuMobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuMobBtn.TextSize = 20
ToggleMenuMobBtn.Active = true
ToggleMenuMobBtn.Draggable = true
ToggleMenuMobBtn.Parent = MobileScreenGui

local MobMenuCorner = Instance.new("UICorner")
MobMenuCorner.CornerRadius = UDim.new(1, 0)
MobMenuCorner.Parent = ToggleMenuMobBtn

local MobMenuStroke = Instance.new("UIStroke")
MobMenuStroke.Color = Color3.fromRGB(80, 120, 255)
MobMenuStroke.Thickness = 2
MobMenuStroke.Parent = ToggleMenuMobBtn

local AimMobBtn = Instance.new("TextButton")
AimMobBtn.Size = UDim2.new(0, 65, 0, 65)
AimMobBtn.Position = UDim2.new(1, -85, 0.45, -32)
AimMobBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 38)
AimMobBtn.Text = "🎯"
AimMobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimMobBtn.TextSize = 22
AimMobBtn.Font = Enum.Font.GothamBold
AimMobBtn.Active = true
AimMobBtn.Draggable = true
AimMobBtn.Parent = MobileScreenGui

local MobAimCorner = Instance.new("UICorner")
MobAimCorner.CornerRadius = UDim.new(1, 0)
MobAimCorner.Parent = AimMobBtn

local MobAimStroke = Instance.new("UIStroke")
MobAimStroke.Color = Color3.fromRGB(80, 120, 255)
MobAimStroke.Thickness = 2
MobAimStroke.Parent = AimMobBtn

--------------------------------------------------------------------------------
-- ANA MENÜ (LEGIT SUITE) OLUŞTURMA
--------------------------------------------------------------------------------
local MainFrameLegit = Instance.new("Frame")
MainFrameLegit.Name = "AstraMainFrameLegit"
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
Title.RichText = true
Title.Text = "⚡ ASTRA OS <font color='#5090FF'>// Pro Gelişmiş Suite</font>"
Title.TextColor3 = Color3.fromRGB(245, 245, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.Position = UDim2.new(0, 0, 1, 0)
AccentLine.BackgroundColor3 = Color3.fromRGB(45, 100, 210)
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
    sf.ScrollBarImageColor3 = Color3.fromRGB(45, 100, 210)
    sf.Visible = false
    sf.Parent = ContentArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = sf

    pages[key] = sf
    return sf
end

local combatPage = createTabContent("Combat")
local visualsPage = createTabContent("Visuals")
local presetsPage = createTabContent("Presets")
local settingsPage = createTabContent("Settings")

combatPage.Visible = true

local function createTabButton(name, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 40)
    btn.Position = UDim2.new(0, 6, 0, 0)
    btn.BackgroundColor3 = (key == "Combat") and Color3.fromRGB(45, 100, 210) or Color3.fromRGB(20, 21, 30)
    btn.BorderSizePixel = 0
    btn.Text = "   " .. name
    btn.TextColor3 = (key == "Combat") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 165, 190)
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
        print("[AstraOS Log] Sekme Degistirildi: " .. name)
    end)

    tabButtons[key] = btn
end

createTabButton("🎯 Legit Bot", "Combat")
createTabButton("👁️ Görseller", "Visuals")
createTabButton("📦 Hazır Ayarlar", "Presets")
createTabButton("⚙️ Ayarlar", "Settings")

local registeredSliders = {}
local registeredToggles = {}

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

    registeredToggles[settingKey] = {Button = ToggleBtn, UpdateFunc = updateVisual}

    ToggleBtn.MouseButton1Click:Connect(function()
        settingsLegit[settingKey] = not settingsLegit[settingKey]
        updateVisual()
        showActionNotification(name, settingsLegit[settingKey])
        print("[AstraOS Log] " .. name .. " durumu degistirildi -> " .. (settingsLegit[settingKey] and "AKTIF" or "KAPALI"))
    end)
end

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
    SliderFill.BackgroundColor3 = Color3.fromRGB(45, 100, 210)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = SliderFill

    local function updateSliderVisual(val)
        local clampedVal = math.clamp(val, minVal, maxVal)
        local percent = (clampedVal - minVal) / (maxVal - minVal)
        SliderFill.Size = UDim2.new(math.clamp(percent, 0, 1), 0, 1, 0)
        Label.Text = name .. ": " .. tostring(clampedVal)
    end

    registeredSliders[settingKey] = {UpdateFunc = updateSliderVisual, Min = minVal, Max = maxVal}

    local dragging = false
    SliderBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInputService.InputEnded:Connect(function(input) 
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
            dragging = false 
            print("[AstraOS Log] " .. name .. " yeni degeri -> " .. tostring(settingsLegit[settingKey]))
        end 
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local val = math.floor(minVal + (maxVal - minVal) * percent + 0.5)
            settingsLegit[settingKey] = val
            updateSliderVisual(val)
        end
    end)
end

local function refreshMenuUI()
    for key, data in pairs(registeredSliders) do
        if settingsLegit[key] ~= nil then
            data.UpdateFunc(settingsLegit[key])
        end
    end
    for key, data in pairs(registeredToggles) do
        if settingsLegit[key] ~= nil then
            data.UpdateFunc()
        end
    end
end

createToggle(combatPage, "Legit Aim", "LegitAim")
createToggle(combatPage, "Duvar Arkası Kontrol", "WallCheck")
createToggle(combatPage, "Takım Arkadaşı Koruması", "TeamCheck")
createToggle(combatPage, "Legit FOV Göster", "LegitFOVVisible")
createSlider(combatPage, "Yumuşatma (Smoothness)", "Smoothness", 1, 15)
createSlider(combatPage, "FOV Yarıçapı", "FOVRadius", 50, 400)

createToggle(visualsPage, "ESP Box", "ESPBox")
createToggle(visualsPage, "Tracers", "Tracers")
createToggle(visualsPage, "Name ESP", "NameESP")
createToggle(visualsPage, "Distance ESP", "DistanceESP")
createToggle(visualsPage, "Can Barı (Health Bar)", "HealthBar")
createToggle(visualsPage, "Skeleton", "Skeleton")
createToggle(visualsPage, "Chams", "Chams")

local function createPresetButton(parentPage, name, desc, applyCallback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, 65)
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
    Label.Size = UDim2.new(0.6, 0, 0, 22)
    Label.Position = UDim2.new(0, 14, 0, 8)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 225, 240)
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(0.6, 0, 0, 20)
    DescLabel.Position = UDim2.new(0, 14, 0, 32)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = desc
    DescLabel.TextColor3 = Color3.fromRGB(140, 145, 170)
    DescLabel.TextSize = 10
    DescLabel.Font = Enum.Font.GothamMedium
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = Card

    local ApplyBtn = Instance.new("TextButton")
    ApplyBtn.Size = UDim2.new(0, 100, 0, 36)
    ApplyBtn.Position = UDim2.new(1, -112, 0.5, -18)
    ApplyBtn.BackgroundColor3 = Color3.fromRGB(45, 100, 210)
    ApplyBtn.BorderSizePixel = 0
    ApplyBtn.Text = "Uygula"
    ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ApplyBtn.TextSize = 11
    ApplyBtn.Font = Enum.Font.GothamBold
    ApplyBtn.Parent = Card

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = ApplyBtn

    ApplyBtn.MouseButton1Click:Connect(function()
        applyCallback()
        refreshMenuUI()
        showActionNotification("Hazır Ayar", true)
        print("[AstraOS Log] Hazir Preset Uygulandi -> " .. name .. " | FOV: " .. settingsLegit.FOVRadius .. " | Smoothness: " .. settingsLegit.Smoothness .. " | WallCheck: " .. tostring(settingsLegit.WallCheck))
    end)
end

createPresetButton(presetsPage, "⚡ Agresif Preset", "Hızlı kilitlenme, büyük FOV ve yüksek hassasiyet.", function()
    settingsLegit.FOVRadius = 500
    settingsLegit.Smoothness = 1
    settingsLegit.WallCheck = true
end)

createPresetButton(presetsPage, "⚖️ Dengeli Preset", "Genel oyun akışı için ideal optimize ayarlar.", function()
    settingsLegit.FOVRadius = 180
    settingsLegit.Smoothness = 4
    settingsLegit.WallCheck = true
end)

createPresetButton(presetsPage, "🕵️ Gizli (Legit) Preset", "Belli etmeyen, akıcı ve doğal vuruş hissiyatı.", function()
    settingsLegit.FOVRadius = 100
    settingsLegit.Smoothness = 8
    settingsLegit.WallCheck = true
end)

local function createWhitelistPanel(parentPage)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -6, 0, 110)
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
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 14, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = "🛡️ Whitelist Yönetimi (Oyuncu Adı)"
    Label.TextColor3 = Color3.fromRGB(220, 225, 240)
    Label.TextSize = 11.5
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Card

    local WlBox = Instance.new("TextBox")
    WlBox.Size = UDim2.new(1, -28, 0, 30)
    WlBox.Position = UDim2.new(0, 14, 0, 32)
    WlBox.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    WlBox.BorderSizePixel = 0
    WlBox.PlaceholderText = "Eklenecek Oyuncu Adı..."
    WlBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 140)
    WlBox.Text = ""
    WlBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    WlBox.TextSize = 11
    WlBox.Font = Enum.Font.GothamMedium
    WlBox.Parent = Card

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = WlBox

    local AddBtn = Instance.new("TextButton")
    AddBtn.Size = UDim2.new(0.48, 0, 0, 28)
    AddBtn.Position = UDim2.new(0, 14, 0, 70)
    AddBtn.BackgroundColor3 = Color3.fromRGB(15, 55, 30)
    AddBtn.BorderSizePixel = 0
    AddBtn.Text = "Ekle"
    AddBtn.TextColor3 = Color3.fromRGB(90, 255, 150)
    AddBtn.TextSize = 10.5
    AddBtn.Font = Enum.Font.GothamBold
    AddBtn.Parent = Card

    local AddCorner = Instance.new("UICorner")
    AddCorner.CornerRadius = UDim.new(0, 6)
    AddCorner.Parent = AddBtn

    local RemoveBtn = Instance.new("TextButton")
    RemoveBtn.Size = UDim2.new(0.48, 0, 0, 28)
    RemoveBtn.Position = UDim2.new(0.52, -2, 0, 70)
    RemoveBtn.BackgroundColor3 = Color3.fromRGB(55, 15, 15)
    RemoveBtn.BorderSizePixel = 0
    RemoveBtn.Text = "Çıkar"
    RemoveBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    RemoveBtn.TextSize = 10.5
    RemoveBtn.Font = Enum.Font.GothamBold
    RemoveBtn.Parent = Card

    local RemCorner = Instance.new("UICorner")
    RemCorner.CornerRadius = UDim.new(0, 6)
    RemCorner.Parent = RemoveBtn

    AddBtn.MouseButton1Click:Connect(function()
        local name = WlBox.Text
        if name ~= "" then
            local found = false
            for _, v in ipairs(WhitelistPlayers) do if string.lower(v) == string.lower(name) then found = true end end
            if not found then
                table.insert(WhitelistPlayers, name)
                WlBox.Text = "Eklendi: " .. name
                print("[AstraOS Log] Whitelist'e Eklendi: " .. name)
                task.wait(1.5)
                WlBox.Text = ""
            else
                WlBox.Text = "Zaten listede var!"
                task.wait(1.5)
                WlBox.Text = ""
            end
        end
    end)

    RemoveBtn.MouseButton1Click:Connect(function()
        local name = WlBox.Text
        if name ~= "" then
            for i, v in ipairs(WhitelistPlayers) do
                if string.lower(v) == string.lower(name) then
                    table.remove(WhitelistPlayers, i)
                    WlBox.Text = "Çıkarıldı: " .. name
                    print("[AstraOS Log] Whitelist'ten Cikarildi: " .. name)
                    task.wait(1.5)
                    WlBox.Text = ""
                    return
                end
            end
            WlBox.Text = "Listede yok!"
            task.wait(1.5)
            WlBox.Text = ""
        end
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

createWhitelistPanel(settingsPage)
createUnloadPanel(settingsPage)

local rightMouseDown = false
local mobileAimToggled = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then rightMouseDown = true end
    if gameProcessed then return end
    if input.KeyCode == keybinds.MenuToggleKey then
        MainFrameLegit.Visible = not MainFrameLegit.Visible
        showActionNotification("Menü", MainFrameLegit.Visible)
        print("[AstraOS Log] Menü görünürlügü: " .. tostring(MainFrameLegit.Visible))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then rightMouseDown = false end
end)

ToggleMenuMobBtn.MouseButton1Click:Connect(function()
    MainFrameLegit.Visible = not MainFrameLegit.Visible
    showActionNotification("Menü", MainFrameLegit.Visible)
    print("[AstraOS Log] Mobil Menü Butonuna Basildi -> Görünürlük: " .. tostring(MainFrameLegit.Visible))
end)

AimMobBtn.MouseButton1Click:Connect(function()
    mobileAimToggled = not mobileAimToggled
    settingsLegit.LegitAim = mobileAimToggled
    showActionNotification("Legit Aim", settingsLegit.LegitAim)
    AimMobBtn.BackgroundColor3 = mobileAimToggled and Color3.fromRGB(15, 55, 30) or Color3.fromRGB(20, 25, 38)
    print("[AstraOS Log] Mobil Aim Butonuna Basildi -> Legit Aim: " .. tostring(settingsLegit.LegitAim))
end)

local function isVisible(targetPart)
    if not settingsLegit.WallCheck then return true end
    local camPos = Camera.CFrame.Position
    local direction = targetPart.Position - camPos
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    if LocalPlayer.Character then params.FilterDescendantsInstances = {LocalPlayer.Character, Camera} end
    params.IgnoreWater = true
    
    local result = workspace:Raycast(camPos, direction, params)
    if not result or result.Instance:IsDescendantOf(targetPart.Parent) then 
        return true 
    end
    return false
end

local function isValidTarget(player)
    if not player or player == LocalPlayer then return false end
    if isWhitelisted(player) then return false end
    if isTeamMember(player) then return false end
    return true
end

--------------------------------------------------------------------------------
-- OPTİMİZE DÖNGÜ (GELİŞTİRİLMİŞ AIMBOT VE VISUALS)
--------------------------------------------------------------------------------
RunService.RenderStepped:Connect(function(deltaTime)
    if not isScriptLoaded or not Camera then return end

    local viewportCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if settingsLegit.FOVEnabled and settingsLegit.LegitFOVVisible then
        fovCircleLegit.Visible = true
        fovCircleLegit.Radius = settingsLegit.FOVRadius
        fovCircleLegit.Position = viewportCenter
    else
        fovCircleLegit.Visible = false
    end

    -- Geliştirilmiş Aimbot Mantığı (Görüş Açısı + Mesafe Ağırlıklı Hedef Seçimi)
    if settingsLegit.LegitAim and (rightMouseDown or mobileAimToggled) then
        local bestTarget = nil
        local bestScore = math.huge

        for _, player in ipairs(Players:GetPlayers()) do
            if isValidTarget(player) and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local targetPart = player.Character:FindFirstChild(settingsLegit.HitboxTarget) or player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
                
                if targetPart and humanoid and humanoid.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                        
                        if mouseDist <= settingsLegit.FOVRadius then
                            if isVisible(targetPart) then
                                -- Hedef Skorlama: İmleç mesafesi ile dünya mesafesini harmanlayarak en uygun hedefi seçer
                                local worldDist = (Camera.CFrame.Position - targetPart.Position).Magnitude
                                local score = mouseDist + (worldDist * 0.1)
                                
                                if score < bestScore then
                                    bestScore = score
                                    bestTarget = targetPart
                                end
                            end
                        end
                    end
                end
            end
        end

        if bestTarget then
            local currentCF = Camera.CFrame
            local targetCF = CFrame.new(currentCF.Position, bestTarget.Position)
            
            local smoothValue = math.clamp(settingsLegit.Smoothness, 1, 30)
            if smoothValue == 1 then
                Camera.CFrame = targetCF
            else
                -- Dinamik Yumuşatma Mantığı
                local distanceFactor = math.clamp((Camera.CFrame.Position - bestTarget.Position).Magnitude / 100, 0.5, 2)
                local alpha = math.clamp((1 / (smoothValue * distanceFactor)) * (deltaTime * 60), 0.01, 1)
                Camera.CFrame = currentCF:Lerp(targetCF, alpha)
            end
        end
    end

    -- Chams (Highlight) Güncelleyici
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local isValid = isValidTarget(player)
            local highlight = player.Character:FindFirstChild("AstraChams")

            if settingsLegit.Chams and isValid then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "AstraChams"
                    highlight.FillColor = Color3.fromRGB(45, 100, 210)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = player.Character
                else
                    highlight.Enabled = true
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end

    -- ESP & Can Barı Güncelleyici
    for player, drawings in pairs(activeDrawings) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local isValid = isValidTarget(player)

        if hrp and humanoid and humanoid.Health > 0 and isValid then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local head = char:FindFirstChild("Head")
                if head then
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local rootPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    
                    local height = math.abs(headPos.Y - rootPos.Y)
                    local width = height / 2.2
                    local boxPosition = Vector2.new(vector.X - width / 2, headPos.Y)

                    if settingsLegit.ESPBox then
                        drawings.Box.Size = Vector2.new(width, height)
                        drawings.Box.Position = boxPosition
                        drawings.Box.Visible = true
                    else drawings.Box.Visible = false end

                    if settingsLegit.NameESP then
                        drawings.Name.Text = player.Name
                        drawings.Name.Position = Vector2.new(boxPosition.X + (width / 2), boxPosition.Y - 16)
                        drawings.Name.Visible = true
                    else drawings.Name.Visible = false end

                    if settingsLegit.DistanceESP and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                        drawings.Dist.Text = "[" .. tostring(dist) .. "m]"
                        drawings.Dist.Position = Vector2.new(boxPosition.X + (width / 2), boxPosition.Y + height + 2)
                        drawings.Dist.Visible = true
                    else drawings.Dist.Visible = false end

                    if settingsLegit.HealthBar then
                        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        local barHeight = height * healthPercent
                        
                        drawings.HealthBarOutline.Size = Vector2.new(4, height + 2)
                        drawings.HealthBarOutline.Position = Vector2.new(boxPosition.X - 7, boxPosition.Y - 1)
                        drawings.HealthBarOutline.Visible = true

                        drawings.HealthBar.Size = Vector2.new(2, barHeight)
                        drawings.HealthBar.Position = Vector2.new(boxPosition.X - 6, boxPosition.Y + (height - barHeight))
                        drawings.HealthBar.Color = Color3.fromRGB(255 - (healthPercent * 255), healthPercent * 255, 0)
                        drawings.HealthBar.Visible = true
                    else
                        drawings.HealthBar.Visible = false
                        drawings.HealthBarOutline.Visible = false
                    end
                else
                    drawings.Box.Visible = false; drawings.Name.Visible = false; drawings.Dist.Visible = false; drawings.HealthBar.Visible = false; drawings.HealthBarOutline.Visible = false
                end
            else
                drawings.Box.Visible = false; drawings.Name.Visible = false; drawings.Dist.Visible = false; drawings.HealthBar.Visible = false; drawings.HealthBarOutline.Visible = false
            end
        else
            drawings.Box.Visible = false; drawings.Name.Visible = false; drawings.Dist.Visible = false; drawings.HealthBar.Visible = false; drawings.HealthBarOutline.Visible = false
        end
    end

    -- Tracers Güncelleyici
    for player, line in pairs(activeTracers) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local isValid = isValidTarget(player)

        if settingsLegit.Tracers and hrp and humanoid and humanoid.Health > 0 and isValid then
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                line.To = Vector2.new(screenPos.X, screenPos.Y)
                line.Visible = true
            else line.Visible = false end
        else line.Visible = false end
    end

    -- Skeleton Güncelleyici
    for player, bones in pairs(activeSkeletons) do
        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local isValid = isValidTarget(player)

        if settingsLegit.Skeleton and humanoid and humanoid.Health > 0 and isValid then
            local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
            local limbPairs = {}

            if isR15 then
                limbPairs = {
                    {char:FindFirstChild("Head"), char:FindFirstChild("UpperTorso")},
                    {char:FindFirstChild("UpperTorso"), char:FindFirstChild("LowerTorso")},
                    {char:FindFirstChild("UpperTorso"), char:FindFirstChild("LeftUpperArm")},
                    {char:FindFirstChild("LeftUpperArm"), char:FindFirstChild("LeftLowerArm")},
                    {char:FindFirstChild("LeftLowerArm"), char:FindFirstChild("LeftHand")},
                    {char:FindFirstChild("UpperTorso"), char:FindFirstChild("RightUpperArm")},
                    {char:FindFirstChild("RightUpperArm"), char:FindFirstChild("RightLowerArm")},
                    {char:FindFirstChild("RightLowerArm"), char:FindFirstChild("RightHand")},
                    {char:FindFirstChild("LowerTorso"), char:FindFirstChild("LeftUpperLeg")},
                    {char:FindFirstChild("LeftUpperLeg"), char:FindFirstChild("LeftLowerLeg")},
                    {char:FindFirstChild("LeftLowerLeg"), char:FindFirstChild("LeftFoot")},
                    {char:FindFirstChild("LowerTorso"), char:FindFirstChild("RightUpperLeg")},
                    {char:FindFirstChild("RightUpperLeg"), char:FindFirstChild("RightLowerLeg")},
                    {char:FindFirstChild("RightLowerLeg"), char:FindFirstChild("RightFoot")}
                }
            else
                local torso = char:FindFirstChild("Torso")
                limbPairs = {
                    {char:FindFirstChild("Head"), torso},
                    {torso, char:FindFirstChild("Left Arm")},
                    {torso, char:FindFirstChild("Right Arm")},
                    {torso, char:FindFirstChild("Left Leg")},
                    {torso, char:FindFirstChild("Right Leg")}
                }
            end

            for i = 1, #bones do
                local boneLine = bones[i]
                local pair = limbPairs[i]
                if pair and pair[1] and pair[2] and boneLine then
                    local posA, onA = Camera:WorldToViewportPoint(pair[1].Position)
                    local posB, onB = Camera:WorldToViewportPoint(pair[2].Position)
                    if onA or onB then
                        boneLine.From = Vector2.new(posA.X, posA.Y)
                        boneLine.To = Vector2.new(posB.X, posB.Y)
                        boneLine.Visible = true
                    else boneLine.Visible = false end
                else
                    if boneLine then boneLine.Visible = false end
                end
            end
        else
            for _, boneLine in ipairs(bones) do boneLine.Visible = false end
        end
    end
end)

print("[AstraOS System] AstraOS Rivals Pro Suite başarıyla yüklendi! Konsol logları aktif.")
