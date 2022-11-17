When building a game, there are several instances where you may need to allocate a high volume of instances for a certain process. For example, a rapid-fire gun will fire several bullets in quick succession. Where do these bullets come from? Usually you have a prefabricated bullet model, which is copied each time a bullet is fired. In Roblox, the :Clone() operation of Instance is not optimal to be used at a high frequency.

### Enter: RecycledInstance

A RecycledInstance is a prefabricated instance with it's own custom :Clone() and :Destroy() methods. At first, cloning an instance is exactly the same as usual, but once you destroy the instance (for example, the bullet's lifespan has ended) instead of deleting the instance it is put into a cache in order to be re-used the next time you call :Clone(). This alliviates the overhead from creating and destroying instances at high rates.
