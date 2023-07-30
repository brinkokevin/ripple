local types = require(script.Parent.Parent.types)
local intermediate = require(script.Parent.Parent.utils.intermediate)

type LinearOptions = {
	speed: number?,
} | number?

local function configure(options: LinearOptions)
	local speed = if type(options) == "table" then options.speed else options

	return {
		speed = speed or 1,
	}
end

local function linear(motionGoal: types.MotionGoal, options: LinearOptions): types.MotionSolver
	local config = configure(options)
	local goals = intermediate.to(motionGoal)

	return function(key, state, deltaTime)
		local goal = intermediate.index(goals, key)

		if not goal then
			return
		end

		local velocity = config.speed * deltaTime * math.sign(goal - state.value)

		if math.abs(velocity) >= math.abs(goal - state.value) then
			state.complete = true
			state.value = goal
			state.velocity = 0
		else
			state.value += velocity
			state.velocity = velocity
		end
	end
end

return linear
