
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

local menuBtn

display.setStatusBar(display.HiddenStatusBar)


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local bg = display.newImage('images/bg.png', 0, -45)
		group:insert(bg)
	
	-- place a game title on the screen
	local gametitle = display.newImage("images/title.png", 64, 70)		
		group:insert( gametitle )
	
	-- 'onRelease' event listener for playBtn
	local function onMenuBtnRelease()
		-- go to level1.lua scene
		storyboard.gotoScene( "menu", "slideLeft")	
		--return true	-- indicates successful touch
	end

	if "Win" == system.getInfo( "platformName" ) then
	    COMIC = "Comic Sans MS"
	elseif "Android" == system.getInfo( "platformName" ) then
	    COMIC = "2266"
	end

		score = loadsave.loadTable("score.json")
		print('-----')
		for k, v in pairs(score) do
			print(k, v)
			if (v < 20) then 
				local options = 
				{
				   text = "Score:".. v,    
				    x = 165,
				    y = 250,  
				    fontSize = 30
				}
				local myText = display.newText( options )
				local grade = display.newText( "Awesome", 70, 300, COMIC, 40 )				
				group:insert(myText)
				group:insert(grade)
			
			elseif (v < 30) then
				local options = 
				{
				   text = "Score:".. v,    
				    x = 165,
				    y = 250,  
				    fontSize = 28
				}
				local myText = display.newText( options )
				local grade = display.newText( "Great", 105, 300, COMIC, 40 )				
				group:insert(myText)
				group:insert(grade)
			
			elseif (v < 40) then
				local options = 
				{
				   text = "Score:".. v,    
				    x = 165,
				    y = 250,  
				    fontSize = 28,
				}
				local myText = display.newText( options )
				local grade = display.newText( "Cool", 117, 300, COMIC, 40 )				
				group:insert(myText)
				group:insert(grade)
			
			elseif (v < 50) then
				local options = 
				{
				   text = "Score:".. v,    
				    x = 165,
				    y = 250,  
				    fontSize = 28,
				}
				local myText = display.newText( options )
				local grade = display.newText( "You are better than that!", 15, 300, COMIC, 25 )				
				group:insert(myText)
				group:insert(grade)
			
			elseif (v > 50) then
				local options = 
				{
				   text = "Score:".. v,    
				    x = 165,
				    y = 250,  
				    fontSize = 28,
				}
				local myText = display.newText( options )
				local grade = display.newText( "Never give up!", 65, 300, COMIC, 30 )				
				group:insert(myText)
				group:insert(grade)			
			end		
		end
		
	local menuBtn = widget.newButton{	
		defaultFile = "images/voltarBtn.png", 
    	--overFile = "Button_Purple.png",
		left=134, top=395,
		onRelease = onMenuBtnRelease -- event listener function
	}
	group:insert(menuBtn)
	
	
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
	
	if menuBtn then
		menuBtn:removeSelf()	-- widgets must be manually removed
		menuBtn = nil
	end
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