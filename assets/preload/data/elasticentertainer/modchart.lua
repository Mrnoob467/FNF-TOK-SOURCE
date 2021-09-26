-- variables
local goOff = false
local toneItDown = false

-----------------------------------------------------------------------------------------------------

function arrowDefault(id) -- Thanks BMV277~!!
	_G['defaultStrum'..id..'X'] = getActorX(id)
end

function EnemyTurn() -- Thanks BMV277~!!
    for i=0,3 do
	tweenFadeIn(i,1,0.1)
	tweenPos(i, _G['defaultStrum'..i..'X'] + 375,getActorY(i),0.5)
    end
    for i = 4, 7 do
	tweenFadeIn(i,0,0.1)
    end
end

function ProtagTurn() -- Thanks BMV277~!!
    for i=0,3 do
	tweenFadeIn(i,0,0.1)
	tweenPos(i, _G['defaultStrum'..i..'X'] - 275,getActorY(i),0.5)
    end
    for i = 4, 7 do
	tweenFadeIn(i,1,0.1)
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

end

function update(elapsed)

------------------------------------------------------------
	local currentBeat = (songPos / 1000)*(bpm/20)
------------------------------------------------------------
	if goOff then
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] - 20 * math.sin((currentBeat + i*1)) + 0, i)
			setActorY(_G['defaultStrum'..i..'Y'] - 15 * math.cos((currentBeat + i*5)) + 10, i)
		end
	end
------------------------------------------------------------
--[[if toneItDown then
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 6 * math.sin((currentBeat + i*6)) - 2, i)
			setActorY(_G['defaultStrum'..i..'Y'] + 1 * math.cos((currentBeat + i*4)) - 5, i)
		end
	end
--]]
------------------------------------------------------------
	if toneItDown then
		local currentBeat = (songPos / 1000)*(bpm/15)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*0.25)) - 5, i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25)) - 5, i)
		end
	end
------------------------------------------------------------
	if curStep >= 0 and curStep < 139 then
        for i = 0,7 do 
            tweenFadeOut(i,0,1)
        end
	end
------------------------------------------------------------
	if curStep >= 170 and curStep < 207 then
		strumLine1Visible = false
        for i = 0,7 do 
            tweenFadeOut(i,1,2)
        end
		ProtagTurn()
	end
------------------------------------------------------------
	if curStep >= 360 and curStep < 361 then
		Regular()
		strumLine1Visible = true
		goOff = false
		toneItDown = true
	end
------------------------------------------------------------
	

end

function beatHit(beat)

end

function stepHit(step)

end

function playerTwoTurn()

end

function playerOneTurn()

end

function keyPressed(key)

end

function songStart()

end