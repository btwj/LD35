Character = {}

function Character:new(costume, id)
	padding = 20
	length = 0.8
	local psystem = love.graphics.newParticleSystem(c.IMG_PARTICLE)
	psystem:setParticleLifetime(0.2, 0.5)
	psystem:setLinearAcceleration(-20, -5, 20, 200)
	psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
	psystem:setAreaSpread("normal", 10, 10)
	local obj = {
		id = id,
		x = love.math.random(padding, love.graphics.getWidth() - padding), 
		state = "idle",
		dir = 1,
		image = c.COSTUME_IMAGES[costume],
		costume = costume,
		marker = false,
		markerId = -1,
		markerImage = nil,
		dead = false,
		cloud = psystem,
		fade = false,
		fadeTimer = 0.0,
		speaking = false,
		curQuote = "",
		curQuoteWidth = 0,
		quoteTimer = 0.0
	}
	self.__index = self
	return setmetatable(obj, self)
end

function Character:update(dt)
	self.cloud:update(dt)
	if self.fade then
		self.fadeTimer = self.fadeTimer + dt
		if self.fadeTimer > length then
			self.fade = false
			self.dead = true
		end
	end

	if love.math.random() < 0.001 and not self.speaking then
		self.curQuote = c.QUOTES[self.costume][love.math.random(#c.QUOTES[self.costume])]
		self.curQuoteWidth = font:getWidth(self.curQuote)
		self.speaking = true
	end

	if self.speaking then
		self.quoteTimer = self.quoteTimer + dt
	end
	
	if self.speaking and self.quoteTimer > 2 then
		self.quoteTimer = 0
		self.speaking = false
	end

	if self.state == "frozen" then 
		return
	end
	if self.state == "walking" then
		self.x = self.x + self.dir * dt * 50
		if love.math.random() < 0.01 then
			self.state = "idle"
		end
		if self.x < padding then
			self.x = padding
			self.dir = 1
		elseif self.x > love.graphics.getWidth() - padding then
			self.x = love.graphics.getWidth() - padding
			self.dir = -1
		end
	elseif love.math.random() < 0.02 then
		self.state = "walking"
		if love.math.random() < 0.5 then
			self.dir = -1
		else
			self.dir = 1
		end
	end

end

function Character:addMarker(markerId)
	self.marker = true
	self.markerId = markerId
	self.markerImage = love.graphics.newImage("img/ui/marker_" .. self.markerId .. ".png")
	self.markerImage:setFilter("nearest", "nearest")
end

function Character:transform()
	self.costume = "lizardperson"
	self.image = c.COSTUME_IMAGES[self.costume]
	self.cloud:emit(100)
	self.fade = true
end

function Character:draw(highlighted)
	if self.dead then
		return
	end

	local y = 0
	if not highlighted then
		y = 180
	else
		y = 160
	end
	love.graphics.setColor(0, 0, 0, 60)
	love.graphics.ellipse("fill", self.x, 180 + self.image:getHeight()*2, 18, 6)

	if self.fade then
		love.graphics.setColor(255, 255, 255, (length - self.fadeTimer)/length * 255)
	else
		love.graphics.setColor(255, 255, 255, 255)
	end
	love.graphics.draw(self.image, self.x, y, 0, 2 * self.dir, 2, self.image:getWidth()/2)

	

	if self.marker then
		love.graphics.draw(c.IMG_BUBBLE, self.x, y - c.IMG_BUBBLE:getHeight() - 48, 0, 2, 2, c.IMG_BUBBLE:getWidth()/2)
		love.graphics.draw(c.IMG_BUBBLE, self.x, y - c.IMG_BUBBLE:getHeight() - 48 + 16, 0, 2, 2, c.IMG_BUBBLE:getWidth()/2)
	end

	love.graphics.setColor(255, 255, 255, 255)

	if self.speaking then
		local quotePadding = 5
		local qx = 0
		local sWidth = love.graphics.getWidth()
		if self.x < sWidth / 2 then
			if self.x < (self.curQuoteWidth + quotePadding * 2)/2 then
				qx = 0
			else
				qx = self.x - (self.curQuoteWidth + quotePadding * 2)/2
			end
		else
			if self.x > sWidth - (self.curQuoteWidth + quotePadding * 2)/2 then
				qx = sWidth - (self.curQuoteWidth + quotePadding * 2)
			else
				qx = self.x - (self.curQuoteWidth + quotePadding * 2)/2
			end
		end
		love.graphics.rectangle("fill", qx, y - 40, self.curQuoteWidth + quotePadding * 2, 10 + quotePadding * 2)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle("line", qx, y - 40, self.curQuoteWidth + quotePadding * 2, 10 + quotePadding * 2)
		love.graphics.print(self.curQuote, qx + quotePadding, y - 40);
		love.graphics.line(self.x, y - 40 + 10 + quotePadding * 2, self.x, y)
		love.graphics.setColor(255, 255, 255, 255)
	end

	love.graphics.draw(self.cloud, self.x, y + 20)
end