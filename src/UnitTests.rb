require 'test/unit'
require './IdObj.rb'
require './GameObj.rb'
require './Item.rb'
require './Inventory.rb'
require './Player.rb'
require './Bag.rb'
require './LookCommand'

# Unit Tests for SwinAdventure in Ruby
# Written By Alex Cummaudo 24-01-2014

# Populates an inventory with some random items
def pop_inv(inv, size)    

    items = Array.new;

    # Populate with size
    case size
        when :pocket
            @book  = Item.new(["book", "novel"], "1984", "An Orwellian Nightmare")
            @pen   = Item.new(["pen", "biro"], "4-Pen", "A four pen with red, green, blue and black inks")
            @phone = Item.new(["phone", "cell"], "iPhone", "An iPhone 5")         
            items.push(@book, @pen, @phone)
            
        when :wallet
            @myki   = Item.new(["myki", "travelcard"], "Myki", "An consession myki card")
            @idcard = Item.new(["id", "card"], "ID card", "Swinny ID card")
            @cash   = Item.new(["cash", "money"], "$20 banknote", "A 20 dollar banknote")     
            items.push(@myki, @idcard, @cash)
    end
            
    #put the items in
    items.each do |item|
        inv.put(item)
    end
end

# Executes a string on a given command
def exec_cmd(cmd, str)
    return cmd.execute(@pl, str.split(" "))
end

# Identifiable Object Tests
class TestIdObj < Test::Unit::TestCase
    
    def setup
        @id = IdObj.new(["Book", "Novel"])       
    end
    
    def test_are_you
        # Are you pass
        assert_equal true, @id.are_you("Book")
        assert_equal true, @id.are_you("Novel")
        
        # Are you pass case insensitive
        assert_equal true, @id.are_you("bOOk")
        
        # Not are you
        assert_equal false, @id.are_you("banana")
    end 
    
    def test_first_id
        assert_equal "Book", @id.first_id()
    end
    
    def test_add_id
        @id.add_id("hardback")
        assert_equal true, @id.are_you("hardback")
    end
end

# Item Tests
class TestItem < Test::Unit::TestCase
    
    def setup
        @item = Item.new(["book", "novel"], "1984", "An Orwellian Nightmare")
    end
    
    def test_are_you
        assert_equal true, @item.are_you("novel")
        assert_equal false, @item.are_you("banana")
    end
    
    def test_short_desc
        assert_equal "1984 - book", @item.short_desc
    end
    
    def test_long_desc
        assert_equal "An Orwellian Nightmare", @item.long_desc
    end
    
end

# Inventory Tests
class TestInventory < Test::Unit::TestCase
    
    def setup
        @inv = Inventory.new
        pop_inv(@inv, :pocket)
    end
    
    def test_find_item
        assert_equal true, @inv.has_item("book")
        assert_equal true, @inv.has_item("pen")
        assert_equal true, @inv.has_item("phone")
        assert_equal false, @inv.has_item("banana")
    end
    
    def test_fetch
        # first fetch the item
        assert_equal @book, @inv.fetch("book")
        
        # fetch implies non-removal, check still has item
        assert_equal true, @inv.has_item("book")
    end
    
    def test_take
        # first fetch the item
        assert_equal @pen, @inv.take("biro")
        
        # take implies removal, check no longer has item
        assert_equal false, @inv.has_item("biro")
    end
    
    def test_item_list
        assert_equal "book, pen, phone", @inv.item_list
    end
end

# Player tests
class TestPlayer < Test::Unit::TestCase
    
    def setup
        @pl = Player.new("Fred", "The Mighty Programmer")
        pop_inv(@pl.inv, :pocket)
    end

    def test_player_identifiable
        assert_equal true, @pl.are_you("me")
        assert_equal true, @pl.are_you("inv")
        assert_equal false, @pl.are_you("banana")
    end
    
    def test_player_locate
        assert_equal @book, @pl.locate("novel")
        assert_equal nil , @pl.locate("banana")
        assert_equal @pl, @pl.locate("self")
    end
    
    def test_player_desc
        assert_equal "Fred, The Mighty Programmer, has the following inventory: book, pen, phone", @pl.long_desc
    end

end

# Bag Tests
class TestBag < Test::Unit::TestCase
    
    def setup
        @backpack = Bag.new(["backpack", "satchel"], "Backpack", "A brown backpack")
        @wallet = Bag.new(["wallet", "purse"], "Waller", "A leather wallet")
        
        pop_inv(@backpack.inv, :pocket)
        pop_inv(@wallet.inv, :wallet)
        
        # add bag 1 to bag 2's
        @backpack.inv.put(@wallet)
    end
    
    def test_locate_items
        # Locate direct items
        assert_equal @book, @backpack.locate("book")
        assert_equal @cash, @wallet.locate("cash")
        
        # Locate bag within bag
        assert_equal @wallet, @backpack.locate("wallet")
        # Non-locate outer bag from inner bag
        assert_equal nil, @wallet.locate("backpack")
        
        # Locate self
        assert_equal @wallet, @wallet.locate("wallet")
        assert_equal @backpack, @backpack.locate("backpack")
        
        # Locate non-existant
        assert_equal nil, @backpack.locate("bannana")
        assert_equal nil, @wallet.locate("cell") # cell is in backpack not wallet!
    end
    
    def test_bag_desc
        assert_equal "myki, id, cash", @wallet.long_desc
        assert_equal "book, pen, phone, wallet", @backpack.long_desc
    end 
end

# Look command tests
class TestLookCommand < Test::Unit::TestCase

    def setup
        @cmd_look = LookCommand.new
        @pl = Player.new("Fred", "The Mighty Programmer")
        
        @backpack = Bag.new(["backpack", "satchel"], "Backpack", "A brown backpack")        
        pop_inv(@backpack.inv, :pocket)
        pop_inv(@pl.inv, :wallet)
        
        @pl.inv.put(@backpack)
    end
    
    def test_commands
        # Return player inventory desc
        assert_equal  @pl.long_desc, exec_cmd(@cmd_look, "look at me")
        # Return the book description in the players inv
        assert_equal  @myki.long_desc, exec_cmd(@cmd_look, "look at myki")
        # Return cannot find the item for non-existant item
        assert_equal  "Cannot find the banana", exec_cmd(@cmd_look, "look at banana")
        # Return the phone description in the players backpack explicitily
        assert_equal  @phone.long_desc, exec_cmd(@cmd_look, "look at phone in backpack")
        # Return non-existant bag
        assert_equal  "Cannot find the wallet", exec_cmd(@cmd_look, "look at phone in wallet")
        # Return non-existant item in bag
        assert_equal  "Cannot find the banana", exec_cmd(@cmd_look, "look at banana in backpack")
        # Return invalid look
        assert_equal  "I don't know how to look like that", exec_cmd(@cmd_look, "look")
    end
end