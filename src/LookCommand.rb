require './Command'

# Look Command Class
# Written By Alex Cummaudo 24-01-2014
class LookCommand < Command

    # Constructor to set this command's ids
    def initialize
        super(["look"])
    end
    
    # Executes the look command on the player so that the
    # player may look at items
    # @param player Player to execute the action on
    # @param text Command strings
    # @return [string] The string of the item found (its description)
    def execute(player, text)
        # Accoriding to logic, fulfil the following:
        # There must be either 3 or 5 elements in the array, otherwise return “I don’t know how to look like that”
        return "I don't know how to look like that" if !(text.count == 3 || text.count == 5)
        
        # The first word must be “look”, otherwise return “Error in look input”
        return "Error in look input" if !(text[1-1] == "look")
        
        # The second word must be “at”, otherwise return “What do you want to look at?”
        return "What do you want to look at?" if !(text[2-1] == "at")
        
        # If there are 5 elements, then the 4th word must be “in”, otherwise return “What do you want to look in?”
        return "What do you want to look in?" if (text.count == 5 && text[4-1] != "in")
                
        # If there are 3 elements, the container id is “inventory” (i.e. look at my inventory)
        # If there are 5 elements, then the container id is the 5th word
        containerId = "inventory" if text.count == 3
        containerId = text[5-1] if text.count == 5

        # The item id is always the 3rd word
        itemId = text[3-1]
                
        # If I cannot find the container, say so
        container = player.locate(containerId)
        return "Cannot find the " << containerId if container.nil?
        
        # Perform the look at in, with the container id and the item id
        return look_at_in(itemId, container)
    end
    
    # Locates an item within an inventory
    # @param id The item id to find
    # @param container The container to look within
    # @return [string] The string of the the item found (its description)
    def look_at_in(id, container)
        # Containers must respond to locate
        i = container.locate(id) if container.respond_to?("locate")

        # Return the description if this item is found
        return i.long_desc if !i.nil?
        
        # Failed to find it
        return "Cannot find the " << id
    end 
    
    # privateize methods
    private :look_at_in
end