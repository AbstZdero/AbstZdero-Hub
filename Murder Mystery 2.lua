--// Target PlaceId
local TARGET_PLACE_ID = 16039690331

--// Check if we're in the correct game
if game.PlaceId == TARGET_PLACE_ID then
 
--// Wizard UI Library
local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// Window
local Window = Library:NewWindow("AbstZdero Hub")
local MainTab = Window:NewSection("Main")
local ESPSection = Window:NewSection("ESP Toggles")

--// Toggle states
local MurdererESP = false
local SheriffESP = false
local InnocentESP = false
local NameESP = false

--// Item Check
local function itemCheck(player, itemName)
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name == itemName then return true end
    end
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name == itemName then
                return true
            end
        end
    end
    return false
end

--// HIGHLIGHT ESP
local function updateHighlight(player)
    if player == LocalPlayer then return end
    if not player.Character then return end

    local hasMurderer = itemCheck(player, "Knife)
    local hasGun = itemCheck(player, "Gun")
    local innocent = not hasMonster and not hasGun

    local highlight = player.Character:FindFirstChild("ESPHighlight")

    local enable =
        (MurdererESP and hasMurderer) or
        (SheriffESP and hasGun) or
        (InnocentESP and innocent)

    if enable then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.Adornee = player.Character
            highlight.Parent = player.Character
        end

        if hasMurderer and Murdereresp then
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
        elseif hasGun and SheriffESP then
            highlight.FillColor = Color3.fromRGB(0, 0, 255)
        elseif innocent and InnocentESP then
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
        end
    else
        if highlight then highlight:Destroy() end
    end
end

--// NAME ESP
local function updateNameESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end

    local head = player.Character:FindFirstChild("Head")
    if not head then return end

    local gui = head:FindFirstChild("NameESP")

    if not NameESP then
        if gui then gui:Destroy() end
        return
    end

    if not gui then
        gui = Instance.new("BillboardGui")
        gui.Name = "NameESP"
        gui.Size = UDim2.new(0, 200, 0, 40)
        gui.StudsOffset = Vector3.new(0, 2.5, 0)
        gui.AlwaysOnTop = true
        gui.Parent = head

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 0.5, 0)
        txt.BackgroundTransparency = 1
        txt.TextScaled = true
        txt.Font = Enum.Font.SourceSansBold
        txt.Parent = gui
    end

    local text = gui:FindFirstChildOfClass("TextLabel")
    text.Text = player.Name

    local hasMonster = itemCheck(player, "Knife")
    local hasGun = itemCheck(player, "Gun")

    if hasMurderer then
        text.TextColor3 = Color3.fromRGB(255, 0, 0)
    elseif hasGun then
        text.TextColor3 = Color3.fromRGB(0, 0, 255)
    else
        text.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
end

--// Highlight loop
task.spawn(function()
    while true do
        for _, plr in pairs(Players:GetPlayers()) do
            pcall(updateHighlight, plr)
        end
        task.wait(0.2)
    end
end)

--// Name ESP loop
task.spawn(function()
    while true do
        if NameESP then
            for _, plr in pairs(Players:GetPlayers()) do
                pcall(updateNameESP, plr)
            end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("Head") then
                    local gui = plr.Character.Head:FindFirstChild("NameESP")
                    if gui then gui:Destroy() end
                end
            end
        end
        wait(0.2)
    end
end)

--// Player support
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        updateHighlight(player)
        updateNameESP(player)
    end)
end)

--// UI Toggles
ESPSection:CreateToggle("Murderer ESP", function(v) MurdererESP = v end)
ESPSection:CreateToggle("Sheriff ESP", function(v) SheriffESP = v end)
ESPSection:CreateToggle("Innocent ESP", function(v) InnocentESP = v end)
ESPSection:CreateToggle("Name ESP", function(v) NameESP = v end)
