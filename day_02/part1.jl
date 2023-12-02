global colors = ["red" "green" "blue"]



function parse_data(line)
    
    split_line = split(line, ":")
    game = split_line[1]
    games = split(game, " ")
    game_num = games[2]
    pulls = split(split_line[2], ";")
    # println(length(pulls))
    results = zeros(length(pulls),3)
    i = 0; 
    for pull in pulls
        i+=1
        cubes = split(pull, ",")
        j = 0
        for color in colors
            j+=1
            # println(cube)
            for cube in cubes
                if occursin(color, cube)
                    num_split = split(cube," ")
                    results[i,j] = parse(Float64, num_split[2])
                end
            end
            

        end
    end
    # print("game: ", game)
    # println(results)
    # game = 0
    return game_num, results
end

function check_valid(results)
    color_max = [12.0, 13.0, 14.0]
    valid = Bool[]
    for i in range(1,3)
        
        for r in results[:,i]
            if r <= color_max[i]
                push!(valid, true)
            else
                push!(valid, false)
            end
        end
        println(results[:,i])
        println(valid)
    end

    valid_game = all(valid)
    return valid_game
end

function make_valid(results)
    valid_game = []
    for i in range(1,3)
        
        push!(valid_game, maximum(results[:,i]))
    end
    return valid_game
end


function check_games(lines)
    total = 0
    for line in lines
        game, results = parse_data(line)
        # figure out if valid
        println("checking if: ", game, " is valid")
        is_valid = check_valid(results)
        if is_valid
            # println(game, "is valid")
            total+= parse(Int, game)
        end
    end
    return total
end

function check_power(lines)
    total = 0
    for line in lines
        game, results = parse_data(line)
        # figure out if valid
        println("checking if: ", game, " is valid")
        made_valid = make_valid(results)
        print(made_valid)
        
        power = *made_valid
        # if is_valid
        #     # println(game, "is valid")
        #     total+= parse(Int, game)
        # end
    end
    return total
end


lines = readlines("day_02/part1_sample.txt")
# lines = readlines("day_02/input.txt")

# total_sum = check_games(lines)
total_sum = check_power(lines)
println(total_sum)
println("done")