require "./Item.rb"

# Inventory Class
# Written By Alex Cummaudo 24-01-2014
class Inventory
    
    # Constructor
    def initialize
        @inv = Array.new
    end

    # Looks up an item and performs the block on that item
    # if found
    # @private
    # @learn do not use self.lookup (the scope becomes public once self. is used)
    # @param id The id of the item to perform the block on
    # @param block The block (proc) to execute if the item with that id is found
    # @learn proc vs lambda == proc return ends entire method (lookup) vs lambda return
    #        just ends that lambda block
    # @return [nil] if nothing is found, else dependent on return statement of block param
    def lookup(id, block)
        if @inv.respond_to?("each")
            @inv.each do |invItem|
                block.call(invItem) if invItem.are_you(id)
            end
        end
        return nil
    end

    # Checks if this inventory has an item with that id
    # @param id The id of the item to check if I have
    # @return [bool] Whether or not I have this item
    def has_item(id)
        # Pass in a proc that will return true if item with id is looked up
        return false if lookup(id, Proc.new { return true }).nil?
    end
    
    # Puts an item into the inventory
    # @param item The item we want to put in
    def put(item)
        @inv.push(item)
    end
    
    # Fetches an item from the inventory with the given id (but does not remove it)
    # @param id The id of the item to get
    # @return [Item] The item to return
    def fetch(id)
        # Pass in a proc that will return true if item with id is looked up
        # (pass in invItem as a param to lambda)
        return lookup(id, Proc.new { |invItem| return invItem } )
    end
    
    # Take an item from the inventory with the given id and removes it
    # @param id The id of the item to get
    # @return [Item] The item to return
    def take(id)
        return lookup(id, Proc.new { |invItem| @inv.delete(invItem); return invItem })
    end
    
    # Returns an item list of every thing I have
    # @return [string] the items I have as a list
    def item_list
        list = Array.new;

        if @inv.respond_to?("each")
            @inv.each do |invItem|
                list.push(invItem.first_id)
            end
        end
        
        return list.join(", ");
    end
    
    # Define privates
    private :lookup
end