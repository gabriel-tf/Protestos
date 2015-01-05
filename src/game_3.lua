
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
--local screenW, screenH, halfW, halfY = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5


--Tela
local W = display.contentWidth  -- Pega a largura da tela
local H = display.contentHeight -- Pega a altura da tela
local center_x = display.contentCenterX
local center_y = display.contentCenterY

local loadsave = require("loadsave")

display.setStatusBar(display.HiddenStatusBar)

require "sprite"

-- F�sica

local physics = require('physics')
physics.start()
physics.setGravity(0, 0)
--physics.setDrawMode('hybrid')

-- Status Game
local statusGame

-- Graficos
local data_sheet = {
	width = 38,
	height = 50,
	sheetContentWidth = 115,
	sheetContentHeight = 200,
	numFrames = 12
}

--animation data
local data_sprite = {
	{
		name = 'walking_down',
		frames= { 1, 2, 3},
		time = 300,
		loopCount = 1
	},
	{
		name = 'walking_left',
		frames= { 4, 5, 6},
		time = 300,
		loopCount = 1
	},
	{
		name = 'walking_right',
		frames= { 7, 8, 9},
		time = 300,
		loopCount = 1
	},
	{
		name = 'walking_up',
		frames= { 10, 11, 12},
		time = 300,
		loopCount = 1
	},
	{
		name = 'stop',
		frames = {12},
		time = 1
	}
}
-- Menu Background

local bg

-- Sound

local sound_background
local sound_lose
local sound_goal

-- Buttons in Game
local backBtn

-- Game Background

local gameBg
local policia
local manifestantes
local barraIngame

-- Player

local player

-- Setas

local up
local left
local down
local right

-- Alert

local alertView

-- Variables
local setas
local obstacles
local counter = 0
local myText
local time
local gameTime
local score

-- Fun��es

local addObstacle = {}
local movePlayer = {}
local update = {}
local onCollision = {}
local alert = {}
local timerStart = {}
local gameOver = {}

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	statusGame = 'playing'

	sound_goal = audio.loadSound( 'sound/goal.mp3')		
	sound_lose = audio.loadSound( 'sound/gameover.mp3')
	sound_background = audio.loadStream( 'sound/background.mp3')
	
	audio.play( sound_background, { loop = -1 })

	-- Game Background

	gameBg = display.newImage('images/rua_3.png',0, -45)
	group:insert(gameBg)

	-- Obstaculos

	obstacles = display.newGroup()

			addObstacle(200, 50, 'images/rock', false, 'l', 'stuff')
			addObstacle(100, 230, 'images/rock2', false, 'l', 'stuff')
			addObstacle(0, 230, 'images/rock', false, 'l', 'stuff')
			addObstacle(184, 140, 'images/rock2', false, 'l', 'stuff')
			addObstacle(4, 50, 'images/rock2', false, 'l', 'stuff')
			addObstacle(300, 320, 'images/rock', true, 'l', 'stuff')
			addObstacle(150, 320, 'images/rock2', true, 'l', 'stuff')
			
			addObstacle(200, 0, 'images/grenede2', true, 'r', 'stuff')
			addObstacle(80, 0, 'images/grenede', true, 'r', 'stuff')
			addObstacle(70, 177, 'images/grenede2', true, 'r', 'stuff')
			addObstacle(150, 177, 'images/grenede', true, 'r', 'stuff')
			addObstacle(75, 270, 'images/grenede2', true, 'r', 'stuff')
			addObstacle(300, 270, 'images/grenede2', true, 'r', 'stuff')
			addObstacle(0, 90, 'images/grenede2', true, 'r', 'stuff')
			addObstacle(204, 90, 'images/grenede', true, 'r', 'stuff')

	group:insert(obstacles)

	local g1= display.newImage("images/chegada.png", 0, -15)
	g1.name = 'goal'
	physics.addBody(g1, 'static')
	g1.isSensor = true
	g1.isVisible = false

	--Imagens

	policia = display.newImage('images/policia.png', -10, -45)
	physics.addBody( policia, "static" )
	group:insert(policia)

	manifestantes = display.newImage('images/manifestantes.png', 285, -45)
	physics.addBody( manifestantes, "static")
	group:insert(manifestantes)

	barraIngame = display.newImage('images/barra_ingame.png', 0, 415)
	physics.addBody( barraIngame, "static")
	group:insert(barraIngame)


	left = display.newImage('images/seta_left.png', 0, 440)
	right = display.newImage('images/seta_right.png', 55, 440)
	down = display.newImage('images/seta_down.png', 250, 470)
	up = display.newImage('images/seta_up.png', 250, 415)

	left.name =  "left"
	right.name =  "right"
	down.name =  "down"
	up.name =  "up"
	group:insert(left)
	group:insert(right)
	group:insert(down)
	group:insert(up)

	-- Player

	player_sheet = graphics.newImageSheet( 'images/jogador.png', data_sheet )

	player = display.newSprite( player_sheet, data_sprite )
	player.x = center_x
	player.y = 380
	player.x_speed = 0
	player.name = 'player'

	player:setSequence('stop')
	player:play()
	physics.addBody(player, 'dynamic',{ radius = '21'})

	gameListeners('add')
	group:insert(player)

	if "Win" == system.getInfo( "platformName" ) then
	    COMIC = "Comic Sans MS"
	elseif "Android" == system.getInfo( "platformName" ) then
	    COMIC = "2266"
	end

	time = event.params.time
	local gameTime = display.newText("Time: " .. time, 130, 493, COMIC, 20)
	gameTime:setTextColor(200,200,200)
	group:insert(gameTime)

	function timerStart()
		if statusGame == 'playing' then
			time = time + 1
			gameTime.text = "Time: " .. time
		end
	end
		timerInGame = timer.performWithDelay(1000, timerStart, 0)
