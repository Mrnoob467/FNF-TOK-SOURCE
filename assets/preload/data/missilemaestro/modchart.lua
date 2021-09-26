-- variables
local goOff = false
local toneItDown = false
local arrowFly = false

-- pre-written functions
function arrowDefault(id) -- Thanks BMV277~!!
	_G['defaultStrum'..id..'X'] = getActorX(id)
end

function EnemyTurn() -- Thanks BMV277~!!
    for i=0,3 do
	tweenFadeIn(i,1,0.5)
	tweenPos(i, _G['defaultStrum'..i..'X'] + 375,getActorY(i),0.5)
    end
    for i = 4, 7 do
	tweenFadeIn(i,0,0.5)
    end
end

function ProtagTurn() -- Thanks BMV277~!!
    for i=0,3 do
	tweenFadeIn(i,0,0.5)
	tweenPos(i, _G['defaultStrum'..i..'X'] - 275,getActorY(i),0.5)
    end
    for i = 4, 7 do
	tweenFadeIn(i,1,0.5)
	tweenPos(i, _G['defaultStrum'..i..'X'] - 275,getActorY(i),0.5)
    end
end

function Regular() -- Thanks BMV277~!!
    for i=0,7 do
		tweenFadeIn(i,1,0.5)
		tweenPos(i, _G['defaultStrum'..i..'X'],getActorY(i),0.5)
    end
end

-----------------------------------------------------------------------------------------------------

function start(song)

------------------------------------------------------------------------
--	middlePoint = ((_G['defaultStrum7X'] - _G['defaultStrum0X']) / 2) - 150
------------------------------------------------------------------------

end

function update(elapsed)

------------------------------------------------------------------------
	local currentBeat = (songPos / 1000)*(bpm/15)
------------------------------------------------------------------------
	if arrowFly then
		for i=0,3 do
			setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((songPos / 1000) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 30 * math.sin((songPos / 1000) * 2 * math.pi), i)
		end
	end
------------------------------------------------------------------------
	if toneItDown then
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*0.25)) - 5, i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25)) - 5, i)
		end
	end
------------------------------------------------------------------------
	if curStep >= 0 and curStep < 140 then
		showOnlyStrums = true
        for i=0,7 do 
            tweenFadeOut(i,0,0.5)
        end
	end
------------------------------------------------------------------------
	if curStep >= 140 and curStep < 143 then
        for i=0,3 do
            tweenFadeOut(i,1,0.5)
        end
	end
------------------------------------------------------------------------
	if curStep >= 170 and curStep < 207 then
		showOnlyStrums = false
    	for i=4,7 do
    		tweenFadeOut(i,1,0.5)
    	end
	end
------------------------------------------------------------------------
	if curStep >= 336 and curStep < 463 then
		toneItDown = true
	end
------------------------------------------------------------------------
	if curStep >= 464 and curStep < 470 then
		arrowFly = true
		arrowDefault()
	end
------------------------------------------------------------------------
	if curStep >= 721 then
		showOnlyStrums = true
        for i=0,7 do 
            tweenFadeOut(i,0,0.5)
        end
	end
------------------------------------------------------------------------

end

function beatHit(beat)

end

function stepHit(step)
	if step == 463 then
        for i=0,7 do
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'],getActorAngle(i) + 360, 0.3, 'arrowDefault')
        end
	end
end

function playerTwoTurn()

end

function playerOneTurn()

end

function keyPressed(key)

end

function songStart()

end