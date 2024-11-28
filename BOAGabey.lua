-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- State to control auto farming
local isFarmingEnabled = true

-- Function to display status message
local function displayStatusMessage(message, color)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = message
    textLabel.Size = UDim2.new(1, 0, 0.1, 0)  -- Full width, small height
    textLabel.Position = UDim2.new(0, 0, 0.4, 0)  -- Center vertically
    textLabel.TextColor3 = color  -- Custom color
    textLabel.TextSize = 50
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = screenGui

    -- Destroy after 3 seconds
    wait(3)
    screenGui:Destroy()
end

-- Function to teleport to chest
local function teleportToChest()
    local chest = Workspace:FindFirstChild("Chest")
    if chest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = chest.Body.CFrame
        print("[INFO] Teleported to chest.")
    end
end

-- Function to interact with chest
local function interactWithChest()
    local chest = Workspace:FindFirstChild("Chest")
    if chest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local chestPos = chest.Body.CFrame.Position
        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position

        if (chestPos - playerPos).Magnitude <= 10 then
            -- Hold 'E' for 5 seconds
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
            wait(5)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
            print("[INFO] Attempted to claim the chest.")
        else
            print("[INFO] Too far from the chest.")
        end
    end
end

-- Function to rejoin server
local function rejoinServer()
    print("[INFO] No chest found. Attempting to rejoin...")
    LocalPlayer:Kick("Rejoining...")
    wait(2)
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end

-- Function to handle auto farming
local function autoFarm()
    while isFarmingEnabled do
        local chest = Workspace:FindFirstChild("Chest")

        if chest then
            teleportToChest()
            wait(1)  -- Allow time for teleport
            interactWithChest()
        else
            print("[INFO] Chest not found. Rejoining...")
            rejoinServer()
            wait(2)
        end

        -- Check every second for a new chest
        wait(1)
    end
end

-- Keybind to toggle auto farming
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.P then
        isFarmingEnabled = not isFarmingEnabled
        if isFarmingEnabled then
            displayStatusMessage("Gabe Boa Enabled", Color3.fromRGB(128, 0, 128))  -- Purple
            spawn(autoFarm)  -- Restart auto farming
        else
            displayStatusMessage("Gabe Boa Disabled", Color3.fromRGB(255, 0, 0))  -- Red
        end
    end
end)

-- Wait 10 seconds after rejoining
game:GetService("Players").PlayerAdded:Connect(function(player)
    if player == LocalPlayer then
        print("Rejoined the game, waiting for game to load...")
        wait(10)
        print("Game loaded, running the script...")
        if isFarmingEnabled then
            spawn(autoFarm)
        end
    end
end)

-- Initial farming start
spawn(autoFarm)
