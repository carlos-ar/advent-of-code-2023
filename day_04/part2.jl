# part 1 day 3
using Printf
using DelimitedFiles
function parse_line(line)
    # split line first to get game number
    split_line = split(line, ":")
    card = split_line[1]
    cards = split(card, " ")
    card_num = cards[2]

    numbers = split(split_line[2], "|")
    winners = Int[]; players = Int[]

    # println(win)
    for n in split(numbers[1], " ")
        if n !=""
            push!(winners, parse(Int,n))
        end
    end
    for n in split(numbers[2], " ")
        if n != ""
            push!(players, parse(Int,n))
        end
    end

    return card_num, winners, players
end

function get_matches(input)
    lines = readlines(input)
    total_game = 0
    card_value = 0
    total_cards = countlines(input)

    count_cards = ones(Int,total_cards)
    println(count_cards)
    for (i,line) in enumerate(lines)
        matches = 0
        card_num, winners, players = parse_line(line)
        # println(card_num, winners, players)
        for w in winners
            for p in players
                if w == p
                    matches+=1
                end
            end
        end

        for j in 1:count_cards[i]
            for k in 1:matches
                count_cards[i+k] += 1
            end
        end
        println(matches)
        println(count_cards)
        # total_game += card_value
    end
    total_game = sum(count_cards)
    return total_game
end

# n, s, nb, g = get_matches("day_03/part1_sample_edit.txt")
winning = get_matches("day_04/part1_sample.txt")
# winning = get_matches("day_04/input.txt")
println(winning)
println("done")