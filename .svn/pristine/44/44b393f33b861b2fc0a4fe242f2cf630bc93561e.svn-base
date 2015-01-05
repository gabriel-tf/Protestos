local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require "widget"

display.setStatusBar(display.HiddenStatusBar)


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local bg = display.newImage('images/bg.png', 0, -45)
		group:insert(bg)
	
	-- place a game title on the screen
	local gametitle = display.newImage("images/title.png", 64, 130)		
		group:insert( gametitle )
	
	-- 'onRelease' event listener for playBtn
	local function onPlayBtnRelease()
		-- go to level1.lua scene
		storyboard.gotoScene( "mike", "crossFade")	
	end
	
	local function onScoreBtnRelease()
		storyboard.gotoScene( "scores", "slideRight")	
	end
	
	local function onCreditsBtnRelease()
		storyboard.gotoScene( "creditos", "slideLeft")	
	end

	-- create a widget button (which will loads level1.lua on release)
	local playBtn = widget.newButton{	
		defaultFile = "images/playBtn.png", 
    	--overFile = "Button_Purple.png",
		left=134, top=245,
		onRelease = onPlayBtnRelease -- event listener function
	}
	group:insert(playBtn)
	
	local scoreBtn = widget.newButton{	
		defaultFile = "images/scoreBtn.png", 
    	--overFile = "Button_Purple.png",
		left=132, top=309,
		onRelease = onScoreBtnRelease
	}	
	group:insert(scoreBtn)
	
	local creditsBtn = widget.newButton{	
		defaultFile = "images/creditsBtn.png", 
    	--overFile = "Button_Purple.png",
		left=114, top=365,
		onRelease = onCreditsBtnRelease
	}	
	group:insert(creditsBtn)
	
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
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	elseif scoreBtn then
		scoreBtn:removeSelf()
		scoreBtn = nil
	elseif creditsBtn then
		creditsBtn:removeSelf()
		creditsBtn = nil
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