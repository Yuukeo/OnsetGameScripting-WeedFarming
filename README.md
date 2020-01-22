# OnsetGameScripting-WeedFarming
Onset Game Scripting - Weed farming

1. You will have to Plant with seeds ( you need to create the seeds in inventory and change client script to check if available)
2. Wait to grow, bloom
3. Harvest
4. Pick up the weed bag
5. Do whatever you want with it

Still buggy : 

I start to believe that CallRemoteEvent is buggy! The "ilegalmaconha:updatepacotes" should be called just every time a new packet is generated, but it doenst. but if you harvest another plant then it will fire event and update client with new packets....

gotta see wth is happening...
