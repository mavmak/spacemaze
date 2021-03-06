---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------

-- include the Corona "storyboard" module
storyboard = require( "storyboard" )
scene = storyboard.newScene()

--this is necessary for my application, if I don't add the screen will turn of because there are no touch events
system.setIdleTimer( false )
--this sets how often to get information from the Accelerometer, 100 is the maximum
system.setAccelerometerInterval( 100 )

--loads the Corona's physic module and the physics characteristics of my objects from myphysics.lua
physics = require "physics"
physicsData = (require "myphysics").physicsData(1.0)
physics.setReportCollisionsInContentCoordinates( true )
---------------------------------------------------------------------------------
-- BEGINNING OF  IMPLEMENTATION
---------------------------------------------------------------------------------
--loads the global functions from globals.lua on global table
global = require( "globals" )

-- Called when the scene's view does not exist
function scene:createScene( event )
	local screenGroup = self.view

    --use the global.initialize function to initialize the scene, the first parameter is the time, the second is which is the next scene and the third the maze's png
	global.initialize(40,2,'maze1.png')
	--starts the physicss
	physics.start(); 
	physics.setGravity( 0,0 )
	--used to play planet's Sprite, animation impression
	planetSprite:play()

	--show instructions
	instructions=display.newImage( "instructions_level1.png" )
	instructions.x=display.contentCenterX
	instructions.y=display.contentCenterY
	instructions.name="instructions"
    --used to disapear instructions after 8 seconds
	transition.to( instructions, { time=8000, alpha=0, y = 100} )

	--assigns physics to the objects of the screen
	physics.addBody (planetSprite, "dynamic",physicsData:get("earthphysics"))
	planetSprite.isSleepingAllowed = false
	physics.addBody (maze, "static",physicsData:get("mazelevel1_1"))
	physics.addBody (maze2, "static",physicsData:get("mazelevel1_2"))
    physics.addBody (borderleft, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderright, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderup, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderdown, "static",{ friction=0.5, bounce=0 })
	physics.addBody (exitscn, "static",physicsData:get("exitscn"))

	Runtime:addEventListener("enterFrame", global.checkTime)
	Runtime:addEventListener( "accelerometer", global.onTilt )
	Runtime:addEventListener( "collision", global.onCollision )

	screenGroup:insert( background )
	screenGroup:insert(displayTime)
	screenGroup:insert( planetSprite )
	screenGroup:insert( explosionSprite )
	screenGroup:insert( maze )
	screenGroup:insert( maze2 )
	screenGroup:insert( borderleft )
	screenGroup:insert( borderright )
	screenGroup:insert( borderdown)
	screenGroup:insert( borderup)
	screenGroup:insert( exitscn )
	screenGroup:insert( instructions )
end




-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	physics.start()
    audio.play(backgroundMusicSound,{channel = 1,loops=-1})
	startTime = os.time()
	transition.to ( displayTime, {alpha=1,time=500} )
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	physics.stop( )
    audio.stop()
	Runtime:removeEventListener( "enterFrame", global.checkTime )
    Runtime:removeEventListener( "accelerometer", global.onTilt )
    Runtime:removeEventListener( "collision", global.onCollision )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	package.loaded[physics] = nil
	physics = nil
end


-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene