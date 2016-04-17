require "stage"

Level = {}

function Level:new()
	vis = false
	local obj = {
		stage = {},
		cycle = 0,
		level = 1,
		state = "fadein",
		captured = {},
		curMarker = 0,
		curMarkerId = 0,
		marked = {},
		blackoutTimer = 0.0,
		fadeOutTimer = 0.0,
		fadeInTimer = 0.0,
		data = {
			{peopleData = {{"secretagent", "hillaryclinton", "billclinton"}, {"secretagent"}, {"billclinton"}},
			 info = {shapeshifters = 1, text = "Shapeshifters: 1\nOur intel says this shapeshifter, unfortunately, suffered damage to his brain. Not the brightest one."}},
			{peopleData = {{"barackobama", "secretagent", "billclinton"}, {"secretagent"}, {"hillaryclinton"}},
			 info = {shapeshifters = 1, text = "Shapeshifters: 1\nThis shapeshifter's a little smarter, but not by much."}},
			{peopleData = {{"secretagent", "secretagent2"}, {"secretagent"}, {"secretagent"}, {"secretagent"}, {"secretagent2"}},
			 info = {shapeshifters = 1, markers = 1, text = "Shapeshifters: 1\nMarkers: 1\nWe've provided you a marker, which lets you make a permanent mark on someone."}},
			{peopleData = {{"secretagent", "davidcameron"}, {"secretagent"}, {"davidcameron", "secretagent"}},
			 info = {shapeshifters = 2, text = "Shapeshifters: 2\nTwo shapeshifters! Can you do it?"}},
			{peopleData = {{"billclinton", "davidcameron", "hillaryclinton"}, {"davidcameron", "hillaryclinton"}, {"hillaryclinton"}, {"billclinton"}},
			 info = {shapeshifters = 2, markers = 1, text = "Shapeshifters: 2\nMarkers: 1\nA sticky situation."}},
			{peopleData = {{"secretagent", "secretagent", "secretagent2"}, {"secretagent", "secretagent2"}, {"secretagent"}, {"secretagent2"}},
			 info = {shapeshifters = 2, markers = 2, markerType = "unique", text = "Shapeshifters: 2\nMarkers: 2 [UNIQUE]\nTwo different markers now."}},
			{peopleData = {{"secretagent", "secretagent2"}, {"secretagent2", "secretagent"}, {"secretagent"}, {"secretagent2"}},
			 info = {shapeshifters = 2, markers = 2, markerType = "identical", text = "Shapeshifters: 2\nMarkers: 2 [IDENTICAL]\nOops, we ran out of unique markers. Here, have two identical ones."}},
			{peopleData = {{"secretagent", "queensguard"}, {"secretagent", "queensguard"}, {"secretagent", "queensguard"}, {"secretagent"}, {"queensguard"}},
			 info = {shapeshifters = 3, markers = 1, markerType = "unique", text = "Shapeshifters: 3\nMarkers: 1\nThis situation was not helped by the identically dressed secret agents."}},
			{peopleData = {{"barackobama", "queenelizabeth"}, {"barackobama", "queenelizabeth"}, {"barackobama", "queenelizabeth"}, {"barackobama"}, {"queenelizabeth", "barackobama"}, {"queenelizabeth", "barackobama"}, {"queenelizabeth", "barackobama"}},
			 info = {shapeshifters = 6, text = "Shapeshifters: 6\nWhere did our markers go? I swear I placed them here somewhere."}},
		}
	}
	self.__index = self
	return setmetatable(obj, self)
end

function Level:load(level)
	self.cycle = 0
	self.level = level
	self.stage = nil
	self.stage = Stage:new(self:getPeopleTable())
	self.stage:load()
end