end

function gameListeners(action)
	if(action == 'add') then
		Runtime:addEventListener('enterFrame', update)
		up:addEventListener('tap', movePlayer)
		left:addEventListener('tap', movePlayer)
		down:addEventListener('tap', movePlayer)
		right:addEventListener('tap', movePlayer)
		player:addEventListener('collision', onCollision)
	else
		Runtime:removeEventListener('enterFrame', update)
		up:removeEventListener('tap', movePlayer)
		left:removeEventListener('tap', movePlayer)
		down:removeEventListener('tap', movePlayer)
		right:removeEventListener('tap', movePlayer)
		player:removeEventListener('collision', onCollision)
	end
end


function addObstacle(X, Y, graphic, inverted, dir, name)
	local c = display.newImage(graphic .. '.png', X, Y)
	c.dir = dir
	c.name = name

	--Rotate graphic if going right

	if(inverted) then
		c.xScale = -1
	end

	-- F�sica

	physics.addBody(c, 'static', {radius='15'})
	c.isSensor = true

	obstacles:insert(c)
end

-- Move Player

function movePlayer(e)
	if(e.target.name == 'up') then
		transition.to(player,{time = 200, y = player.y - 31,})
		player:setSequence('walking_up')
		player:play()
	elseif(e.target.name == 'left') then
		transition.to(player,{time = 200, x = player.x - 31,})
		player:setSequence('walking_left')
		player:play()
	elseif(e.target.name == 'down') then
		transition.to(player,{time = 200, y = player.y + 31,})
		player:setSequence('walking_down')
		player:play()
	elseif(e.target.name == 'right') then
		transition.to(player,{time = 200, x = player.x + 31,})
		player:setSequence('walking_right')
		player:play()
	end

	if (player.x < 5) then
		player.x = W
	elseif(player.x > W) then
		player.x = 0
	end
end

function update()
	-- Move Obstaculos

	for i = 1, obstacles.numChildren do
		if(obstacles[i].dir == 'l') then
			obstacles[i].x = obstacles[i].x  - 2.6

		else
			obstacles[i].x = obstacles[i].x + 2.6
		end

		-- Carrega os obstaculos quando eles saem do est�gio
		--Direita
		if(obstacles[i].dir == 'r' and obstacles[i].x > display.contentWidth + (obstacles[i].width * 0.5)) then
			obstacles[i].x = -(obstacles[i].width * 0.5)
		end

		-- Carrega os obstaculos quando eles saem do est�gio
		--Esquerda
		if(obstacles[i].dir == 'l' and obstacles[i].x < -(obstacles[i].width * 0.5)) then
			obstacles[i].x = display.contentWidth + (obstacles[i].width * 0.5)
		end
	end
end

function onCollision(e)
	if(e.other.name == 'stuff') then
		display.remove(e.target)
		audio.stop()
		audio.play(sound_lose)
		alert('lose')
	elseif(e.other.name == 'goal') then
		display.remove(e.target)
		audio.stop()
		counter = counter + 1
	end

	if(counter == 1) then
		alert()
	end
end

local function returnToMenuTouch(event)
	if(event.phase == "began") then
		storyboard.gotoScene("menu", "fade", "1000")
	end
	display.remove(menuBtn)
	display.remove(backBtn)
	display.remove(alertView)
end

local function returnToGameTouch(event)
		if(event.phase == "began") then
			storyboard.gotoScene("game", "fade", "300")
		end
		display.remove(menuBtn)
		display.remove(backBtn)
		display.remove(alertView)
end

function alert(action)
	gameListeners('rmv')
	display.remove(obstacles)
	if(action == 'lose') then
		timer.pause(timerInGame)
		alertView = display.newImage('images/lose.png', 90, 300)
		menuBtn = display.newImage('images/menu_button.png', 55, 360)
		backBtn = display.newImage('images/again_button.png', 175, 360)

		menuBtn:addEventListener("touch", returnToMenuTouch)
		backBtn:addEventListener("touch", returnToGameTouch)

	else		
		timer.pause(timerInGame)
		
		score = {}
		score.time = time
		loadsave.saveTable(score,"score.json")

		storyboard.gotoScene("win", "fade", "3000")
	end

	transition.from(alertView, {time = 200, alpha = 0.1})

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	if storyboard.getPrevious() ~= nil then
		storyboard.removeScene(storyboard.getPrevious())
	end

end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene