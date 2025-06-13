-- Script de Delta para herramientas de teletransporte y retroceso
-- Personaliza los nombres de las herramientas y las coordenadas fijas.

local TOOL_NAME_TELEPORT_1 = "Expansion de dominio 1" -- Nombre para la primera herramienta de teletransporte
local TELEPORT_COORDS_1 = Vector3.new(-66, 36, 20334) -- Coordenadas para la herramienta 1

local TOOL_NAME_TELEPORT_2 = "expansion de dominio 2" -- Nombre para la segunda herramienta de teletransporte
local TELEPORT_COORDS_2 = Vector3.new(1056, 147, 23007) -- Coordenadas para la herramienta 2

local TOOL_NAME_TELEPORT_VOID = "Teletransporte al Vacío" -- Nombre para la herramienta de teletransporte al vacío
local TELEPORT_COORDS_VOID = Vector3.new(0, -5000, 0) -- <--- ¡COORDENADAS PARA EL VACÍO! Puedes ajustarlas si el vacío de tu juego es más bajo o en otro lugar.

local TOOL_NAME_REWIND = "Retroceso Temporal" -- Nombre para la herramienta de retroceso

-- NO EDITAR NADA DE AQUÍ EN ADELANTE SI NO SABES LO QUE HACES

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local lastPosition = nil
local lastPositionTime = 0

local function createTool(name)
    local tool = Instance.new("Tool")
    tool.Name = name
    tool.RequiresHandle = false
    tool.Parent = LocalPlayer.Backpack
    return tool
end

-- Crear las herramientas
local teleportTool1 = createTool(TOOL_NAME_TELEPORT_1)
local teleportTool2 = createTool(TOOL_NAME_TELEPORT_2)
local teleportVoidTool = createTool(TOOL_NAME_TELEPORT_VOID) -- Nueva herramienta para el vacío
local rewindTool = createTool(TOOL_NAME_REWIND)

-- Función para teletransportar
local function teleport(coordinates)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(coordinates)
        print("Teletransportado a:", coordinates)
    else
        warn("No se pudo teletransportar: No se encontró HumanoidRootPart.")
    end
end

-- Eventos para las herramientas de teletransporte (con coordenadas fijas)
teleportTool1.Activated:Connect(function()
    teleport(TELEPORT_COORDS_1)
end)

teleportTool2.Activated:Connect(function()
    teleport(TELEPORT_COORDS_2)
end)

-- Evento para la nueva herramienta de teletransporte al vacío
teleportVoidTool.Activated:Connect(function()
    teleport(TELEPORT_COORDS_VOID)
end)

-- Actualizar la última posición cada 5 segundos
RunService.Stepped:Connect(function(time)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if time - lastPositionTime >= 5 then
            lastPosition = LocalPlayer.Character.HumanoidRootPart.Position
            lastPositionTime = time
        end
    end
end)

-- Evento para la herramienta de retroceso
rewindTool.Activated:Connect(function()
    if lastPosition then
        teleport(lastPosition)
        print("Se ha retrocedido a la posición de hace 5 segundos.")
    else
        warn("No hay una posición anterior para retroceder (espera 5 segundos).")
    end
end)
