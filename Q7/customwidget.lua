CustomWidget = {}
window = nil

function init()
	create()
	tick()
end

function terminate()
  	destroy()
  	window = nil
end

function create()
	destroy()

	window = g_ui.displayUI('customwidget.otui')
end

function destroy()
	if window then
		window:destroy()
		window = nil
	end
end

function resetPosition()
	local btn = window:getChildById('clickme')
	currentMargin = 200
	btn:setMarginLeft(200)
	btn:setMarginTop(math.random(1, 200))
end

function onBtnClick()
	local btn = window:getChildById('clickme')
	resetPosition()
end

tickId = 0
currentMargin = 200

function tick()
	local btn = window:getChildById('clickme')
	currentMargin = currentMargin - 5
	if currentMargin < 1 then
		resetPosition()
	end

	btn:setMarginLeft(currentMargin)	
	tickId = scheduleEvent(tick, 100)
end