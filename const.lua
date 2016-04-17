c = {}

c.QUOTES = {
	secretagent = {"I shall be neither seen, nor heard.", "NO TOUCHING!", "These are my awards, mother. From army.", "The seal is for marksmanship.", "The gorilla is for sand racing."},
	davidcameron = {"Me? And a pig? Ha.", "Taxes? Those are optional right?"},
	billclinton = {"It's the reptilians, stupid.", "I did not have reptilian relations.", "For reptiles, for a change."},
	hillaryclinton = {"I'm with... me?", "Ha. Hahaha. Reptile? Pssh."},
	barackobama = {"Change we need.", "Yes sss we can.", "I was not born on another planet."},
	secretagent2 = {"Pew pew.", "I've crushed a squirrel once. Fear me.", "Don't test me.", "I could shoot you now.", "They're putting me in something called Hero Squad."},
	queenelizabeth = {"Cup of tea please.", "Some cookies, dear."},
	queensguard = {"Make way for the Queen's guard!", "..."},
	lizardperson = {"Hss! HSSSS!"}
}

c.COSTUMES = {"secretagent", "davidcameron", "billclinton", "hillaryclinton", "barackobama", "secretagent2", "queenelizabeth", "queensguard", "lizardperson"}
c.COSTUME_IMAGES = {}
c.IMG_PARTICLE = love.graphics.newImage("img/ui/particle.png")
c.IMG_BUBBLE = love.graphics.newImage("img/ui/bubble.png")
c.IMG_BUBBLE:setFilter("nearest", "nearest")
c.SFX_SWITCH = love.audio.newSource("sounds/switch.wav", "static")
c.SFX_TRANSFORM = love.audio.newSource("sounds/transform.wav", "static")
c.SFX_STRIKE = love.audio.newSource("sounds/hit.wav", "static")
c.SFX_SWITCH:setVolume(0.2)
c.SFX_TRANSFORM:setVolume(0.1)
c.SFX_STRIKE:setVolume(0.2)

c.BTN_CAPTURE = love.graphics.newImage("img/ui/btn_capture.png")
c.BTN_CAPTURE_HOVER = love.graphics.newImage("img/ui/btn_capture_hover.png")
c.BTN_MARKER = love.graphics.newImage("img/ui/btn_place_marker.png")
c.BTN_MARKER_HOVER = love.graphics.newImage("img/ui/btn_place_marker_hover.png")
c.BTN_VIS = love.graphics.newImage("img/ui/btn_vis.png")
c.BTN_VIS_TOGGLE = love.graphics.newImage("img/ui/btn_vis_toggle.png")
c.BTN_CAPTURE:setFilter("nearest", "nearest")
c.BTN_CAPTURE_HOVER:setFilter("nearest", "nearest")
c.BTN_MARKER:setFilter("nearest", "nearest")
c.BTN_MARKER_HOVER:setFilter("nearest", "nearest")
c.BTN_VIS:setFilter("nearest", "nearest")
c.BTN_VIS_TOGGLE:setFilter("nearest", "nearest")

for i, costume in ipairs(c.COSTUMES) do
	c.COSTUME_IMAGES[costume] = love.graphics.newImage("img/characters/" .. costume .. ".png")
	c.COSTUME_IMAGES[costume]:setFilter("nearest", "nearest")
end