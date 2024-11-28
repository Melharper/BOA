-- Define a flag to enable/disable the script
local isAutoExecuteEnabled = true  -- Set this to true by default

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
        print("Auto Execute Enabled: ", isAutoExecuteEnabled)  -- Debug line
        if isAutoExecuteEnabled then
            showStatusMessage("Gabe Boa Enabled")
        else
            showStatusMessage("Gabe Boa Disabled")
        end
    end
end)

-- Ensure that the script stops execution if auto-execution is disabled
local function checkIfExecutionEnabled()
    if not isAutoExecuteEnabled then
        print("Auto-execution is disabled. Halting script execution.")
        return false  -- If disabled, halt further execution
    end
    return true  -- If enabled, continue execution
end

-- Function to select and spawn Invisible Woman character (only once)
local function selectAndSpawnCharacter()
    -- Stop execution if auto-execution is disabled
    if not checkIfExecutionEnabled() then return end

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

-- Add more checks in other parts of the script where execution should be conditional on the flag.

-- For example, before the main loop runs, check if the flag allows execution:
while true do
    -- If auto-execution is disabled, stop the loop
    if not checkIfExecutionEnabled() then
        print("Auto-execution is disabled. Exiting main loop.")
        break
    end
    
    -- Continue with your logic if enabled
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

-- Function to toggle auto-execution when 'P' is pressed
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        isAutoExecuteEnabled = not isAutoExecuteEnabled  -- Toggle the state
        print("Auto Execute Enabled: ", isAutoExecuteEnabled)
        if isAutoExecuteEnabled then
            showStatusMessage("Gabe Boa Enabled")
        else
            showStatusMessage("Gabe Boa Disabled")
        end
    end
end)
