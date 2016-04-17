require "character"
require "level"
require "cutscene"

state = ""
strikes = 0
cutsceneNo = 1
cutscenes = {
	{"Greetings, soldier."},
	{"Our investigative branch has recently discovered that shapeshifting reptilians have infiltrated the highest ranks of our leadership, and are taking control.",
	"You have been transferred to our newly formed division: The Reptilian Elimination Squad.",
	"Stop questioning the story, I was desperate."},
	{"Your goal is to find and eliminate shapeshifters in each room.",
	 "These reptiles will shapeshift whenever the lights are toggled off and on.",
	 "On further research, we have found that these reptiles always shapeshift in specific, repeated patterns."},
	{"Hurt any of our finest people, you'll be punished. Three strikes and you're out.", "Good luck, soldier."}
}
levelNo = 1
bgImg = love.graphics.newImage("img/ui/background.png")
gameOverImg = love.graphics.newImage("img/ui/gameover.png")
gameOverImg:setFilter("nearest", "nearest")
gameWinImg = love.graphics.newImage("img/ui/gamewin.png")
gameWinImg:setFilter("nearest", "nearest")
bgImg:setFilter("nearest", "nearest")
font = love.graphics.newFont("fonts/Munro.ttf", 20)
paused = false
gameOver = false
gameWon = false

function nextCutscene()
	cutsceneNo = cutsceneNo + 1
	if cutsceneNo > #cutscenes then
		level = Level:new()
		level:load(1)
		state = "level"
	end
	cutscene = Cutscene:new(cutscenes[cutsceneNo], nextCutscene)
end

function nextLevel()
	levelNo = levelNo + 1
	if levelNo > #level.data then
		gameWin = true
		paused = true
		return
	end
	level = Level:new()
	level:load(levelNo)
end

function love.load()
	love.graphics.setFont(font)
	state = "cutscene"
	cutscene = Cutscene:new(cutscenes[cutsceneNo], nextCutscene)
end

function love.draw()
	
	if state == "level" then
		love.graphics.draw(bgImg, 0, 0, 0, 2, 2)
		level:draw()
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf("Strikes: " .. strikes, love.graphics.getWidth() - 120, love.graphics.getHeight() - 40, 100, "right")
		love.graphics.setColor(255, 255, 255)
	elseif state == "cutscene" then
		cutscene:draw()
	end

	if paused then
		love.graphics.setColor(0, 0, 0, 230)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(255, 255, 255)
	end

	if gameOver then
		love.graphics.draw(gameOverImg, 0, 0, 0, 2, 2)
	elseif gameWon then
		love.graphics.draw(gameWinImg, 0, 0, 0, 2, 2)
	end
end

function love.update(dt)
	if not paused then
		if state == "level" then
			level:update(dt)
		elseif state == "cutscene" then
			cutscene:update(dt)
		end
	end

	if strikes >= 3 then
		paused = true
		gameOver = true
	end
end

function love.keypressed(key, scancode, isrepeat)
	if state == "level" and key == "space" and level.state == "idle" and not paused then
		level:nextCycle()
	end
end

function love.mousepressed(x, y, button, istouch)
	if state == "level" and not paused then
		level:mousepressed(x, y, button)
	elseif state == "cutscene" then
		nextCutscene()
	end
end

function love.mousereleased(x, y, button, istouch)
	if state == "level" and not paused then
		level:mousereleased(x, y, button)
	end
end

