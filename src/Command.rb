require './IdObj'

# Command Class
# Written By Alex Cummaudo 24-01-2014
class Command < IdObj
    
    # Constructor for parent
    def initialize(ids)
        super(ids)
    end
    
    # Execute method performs an action based on the type of command
    # passed and the words it contains
    # @abstract
    # @param player Player to execute the action on
    # @param text Command strings
    def execute(player, text)
        raise NotImplementedError, "Abstract method"
    end

end