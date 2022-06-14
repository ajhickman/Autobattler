#Team 2: Electric Boogaloo, Andy, Donna, Renat, Tobias
# Create an auto-battler game.

# In this game, you should create a character. This can consist of giving it a name. Or more, up to you. Mostly a name. Maybe a job? The character should be assigned some number of hp.

# There should be a main menu, from this menu, the player should be able to:

#Making the character:

#name
#wallet
#hp status
#equipment
#tracking inventory

# 1) Buy some gear

#present user with list of items for purchase
#let user select which items to buy
#check how much money user has
#do math and see what they can afford
#when they purchase items, deduct from their available funds
# 2) Go heal

#ask them if they want to heal
#tell them cost to heal
#check to see if they can afford it
#if they can afford. heal and deduct cost
# 3) Look for a fight

#find a monster
#player and monster take turns doing damage
#winner takes money
#if player loses. present option to make new character

# When buying gear, the player should be able to buy an item that gives them more damage when looking for a fight. (A sword, a stick, a book of insults, a biochemistry textbook in a sock) - This should cost money

# When healing, the player should be charged money to put their health points up to the maximum level

# When looking for a fight, the player should find a monster. The player and the monster should take turns doing damage to each other until one is out of health points. If the monster loses, the player gains some money. If the player loses, the game is over and they must make a new character. The player should not be given any options during the fight, they should just watch it happen and find out the results.

puts 'Welcome to Ultimate Monster Battle Simulator!!'

# each stat has a starting value that doesn't change and a current value that does
# capital letters makes a thing a constant, and signify the default starting values
WALLET = 0
DAMAGE = 1
EXP = 0
#playing is the variable that changes when we want to quit
playing = true


while playing
    # get name and setting character variables
    puts 'Please name your character!'
    name = gets.chomp

    maxHP = 20
    wallet = WALLET
    hp = maxHP
    damage = DAMAGE
    exp = EXP
    level = 1

    #Random range affects probability of finding stronger monsters, setting it to 25 guarantees goblins at first
    random_range = 25

    # Define shop inventory
    # itemName => [cost, damage]
    shop = { 'stick' => [1, 2], 'sword' => [6, 5], 'halberd' => [15, 11], '~*~Magic Sword~*~' => [50, 25], 'Big Ass Dragon Slayer' => [500, 300]}

    #main menu selection and current stats
    puts "Welcome #{name}!"
    

    while hp > 0
        #Let player know their current status
        puts "#{name}, you currently have #{wallet} gold, #{hp} hit points, and do #{damage} damage."
        puts "\nMenu: \na) Buy gear \nb) Heal \nc) Look for a fight \nq) Quit"
        selection = gets.chomp.downcase

        #player selections
        #if you select go to shop and buy gear: deduct cost and set damage
        if selection == 'a'
            puts 'Welcome to the shop. What would you like to buy?'
            #Build the shop menu
            # TODO Allign columns later
            
            # Displays the items you can buy with an index number so they can be bought
            shop.each_with_index do |(item, stats), index|
                puts " #{index + 1} |  #{item} | cost: #{stats[0]} | dmg: #{stats[1]}"             
            end
            shop_selection = gets.to_i
            
            #input verification, had to add 1 because Ruby defaults to 0 if not valid
            if shop_selection > 0 && shop_selection <= shop.length
                #Check to see if player has enough cash
                if wallet >= shop.values[shop_selection - 1][0]
                    damage = shop.values[shop_selection - 1][1]
                    wallet = wallet - shop.values[shop_selection - 1][0]
                puts "Thank you for your purchase of #{shop.keys[shop_selection - 1]}. Please come again."
                gets
                else 
                    puts "You're broke."
                    gets
                end
            else
                puts "Did not enter valid request, returning to menu"
                gets
            end

        end
        
        # if you select heal: go to back alley: deduct cost and add hp
        if selection == 'b'
                puts '\nWelcome to the mystical back alley'
                puts "Your hp is currently: #{hp}. Your max hp is: #{maxHP}."
                puts 'Would you like to heal? That will be 10 gold coins. Y/N'
                heal = gets.chomp.downcase

                # if they choose "yes" to heal
                if heal == 'y'
                    # TODO: check if they have enough money
                    puts "\nOk, *POFF* you're healed!"
                    gets
                    # set HP to default
                    hp = maxHP

                    # charge them money
                    wallet = wallet - 10
                else
                    #if they choose not to heal
                    puts "\nOk see you next time. Hope you don't die."
                    gets
                end
        end

        # if you select fight: damages to player and enemy until one dies

        if selection == 'c'
                # Hash of enemies. Key is monster name, values are Damage, HP, purse, experience given, and randomization number sort of probability but not technically
                enemies = {"Goblin" => [1, 5, 5, 1, 30], "Blue Slime" => [3, 15, 10, 4, 55], "Bugbear" => [6, 35, 18, 10, 80], "Phase Spider" => [15, 69, 25, 25, 98], "Dragon" => [19, 300, 1000000, 1000, 100]}
                # Give us a random number between 1 and current random range
                random_enemy = rand(1..random_range)
                # Making enemy variables but leave empty
                enemy_name = ""
                enemy_damage = 0
                enemy_health = 0
                enemy_purse = 0
                enemy_exp = 0

                # This loop checks the 'probability' in the enemies hash versus the random number generated to see which one we're fighting.

                enemies.each do |name, stats|
                    if random_enemy <= stats[4]
                        puts "\nYou found a wild #{name}!"
                        # Sets the enemy variables that will be used in the fight below
                        enemy_name = name
                        enemy_damage = stats[0]
                        enemy_health = stats[1]
                        enemy_purse = stats[2]
                        enemy_exp = stats[3]
                        break
                    end
                end

                puts "your HP: #{hp}, enemy HP: #{enemy_health}"
                sleep 0.5
                while true 
                    #Player does damage

                    enemy_health = enemy_health - damage

                    # print current damage

                    #checks to see if enemy is dead
                    if enemy_health <= 0
                        # if enemy is dead, add money to wallet and leave fight
                        puts "your HP: #{hp}, enemy HP: 0 - you did #{damage} damage"
                        puts "You defeated the #{enemy_name}! They dropped #{enemy_purse} gold!"
                        wallet = wallet + enemy_purse
                        exp = exp + enemy_exp

                        # This if statement raises your chance of finding stronger enemies as you win more fights
                        if random_range <= 100
                            random_range = random_range + 5
                        end

                        #Check for level up
                        if exp >= 2 * level * level
                            level = level + 1
                            maxHP = maxHP + 5
                            puts "#{name} just leveled up to level #{level}! Max HP is now #{maxHP}!"
                            exp = 0
                        end
                        gets
                        break
                    else
                        puts "your HP: #{hp}, enemy HP: #{enemy_health} - you did #{damage} damage"
                    end

                    # Enemy does damage
                    hp = hp - enemy_damage

                    #print current damage
                    
                    #pause for a moment so user can see HP going down
                    sleep 0.5
                    #checks to see if player dies
                    if hp <= 0
                        puts "your HP: 0, enemy HP: #{enemy_health} - enemy did #{enemy_damage} damage"
                        # If you die, brings back to character creation screen
                        puts "You've been defeated! Sucks to suck, try again"
                        gets
                        system ("cls")
                        break
                    else
                        puts "your HP: #{hp}, enemy HP: #{enemy_health} - enemy did #{enemy_damage} damage"
                    end
                    
                end
        end

        if selection == "q"
            hp = 0
            playing = false
        end

        system ("cls")
    end    
end