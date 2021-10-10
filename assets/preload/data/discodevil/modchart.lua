-- variables
local goOff = false
local toneItDown = false

-----------------------------------------------------------------------------------------------------

function start(song)

end

function arrowDefault(id) -- Thanks BMV277~!!
	_G['defaultStrum'..id..'X'] = getActorX(id)
end

function update(elapsed)

---------------------------------------------------------------------------
	local currentBeat2 = (songPos / 1000)*(bpm/60)
	local valuezoom = math.sin(currentBeat2 * math.pi) /8
---------------------------------------------------------------------------
	if goOff then
		local currentBeat = (songPos / 1000)*(bpm/25)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 30 * math.sin((currentBeat + i*50)) - 36, i)
			setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25)) - 30, i)
		end
	end
---------------------------------------------------------------------------
	if toneItDown then
		local currentBeat = (songPos / 1000)*(bpm/25)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*0.25)) - 5, i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25)) - 5, i)
		end
	end
---------------------------------------------------------------------------
	if curStep >= 0 and curStep < 15 then
		toneItDown = true
	end
---------------------------------------------------------------------------
	if curStep >= 330 and curStep < 335 then
		tweenCameraZoom(1,(crochet * 2) / 1000)
	end
---------------------------------------------------------------------------
	if curStep >= 335 and curStep < 463 then
		toneItDown = false
		goOff = true
	end
---------------------------------------------------------------------------
	if curStep >= 463 and curStep < 464 then
		goOff = false
		toneItDown = true
	end
---------------------------------------------------------------------------
	if curStep >= 720 and curStep < 852 then
		toneItDown = false
		goOff = true
	end
---------------------------------------------------------------------------
	if curStep >= 852 and curStep < 853 then
		arrowDefault()
	end
---------------------------------------------------------------------------

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