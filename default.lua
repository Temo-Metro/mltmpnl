----------------------------------------// Variables \\----------------------------------------
--// Tempanel Scales
local LowScale = UDim2.new(0.32, 0, 0.448, 0)
local NormalScale = UDim2.new(0.414, 0, 0.58, 0)
local LastScale = NormalScale

--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")
local LightingService = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUserService = game:GetService("VirtualUser")

--// Local player
local LocalPlayer = Players.LocalPlayer
local PlayerGui : PlayerGui = LocalPlayer.PlayerGui
local PlayerIsMobile = false

UserInputService.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.Touch then
		PlayerIsMobile = true
	end
end)

--// Prevention
if PlayerGui:FindFirstChild("Tempanel") then
	return warn("Tempanel is already running.")
end

--// Leaderstats
local leaderstats = LocalPlayer.leaderstats
local StrengthVal : NumberValue = leaderstats:WaitForChild("Strength")
local RebirthVal: NumberValue = leaderstats:WaitForChild("Rebirths")

--// Game
local GameId = game.PlaceId
local JobId = game.JobId

--// Types
type Props = {
    UIType: string,
    Parent : Instance,
    Name : string,
    AnchorPoint : Vector2,
    Size : UDim2,
    Position: UDim2,
    Interactable : boolean,
    ClipsDescendants : boolean,
    IsDraggable : boolean,
    BackgroundColor3 : Color3,
    BackgroundTransparency : number,
    Corner : UDim?,
    Text : string?,
    TextScaled : boolean?,
    TextColor3 : Color3?,
    PlaceholderText : string?,
    PlaceHolderTextColor3 : Color3?,
    Font : Enum.Font?
}
type UIStrokeProps = {
    ApplyStrokeMode: Enum.ApplyStrokeMode,
    StrokeSizingMode : Enum.StrokeSizingMode,
    Color : Color3,
    Thickness : number,
    Transparency : number
}

--// Required Events
local MuscleEvent = LocalPlayer.muscleEvent
local EquipPetEvent = ReplicatedStorage.rEvents.equipPetEvent
local UltimatesRemote = ReplicatedStorage.rEvents.ultimatesRemote
local RebirthRemote = ReplicatedStorage.rEvents.rebirthRemote
local CodeRemote = ReplicatedStorage.rEvents.codeRemote
local CheckChestRemote = ReplicatedStorage.rEvents.checkChestRemote
local GroupRemote = ReplicatedStorage.rEvents.groupRemote

--// Event Args
local PunchArg = "punch"
local PunchArgR = "rightHand"
local PunchArgL = "leftHand"

local EquipArg = "equipPet"
local UnequipArg = "unequipPet"

local RebirthArg = "rebirthRequest"

local UltimatesArg = "upgradeUltimate"
local RepSpeedArg = "+5% Rep Speed"
local PetSlotArg = "+1 Pet Slot"
local ItemCapacityArg = "+10 Item Capacity"
local DailySpinArg = "+1 Daily Spin"
local ChestRewardsArg = "x2 Chest Rewards"

--// Last Punch
local LastPunch

--// Areas
local Beach = CFrame.new(2.9506104, 7.95357132, 139.510971, 0.999995828, -5.72376599e-08, 0.00287873251, 5.71228291e-08, 1, 3.99710309e-08, -0.00287873251, -3.9806423e-08, 0.999995828)

local DurabilityRocks = {
	[10] = {
		DurReq = 0,
		HRPCFrame = CFrame.new(27.8591347, 8.43312359, 2100.1377, -0.652764857, 2.24802199e-09, 0.757560611, 9.56121671e-09, 1, 5.27113464e-09, -0.757560611, 1.06840119e-08, -0.652764857)
	},
	[9] = {
		DurReq = 10, 
		HRPCFrame = CFrame.new(-166.35611, 7.90356207, 422.852081, -0.00645942101, 1.14102852e-08, -0.999979138, -5.67331604e-08, 1, 1.17769936e-08, 0.999979138, 5.6808048e-08, -0.00645942101)
	},
	[8] = {
		DurReq = 100,
		HRPCFrame = CFrame.new(154.936569, 3.95177746, -146.691879, 0.414772689, -1.31992506e-09, -0.909925044, -4.63733318e-09, 1, -3.56443008e-09, 0.909925044, 5.69805403e-09, 0.414772689)
	},
	[7] = {
		DurReq = 5000,
		HRPCFrame = CFrame.new(282.36557, 9.00846195, -599.420959, -0.211444214, 1.84850411e-08, -0.977390051, 1.97662331e-09, 1, 1.84850411e-08, 0.977390051, 1.97662331e-09, -0.211444214)
	},
	[6] ={
		DurReq = 150000,
		HRPCFrame = CFrame.new(40.2047043, -444.826294, 882.583862, 0.027385978, 0.742171943, -0.66964978, -0.99962306, 0.0216578227, -0.0168772116, 0.00197736197, 0.669859529, 0.742485225)
	},
	[5] = {
		DurReq = 400000,
		HRPCFrame = CFrame.new(40.2047043, -444.826294, 882.583862, 0.027385978, 0.742171943, -0.66964978, -0.99962306, 0.0216578227, -0.0168772116, 0.00197736197, 0.669859529, 0.742485225)
	},
	[4] = {
		DurReq = 750000,
		HRPCFrame = CFrame.new(40.2047043, -444.826294, 882.583862, 0.027385978, 0.742171943, -0.66964978, -0.99962306, 0.0216578227, -0.0168772116, 0.00197736197, 0.669859529, 0.742485225)
	},
	[3] = {
		DurReq = 1000000,
		HRPCFrame = CFrame.new(40.2047043, -444.826294, 882.583862, 0.027385978, 0.742171943, -0.66964978, -0.99962306, 0.0216578227, -0.0168772116, 0.00197736197, 0.669859529, 0.742485225)
	},
	[2] = {
		DurReq = 5000000,
		HRPCFrame = CFrame.new(-9036.41113, 37.1280937, -6057.37354, 0.0564302094, 0.0176537428, -0.998250484, 2.14902496e-09, 0.999843657, 0.0176819172, 0.998406529, -0.000997796538, 0.0564213879)
	},
	[1] = {
		DurReq = 10000000,
		HRPCFrame = CFrame.new(40.2047043, -444.826294, 882.583862, 0.027385978, 0.742171943, -0.66964978, -0.99962306, 0.0216578227, -0.0168772116, 0.00197736197, 0.669859529, 0.742485225)
	},
}

--// Chests
local Chests = {
	"Golden Chest",
	"Enchanted Chest",
	"Mythical Chest",
	"Magma Chest",
	"Legends Chest",
	"Jungle Chest"
}

--// Codes
local AvailableCodes = {
	"frostgems10",
	"mightygems2500",
	"galaxycrystal50",
	"spacegems50",
	"epicreward500",
	"launch250",
	"MillionWarriors",
	"Musclestorm50",
	"ultimate250",
	"megalift50",
	"supermuscle100",
	"superpunch100",
	"Skyagility50",
	"speedy50"
}

--// Pets XP
local XPRequirements = {
	["Basic"] = 250,
	["Advanced"] = 500,
	["Rare"] = 750,
	["Epic"] = 1000,
	["Unique"] = 1250,
}

--// Pet Glitch Chosen Location
local GlitchTreadmillLoc = CFrame.new(-43.6381531, 9.58767509, 237.509155, 0.00198567891, 2.14212861e-08, -0.999998033, 8.97295127e-09, 1, 2.14391456e-08, 0.999998033, -9.01550479e-09, 0.00198567891)
local PetGlitchLoc
local LastXPPerHit = nil

--// Colors
local EnabledColor = Color3.fromRGB(125, 188, 255)
local DisabledColor = Color3.fromRGB(100, 100, 100)

--// Notifications
local NotificationIcons = {
	Info = "rbxassetid://121775500801091",
	Success = "rbxassetid://97967053333005",
	Warning = "rbxassetid://96542521156552",
	Error = "rbxassetid://80426073633520"
}

----------------------------------------// Functions \\----------------------------------------
function CreateTempanel()
	if not PlayerGui then
		repeat task.wait() until PlayerGui
	end
	
	if PlayerGui:FindFirstChild("Tempanel") then
		return warn("Tempanel is already running.")
	end
	
	local Tempanel = Instance.new("ScreenGui", PlayerGui)
	
	Tempanel.Name = "Tempanel"
	Tempanel.DisplayOrder = 99
	Tempanel.IgnoreGuiInset = true
	Tempanel.ResetOnSpawn = false
	Tempanel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	return Tempanel
end

function CreateCorner(UI, Radius)
	if not UI then
		return
	end

	local NewCorner = Instance.new("UICorner", UI)
	NewCorner.CornerRadius = Radius
end

function CreateUIStroke(UI, UIStrokeProps : UIStrokeProps)
	if not UI then
		return
	end

	local NewUIStroke = Instance.new("UIStroke", UI)
	NewUIStroke.ApplyStrokeMode = UIStrokeProps.ApplyStrokeMode
	NewUIStroke.StrokeSizingMode = UIStrokeProps.StrokeSizingMode
	NewUIStroke.Color = UIStrokeProps.Color
	NewUIStroke.Thickness = UIStrokeProps.Thickness
	NewUIStroke.Transparency = UIStrokeProps.Transparency
end

function CreateUIComp(Props: Props)
	local IsDraggableVal = Props.IsDraggable

	local NewComp : TextButton | ImageButton | Frame | ImageLabel | ImageButton | TextLabel | TextBox = Instance.new(Props.UIType, Props.Parent)
	NewComp.Name = Props.Name
	NewComp.AnchorPoint = Props.AnchorPoint
	NewComp.Size = Props.Size
	NewComp.Position = Props.Position
	NewComp.Interactable = Props.Interactable
	NewComp.ClipsDescendants = Props.ClipsDescendants
	NewComp.BackgroundColor3 = Props.BackgroundColor3
	NewComp.BackgroundTransparency = Props.BackgroundTransparency

	if IsDraggableVal then
		EnableDragging(NewComp)
	end

	if Props.Corner then
		CreateCorner(NewComp, Props.Corner)
	end

	if Props.Text then
		NewComp.Text = Props.Text
	end

	if Props.TextScaled then
		NewComp.TextScaled = Props.TextScaled
	end

	if Props.TextColor3 then
		NewComp.TextColor3 = Props.TextColor3
	end

	if Props.PlaceholderText then
		NewComp.PlaceholderText = Props.PlaceholderText
	end

	if Props.PlaceholderColor3 then
		NewComp.PlaceholderColor3 = Props.PlaceholderColor3
	end
	
	if Props.Font then
		NewComp.FontFace = Props.Font
	end
	
	NewComp.BorderSizePixel = 0

	return NewComp
