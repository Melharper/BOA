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

-- Auto-execute script when rejoining
game:GetService("Players").PlayerAdded:Connect(function(player)
    if player == game.Players.LocalPlayer then
        -- Add a 10-second delay to ensure the game has fully loaded
        print("Rejoined the game, waiting for game to load...")

        wait(10)  -- Wait for 10 seconds

        print("Game loaded, running the script...")

        -- Check if auto-execution is enabled
        if isAutoExecuteEnabled then
            print("Auto Execute is enabled, executing the script...")
            -- Load and execute the original script from GitHub
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Melharper/BOA/main/BOAGabey.lua"))()
        else
            print("Auto Execute is disabled.")
        end
    end
end)
