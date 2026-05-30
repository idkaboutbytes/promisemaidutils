--!strict
--[=[
	Helper functions for maids and promises

	@class PromiseMaidUtils
]=]

const Maid = require('./roblox_packages/Maid')
const Promise = require('./roblox_packages/promise')

const PromiseMaidUtils = {}

--[=[
	Calls the callback with a maid for the lifetime of the promise.

	```lua
	local promise = Promise.delay(5)
	PromiseMaidUtils.whilePromise(promise, function(maid)
		-- Do work while the promise is pending
	end)
	```
]=]
@checked
function PromiseMaidUtils.whilePromise<T...>(promise: Promise.Promise<T...>, callback: ((Maid.Maid) -> ())?): Maid.Maid
	assert(Promise.isPromise(promise), 'Bad promise')
	assert(type(callback) == 'function', 'Bad callback')

	local maid = Maid.new()

	if not promise:IsPending() then
		return maid
	end

	promise:Finally(function()
		maid:DoCleaning()
	end)

	if callback then
		callback(maid)
	end

	-- Cleanup immediately if the callback resolves the promise immeidately
	if not promise:IsPending() then
		maid:DoCleaning()
	end

	return maid
end

return PromiseMaidUtils
