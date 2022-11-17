When building a game, there are several scenarios where you may need to allocate a high volume of instances for a certain process. For example, a rapid-fire gun will fire several bullets in quick succession. Where do these bullets come from? Usually you have a prefabricated bullet model, which is copied each time a bullet is fired. In Roblox, the :Clone() operation of Instance is not optimal to be used at a high frequency.

### Enter: RecycledInstance

A RecycledInstance is a prefabricated instance with it's own custom :Clone() and :Destroy() methods. At first, cloning an instance is exactly the same as usual, but once you destroy the instance (for example, the bullet's lifespan has ended) instead of deleting the instance it is put into a cache in order to be re-used the next time you call :Clone(). This alliviates the overhead from creating and destroying instances at high rates.

To give you a better understanding of what is going on under the hood, I will continue with the gun example. Let's say you are making a FPS. In your game, each player will have weapons. Let's assume all weapons use the same bullet prefab. You would create a recycledInstance to wrap said bullet prefab. Then, when people join your game and start shooting the gun, the cache will dynamically expand until there is enough recycled copies of the instance so that new instances never need to be created again.

If you want to juice even more performance out of this, you don't need to let the system dynamically expand the cache. You can :prepare() the cache manually which will create `x` number of instances in advance so the cache is already prepared.

If you are dynamically expanding the cache, there is an optional method called :optimize() which will shrink excess cached instances that are never being used because the demand for copies is not high enough. Most of the time you don't need to call this, because it's just better to have say 1000 copies existing at all times, rather than re-creating your copies every time you need them.

Either way, if you choose to :clone() and :optimize(), it's still faster.