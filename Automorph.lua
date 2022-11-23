--\\===================================================================================//--

local morphs = game:GetService("ServerStorage"):WaitForChild("Morphs")

local Divisions = {
	EA = {5733198, "EA", "Emperor's Assassins"};
	DHG = {5649290, "DHG", "Dark Honor Guards"}; -- 5649290
	DM = {5649284, "DM", "Dread Masters"};
	II = {5649292, "II", "Imperial Intelligence"};
	IQ = {5649287, "IQ", "Inquisitors"};
}

--\\ Place newly made morphs into the morph location in ServerStorage and follow the layout: 
-- In morphsTable: whatevernamedoesntmatter = {morphs["has to be morphs name"], group rank of individual group as id};< also use semicolon at the end
-- Multiple are possible in one line, not the same rank id tho

local morphsTable = {

	MainMorphs = {

	};

	EA = {

	};

	DHG = {
		DHG_Commander = {morphs["DHG Commander"], 255};
	};

	DM = {

	};


	II = {

	};

	IQ = {

	};
}

function acremove(dachar)
	for _,Accessory in pairs(dachar:GetChildren()) do
		if Accessory:IsA("Accessory") then
			Accessory:Destroy()
		end
	end
end

game.Players.PlayerAdded:Connect(function(plr)
	local morphToUse = nil


	plr.CharacterAdded:Connect(function(char)

		for _, q in pairs(morphsTable.MainMorphs) do
			if plr:GetRankInGroup(5545421) == q[2] and plr.Team.Name == "The Sith Order" then
				morphToUse = q[1]
			end
		end

		for i, v in pairs(Divisions) do
			if plr:IsInGroup(v[1]) and plr.Team.Name == v[3] then
				for x,y in pairs(morphsTable[v[2]]) do
					if plr:GetRankInGroup(v[1]) == y[2] then
						morphToUse = y[1]
					end
				end
			end
		end

		if morphToUse == nil then 
			warn("No morphs found inside the morphsTable!")
			return end

		plr.CharacterAppearanceLoaded:Connect(function()
			acremove(char)
		end)

		local BodyPartsTable = {

			Eyes = {morphToUse.Eyes, "Head"};

			Arm1 = {morphToUse.Arm1, "Left Arm"};
			Arm2 = {morphToUse.Arm2, "Right Arm"};
			Chest = {morphToUse.Chest, "Torso"};

			Leg1 = {morphToUse.Leg1, "Left Leg"};
			Leg2 = {morphToUse.Leg2, "Right Leg"};

		}

		local function weldMorph(morphpart, bodypart)
			coroutine.resume(coroutine.create(function()
				if char:findFirstChild("Humanoid") ~= nil and char:findFirstChild(morphpart.Name) == nil then
					local g = morphpart:Clone()
					g.Parent = char
					local C = g:GetChildren()
					for i=1, #C do
						if C[i].className == "Part" or C[i].className == "UnionOperation" or C[i].className == "WedgePart" or C[i].className=="MeshPart" then
							local W = Instance.new("Weld")
							W.Part0 = g.Middle
							W.Part1 = C[i]
							local CJ = CFrame.new(g.Middle.Position)
							local C0 = g.Middle.CFrame:inverse()*CJ
							local C1 = C[i].CFrame:inverse()*CJ
							W.C0 = C0
							W.C1 = C1
							W.Parent = g.Middle
						end
						local Y = Instance.new("Weld")
						Y.Part0 = bodypart
						Y.Part1 = g.Middle
						Y.C0 = CFrame.new(0, 0, 0)
						Y.Parent = Y.Part0
					end

					local h = g:GetChildren()
					for i = 1, # h do
						if h[i].className == "Part" or  h[i].className == "UnionOperation" or C[i].className == "WedgePart" or C[i].className=="MeshPart" then
							h[i].Anchored = false
							h[i].CanCollide = false
						end
					end
				end
			end))
		end

		local h = char:WaitForChild("Humanoid")
		if h ~= nil and morphToUse:FindFirstChild("Shirt") ~= nil then
			local s = char:findFirstChild("Shirt")
			local p = char:findFirstChild("Pants")
			if s~=nil and p~=nil then
				char.Shirt:remove()
				char.Pants:remove()
				morphToUse.Shirt:clone().Parent = char
				morphToUse.Pants:clone().Parent = char
			elseif s~=nil then
				char.Shirt:remove()
				morphToUse.Shirt:clone().Parent = char
			elseif p~=nil then
				char.Pants:Remove()
				morphToUse.Pants:clone().Parent = char
			elseif s==nil and p==nil then
				morphToUse.Shirt:clone().Parent = char
				morphToUse.Pants:clone().Parent = char
			end
		else
			print("Morph does not have clothing")
		end

		coroutine.resume(coroutine.create(function()
			for i, v in pairs(BodyPartsTable) do
				weldMorph(v[1], char[v[2]])
			end
		end))
	end)
end)
