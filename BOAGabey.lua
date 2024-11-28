-- Define a flag to enable/disable the script
local isAutoExecuteEnabled = true

-- Function to display the status message (enabled/disabled)
local function showStatusMessage(status)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = status
    textLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
    textLabel.Position = UDim2.new(0.25, 0, 0.45, 0)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.BackgroundTransparency = 1
    textLabel.TextSize = 30
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Parent = screenGui

    -- Remove the message after 2 seconds
    wait(2)
    screenGui:Destroy()
end

-- Function to toggle auto-execution when 'P' is pressed
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        isAutoExecuteEnabled = not isAutoExecuteEnabled  -- Toggle the state
        if isAutoExecuteEnabled then
            showStatusMessage("Gabe BOA Enabled")
        else
            showStatusMessage("Auto Execute Disabled")
        end
    end
end)

-- Function to select and spawn Invisible Woman character (only once)
local function selectAndSpawnCharacter()
    print("[INFO] Attempting to select and spawn Invisible Woman...")

    local args = {
        [1] = "RequestCharacter",
        [2] = "InvisibleWoman",
        [3] = "Default"
    }

    -- Directly call the RemoteFunction to spawn Invisible Woman
    local success, result = pcall(function()
        return game:GetService("ReplicatedStorage"):WaitForChild("ClientModules"):WaitForChild("Network"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
    end)

    if success then
        print("[INFO] Invisible Woman character selected and deployed!")
    else
        print("[ERROR] Failed to select character: " .. tostring(result))
    end
end

-- Get necessary services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Function to teleport to the chest (only when a chest is found)
local function teleportToChest()
    local chest = Workspace:FindFirstChild("Chest")
    if chest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = chest.Body.CFrame
        print("[INFO] Teleported to chest.")
    end
end

-- Function to interact with the chest (hold 'E' for 5 seconds)
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

-- Function to rejoin the server after chest collection
local function rejoinServer()
    print("[INFO] No chest found. Attempting to rejoin...")

    -- Kick the player to mimic Infinite Yield's behavior
    LocalPlayer:Kick("Rejoining...")

    -- Wait for a moment to allow the kick message to appear
    wait(2)

    -- Use TeleportService to reconnect as a fallback
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end

-- Spawn the character only once before the main loop
selectAndSpawnCharacter()

-- Main loop to check and interact with chests
while true do
    local chest = Workspace:FindFirstChild("Chest")

    if chest then
        teleportToChest()
        wait(1) -- Allow time for teleport
        interactWithChest()
    else
        print("[INFO] Chest not found. Rejoining...")
        rejoinServer()  -- Rejoin the server if the chest is not found
        wait(2)  -- Allow rejoin time before checking again
    end

    -- Check every second for a new chest after rejoining
    wait(1)
end
