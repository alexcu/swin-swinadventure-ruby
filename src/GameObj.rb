require './IdObj'

# GameObject Class
# Written By Alex Cummaudo 24-01-2014
class GameObj < IdObj
    
    # Name property
    # @readonly
    attr_reader :name
    # Long Description property
    # @readonly
    def long_desc 
        @desc
    end
    # Short Description property
    # @readonly
    def short_desc
        return @name << " - " << self.first_id()
    end
    
    
    # Initialiser
    # @param ids The unique identifiers for this object
    # @param name The name of this game object
    # @param desc The description of this game object
    def initialize(ids, name, desc)
        # initialise super with ids
        super(ids)
        
        @name = name
        @desc = desc    
    end
end
