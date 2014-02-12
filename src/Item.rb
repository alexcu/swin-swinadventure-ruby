require './GameObj.rb'

# Item Class
# Written By Alex Cummaudo 24-01-2014
class Item < GameObj

    # Initialiser
    # @param ids The unique identifiers for this item
    # @param name The name of this item
    # @param desc The description of this item
    def initialize(ids, name, desc)
        super(ids, name, desc)
    end
    
end
