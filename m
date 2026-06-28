
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local KnifeHit = ReplicatedStorage:WaitForChild("Knife"):WaitForChild("Remotes"):WaitForChild("KnifeHit")

-- Function to find the nearest alive player
local function getNearestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge -- Start with infinity

    local myCharacter = LocalPlayer.Character
    if not myCharacter then return nil end
    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        -- Ensure we aren't targeting ourselves
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                
                -- Check if the player is alive and has a root part
                if root and humanoid and humanoid.Health > 0 then
                    local distance = (myRoot.Position - root.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        -- Target a reliable part like the HumanoidRootPart or Torso
                        closestPlayer = root 
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Example execution trigger
-- You can bind this to your throw action or keybind
local function targetNearest()
    local targetPart = getNearestPlayer()
    
    if targetPart then
        local args = {
            "throw",
            targetPart
        }
        KnifeHit:FireServer(unpack(args))
    else
        print("No valid target found nearby.")
    end
end

-- Call the function
targetNearest()
