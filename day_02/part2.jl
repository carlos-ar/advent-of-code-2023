global colors = ["red" "green" "blue"]

function parse_data(line)
    # function to parse a single line
    # returns:
    #   game as an Int
    #   results as a matrix of size (N, 3)
    #   N is number of pulls and 3 is the colors

    # split line first to get game number
    split_line = split(line, ":")
    game = split_line[1]
    games = split(game, " ")
    game_num = games[2]

    # split second half of line to get the pulls string
    pulls = split(split_line[2], ";")
    results = zeros(length(pulls),3)
    i = 0; 
    # now loop for each pull and ...
    for pull in pulls
        i+=1
        # ... split the each pull into red, blue, green value pairs
        cubes = split(pull, ",")
        j = 0
        for color in colors
            j+=1
            for cube in cubes
                # check if there is a color cube in the current
                # pull, and then add it to the results matrix
                if occursin(color, cube)
                    num_split = split(cube," ")
                    results[i,j] = parse(Float64, num_split[2])
                end
            end
            

        end
    end
    return game_num, results
end

function make_valid(results)
    # loop through each color column to get the max value
    # which would correspond to the valid game
    valid_game = []
    for i in range(1,3)
        push!(valid_game, maximum(results[:,i]))
    end
    return valid_game
end

function check_power(lines)
    # loop through all the lines to get the max
    # valid game and create the 
    total = 0
    for line in lines
        game, results = parse_data(line)
        # figure out if valid
        # println("checking if: ", game, " is valid")
        made_valid = make_valid(results)        

        # cant figure out how to make a pi product in julia
        # so I did this instead -_-
        power = 1.0
        for m in made_valid
            new_power = m*power
            power =  new_power
        end
        
        total += power
    end
    return total
end


# lines = readlines("day_02/part1_sample.txt")
lines = readlines("day_02/input.txt")

# total_sum = check_games(lines)
total_sum = check_power(lines)
println(total_sum)
println("done")