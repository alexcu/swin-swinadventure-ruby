# Identifiable object class
# Written by Alex Cummuado 24-01-2014
class IdObj

    # Initialiser
    def initialize(ids)
        @ids = ids
    end
    
    # Checks if the passed id is within my list
    # of identifiers
    # @param [string] The id to check
    # @return [bool] Whether or not the identifier passed exists
    def are_you(id)
        # process as list
        if @ids.respond_to?("each")
            @ids.each do |iterId|
                return true if iterId.upcase == id.upcase
            end
        # process as singular
        else 
            return iterId.upcase == id.upcase
        end
        # Out of loop? Return false
        return false
    end
    
    # Returns the first id
    # @return [string, nil] The first id or nil if none exists
    def first_id()
        return @ids.first if @ids.respond_to?("first")
        return nil
    end
    
    # Pushes an identifier to the identifier list
    # @param [string] The identifier to add
    def add_id(id)
        @ids.push(id)
    end

end