end

function CreateButton(NameArg, ParentArg, ButtonImg : string, ButtonType : string, PositionArg : UDim2)
	if not ParentArg or not ButtonType then
		return
	end
	
	if ButtonType == "TitleHolder" then
		local Button = CreateUIComp({
			UIType = "ImageButton",
			Parent = ParentArg,
			Name = NameArg,
			AnchorPoint = Vector2.new(.5, .5),
			Size = UDim2.new(0.145, 0, 0.555, 0),
			Position = PositionArg,
			Interactable = true,
			ClipsDescendants = false,
			IsDraggable = false,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Corner = UDim.new(.1, 0),
			Text = nil,
			TextScaled = nil,
			PlaceholderText = nil,
			PlaceholderColor3 = nil,
			Font = nil
		})
		Button.Active = false
		Button.AutoButtonColor= false
		Button.Image = ButtonImg
		local ButtonUIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", Button); ButtonUIAspectRatioConstraint.AspectRatio = 1
		return Button
	elseif ButtonType == "ButtonsHolder" then
		local Button = CreateUIComp({
			UIType = "ImageButton",
			Parent = ParentArg,
			Name = NameArg,
			AnchorPoint = Vector2.new(.5, .5),
			Size = UDim2.new(.95, 0, .1, 0),
			Position = UDim2.new(.5, 0, .5, 0),
			Interactable = true,
			ClipsDescendants = false,
			IsDraggable = false,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Corner = UDim.new(.1, 0),
			Text = nil,
			TextScaled = nil,
			TextColor3 = nil,
			PlaceholderText = nil,
			PlaceholderColor3 = nil,
			Font = nil
		})
		Button.Active = false
		Button.AutoButtonColor = false
		Button.Image = ButtonImg
		local ButtonUIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", Button); ButtonUIAspectRatioConstraint.AspectRatio = 182/40
		local SelectedVal = Instance.new("BoolValue", Button); SelectedVal.Name = "Selected"; SelectedVal.Value = false
		return Button
	end
end

function CreateTab(NameArg: string, ParentArg)
	local Tab : ScrollingFrame = CreateUIComp({
		UIType = "ScrollingFrame",
		Parent = ParentArg,
		Name = NameArg,
		AnchorPoint = Vector2.new(.5, .5),
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(.5, 0, .5, 0),
		Interactable = true,
		ClipsDescendants = true,
		IsDraggable = false,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Corner = nil,
		Text = nil,
		TextScaled = nil,
		TextColor3 = nil,
		PlaceholderText = nil,
		PlaceholderColor3 = nil,
		Font = nil
	})
	Tab.CanvasSize = UDim2.new(0, 0, 3, 0)

	if Tab.Name == "Home" then
		Tab.Position = UDim2.new(.5, 0, .5, 0)
	end

	local Holder = CreateUIComp({
		UIType = "Frame",
		Parent = Tab,
		Name = "Holder",
		AnchorPoint = Vector2.new(.5, .5),
		Size = UDim2.new(.945, 0, .945, 0),
		Position = UDim2.new(.5, 0, .5, 0),
		Interactable = true,
		ClipsDescendants = false,
		IsDraggable = false,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Corner = UDim.new(0, 0),
		Text = nil,
		TextScaled = nil,
		TextColor3 = nil,
		PlaceholderText = nil,
		PlaceholderColor3 = nil,
		Font = nil
	})

	local ULL = Instance.new("UIListLayout", Holder); ULL.Padding = UDim.new(.0115, 0); ULL.HorizontalAlignment = Enum.HorizontalAlignment.Center; ULL.VerticalAlignment = Enum.VerticalAlignment.Top; ULL.SortOrder = Enum.SortOrder.Name

	--// ScrollBar
	Tab.ScrollBarThickness = 5
	Tab.ScrollBarImageTransparency = .675

	return Tab
end

function AddCompInTab(Tab : Frame, Props: Props)
	if not Tab then 
		return
	end

	Props.Parent = Tab:WaitForChild("Holder")
	local Comp = CreateUIComp(Props)
	return Comp
end

