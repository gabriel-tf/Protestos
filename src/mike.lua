
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------
local menuBtn

display.setStatusBar(display.HiddenStatusBar)

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local bg = display.newImage('images/story.png', 0, -45)
		group:insert(bg)
	
	-- 'onRelease' event listener for playBtn
	local function onGameBtnRelease()
		-- go to level1.lua scene
		storyboard.gotoScene( "game", "fade")	
		--return true	-- indicates successful touch
	end

	-- create a widget button (which will loads level1.lua on release)
	local menuBtn = widget.newButton{	
		defaultFile = "images/playBtn.png", 
    	--overFile = "Button_Purple.png",
		left=134, top=467,
		onRelease = onGameBtnRelease -- event listener function
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