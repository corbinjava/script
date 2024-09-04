-- Load the Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Create a Window
local Window = OrionLib:MakeWindow({
    Name = "Old a bizzare day",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OldBizzareDay"
})

-- Variable to track the running status of autofarm
local autofarmRunning = false

-- Function to teleport to the "Handle" of an item
local function teleportToItem(itemName)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    -- Search for the item in the Workspace
    local item = workspace:FindFirstChild(itemName)

    if item and item:FindFirstChild("Handle") then
        local handle = item.Handle

        -- Teleport the player's HumanoidRootPart to the Handle's position
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = handle.CFrame
        end
    end
end

-- Function to start the autofarm loop
local function startAutofarm(itemsToScan)
    if not autofarmRunning then
        autofarmRunning = true
        spawn(function()
            while autofarmRunning do
                if #itemsToScan > 0 then
                    for _, itemName in pairs(itemsToScan) do
                        teleportToItem(itemName)
                    end
                else
                    -- Stop the autofarm loop if no items are enabled
                    autofarmRunning = false
                end
                wait(1) -- Adjust this delay for how often it scans the map for items
            end
        end)
    end
end

-- Create the Autofarm Tab
local AutofarmTab = Window:MakeTab({
    Name = "Autofarm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Autofarm Sections
local AutofarmSection = AutofarmTab:AddSection({
    Name = "Autofarm Options"
})

-- Autofarm Toggles
local activeItems = {} -- List to store active items for scanning

-- Create Toggles for each item
local function addItemToggle(itemName)
    AutofarmSection:AddToggle({
        Name = itemName,
        Default = false,
        Callback = function(Value)
            if Value then
                table.insert(activeItems, itemName) -- Add to active items
                if #activeItems == 1 then
                    startAutofarm(activeItems) -- Start scanning if it's the first item
                end
            else
                -- Remove the item from activeItems when disabled
                for i = #activeItems, 1, -1 do
                    if activeItems[i] == itemName then
                        table.remove(activeItems, i)
                    end
                end
                -- Stop autofarming if no active items are left
                if #activeItems == 0 then
                    autofarmRunning = false
                end
            end
        end
    })
end

-- Create Toggle for ALL
AutofarmSection:AddToggle({
    Name = "ALL",
    Default = false,
    Callback = function(Value)
        local allItems = {
            "Stand Arrow", "Rokakaka Fruit", "Banknote", "Trowel", "Frog",
            "Requiem Arrow", "Vampire Mask", "DIO's Diary", "Camera", 
            "Shadow Camera", "Holy Corpse", "Monochromatic Sphere", 
            "Ender Pearl", "Water", "DIO's Soul", "Dio Brando's Soul", 
            "Vamparic Minion's Soul"
        }
        
        if Value then
            activeItems = allItems -- Set active items to all items
            startAutofarm(activeItems)
        else
            activeItems = {} -- Clear the active items list
            autofarmRunning = false -- Stop the autofarm loop
        end
    end
})

-- Add individual item toggles
addItemToggle("Stand Arrow")
addItemToggle("Rokakaka Fruit")
addItemToggle("Banknote")
addItemToggle("Trowel")
addItemToggle("Frog")
addItemToggle("Requiem Arrow")
addItemToggle("Vampire Mask")
addItemToggle("DIO's Diary")
addItemToggle("Camera")
addItemToggle("Shadow Camera")
addItemToggle("Holy Corpse")
addItemToggle("Monochromatic Sphere")
addItemToggle("Ender Pearl")
addItemToggle("Water")
addItemToggle("DIO's Soul")
addItemToggle("Dio Brando's Soul")
addItemToggle("Vamparic Minion's Soul")

-- Create the Movement Tab
local MovementTab = Window:MakeTab({
    Name = "Movement",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Fly Section
local FlySection = MovementTab:AddSection({
    Name = "Fly Options"
})

-- Teleport Section
local TeleportSection = MovementTab:AddSection({
    Name = "Teleport Options"
})

-- Variables to track Fly state
local flyEnabled = false
local flyToggleEnabled = false -- Determines if the keybind should work
local flySpeed = 50 -- Default flight speed
local previousCameraMode = nil -- To store the player's camera mode before flight

-- Function to handle flying movement
local function fly()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")

    -- Save the current camera mode and enable shiftlock
    previousCameraMode = player.DevEnableMouseLock
    player.DevEnableMouseLock = true

    -- Create BodyGyro and BodyVelocity for smooth movement
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
    bodyVelocity.Parent = rootPart

    -- Fly loop (controlled by movement keys)
    while flyEnabled do
        local moveDirection = Vector3.new(0, 0, 0)
        local userInput = game:GetService("UserInputService")

        -- Adjust movement based on player input
        if userInput:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if userInput:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end

        bodyVelocity.Velocity = moveDirection * flySpeed
        wait(0.1)
    end

    -- Cleanup when fly is disabled and restore camera mode
    bodyGyro:Destroy()
    bodyVelocity:Destroy()
    player.DevEnableMouseLock = previousCameraMode
end

-- Function to handle Fly toggle in the menu
local function handleFlyToggle(isEnabled)
    flyToggleEnabled = isEnabled -- Set whether keybind should work
end

-- Function to handle keybind-based fly toggle
local function toggleFly()
    if flyToggleEnabled then -- Check if Fly toggle in the menu is enabled
        flyEnabled = not flyEnabled -- Toggle the fly state

        if flyEnabled then
            fly() -- Start flying
        else
            -- Stop flying
        end
    end
end

-- Fly Toggle (GUI only tells if keybind should work)
FlySection:AddToggle({
    Name = "Enable Fly Keybind",
    Default = false,
    Callback = function(Value)
        handleFlyToggle(Value) -- Tell the script whether to allow the keybind to work
    end
})

-- Fly Keybind (only works if Fly toggle in GUI is enabled)
FlySection:AddBind({
    Name = "Fly Keybind",
    Default = Enum.KeyCode.F, -- Set your preferred key
    Hold = false,
    Callback = function()
        toggleFly() -- Toggle fly mode via keybind
    end
})

-- Flight Speed Slider (1-10) - placed below Fly Keybind, colored blue
FlySection:AddSlider({
    Name = "Flight Speed",
    Min = 1,
    Max = 10,
    Default = 5,
    Color = Color3.fromRGB(0, 0, 255), -- Blue color
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        flySpeed = value * 10 -- Set fly speed (multiply for more noticeable effect)
    end
})

-- Click TP Toggle
TeleportSection:AddToggle({
    Name = "Click TP",
    Default = false,
    Callback = function(Value)
        clickTpEnabled = Value
        if Value then
            local player = game.Players.LocalPlayer
            local mouse = player:GetMouse()

            mouse.Button1Down:Connect(function()
                if clickTpEnabled then
                    -- Teleport player to mouse position when clicked
                    local character = player.Character or player.CharacterAdded:Wait()
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0)) -- Teleport slightly above the click
                    end
                end
            end)
        end
    end
})

-- Add Dropdown for Teleporting to Players
local playerDropdown = TeleportSection:AddDropdown({
    Name = "Teleport to Player",
    Options = {}, -- Empty initially, we'll populate it later
    Callback = function(selectedPlayerName)
        local player = game.Players:FindFirstChild(selectedPlayerName)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
        end
    end
})

-- Populate the player dropdown dynamically
local function updatePlayerDropdown()
    local playerList = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        table.insert(playerList, player.Name)
    end
    playerDropdown:Refresh(playerList, true) -- Refresh the dropdown options with the current players
end

-- Continuously update the dropdown with current players
spawn(function()
    while true do
        updatePlayerDropdown()
        wait(5) -- Update every 5 seconds
    end
end)

-- Create the Misc Tab
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Teleport Options Section in Misc
local TeleportMiscSection = MiscTab:AddSection({
    Name = "Teleport Options"
})

-- Other Options Section in Misc
local OtherOptionsSection = MiscTab:AddSection({
    Name = "Other Options"
})

-- Create a Textbox for Coordinates
TeleportMiscSection:AddTextbox({
    Name = "Enter Coordinates (X, Y, Z)",
    Default = "",
    TextDisappear = true,
    Callback = function(coords)
        -- Split the input coordinates by commas
        local splitCoords = {}
        for coord in string.gmatch(coords, "[^,]+") do
            table.insert(splitCoords, tonumber(coord)) -- Convert to numbers
        end

        -- Check if there are 3 coordinates provided (X, Y, Z)
        if #splitCoords == 3 then
            local x, y, z = splitCoords[1], splitCoords[2], splitCoords[3]

            -- Teleport player to the given coordinates
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
            end
        end
    end
})

-- Add a Self Destruct Button in Misc Tab
OtherOptionsSection:AddButton({
    Name = "Self Destruct",
    Callback = function()
        OrionLib:Destroy() -- Destroys the entire GUI
    end
})

-- Initialize the Orion Interface
OrionLib:Init()
