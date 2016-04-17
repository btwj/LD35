require "character"

Stage = {}

function Stage:new(people)
	local obj = {
		people = people,
		highlighted = nil,
		characters = {}
	}
	self.__index = self
	return setmetatable(obj, self)
end

function Stage:load()
	love.graphics.setBackgroundColor(255, 255, 255)
	for i, person in ipairs(self.people) do
		table.insert(self.characters, Character:new(person, i))
	end
end

function Stage:freeze()
	for i, character in ipairs(self.characters) do
		character.state = "frozen"
	end
end

function Stage:unfreeze()
	for i, character in ipairs(self.characters) do
		character.state = "idle"
	end
end

function Stage:draw()
	
	local mx, my = love.mouse.getPosition()
	local minId = 0
	local minDist = 20
	if self.highlighted == nil then
		if math.abs(my - 250) < 50 then
			for i, character in ipairs(self.characters) do
				if math.abs(character.x - mx) < minDist and not character.dead then
					minDist = math.abs(character.x - mx)
					minId = i
				end
			end
			if love.mouse.isDown(1) and minId ~= 0 then
				self.highlighted = self.characters[minId]
			end
		end
	end
	for i, character in ipairs(self.characters) do
		if i == minId or self.highlighted ~= nil and i == self.highlighted.id then
			character:draw(true)
		else
			character:draw(false)
		end
	end
end

function Stage:update(dt)
	if self.highlighted ~= nil then
		self:freeze()
	end
	for i, character in ipairs(self.characters) do
		character:update(dt)
	end
end

function Stage:toggleVis(vis, captured)
	local function shuffle(t)
		for i = #t, 2, -1 do
		local j = math.random(i)
		t[i], t[j] = t[j], t[i]
		end
	end

	local correspondence = {}
	for i = 1, #self.characters do
		table.insert(correspondence, i)
	end

	shuffle(correspondence)

	if vis then
		local counter = 1
		local width = (love.graphics.getWidth()) / (#self.characters - captured + 1)
		for i, id in ipairs(correspondence) do
			if not self.characters[id].dead then
				self.characters[id].x = counter * width
				self.characters[id].state = "frozen"
				counter = counter + 1
			end
		end
	else
		if self.highlighted == nil then
			self:unfreeze();
		end
	end
end