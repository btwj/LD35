Cutscene = {}

function Cutscene:new(messages, callback)
	local beep = love.audio.newSource("sounds/beep2.wav", "static")
	beep:setVolume(0.1)
	beep:setPitch(2)
	local obj = {
		timer = 0,
		messages = messages,
		letter = 1,
		messageNo = 1,
		text = "",
		paused = false,
		callback = callback,
		beep = beep
	}
	self.__index = self
	return setmetatable(obj, self)
end

function Cutscene:draw()
	love.graphics.setBackgroundColor(0, 0, 0)
	love.graphics.printf(self.text .. "|", 20, 20, love.graphics.getWidth() - 20*2)
end

function Cutscene:update(dt)
	if not self.paused then
		self.timer = self.timer + dt
	end

	if self.timer > 0.02 and self.letter <= #self.messages[self.messageNo] then
		self.text = self.text .. string.sub(self.messages[self.messageNo], self.letter, self.letter)
		self.letter = self.letter + 1
		self.timer = 0
		self.beep:play()
	end

	if self.timer > 0.8 then
		self.text = self.text .. "\n\n"
		self.letter = 1
		self.messageNo = self.messageNo + 1
		self.timer = 0
		if self.messageNo > #self.messages then
			self.paused = true
			self.callback()
		end
	end
end