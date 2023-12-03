# colors of cubes
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

function check_valid(results)
    # function to check if your pull matrix is valid
    color_max = [12.0, 13.0, 14.0]
    valid = Bool[]
    for i in range(1,3) # only three colors so range = 1,2,3 in matrix
        for r in results[:,i]
            # check if any of these are bad
            # so create a vector of Bool of N*3 in length
            if r <= color_max[i]
                push!(valid, true)
            else
                push!(valid, false)
            end
        end
    end
    # simply check of any of these are false
    valid_game = all(valid)
    return valid_game
end

function check_games(lines)
    total = 0
    for line in lines
        game, results = parse_data(line)
        # figure out if valid
        is_valid = check_valid(results)
        if is_valid
            total+= parse(Int, game)
        end
    end
    return total
end


# lines = readlines("day_02/part1_sample.txt")
lines = readlines("day_02/input.txt")

total_sum = check_games(lines)
println(total_sum)
println("done")