require "./Inventory.rb"
require "./Item.rb"

# Bag Class
# Written By Alex Cummaudo 24-01-2014
class Bag < Item

    # Property
    # @readonly inv access to my inventory
    attr_reader :inv
    # Returns list of items in this inventory
    # @return [string] The items in this inventory
    def long_desc
        return @inv.item_list
    end
    
    # Constructor for parent
    def initialize(ids, name, desc)
        super(ids, name, desc)
        @inv = Inventory.new
    end
    
    # Locates items within its inventory (or self)
    # @param id The item with the id to find
    # @return [GameObj] The item if found (nil otherwise)
    def locate(id)
        return self if are_you(id)
        
        i = @inv.fetch(id)
        return i if !i.nil?
        
        return nil
    end

end