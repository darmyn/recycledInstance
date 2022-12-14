When building a game, there are several scenarios where you may need to allocate a high volume of instances for a certain process. For example, a rapid-fire gun will fire several bullets in quick succession. Where do these bullets come from? Usually you have a prefabricated bullet model, which is copied each time a bullet is fired. In Roblox, the :Clone() operation of Instance is not optimal to be used at a high frequency.

### Enter: RecycledInstance

A RecycledInstance wraps your prefabricated instance with it's own custom :clone() and :destroy() methods. At first, cloning an instance is exactly the same as usual, but once you destroy the instance (for example, the bullet's lifespan has ended) instead of deleting the instance it is put into a cache in order to be re-used the next time you call :clone(). This alliviates the overhead from creating and destroying instances at high rates.

To give you a better understanding of what is going on under the hood, I will continue with the gun example. Let's say you are making a first person shooter. In your game, each player will have weapons. Let's assume all weapons use the same bullet prefab. You would create a recycledInstance to wrap said bullet prefab. Your weapon system would call the custom :clone() methods when firing a bullet, and the custom :destroy() method when the bullet's lifespan has ended. Then, when people join your game and start shooting the gun, the cache will dynamically expand until there is enough recycled copies of the instance so that new instances never need to be created again.

If you want to juice even more performance out of this, you don't need to let the system dynamically expand the cache. You can :prepare() the cache manually which will create `x` number of instances in advance so the cache is already prepared.

If you are dynamically expanding the cache, there is an optional method called :optimize() which will shrink excess cached instances that are never being used because the demand for copies is not high enough (say you had 8 players in your game firing 1000 bullets a minute, but then 4 of them left. Your cache would still remain at the size necessary to handle the load of 8\*1000). Most of the time you don't need to call this, because it's just better to have say 1000 copies existing at all times, rather than re-creating additional copies as players join and leave.

Either way, if you choose to :optimize(), even though the cache may have to re-grow in size by cloning the actual instance again, it will soon return back to re-using instances, meaning it's still faster than using the default :Clone() and :Destroy() methods.

FYI :destroy() will only set the CFrame of BaseParts, or call :MoveTo() on a model when recycling instances. It will not re-parent the instance. This is arguably faster. However the :destroy() method has an optional paramater to set the parent in case you want to recycle something that doesn't have the ability to be positioned in the world, or you want to keep your bullets organized.

# API
```lua
:prepare(cacheSize: number) --> pre-emptively expands the cache in advance
:clone() --> returns an instance by either recycling an old one, or if that is not possible, cloning one
:destroy(instance: Instance, parent: Instance?) --> recycles an instance for later use
:optimize(permittedExecss: number) --> trims the cache for excess instances that are not needed based on the current demand
```