function AddOptInTab(NameArg: string, Tab : Frame, Type: string, SizeArg : UDim2?, Image : string?)
	if not Tab then
		return
	end
	
	Tab = Tab:FindFirstChild("Holder")
	if not Tab then
		return
	end
	
	if Type == "PlainString" then
		local Opt = CreateUIComp({
			UIType = "TextLabel",
			Parent = Tab,
			Name = NameArg,
			AnchorPoint = Vector2.new(.5, .5),
			Size = UDim2.new(1, 0, .022, 0),
			Position = UDim2.new(.5, 0, .5, 0),
			Interactable = true,
			ClipsDescendants = false,
			IsDraggable = false,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Corner = nil,
			Text = "<u>"..string.split(string.gsub(NameArg, "SectionIndicator", ""), "_")[2].."</u>",
			TextScaled = true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			PlaceholderText = nil,
			PlaceholderColor3 = nil,
			Font = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Regular,
				Enum.FontStyle.Normal
			)})
		Opt.RichText = true
		Opt.TextTransparency = .325
		return Opt
	elseif Type == "PlainImage" and SizeArg and Image then
		local Opt = CreateUIComp({
			UIType = "ImageLabel",
			Parent = Tab,
			Name = NameArg,
			AnchorPoint = Vector2.new(.5, .5),
			Size = SizeArg,
			Position = UDim2.new(.5, 0, .5, 0),
			Interactable = true,
			ClipsDescendants = false,
			IsDraggable = false,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = .975,
			Corner = UDim.new(.05, 0),
			Image = NameArg,
			ImageTransparency = 0,
			PlaceholderText = nil,
			PlaceholderColor3 = nil,
			Font = nil
		})
		Opt.Image = Image
		return Opt
	end
	
	local Opt = CreateUIComp({
		UIType = "TextButton",
		Parent = Tab,
		Name = NameArg,
		AnchorPoint = Vector2.new(.5, .5),
		Size = UDim2.new(.95, 0, .08, 0),
		Position = UDim2.new(.5, 0, .5, 0),
		Interactable = true,
		ClipsDescendants = false,
		IsDraggable = false,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Corner = UDim.new(.1, 0),
		Text = "",
		TextScaled = nil,
		TextColor3 = nil,
		PlaceholderText = nil,
		PlaceholderColor3 = nil,
		Font = nil
	})
	local OptUIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", Opt); OptUIAspectRatioConstraint.AspectRatio = 361 / 57
	
	local OptBG = CreateUIComp({
		UIType = "Frame",
		Parent = Opt,
		Name = "Background",
		AnchorPoint = Vector2.new(.5, .5),
		Position = UDim2.new(.5, 0, .5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Interactable = true,
		ClipsDescendants = false,
		IsDraggable = false,
		BackgroundColor3 = Color3.fromRGB(53, 85, 125),
		BackgroundTransparency = .15,
		Corner = UDim.new(.1, 0),
		Text = nil,
		TextScaled = nil,
		TextColor3 = nil,
		PlaceholderText = nil,
		PlaceholderColor3 = nil,
		Font = nil
	})
	
	local Title = CreateUIComp({
		UIType = "TextLabel",
		Parent = Opt,
		Name = tostring(NameArg.."Text"),
		AnchorPoint = Vector2.new(.5, .5),
		Size = UDim2.new(.45, 0, .375, 0),
		Position = UDim2.new(.265, 0, .5, 0),
		Interactable = true,
		ClipsDescendants = false,
		IsDraggable = false,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Corner = nil,
		Text = string.upper(string.split(NameArg, "_")[2]),
		TextScaled = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		PlaceholderText = nil,
		PlaceholderColor3 = nil,
		Font = Font.new(
			"rbxasset://fonts/families/GothamSSm.json", 
			Enum.FontWeight.Bold, 
			Enum.FontStyle.Normal
		)
	})
	Title.TextXAlignment = Enum.TextXAlignment.Left
	
	local function CreateSeparator()
		local Separator = CreateUIComp({
			UIType = "Frame",
			Parent = Opt,
			Name = "Separator",
			AnchorPoint = Vector2.new(.5, .5),
			Position = UDim2.new(.5, 0, .5, 0),
			Size = UDim2.new(.0045, 0, .655, 0),
			Interactable = true,
			ClipsDescendants = false,
			IsDraggable = false,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = .875,
			Corner = nil,
			Text = nil,
			TextScaled = nil,
			TextColor3 = nil,
			PlaceholderText = nil,
			PlaceholderColor3 = nil,
			Font = nil
		})
	end
	
	-- ACTIVATION TYPE
	if Type == "Input" then
		local TypeVal = Instance.new("StringValue", Opt); TypeVal.Name = "Type"; TypeVal.Value = Type
		local ChosenVal = Instance.new("NumberValue", Opt); ChosenVal.Name = "Chosen"; ChosenVal.Value = 0
		local ChangeVal = Instance.new("StringValue", Opt); ChangeVal.Name = "Change"; ChangeVal.Value = string.split(NameArg, "_")[2]
		local Input = CreateUIComp({
			UIType = "TextBox",
			Parent = Opt,
			Name = "Input",
			AnchorPoint = Vector2.new(.5, .5),
			Size = UDim2.new(.465, 0, .375, 0),
			Position = UDim2.new(.75, 0, .5, 0),
			Interactable = true,
			ClipsDescendants = false,
			IsDraggable = false,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Corner = nil,
			Text = "",
			TextScaled = true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			PlaceholderText = "Type value",
			PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
			Font = Font.new(
				"rbxasset://fonts/families/GothamSSm.json", 
				Enum.FontWeight.Bold, 
				Enum.FontStyle.Normal
			)
		})
		Input.TextXAlignment = Enum.TextXAlignment.Right
		CreateSeparator()
	elseif Type == "Toggle" then
		local TypeVal = Instance.new("StringValue", Opt); TypeVal.Name = "Type"; TypeVal.Value = Type
		local ChosenVal = Instance.new("BoolValue", Opt); ChosenVal.Name = "Chosen"; ChosenVal.Value = false
		local ChangeVal = Instance.new("StringValue", Opt); ChangeVal.Name = "Change"; ChangeVal.Value = string.split(NameArg, "_")[2]
		local Toggle = CreateUIComp({
			UIType = "TextLabel",
			Parent = Opt,
			Name = "Toggle",
			AnchorPoint = Vector2.new(.5, .5),
			Size = UDim2.new(.435, 0, .55, 0),
			Position = UDim2.new(.75, 0, .5, 0),
			Interactable = true,
			ClipsDescendants = false,
			IsDraggable = false,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Corner = nil,
			Text = "[ OFF ]",
			TextScaled = true,
			TextColor3 = Color3.fromRGB(100, 100, 100),
			PlaceholderText = nil,
			PlaceholderColor3 = nil,
			Font = Font.new(
				"rbxasset://fonts/families/GothamSSm.json", 
				Enum.FontWeight.Bold, 
				Enum.FontStyle.Italic
			)
		})
		Toggle.TextXAlignment = Enum.TextXAlignment.Right
		CreateSeparator()
	elseif Type == "Activate" then
		local TypeVal = Instance.new("StringValue", Opt); TypeVal.Name = "Type"; TypeVal.Value = Type
		local ChosenVal = Instance.new("BoolValue", Opt); ChosenVal.Name = "Chosen"; ChosenVal.Value = false
		local ChangeVal = Instance.new("StringValue", Opt); ChangeVal.Name = "Change"; ChangeVal.Value = string.split(NameArg, "_")[2]
		Title.TextXAlignment = Enum.TextXAlignment.Center
		Title.Size = UDim2.new(.85, 0, .625, 0)
		Title.Position = UDim2.new(.5, 0, .5, 0)
	else
		return warn("Invalid args [AddOptInTab() Func]")
	end
	
	return Opt
end

function ObtainOptValue(NameArg)
	local Tempanel = PlayerGui:FindFirstChild("Tempanel")
	if not Tempanel then
		CreateNotification("Tempanel is nil for some reason", "Error")
		return
	end

	local MainFrame = Tempanel:WaitForChild("TempanelML")
	local OpenedTabHolder = MainFrame:WaitForChild("OpenedTab")
	local OpenedTabComponentsFold = OpenedTabHolder:WaitForChild("Components")

	local PossibleOpt = OpenedTabComponentsFold:FindFirstChild(NameArg, true)
	local Value = nil

	if PossibleOpt and PossibleOpt:FindFirstChild("Chosen") then
		local ChosenVal = PossibleOpt:FindFirstChild("Chosen")
		Value = ChosenVal.Value
	end

	return Value
end

function ObtainOptValueInstance(NameArg)
	local Tempanel = PlayerGui:FindFirstChild("Tempanel")
	if not Tempanel then
		CreateNotification("Tempanel is nil for some reason", "Error")
		return
	end

	local MainFrame = Tempanel:WaitForChild("TempanelML")
	local OpenedTabHolder = MainFrame:WaitForChild("OpenedTab")
	local OpenedTabComponentsFold = OpenedTabHolder:WaitForChild("Components")

	local PossibleOpt = OpenedTabComponentsFold:FindFirstChild(NameArg, true)
	local Value = nil

	if PossibleOpt and PossibleOpt:FindFirstChild("Chosen") then
		local ChosenVal = PossibleOpt:FindFirstChild("Chosen")
		Value = ChosenVal
	end

	return Value
end

function EnableDragging(UI)
	if not UI then
		return
	end
	UI.Active = false
	
	local StartPos = nil
	local InputBeganPos = nil
	local Pos = nil
	local WasDragging = nil
	
	if UI:IsA("ImageButton") or UI:IsA("TextButton") then
		WasDragging = Instance.new("BoolValue", UI); WasDragging.Name = "WasDragging"; WasDragging.Value = false
	end
	
	local Dragging = Instance.new("BoolValue", UI); Dragging.Name = "Dragging"; Dragging.Value = false
	
	local function AcquireSinkInput()
		return Enum.ContextActionResult.Sink
	end
	
	UI.InputBegan:Connect(function(inpObj)
		if inpObj.UserInputType == Enum.UserInputType.MouseButton1 or inpObj.UserInputType == Enum.UserInputType.Touch then
			if not inpObj.Position then
				return
			end
			
			InputBeganPos = inpObj.Position
			Dragging.Value = true
			StartPos = UI.Position
			if WasDragging then WasDragging.Value = false end
			
			if inpObj.UserInputType == Enum.UserInputType.Touch then
				ContextActionService:BindAction(
					"Block_Cam_While_Dragging",
					AcquireSinkInput,
					false,
					Enum.UserInputType.Touch
				)
			end
		end
	end)
	
	UserInputService.InputEnded:Connect(function(inpObj)
		if inpObj.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging.Value = false
		elseif inpObj.UserInputType == Enum.UserInputType.Touch  then
			Dragging.Value = false
			ContextActionService:UnbindAction("Block_Cam_While_Dragging")
		end
	end)
	
	UserInputService.InputChanged:Connect(function(Input)
		if not Dragging.Value then
			return
		end
		
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			local Delta = Input.Position - InputBeganPos
			
			if WasDragging and Delta.Magnitude >= 5 then
				WasDragging.Value = true
			end
			
			Pos = UDim2.new(	
				StartPos.X.Scale,
				StartPos.X.Offset + Delta.X,
				StartPos.Y.Scale,
				StartPos.Y.Offset + Delta.Y
			)
		end
	end)
	
	
	RunService.RenderStepped:Connect(function(dt)
		if Dragging.Value and Pos then
			UI.Position = Pos
		end
	end)
end

local ButtonInfo = TweenInfo.new(.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
function AnimateButtons()
	task.wait(1)
	local Tempanel = PlayerGui:FindFirstChild("Tempanel")
	if not Tempanel then
		return
	end

	for _, GuiComp in pairs(Tempanel:GetDescendants()) do
		if GuiComp:IsA("TextButton") or GuiComp:IsA("ImageButton") then
			local NormSize = GuiComp.Size

			GuiComp.MouseEnter:Connect(function()
				local Props
				if GuiComp:FindFirstChild("Selected") and GuiComp:FindFirstChild("Selected").Value then
					Props = {BackgroundTransparency = .45}
				else
					Props = {BackgroundTransparency = .85}
				end
				
				local ButtonTween = TweenService:Create(GuiComp, ButtonInfo, Props)
				ButtonTween:Play()
			end)

			GuiComp.MouseLeave:Connect(function()	
				local Props
				if GuiComp:FindFirstChild("Selected") and GuiComp:FindFirstChild("Selected").Value then
					Props = {BackgroundTransparency = .55, Size = NormSize}
				else
					Props = {BackgroundTransparency = 1, Size = NormSize}
				end
				
				local ButtonTween = TweenService:Create(GuiComp, ButtonInfo, Props)
				ButtonTween:Play()
			end)

			GuiComp.MouseButton1Down:Connect(function()
				local Props
				if GuiComp:FindFirstChild("Selected") and GuiComp:FindFirstChild("Selected").Value then
					Props = {BackgroundTransparency = .35, Size = NormSize + UDim2.fromOffset(12.5, 12.5)}
				else
					Props = {BackgroundTransparency = .625, Size = NormSize + UDim2.fromOffset(12.5, 12.5)}
				end
				
				local ButtonTween = TweenService:Create(GuiComp, ButtonInfo, Props)
				ButtonTween:Play()
			end)

			GuiComp.MouseButton1Up:Connect(function()
				local Props
				if GuiComp:FindFirstChild("Selected") and GuiComp:FindFirstChild("Selected").Value then
					Props = {BackgroundTransparency = .55, Size = NormSize}
				else
					Props = {BackgroundTransparency = 1, Size = NormSize}
				end
				local ButtonTween = TweenService:Create(GuiComp, ButtonInfo, Props)
				ButtonTween:Play()
			end)

		end
	end
end

local FrameInfo = TweenInfo.new(.375, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
function OpenTab(TabsFolder : Folder, Tab)
	if Tab.Size == UDim2.new(1, 0, 1, 0) then
		return
	end
	
	Tab.Interactable = true
	Tab.Size = UDim2.new(0, 0, 0, 0)
	Tab.Position = UDim2.new(.5, 0, .5, 0)
	CloseAllTabs(TabsFolder, Tab)
	local Props = {Size = UDim2.new(1, 0, 1, 0)}
	local Tween = TweenService:Create(Tab, FrameInfo, Props)
	Tween:Play()
end

function CloseTab(TabsFolder : Folder, Tab)
	Tab.Interactable = false
	local Props = {Position = UDim2.new(.5, 0, 2.5, 0)}
	local Tween = TweenService:Create(Tab, FrameInfo, Props)
	Tween:Play()
	task.spawn(function()
		Tween.Completed:Wait()
		Tab.Size = UDim2.new(0, 0, 0, 0)
	end)
end

function CloseAllTabs(TabsFolder : Folder, Exclusion : ScrollingFrame?)
	for _, Tab in pairs(TabsFolder:GetChildren()) do
		if Tab:IsA("ScrollingFrame") and Tab ~= Exclusion then
			CloseTab(TabsFolder, Tab)
		end
	end
end

function NotificationServiceInit()
	local Tempanel = PlayerGui:FindFirstChild("Tempanel")
	if not Tempanel then
		return
	end
	
	local NotificationsHolder = CreateUIComp({
		UIType = "CanvasGroup",
		Parent = Tempanel,
		Name = "NotificationsHolder",
		AnchorPoint = Vector2.new(.5, .5),
		Position = UDim2.new(.5, 0, .5, 0),
		Size = UDim2.new(.17, 0, .945, 0),
		Interactable = true,
		ClipsDescendants = true,
		IsDraggable = false,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Corner = nil,
		Text = nil,
		TextScaled = nil,
		TextColor3 = nil,
		PlaceholderText = nil,
		PlaceholderColor3 = nil,
		Font = nil
	})
	NotificationsHolder.ZIndex = 3
	local ULL = Instance.new("UIListLayout", NotificationsHolder); ULL.Padding = UDim.new(.02, 0); ULL.HorizontalAlignment = Enum.HorizontalAlignment.Center; ULL.VerticalAlignment = Enum.VerticalAlignment.Top; ULL.SortOrder = Enum.SortOrder.Name
	return NotificationsHolder
end

local NotificationInfo = TweenInfo.new(.875, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
function CreateNotification(TextArg : string, Type: string, Time : number?)
	local Tempanel = PlayerGui:FindFirstChild("Tempanel")
	if not Tempanel then
		return
	end
	
	local NotificationsHolder = Tempanel:FindFirstChild("NotificationsHolder")
	if not NotificationsHolder then
		return
	end
	
	local NotificationsAmount = #NotificationsHolder:GetChildren() - 1
	if not Time then
		Time = 5
	end
	
	local NewNotif = CreateUIComp({
		UIType = "CanvasGroup",
		Parent = NotificationsHolder,
		Name =  NotificationsAmount,
		AnchorPoint = Vector2.new(.5, 1),
		Position = UDim2.new(.5, 0, .5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		Interactable = true,
		ClipsDescendants = true,
		IsDraggable = false,
		BackgroundColor3 = Color3.fromRGB(8, 9, 20),
		BackgroundTransparency = 0,
		Corner = UDim.new(.235, 0),
		Text = nil,
		TextScaled = nil,
		TextColor3 = nil,
		PlaceholderText = nil,
		PlaceholderColor3 = nil,
		Font = nil
	})
	NewNotif.GroupTransparency = .095
	local TimerBar = CreateUIComp({
		UIType = "Frame",
		Parent = NewNotif,
		Name =  "TimerBar",
		AnchorPoint = Vector2.new(.5, .5),
		Position = UDim2.new(.5, 0, 0.955, 0),
		Size = UDim2.new(1, 0, .035, 0),
		Interactable = true,
		ClipsDescendants = false,
		IsDraggable = false,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = .875,
		Corner = UDim.new(.235, 0),
		Text = nil,
		TextScaled = nil,
		TextColor3 = nil,
		PlaceholderText = nil,
		PlaceholderColor3 = nil,
		Font = nil
	})
	
	local Text = CreateUIComp({
		UIType = "TextLabel",
		Parent = NewNotif,
		Name = "Text",
		AnchorPoint = Vector2.new(.5, .5),
		Position = UDim2.new(.6, 0, .5, 0),
		Size = UDim2.new(.725, 0, .625, 0),
		Interactable = true,
		ClipsDescendants = false,
		IsDraggable = false,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Corner = nil,
		Text = TextArg,
		TextScaled = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		PlaceholderText = nil,
		PlaceholderColor3 = nil,
		Font = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.Bold,
			Enum.FontStyle.Normal
		)
	})
	
	local Icon = CreateUIComp({
		UIType = "ImageLabel",
		Parent = NewNotif,
		Name = "Icon",
		AnchorPoint = Vector2.new(.5, .5),
		Position = UDim2.new(.135, 0, .5, 0),
		Size = UDim2.new(.163, 0, .625, 0),
		Interactable = true,
		ClipsDescendants = true,
		IsDraggable = false,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Corner = nil,
		Text = nil,
		TextScaled = nil,
		TextColor3 = nil,
		PlaceholderText = nil,
		PlaceholderColor3 = nil,
		Font = nil
	})
	
	Icon.Image = NotificationIcons[Type]
	local IconUIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", Icon); IconUIAspectRatioConstraint.AspectRatio = 1
	
	local Props = {Size = UDim2.new(1, 0, .095, 0)}
	local Tween = TweenService:Create(NewNotif, NotificationInfo, Props)
	Tween:Play()
	
	local TimerBarInfo = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local TimerBarProps = {Size = UDim2.new(0, 0, .035, 0)}
	local TimerBarTween = TweenService:Create(TimerBar, TimerBarInfo, TimerBarProps); TimerBarTween:Play()
	
	task.spawn(function()
		TimerBarTween.Completed:Wait()
		DeleteNotification(NewNotif)
	end)
end

local NotificationDelProps = {Size = UDim2.new(0, 0, 0, 0)} 
function DeleteNotification(Notification : Frame)
	if not Notification then
		return
	end
	
	local Tween = TweenService:Create(Notification, NotificationInfo, NotificationDelProps)
	Tween:Play()
	task.spawn(function()
		Tween.Completed:Wait()
		Notification:Destroy()
	end)
end

----------------------------------------// Features Functions \\----------------------------------------
--// Camera
function RotateCameraRandomly()
	local Camera = workspace.CurrentCamera
	local Angle = math.random(-50, 50)

	Camera.CFrame = CFrame.Angles(Angle, 0, 0)
end

--// Character / Humanoid / HumanoidRootPart
function AcquireChar()
	local Char = LocalPlayer.Character
	if Char then
		return Char
	else
		CreateNotification("Char is nil [AcquireChar() Func], waiting for a new one", "Error")
		LocalPlayer.CharacterAdded:Connect(function(newChar)
			return newChar
		end)
	end
end

function AcquireHumanoid()
	local Char = LocalPlayer.Character
	
	if Char then
		local Humanoid = Char:WaitForChild("Humanoid")
		return Humanoid
	else
		CreateNotification("Char is nil [AcquireHumanoid() Func], waiting for a new one", "Error")
		LocalPlayer.CharacterAdded:Connect(function(newChar)
			local newHumanoid = newChar:WaitForChild("Humanoid")
			return newHumanoid
		end)
	end
end

function AcquireHRP()
	local Char = LocalPlayer.Character
	
	if Char then
		local HRP = Char:WaitForChild("HumanoidRootPart")
		return HRP
	else
		CreateNotification("Char is nil [AcquireHumanoid() Func], waiting for a new one", "Error")
		LocalPlayer.CharacterAdded:Connect(function(newChar)
			local newHRP = newChar:WaitForChild("HumanoidRootPart")
			return newHRP
		end)
	end
end

--// WalkSpeed
local WalkSpeedCharListener
function ChangeWalkSpeed(num : number)
	if WalkSpeedCharListener then
		WalkSpeedCharListener:Disconnect()
		WalkSpeedCharListener = nil
	end

	local Humanoid = AcquireHumanoid()
	Humanoid.WalkSpeed = num

	WalkSpeedCharListener = LocalPlayer.CharacterAdded:Connect(function()
		ChangeWalkSpeed(ObtainOptValue("01_WalkSpeed"))
	end)
end

--// JumpPower
local JumpPowerCharListener
function ChangeJumpPower(num : number)
	if JumpPowerCharListener then
		JumpPowerCharListener:Disconnect()
		JumpPowerCharListener = nil
	end

	local Humanoid = AcquireHumanoid()
	Humanoid.JumpPower = num

	LocalPlayer.CharacterAdded:Connect(function()
		ChangeJumpPower(ObtainOptValue("02_JumpPower"))
	end)
end

--// Noclip
local NoclipConnection
local NoclipCharListener
function ToggleNoclip(toggle : boolean)
	if NoclipConnection then
		NoclipConnection:Disconnect()
		NoclipConnection = nil
	end

	if NoclipCharListener then
		NoclipCharListener:Disconnect()
		NoclipCharListener = nil
	end

	NoclipCharListener = LocalPlayer.CharacterAdded:Connect(function(newChar)
		ToggleNoclip(ObtainOptValue("04_Noclip"))
	end)

	local Char = AcquireChar()

	for _, CharPart in pairs(Char:GetDescendants()) do
		if CharPart:IsA("BasePart") then
			CharPart.CanCollide = true
		end
	end

	if toggle then
		NoclipConnection = RunService.Stepped:Connect(function()
			for _, CharPart in pairs(Char:GetDescendants()) do
				if CharPart:IsA("BasePart") then
					CharPart.CanCollide = false
				end
			end
		end)
	end
end

--// Float
local FloatConnection
local FloatUISB, FloatUISE
local FloatId = 0
local FloatCharListener   
function ToggleFloat(toggle : boolean)
	if FloatConnection then
		FloatConnection:Disconnect()
		FloatConnection = nil
	end

	if FloatCharListener then
		FloatCharListener:Disconnect()
		FloatCharListener = nil
	end

	if UISB or UISE then
		UISB:Disconnect(); UISB = nil
		UISE:Disconnect(); UISE = nil
	end

	FloatCharListener = LocalPlayer.CharacterAdded:Connect(function()
		ToggleFloat(ObtainOptValue("05_Float"))
	end)

	local goingDown, goingUp = false, false

	local Humanoid = AcquireHumanoid()
	local HRP = AcquireHRP()
	if workspace:FindFirstChild("FloatPart") then
		workspace.FloatPart:Destroy()
	end

	if toggle then

		local FloatPart = Instance.new("Part", workspace); FloatPart.Name = "FloatPart"; FloatPart.Size = Vector3.new(10, 1, 10); FloatPart.Transparency = 1; FloatPart.Anchored = true
		local TargetY = HRP.Position.Y - 3.5
		FloatConnection = RunService.Stepped:Connect(function()
			if goingDown then
				TargetY -= .5
			 	math.clamp(TargetY, HRP.Position.Y - 4, HRP.Position.Y - 3)
			elseif goingUp then
				TargetY += .5
				math.clamp(TargetY, HRP.Position.Y - 4, HRP.Position.Y - 3)
			end
			FloatPart.Position = Vector3.new(HRP.Position.X, TargetY, HRP.Position.Z)
		end)
		if PlayerIsMobile then
			Humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
				if Humanoid.Jump then
					FloatId += 1
					goingDown = false
				else
					FloatId += 1
					local CurrentFloatId = FloatId

					task.delay(2, function()
						if CurrentFloatId == FloatId then
							goingDown = true
						end
					end)
				end
			end)
		else
			CreateNotification("E to go up, Q to go down", "Info", 3)
			FloatUISB = UserInputService.InputBegan:Connect(function(Input)
				if Input.KeyCode == Enum.KeyCode.Q then
					goingDown = true
					goingUp = false
				elseif Input.KeyCode == Enum.KeyCode.E then
					goingUp = true
					goingDown = false
				end
			end)
			FloatUISE = UserInputService.InputEnded:Connect(function(Input)
				if Input.KeyCode == Enum.KeyCode.Q then
					goingDown = false
				elseif Input.KeyCode == Enum.KeyCode.E then
					goingUp = false
				end
			end)
		end
	end
end

--// FOV
local FOVCharListener 
function ChangeFOV(num : number)
	if FOVCharListener then
		FOVCharListener:Disconnect()
		FOVCharListener = nil
	end

	local Camera = workspace.CurrentCamera
	Camera.FieldOfView = num

	FOVCharListener = LocalPlayer.CharacterAdded:Connect(function()
		ChangeFOV(ObtainOptValue("07_FOV"))
	end)
end

--// Shadows
function ToggleShadows(toggle : boolean)
	LightingService.GlobalShadows = not toggle
end

--// Anti-Afk
local AntiAfkListener
function ToggleAntiAfk(toggle : boolean)
	if AntiAfkListener then
		AntiAfkListener:Disconnect()
		AntiAfkListener = nil
	end

	if toggle then
		AntiAfkListener = LocalPlayer.Idled:Connect(function (args)
			VirtualUserService:CaptureController()
			VirtualUserService:ClickButton2(Vector2.new())
		end)
	end
end

--// Rejoin
function Rejoin()
	local Success, Error = pcall(function()
		TeleportService:TeleportToPlaceInstance(GameId, JobId, LocalPlayer)
	end)

	if Error then
		CreateNotification("Unable to teleport, check console for details", "Error")
		print(Error)
		return
	end
end

--// ServerHop / Join Small Server
local Request = http_request or request or (syn and syn.request)
function ServerHop(joinSmallServer : boolean)
	local function AcquireServers()
		local Response = Request({
			Url = "https://games.roblox.com/v1/games/"..GameId.."/servers/Public?sortOrder=Asc&limit=100",
			Method = "GET"
		})
		if Response.StatusCode == 200 then
			return HttpService:JSONDecode(Response.Body)
		end

		return nil
	end

	local Servers = AcquireServers()
	if not Servers then
		CreateNotification("Failed to acquire servers, try again", "Error")
		return
	end

	local AvailableServers = {}
	for _, Server in pairs(Servers.data) do
		if Server.id ~= JobId and Server.playing <= Server.maxPlayers then
			table.insert(AvailableServers, Server)
		end
	end

	if #AvailableServers > 0 then
		local TargetServer
		if joinSmallServer then
			table.sort(AvailableServers, function(s1, s2)
				return s1.playing < s2.playing
			end)
			TargetServer = AvailableServers[1]
		else
			table.sort(AvailableServers, function(s1, s2)
				return s1.playing > s2.playing
			end)
			TargetServer = AvailableServers[1]
		end

		if not TargetServer then
			CreateNotification("Could not find a target server, try again", "Error")
			return
		end

		local Success, Error = pcall(function()
			TeleportService:TeleportToPlaceInstance(GameId, TargetServer.id, LocalPlayer)
		end)

		if Error then
			CreateNotification("Failed to teleport, try again", "Error")
			return
		end
	end
end

--// Low Gravity
local NormalGravity = 196.2
function ToggleMoonGravity(toggle : boolean)
	if toggle then
		workspace.Gravity = 25
	else
		workspace.Gravity = NormalGravity
	end
end

--// Freeze
local FreezeHRPCharListener
function ToggleFreezeHRP(toggle : boolean)
	if FreezeHRPCharListener then
		FreezeHRPCharListener:Disconnect()
		FreezeHRPCharListener = nil
	end

	local HRP = AcquireHRP()
	HRP.Anchored = toggle
	
	FreezeHRPCharListener = LocalPlayer.CharacterAdded:Connect(function()
		ToggleFreezeHRP(ObtainOptValue("16_Freeze"))
	end)
end

--// Open Dex
local DexOpened = false
function OpenDex()
	if DexOpened then
		CreateNotification("Dex is already open", "Warning", 3)
		return
	end

	DexOpened = true
	loadstring(game:HttpGet("https://github.com/BOXLEGENDARY/Dex/releases/latest/download/out.lua"))()
end

--// Collect Chests
local CollectChestsActive = false
function CollectChests()
	if CollectChestsActive then
		CreateNotification("Collect Chests is already active", "Warning", 3)
		return
	end
	CollectChestsActive = true

	if CollectChestsCharListener then
		CollectChestsCharListener:Disconnect()
		CollectChestsCharListener = nil
	end

	--// Group chest
	if LocalPlayer:IsInGroup(874427664) then
		groupRemote:InvokeServer("groupRewards")
	end

	--// Normal chests
	for _, ChestName in pairs(Chests) do
		CheckChestRemote:InvokeServer(ChestName)
		CreateNotification("Collected "..ChestName..";", "Info", 3.5)
		task.wait(3.5)
	end
	CreateNotification("Successfully collected chests", "Success", 2)
	CollectChestsActive = false
end

--// Redeem All codes
local RedeemAllCodesActive = false
function RedeemAllCodes()
	if RedeemAllCodesActive then
		CreateNotification("RedeemAllCodes is already active", "Warning", 3)
		return
	end
	RedeemAllCodesActive = true

	for _, Code in pairs(AvailableCodes) do
		CodeRemote:InvokeServer(Code)
		task.wait(.5)
	end
	RedeemAllCodesActive = false
end

--// Maximum Rep Speed
local UltimatesFolder = LocalPlayer:WaitForChild("ultimatesFolder")
local RepSpeedVal = UltimatesFolder:FindFirstChild("+5% Rep Speed")
if not RepSpeedVal then
	RepSpeedVal = Instance.new("NumberValue", ultimatesFolder); RepSpeedVal.Name = "+5% Rep Speed"; RepSpeedVal.Value = 0
end
local DefaultVal = RepSpeedVal.Value
function ToggleMaximumRepSpeed(toggle : boolean)
	if toggle then
		RepSpeedVal.Value = 10
	else
		RepSpeedVal.Value = DefaultVal
	end
end

--// Auto-Rep
function ToggleAutoRep(toggle : boolean)
	LocalPlayer:FindFirstChild("autoLiftEnabled", true).Value = toggle
end

--// Auto-Rebirth
local RebirthConnection
local AutoRebirthCharListener
function ToggleAutoRebirth(toggle : boolean)
	if RebirthConnection then
		RebirthConnection:Disconnect()
		RebirthConnection = nil
	end

	if AutoRebirthCharListener then
		AutoRebirthCharListener:Disconnect()
		AutoRebirthCharListener = nil
	end
	
	if toggle then
		RebirthConnection = RunService.Stepped:Connect(function()
			RebirthRemote:InvokeServer(RebirthArg)
			task.wait(7.5)
		end)
	end
	
	AutoRebirthCharListener = LocalPlayer.CharacterAdded:Connect(function()
		ToggleAutoRebirth(ObtainOptValue("06_Auto-Rebirth"))
	end)
end

--// Farm Durability
local FarmDurabilityConnection
local FarmDurabilityCharListener
local FarmDurabilityPunchToolListener
local FarmDurabilityLastPos
function ToggleFarmDurability(toggle : boolean, glitchPets : boolean?)
	if FarmDurabilityConnection then
		FarmDurabilityConnection:Disconnect()
		FarmDurabilityConnection = nil
	end

	if FarmDurabilityCharListener then
		FarmDurabilityCharListener:Disconnect()
		FarmDurabilityCharListener = nil
	end

	if FarmDurabilityPunchToolListener then
		FarmDurabilityPunchToolListener:Disconnect()
		FarmDurabilityPunchToolListener = nil
	end

	local Char = AcquireChar()
	local HRP = AcquireHRP()

	if LastPos then
		HRP.CFrame = FarmDurabilityLastPos
	else
		FarmDurabilityLastPos = HRP.CFrame
	end

	local PunchTool = LocalPlayer.Backpack:FindFirstChild("Punch")

	if toggle then
		if PunchTool then
			PunchTool.Parent = Char
		else
			PunchTool = Char:WaitForChild("Punch")
		end

		FarmDurabilityPunchToolListener = PunchTool.Changed:Connect(function()
			if PunchTool.Parent ~= Char then
				CreateNotification("You need the Punch tool to continue farming", "Warning", 3)
			end
		end)

		FarmDurabilityConnection = RunService.Stepped:Connect(function()
			local ChosenRock = nil
			if glitchPets then

				local RebirthsAmount = RebirthVal.Value
				if RebirthsAmount >= 80 then
					PetGlitchLoc = DurabilityRocks[2].HRPCFrame
				else
					PetGlitchLoc = DurabilityRocks[7].HRPCFrame
				end

				HRP.CFrame = PetGlitchLoc

			else

				for _,  DurabilityRockTbl in ipairs(DurabilityRocks) do
					local DurabilityVal = LocalPlayer:FindFirstChild("Durability", true)
					if DurabilityRockTbl.DurReq <= DurabilityVal.Value then
						ChosenRock = DurabilityRockTbl.HRPCFrame
						break
					end
				end
				HRP.CFrame = ChosenRock
			end

			if LastPunch == "Left" then
				RotateCameraRandomly()
				LastPunch = "Right"
				MuscleEvent:FireServer(PunchArg, PunchArgR)
			elseif LastPunch == "Right" then
				RotateCameraRandomly()
				LastPunch = "Left"
				MuscleEvent:FireServer(PunchArg, PunchArgL)
			else
				RotateCameraRandomly()
				LastPunch = "Right"
				MuscleEvent:FireServer(PunchArg, PunchArgR)
			end
		end)
		task.wait(.35)
	end

	FarmDurabilityCharListener = LocalPlayer.CharacterAdded:Connect(function()
		ToggleFarmDurability(ObtainOptValue("07_Farm Durability"))
	end)
end

--// Auto-Kill
local AutoKillConnection
local AutoKillCharListener
local AutoKillLastPos
function ToggleAutoKill(toggle : boolean)
	CreateNotification("This feature hasn't been developed yet, wait for updates", "Warning")
end

--// Glitch Equipped Pets
local EquippedPetsFold = LocalPlayer:FindFirstChild("equippedPets")
local PetsFold = LocalPlayer:FindFirstChild("petsFolder")

local GlitchPetsCharListener
function ToggleGlitchPets(toggle : boolean)
	local GlitchPetsValInst = ObtainOptValueInstance("01_Glitch Equipped Pets")
	local DurabilityVal = LocalPlayer:FindFirstChild("Durability", true)

	if GlitchPetsCharListener then
		GlitchPetsCharListener:Disconnect()
		GlitchPetsCharListener = nil
	end	

	ToggleFarmDurability(false)

	local HRP = AcquireHRP()
	local Char = AcquireChar()

	if toggle then
		if RebirthVal.Value >= 80 then

			if DurabilityVal.Value <= 5000000 then
				CreateNotification("Not enough durability (5M+ needed)")
				return
			end

			CreateNotification("Glitch can sometimes refuse to work. If your pet stops leveling up after some time, that means it's working", "Info", 10)
		elseif RebirthVal.Value < 80 then

			if DurabilityVal.Value <= 5000 then
				CreateNotification("Not enough durability (5K+ needed)")
				return
			end
			
			CreateNotification("You have to set this up for it to work properly (unless you got 80+ rebirths)", "Warning", 7)
		end

		CreateNotification("Glitching will start after this notification goes away", "Info", 5)
		task.wait(5)

		ToggleFarmDurability(true, true)
	end

	GlitchPetsCharListener = LocalPlayer.CharacterAdded:Connect(function()
		CreateNotification("You've died, please reactivate the glitching feature.", "Info", 4)
		GlitchPetsValInst.Value = false
	end)
end

--// Keep Tempanel
function ToggleKeepTempanel(toggle : boolean)
	if toggle then
		local loadsc = game:HttpGet("https://raw.githubusercontent.com/Temo-Metro/mltmpnl/refs/heads/main/default.lua")
		queue_on_teleport("loadstring(" .. string.format("%q", loadsc) .. ")()")
	else
		queue_on_teleport("")
	end
end

----------------------------------------// Startoff \\----------------------------------------
local Tempanel = CreateTempanel()
local NotificationsHolder = NotificationServiceInit(Tempanel)

--// Button Animations
task.spawn(function()
	Tempanel.DescendantAdded:Connect(function(Descendant)
		if Descendant:IsA("TextButton") or Descendant:IsA("ImageButton") then
			AnimateButtons(Tempanel)
		end
	end)
end)

----------------------------------------// Main Frame and Main Button \\----------------------------------------
--// Main Frame
local MainFrame = CreateUIComp({
	UIType = "CanvasGroup",
	Parent = Tempanel,
	Name = "TempanelML",
	AnchorPoint = Vector2.new(.5, .5),
	Size = UDim2.new(0.414, 0, 0.58, 0),
	Position = UDim2.new(.5, 0, .5, 0),
	Interactable = true,
	ClipsDescendants = true,
	IsDraggable = true,
	BackgroundColor3 = Color3.fromRGB(8, 9, 20),
	BackgroundTransparency = 0,
	Corner = UDim.new(.0167, 0),
	Text = nil,
	TextScaled = nil,
	TextColor3 = nil,
	PlaceholderText = nil,
	PlaceholderColor3 = nil,
	Font = nil
})
MainFrame.GroupTransparency = .095
local MainFrameUIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", MainFrame); MainFrameUIAspectRatioConstraint.AspectRatio = 670/464

--// Main Button
local MainButton = CreateUIComp({
	UIType = "ImageButton",
	Parent = Tempanel,
	Name = "TempanelButton",
	AnchorPoint = Vector2.new(.5, .5),
	Size = UDim2.new(0.037, 0, 0.075, 0),
	Position = UDim2.new(.5, 0, .5, 0),
	Interactable = false,
	ClipsDescendants = false,
	IsDraggable = true,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 1,
	Corner = UDim.new(.1, 0),
	Text = nil,
	TextScaled = nil,
	TextColor3 = nil,
	PlaceholderText = nil,
	PlaceholderColor3 = nil,
	Font = nil
})
local MainButtonUIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", MainButton); MainButtonUIAspectRatioConstraint.AspectRatio = 1
MainButton.Image = "rbxassetid://123823724896303"
MainButton.ImageTransparency = .095
MainButton.Active = false
MainButton.AutoButtonColor = false
MainButton.Visible = false

----------------------------------------// TitleHolder and Tabs \\----------------------------------------
--// TitleHolder
local TitleHolder = CreateUIComp({
	UIType = "Frame",
	Parent = MainFrame,
	Name = "TitleHolder",
	AnchorPoint = Vector2.new(.5, .5),
	Size = UDim2.new(.6, 0, .175, 0),
	Position = UDim2.new(.7, 0, .087, 0),
	Interactable = true,
	ClipsDescendants = false,
	IsDraggable = false,
	BackgroundColor3 = Color3.fromRGB(61, 61, 61),
	BackgroundTransparency = 1,
	Corner = nil,
	Text = nil,
	TextScaled = nil,
	TextColor3 = nil,
	PlaceholderText = nil,
	PlaceholderColor3 = nil,
	Font = nil
})

--// TitleHolder UIStroke
local TitleHolderUIStroke = CreateUIStroke(TitleHolder, {
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	StrokeSizingMode = Enum.StrokeSizingMode.FixedSize,
	Color = Color3.fromRGB(255, 255, 255),
	Thickness =  0.75,
	Transparency = 0.925
})

--// TabOpener
local TabOpener = CreateUIComp({
	UIType = "Frame",
	Parent = MainFrame,
	Name = "TabOpener",
	AnchorPoint = Vector2.new(.5, .5),
	Size = UDim2.new(.4, 0, 1, 0),
	Position = UDim2.new(.2, 0, .5, 0),
	Interactable = true,
	ClipsDescendants = false,
	IsDraggable = false,
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 1,
	Corner = nil,
	Text = nil,
	TextScaled = nil,
	TextColor3 = nil,
	PlaceholderText = nil,
	PlaceholderColor3 = nil,
	Font = nil
})

--// TabOpener UIStroke
local TabOpenerUIStroke = CreateUIStroke(TabOpener, {
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	StrokeSizingMode = Enum.StrokeSizingMode.FixedSize,
	Color = Color3.fromRGB(255, 255, 255),
	Thickness =  0.89,
	Transparency = 0.825
})

--// Opened Tab Holder
local OpenedTabFrame = CreateUIComp({
	UIType = "CanvasGroup",
	Parent = MainFrame,
	Name = "OpenedTab",
	AnchorPoint = Vector2.new(.5, .5),
	Size = UDim2.new(.6, 0, .825, 0),
	Position = UDim2.new(.7, 0, .59, 0),
	Interactable = true,
	ClipsDescendants = false,
	IsDraggable = false,
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 1,
	Corner = nil,
	Text = nil,
	TextScaled = nil,
	TextColor3 = nil,
	PlaceholderText = nil,
	PlaceholderColor3 = nil,
	Font = nil
})

----------------------------------------// TitleHolder Components \\----------------------------------------
local CloseButton = CreateButton("Close", TitleHolder, "rbxassetid://119024518584754", "TitleHolder", UDim2.new(.855, 0, .5, 0))
local ScaleButton = CreateButton("Scale", TitleHolder, "rbxassetid://80958551984940", "TitleHolder", UDim2.new(.685, 0, .5, 0))
local MinimizeButton = CreateButton("Minimize", TitleHolder, "rbxassetid://80131877909116", "TitleHolder", UDim2.new(.515, 0, .5, 0))

----------------------------------------// TabOpener Components \\----------------------------------------
--// Buttons Holder
local ButtonsHolder = CreateUIComp({
	UIType = "Frame",
	Parent = TabOpener,
	Name = "ButtonsHolder",
	AnchorPoint = Vector2.new(.5, .5),
	Size = UDim2.new(.925, 0, .925, 0),
	Position = UDim2.new(.5, 0, .5, 0),
	Interactable = true,
	ClipsDescendants = false,
	IsDraggable = false,
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 1,
	Corner = nil,
	Text = nil,
	TextScaled = nil,
	TextColor3 = nil,
	PlaceholderText = nil,
	PlaceholderColor3 = nil,
	Font = nil
})

--// TabOpener UIListLayout
local TabOpenerUIListLayout = Instance.new("UIListLayout", ButtonsHolder)
TabOpenerUIListLayout.Padding = UDim.new(.0315, 0)
TabOpenerUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabOpenerUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
TabOpenerUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

--// Icon
local Icon = CreateUIComp({
	UIType = "ImageLabel",
	Parent = ButtonsHolder,
	Name = "Icon",
	AnchorPoint = Vector2.new(.5, .5),
	Size = UDim2.new(.95, 0, .35, 0),
	Position = UDim2.new(.5, 0, .5, 0),
	Interactable = true,
	ClipsDescendants = false,
	IsDraggable = false,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 1,
	Corner = nil,
	Text = nil,
	TextScaled = nil,
	TextColor3 = nil,
	PlaceholderText = nil,
	PlaceholderColor3 = nil,
	Font = nil
})

--// Image props
Icon.Image = "rbxassetid://94661420403335"
Icon.ScaleType = Enum.ScaleType.Fit

--// Icon Separator
local IconSeparator = CreateUIComp({
	UIType = "Frame",
	Parent = Icon,
	Name = "IconSeparator",
	AnchorPoint = Vector2.new(.5, .5),
	Size = UDim2.new(.9, 0, .01, 0),
	Position = UDim2.new(.5, 0, .975, 0),
	Interactable = true,
	ClipsDescendants = false,
	IsDraggable = false,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 0.825,
	Corner = nil,
	Text = nil,
	TextScaled = nil,
	TextColor3 = nil,
	PlaceholderText = nil,
	PlaceholderColor3 = nil,
	Font = nil
})

--// Buttons \\--
local HomeButton = CreateButton("Home", ButtonsHolder, "rbxassetid://115893583262362", "ButtonsHolder")
local PlayerButton = CreateButton("Player", ButtonsHolder, "rbxassetid://99565971369187", "ButtonsHolder")
local AutoFarmButton = CreateButton("AutoFarm", ButtonsHolder, "rbxassetid://90369448924549", "ButtonsHolder")
local GlitchesButton = CreateButton("Glitches", ButtonsHolder, "rbxassetid://127669943638087", "ButtonsHolder")
local SettingsButton = CreateButton("Settings", ButtonsHolder, "rbxassetid://70922148940626", "ButtonsHolder")

HomeButton:FindFirstChild("Selected").Value = true

----------------------------------------// OpenedTab Frame Components \\----------------------------------------
local OpenedTabFrameCompFolder = Instance.new("Folder", OpenedTabFrame); OpenedTabFrameCompFolder.Name = "Components"

local HomeTab = CreateTab("Home", OpenedTabFrameCompFolder)
local PlayerTab = CreateTab("Player", OpenedTabFrameCompFolder)
local AutoFarmTab = CreateTab("AutoFarm", OpenedTabFrameCompFolder)
local GlitchesTab = CreateTab("Glitches", OpenedTabFrameCompFolder)
local SettingsTab = CreateTab("Settings", OpenedTabFrameCompFolder)

HomeButton.BackgroundColor3 = Color3.fromRGB(108, 172, 255)
HomeButton.BackgroundTransparency = .55
OpenTab(OpenedTabFrameCompFolder, HomeTab)

----------------------------------------// Tabs Components \\----------------------------------------
----------// Home \\----------

local Note = AddOptInTab("00_Click on the options to apply changes!", HomeTab, "PlainString")
local Version = AddOptInTab("01_Version", HomeTab, "PlainImage", UDim2.new(1, 0, 0.088, 0), "rbxassetid://76990945468621")

----------// Player \\----------

--// Movement Section
local MovementSectionIndicator = AddOptInTab("00_MovementSectionIndicator", PlayerTab, "PlainString")
local WalkspeedFrame = AddOptInTab("01_WalkSpeed", PlayerTab, "Input")
local JumpPowerFrame = AddOptInTab("02_JumpPower", PlayerTab, "Input")

--// Character Section 
local CharacterSectionIndicator = AddOptInTab("03_CharacterSectionIndicator", PlayerTab, "PlainString")
local NoclipFrame = AddOptInTab("04_Noclip", PlayerTab, "Toggle")
local FloatFrame = AddOptInTab("05_Float", PlayerTab, "Toggle")

--// Camera Section
local CameraSectionIndicator = AddOptInTab("06_CameraSectionIndicator", PlayerTab, "PlainString")
local FOVFrame = AddOptInTab("07_FOV", PlayerTab, "Input")

--// Utility Section
local UtilitySectionIndicator = AddOptInTab("08_UtilitySectionIndicator", PlayerTab, "PlainString")
local DisableShadowsFrame = AddOptInTab("09_Disable Shadows", PlayerTab, "Toggle")
local AntiAfkFrame = AddOptInTab("10_AntiAFK", PlayerTab, "Toggle")
local RejoinFrame = AddOptInTab("11_Rejoin", PlayerTab, "Activate")
local ServerHopFrame = AddOptInTab("12_ServerHop", PlayerTab, "Activate")
local JoinSmallServerFrame = AddOptInTab("13_Join Small Server", PlayerTab, "Activate")

--// Extras Section
local ExtrasSectionIndicator = AddOptInTab("14_ExtrasSectionIndicator", PlayerTab, "PlainString")
local LowGravityFrame = AddOptInTab("15_Moon Gravity", PlayerTab, "Toggle")
local FreezeFrame = AddOptInTab("16_Freeze", PlayerTab, "Toggle")
local DexFrame = AddOptInTab("17_Open Dex", PlayerTab, "Activate")

----------// Auto-Farm \\----------

--// Gems Section
local GemsSectionIndicator = AddOptInTab("00_GemsSectionIndicator", AutoFarmTab, "PlainString")
local CollectChestsFrame = AddOptInTab("01_Collect Chests", AutoFarmTab, "Activate")
local RedeemCodesFrame = AddOptInTab("02_Redeem All Codes", AutoFarmTab, "Activate")

--// Workout Section
local WorkoutSectionIndicator = AddOptInTab("03_WorkoutSectionIndicator", AutoFarmTab, "PlainString")

local MaximumRepSpeedFrame = AddOptInTab("04_Maximum Rep Speed", AutoFarmTab, "Toggle")
local AutoRepFrame = AddOptInTab("05_Auto-Rep", AutoFarmTab, "Toggle")
local AutoRebirthFrame = AddOptInTab("06_Auto-Rebirth", AutoFarmTab, "Toggle")
local DurabilityFarm = AddOptInTab("07_Farm Durability", AutoFarmTab, "Toggle")

--// Kills Section
local KillsSectionIndicator = AddOptInTab("08_KillsSectionIndicator", AutoFarmTab, "PlainString")
local AutoKillFrame = AddOptInTab("09_Auto-Kill", AutoFarmTab, "Toggle")

----------// Glitches \\----------

--// Pets Section
local PetsSectionIndicator = AddOptInTab("00_PetsSectionIndicator", GlitchesTab, "PlainString")
local PetFrame = AddOptInTab("01_Glitch Pets", GlitchesTab, "Toggle")

----------// Settings \\----------

--// Teleport Section
local TeleportSectionIndicator = AddOptInTab("01_TempanelSectionIndicator", SettingsTab, "PlainString")
local QueueOnTeleportFrame = AddOptInTab("02_Keep Tempanel", SettingsTab, "Toggle")

----------------------------------------// TitleHolder Functionality \\----------------------------------------
local TempanelInfo = TweenInfo.new(.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

--// Close Function
local function Close()
	if not CloseSure then
		CreateNotification("Press again to quit Tempanel", "Warning", .875)
		CloseSure = true
		task.delay(1.25, function()
			CloseSure = false
		end)
		return
	end
	
	CreateNotification("Closing Tempanel...", "Info", 1.5)
	local Props = {GroupTransparency = 1, Size = MainFrame.Size + UDim2.fromOffset(50, 50)}
	local Tween = TweenService:Create(MainFrame, TempanelInfo, Props)
	Tween:Play()

	--// Connections
	if WalkSpeedCharListener then
		WalkSpeedCharListener:Disconnect()
		WalkSpeedCharListener = nil
	end

	if JumpPowerCharListener then
		JumpPowerCharListener:Disconnect()
		JumpPowerCharListener = nil
	end

	if NoclipConnection then
		NoclipConnection:Disconnect()
		NoclipConnection = nil
	end

	if NoclipCharListener then
		NoclipCharListener:Disconnect()
		NoclipCharListener = nil
	end

	if FloatConnection then
		FloatConnection:Disconnect()
		FloatConnection = nil
	end

	if FloatUISB or FloatUISE then
		FloatUISB:Disconnect(); FloatUISB = nil
		FloatUISE:Disconnect(); FloatUISE = nil
	end

	if FloatId then
		FloatId = nil
	end

	if FloatCharListener then
		FloatCharListener:Disconnect()
		FloatCharListener = nil
	end

	if FOVCharListener then
		FOVCharListener:Disconnect()
		FOVCharListener = nil
	end

	if AntiAfkListener then
		AntiAfkListener:Disconnect()
		AntiAfkListener = nil
	end

	if FreezeHRPCharListener then
		FreezeHRPCharListener:Disconnect()
		FreezeHRPCharListener = nil
	end

	if RebirthConnection then
		RebirthConnection:Disconnect()
		RebirthConnection = nil
	end
	
	if AutoRebirthCharListener then
		AutoRebirthCharListener:Disconnect()
		AutoRebirthCharListener = nil
	end
	
	if FarmDurabilityConnection then
		FarmDurabilityConnection:Disconnect()
		FarmDurabilityConnection = nil
	end

	if FarmDurabilityCharListener then
		FarmDurabilityCharListener:Disconnect()
		FarmDurabilityCharListener = nil
	end

	if FarmDurabilityPunchToolListener then
		FarmDurabilityPunchToolListener:Disconnect()
		FarmDurabilityPunchToolListener = nil
	end

	if FarmDurabilityLastPos then
		FarmDurabilityLastPos:Disconnect()
		FarmDurabilityLastPos = nil
	end

	if AutoKillConnection then
		AutoKillConnection:Disconnect()
		AutoKillConnection = nil
	end

	if AutoKillCharListener then
		AutoKillCharListener:Disconnect()
		AutoKillCharListener = nil
	end

	if AutoKillLastPos then
		AutoKillLastPos:Disconnect()
		AutoKillLastPos = nil
	end

	if GlitchPetsCharListener then
		GlitchPetsCharListener:Disconnect()
		GlitchPetsCharListener = nil
	end

	CreateNotification("Your character will reset shortly", "Warning", 5)
	Humanoid.Health = 0
end

--// CloseButton
local CloseSure = false
CloseButton.MouseButton1Click:Connect(function()
	Close()
end)

--// ScaleButton
ScaleButton.MouseButton1Click:Connect(function()
	if MainFrame.Size == NormalScale then
		local Props = {Size = LowScale}
		TweenService:Create(MainFrame, TempanelInfo, Props):Play()
		LastScale = LowScale
	elseif MainFrame.Size == LowScale then
		local Props = {Size = NormalScale}
		TweenService:Create(MainFrame, TempanelInfo, Props):Play()
		LastScale = NormalScale
	end
end)

--// MinimizeButton
MinimizeButton.MouseButton1Click:Connect(function()
	MainButton.Size = UDim2.new(0, 0, 0, 0)
	MainButton.Visible = true
	local MainButtonProps = {Size = UDim2.new(0.037, 0, 0.075, 0)}
	TweenService:Create(MainButton, TempanelInfo, MainButtonProps):Play()
	MainButton.Interactable = true
	
	MainFrame.Interactable = false
	local Props = {Size = UDim2.new(0, 0, 0, 0), Position = MainButton.Position, GroupTransparency = 1}
	TweenService:Create(MainFrame, TempanelInfo, Props):Play()
end)

--// MainButton
local MainButtonWasDraggingVal = MainButton:WaitForChild("WasDragging")
MainButton.MouseButton1Click:Connect(function()
	if MainButtonWasDraggingVal.Value then
		return
	end
	
	local MainButtonProps = {Size = UDim2.new(0, 0, 0, 0)}
	local ButtonTween = TweenService:Create(MainButton, TempanelInfo, MainButtonProps)
	ButtonTween:Play()
	MainButton.Interactable = false

	MainFrame.Interactable = true
	local Props = {Size = LastScale, Position = UDim2.new(.5, 0, .5, 0), GroupTransparency = 0.095}
	TweenService:Create(MainFrame, TempanelInfo, Props):Play()
	task.spawn(function()
		ButtonTween.Completed:Wait()
		MainButton.Visible = false
	end)
end)

----------------------------------------// TabOpener Functionality \\----------------------------------------
for _, Button in pairs(ButtonsHolder:GetChildren()) do
	if Button:IsA("ImageButton") or Button:IsA("TextButton") then
		Button.MouseButton1Click:Connect(function()
			Button.Interactable = false
			for _, otherButton in pairs(ButtonsHolder:GetChildren()) do
				if otherButton:IsA("ImageButton") and otherButton ~= Button then
					otherButton:FindFirstChild("Selected").Value = false
					otherButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					repeat otherButton.BackgroundTransparency = 1 until otherButton.BackgroundTransparency == 1
					task.delay(.45, function()
						if otherButton.BackgroundTransparency ~= 1 then
							TweenService:Create(otherButton, TweenInfo.new(.35), {BackgroundTransparency = 1}):Play()
						end
					end)
				end
			end
			
			Button.BackgroundColor3 = Color3.fromRGB(108, 172, 255)
			Button:FindFirstChild("Selected").Value = true
			
			local name = Button.Name
			if OpenedTabFrameCompFolder:FindFirstChild(name) then
				local TabToOpen = OpenedTabFrameCompFolder:WaitForChild(name)
				OpenTab(OpenedTabFrameCompFolder, TabToOpen)
				task.delay(.3, function()
					Button.Interactable = true
				end)
			else
				CreateNotification("Tab not found", "Error", 5)
				return 
			end
		end)		
	end
end

----------------------------------------// Options Setup \\----------------------------------------
for _, OptInTab in pairs(OpenedTabFrameCompFolder:GetDescendants()) do
	if OptInTab:IsA("TextButton") and OptInTab:FindFirstChild("Chosen") and OptInTab:FindFirstChild("Type") then
		
		local ChosenVal = OptInTab:WaitForChild("Chosen")
		local TypeVal = OptInTab:WaitForChild("Type")
		
		--// Input \\--
		if TypeVal.Value == "Input" then
			
			local InputString = ""
			local Input : TextBox = OptInTab:WaitForChild("Input")
			
			Input.FocusLost:Connect(function(EnterPressed)
				InputString = Input.Text
				if not tonumber(InputString) then
					CreateNotification("Input has to be a number", "Warning", 3)
					Input.Text = ""
				end
			end)
			
			OptInTab.MouseButton1Click:Connect(function()
				if InputString and tonumber(InputString) then
					ChosenVal.Value = tonumber(InputString)
				else
					CreateNotification("You must type a value first", "Error", 3)
					Input.Text = ""
				end
			end)
			
		--// Toggle \\--
		elseif TypeVal.Value == "Toggle" then
			local ToggleDelay = false
			
			OptInTab.MouseButton1Click:Connect(function()
				if ToggleDelay then
					CreateNotification("You're doing things too fast", "Error", 2)
					return
				end
				
				ToggleDelay = true
				ChosenVal.Value = not ChosenVal.Value
				
				task.delay(.35, function()
					ToggleDelay = false
				end)
			end)
			
		--// Activate \\--
		elseif TypeVal.Value == "Activate" then
			
			OptInTab.MouseButton1Click:Connect(function()
				if ChosenVal.Value == true then
					CreateNotification("You're doing things too fast", "Error", 2)
					return
				end
				
				ChosenVal.Value = true
				task.delay(2, function()
					ChosenVal.Value = false
				end)
			end)
			
		end
		
	end
end

----------------------------------------// Settings Saver \\----------------------------------------
local Settings = {
	["KeepTempanel"] = false
}

if not isfolder("Tempanel") then
	makefolder("Tempanel")
end

function Save()
	writefile("Tempanel/settings.json", HttpService:JSONEncode(Settings))
end

function Load()
	if not isfile("Tempanel/settings.json") then
		Save()
	end

	local Success, Data = pcall(function()
		return HttpService:JSONDecode(readfile("Tempanel/settings.json"))
	end)

	if Success then
		for Key, Value in pairs(Data) do
			Settings[Key] = Value
		end
	end
	ObtainOptValueInstance("02_Keep Tempanel").Value = Settings["KeepTempanel"]
end

function ChangeSetting(Key, Value)
	Settings[Key] = Value
	Save()
end

Load()

----------------------------------------// Options Functionality \\----------------------------------------
for _, OptInTab in pairs(OpenedTabFrameCompFolder:GetDescendants()) do
	if OptInTab:IsA("TextButton") and OptInTab:FindFirstChild("Chosen") and OptInTab:FindFirstChild("Type") and OptInTab:FindFirstChild("Change") then

		local Change = OptInTab:WaitForChild("Change").Value
		local Type = OptInTab:WaitForChild("Type").Value
		local ChosenVal = OptInTab:WaitForChild("Chosen")
		
		local Background
		local Toggle

		
		ChosenVal.Changed:Connect(function()
			
			if Type == "Toggle" then
				Background = OptInTab:WaitForChild("Background")
				Toggle = OptInTab:WaitForChild("Toggle")

				if ChosenVal.Value then
					Toggle.Text = "[ ON ]"
					Toggle.TextColor3 = EnabledColor
					Background.BackgroundTransparency = 0
				else
					Toggle.Text = "[ OFF ]"
					Toggle.TextColor3 = DisabledColor
					Background.BackgroundTransparency = .095
				end
			end

			--------------------// WalkSpeed \\--------------------
			if Change == "WalkSpeed" then
				ChangeWalkSpeed(ChosenVal.Value)
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
			--------------------// JumpPower \\--------------------
			elseif Change == "JumpPower" then
				ChangeJumpPower(ChosenVal.Value)
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
			--------------------// Noclip \\--------------------
			elseif Change == "Noclip" then
				ToggleNoclip(ChosenVal.Value)
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
			--------------------// Float \\--------------------
			elseif Change == "Float" then
				ToggleFloat(ChosenVal.Value)
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
			--------------------// FOV \\--------------------
			elseif Change == "FOV" then
				ChangeFOV(ChosenVal.Value)
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
			--------------------// Disable Shadows \\--------------------
			elseif Change == "Disable Shadows" then
				ToggleShadows(ChosenVal.Value)
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
			--------------------// Anti Afk \\--------------------
			elseif Change == "AntiAFK" then
				ToggleAntiAfk(ChosenVal.Value)
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
			--------------------// Rejoin \\--------------------
			elseif Change == "Rejoin" then

				if not ChosenVal.Value then
					return
				end

				CreateNotification("Rejoining...", "Info", 2)
				Rejoin()
			--------------------// Server Hop \\--------------------
			elseif Change == "ServerHop" then
				if not ChosenVal.Value then
					return
				end

				CreateNotification("Server Hopping; This may take a while", "Info", 7)
				ServerHop(false)
			-------------------// Join Small Server \\--------------------
			elseif Change == "Join Small Server" then
				if not ChosenVal.Value then
					return
				end

				CreateNotification("Joining a small server; This may take a while", "Info", 7)
				ServerHop(true)
			-------------------// Low Gravity \\-------------------
			elseif Change == "Moon Gravity" then
				ToggleMoonGravity(ChosenVal.Value)
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
			-------------------// Freeze \\-------------------
			elseif Change == "Freeze" then
				ToggleFreezeHRP(ChosenVal.Value)
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
			-------------------// Dex \\-------------------
			elseif Change == "Open Dex" then
				if not ChosenVal.Value then
					return
				end

				OpenDex()
				CreateNotification("Opening Dex...", "Info", 2)
			-------------------// Collect Chests \\-------------------
			elseif Change == "Collect Chests" then
				if not ChosenVal.Value then
					return
				end

				CreateNotification("Collecting chests... (May take a while)", "Info", 20)
				CollectChests()
			-------------------// Redeem All Codes \\-------------------
			elseif Change == "Redeem All Codes" then
				if not ChosenVal.Value then
					return
				end

				CreateNotification("Redeeming all codes...", "Info", 3)
				RedeemAllCodes()
			-------------------// Maximum Rep Speed \\-------------------
			elseif Change == "Maximum Rep Speed" then
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
				ToggleMaximumRepSpeed(ChosenVal.Value)
			-------------------// Auto Rep \\-------------------
			elseif Change == "Auto-Rep" then
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
				ToggleAutoRep(ChosenVal.Value)
			-------------------// Auto Rebirth \\-------------------
			elseif Change == "Auto-Rebirth" then
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
				ToggleAutoRebirth(ChosenVal.Value)
			-------------------// Farm Durability \\-------------------
			elseif Change == "Farm Durability" then
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
				ToggleFarmDurability(ChosenVal.Value)
			-------------------// Auto-Kill \\-------------------
			elseif Change == "Auto-Kill" then
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
				ToggleAutoKill(ChosenVal.Value)
			-------------------// Glitch Equipped Pets \\-------------------
			elseif Change == "Glitch Pets" then
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
				ToggleGlitchPets(ChosenVal.Value)
			-------------------// Keep Tempanel \\-------------------
		elseif Change == "Keep Tempanel" then
				ChangeSetting("KeepTempanel", ChosenVal.Value)
				CreateNotification(Change.." changed to "..tostring(ChosenVal.Value), "Success", 2)
				ToggleKeepTempanel(ChosenVal.Value)
			end
		end)
	end

end

----------------------------------------// Notifications \\----------------------------------------
CreateNotification("Welcome, "..LocalPlayer.Name.."!", "Info", 3)