function Level:draw()
	love.graphics.setColor(0, 0, 0, 200)
	local textWidth = 360
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 130)
	love.graphics.setColor(255, 255, 255)
	if self.level == 1 and self.cycle == 0 then
		love.graphics.printf("This is your first mission.\nClick to select a character.\n[space] to turn off the lights.\nToggle VIS for a clearer view.", 20, 20, textWidth)
	elseif self.level == 1 or self.cycle >= 0 then
		love.graphics.printf(self.data[self.level].info.text, 20, 20, textWidth)
	end
	if self.state == "idle" or self.state == "fadeout" or self.state == "fadein" then
		self.stage:draw()
		if self.stage.highlighted ~= nil then
			local mx, my = love.mouse.getPosition()
			if mx >= 176 and mx <= 176 + 128 and my >= 280 and my <= 280 + 64 then
				love.graphics.draw(c.BTN_CAPTURE_HOVER, 176, 280, 0, 2, 2)
			else 
				love.graphics.draw(c.BTN_CAPTURE, 176, 280, 0, 2, 2)
			end
			if self.data[self.level].info.markers then
				if mx >= 176 - 64 - 8 and mx <= 176 - 8 and my >= 280 and my <= 280 + 64 then
					love.graphics.draw(c.BTN_MARKER_HOVER, 176 - 64 - 8, 280, 0, 2, 2)
				else
					love.graphics.draw(c.BTN_MARKER, 176 - 64 - 8, 280, 0, 2, 2)
				end
			end
		end
	elseif self.state == "blackout" then
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(255, 255, 255)
	end
	if not vis then
		love.graphics.draw(c.BTN_VIS, love.graphics.getWidth() - 64 - 16, 16, 0, 2, 2)
	else
		love.graphics.draw(c.BTN_VIS_TOGGLE, love.graphics.getWidth() - 64 - 16, 16, 0, 2, 2)
	end
	if self.state == "fadeout" then
		love.graphics.setColor(0, 0, 0, self.fadeOutTimer * 255)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(255, 255, 255)
	elseif self.state == "fadein" then
		love.graphics.setColor(0, 0, 0, (0.5 - self.fadeInTimer)/0.5 * 255)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(255, 255, 255)
	end
end

function Level:update(dt)
	self.stage:update(dt)
	local mx, my = love.mouse.getPosition()
	if self.state == "blackout" then
		self.blackoutTimer = self.blackoutTimer + dt
		if self.blackoutTimer > 0.3 then
			self.state = "idle"
			self.blackoutTimer = 0
			self.stage:toggleVis(vis, #self.captured)
		end
	end
	if self.state == "fadeout" then
		self.fadeOutTimer = self.fadeOutTimer + dt
		if (self.fadeOutTimer > 1) then
			nextLevel()
		end
	end
	if self.state == "fadein" then
		self.fadeInTimer = self.fadeInTimer + dt
		if (self.fadeInTimer > 0.5) then
			self.state = "idle"
		end
	end
end

function Level:nextCycle()
	self.state = "blackout"
	c.SFX_SWITCH:play()
	self.cycle = self.cycle + 1
	self.stage = Stage:new(self:getPeopleTable())
	self.stage:load()
	for i, character in ipairs(self.stage.characters) do
		if self.marked[character.id] then
			character:addMarker(self.marked[character.id])
		end
		for j, id in ipairs(self.captured) do
			if character.id == id then
				character.dead = true
			end
		end
	end
	
end

function Level:getPeopleTable()
	local people = {}
	local peopleData = self.data[self.level].peopleData
	for i, person in ipairs(peopleData) do
		table.insert(people, person[self.cycle % #person + 1])
	end
	return people
end

function Level:mousepressed(mx, my, button)
	if self.data[self.level].info.markers and mx >= 176 - 64 - 8 and mx <= 176 - 8 and my >= 280 and my <= 280 + 64 and self.curMarker < self.data[self.level].info.markers then
		
		if self.stage.highlighted ~= nil and not self.stage.characters[self.stage.highlighted.id].marker then
			local curCharacter = self.stage.characters[self.stage.highlighted.id]
			curCharacter:addMarker(self.curMarkerId)
			self.marked[curCharacter.id] = self.curMarkerId
			self.curMarker = self.curMarker + 1
			if self.data[self.level].info.markerType == "unique" then
				self.curMarkerId = self.curMarkerId + 1
			end

		end
	end
	if mx >= love.graphics.getWidth() - 64 - 16 and mx <= love.graphics.getWidth() - 16 and my >= 16 and my <= 16 + 64 then
		vis = not vis
		self.stage:toggleVis(vis, #self.captured)
	elseif not(mx >= 176 and mx <= 176 + 128 and my >= 280 and my <= 280 + 64) then
		self.stage.highlighted = nil
		if not vis then
			self.stage:unfreeze()
		end
	end
end

function Level:mousereleased(mx, my, button)
	local stage = self.stage
	if mx >= 176 and mx <= 176 + 128 and my >= 280 and my <= 280 + 64 then
		if stage.highlighted ~= nil then
			if #self.data[self.level].peopleData[stage.highlighted.id] > 1 then
				table.insert(self.captured, stage.highlighted.id)
				stage.highlighted:transform()
				c.SFX_TRANSFORM:play()
				stage.highlighted = nil
				if #self.captured == self.data[self.level].info.shapeshifters then
					self.state = "fadeout"
				end
			else
				strikes = strikes + 1
				c.SFX_STRIKE:play()
			end
		end
	end
end