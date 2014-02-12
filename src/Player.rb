require "./GameObj.rb"
require "./Inventory.rb"

# Player Class
# Written By Alex Cummaudo 24-01-2014
class Player < GameObj
    
    # Properties
    # @readonly Access to my inventory
    attr_reader :inv
    # Overridden long desc to include inventory items
    def long_desc
        return @name << ", " << @desc << ", has the following inventory: " << @inv.item_list
    end
    
    # Constructor for parent
    def initialize(name, desc)
        super(["me", "self", "inv", "inventory"], name, desc)
        @inv = Inventory.new;
    end
    
    # Locates items in the order of precedence:
    # self, inventory
    # @param id The item with the id to locate
    # @return [GameObj] The item we found
    def locate(id)
        return self if are_you(id)

        # Try Inventory
        i = @inv.fetch(id)
        return i if !i.nil?

        return nil
    end 
end