-- Use the automate() function to auto-execute the script on Roblox app launch
automate()

-- Function to check if the player is fully loaded in the game
local function isPlayerInGame()
    return game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- Function to execute the main script after rejoining
local function executeAfterRejoin()
    -- Wait until the player is fully loaded into the game
    while not isPlayerInGame() do
        wait(1)
    end
    
    -- Now that the player is fully loaded, execute the main script
    -- Load Infinite Yield manually (run this part first in the console, outside the script)
    -- loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Infinite%20Yield.txt"))()

    -- Main Script Logic (The part you originally wanted to run after rejoin)
    -- Add any logic here for your custom script (such as interacting with chests, GUI creation, etc.)

    -- Function to create and show the GUI with text
    local function createAndShowGUI()
        -- Create a ScreenGui
        local screenGui = Instance.new("ScreenGui")
        screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        print("ScreenGui Created")

        -- Create a TextLabel to display the message multiple times
        for i = 0, 10 do  -- Repeat 10 times
            local textLabel = Instance.new("TextLabel")
            textLabel.Text = "Gabe is so BOAAAA"  -- The text you want to show
            textLabel.Size = UDim2.new(1, 0, 0.1, 0)  -- Full width, small height
            textLabel.Position = UDim2.new(0, 0, 0.1 * i, 0)  -- Position it lower with each loop
            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Red text
            textLabel.TextSize = 50  -- Large text size
            textLabel.BackgroundTransparency = 1  -- Transparent background
            textLabel.TextStrokeTransparency = 0.5  -- Slight stroke for readability
            textLabel.Font = Enum.Font.SourceSansBold  -- Bold font
            textLabel.Parent = screenGui
            print("TextLabel Created")
        end

        -- Wait for 3 seconds before removing the GUI
        wait(3)
        screenGui:Destroy()
        print("ScreenGui Destroyed")
    end

    -- Create the GUI when the script is executed
    createAndShowGUI()

    -- Function to play the sound at regular intervals
    local function playSoundContinuously()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://2820356263"
        sound.Parent = game.Workspace
        sound.Looped = true
        sound.Volume = 10  -- Adjust the volume as needed
        sound:Play()  -- Play immediately

        -- Play the sound continuously every 5 seconds
        while true do
            if not sound.IsPlaying then
                sound:Play()  -- Play the sound if it stopped
            end
            wait(5)  -- Wait for 5 seconds before playing again
        end
    end

    -- Call the sound-playing function in a separate thread
    spawn(playSoundContinuously)

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
end

-- Wait for rejoin and then execute
executeAfterRejoin()
