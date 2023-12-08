using Printf
using DelimitedFiles

function get_increment_index(hand_array, max_val)
    ind_val = findall(x -> x == max_val, hand_array)
    # println("found $max_val at position $ind_val")
    

    return ind_val
end

function parse_lines(input)
    println("Parsing data")
    lines = readlines(input)
    rows = countlines(input)
    unique_cards = Dict(
        "A" => 1,
        "K" => 2,
        "Q" => 3,
        "J" => 13,
        "T" => 4,
        "9" => 5,
        "8" => 6,
        "7" => 7,
        "6" => 8,
        "5" => 9,
        "4" =>10,
        "3" =>11,
        "2" =>12
    )
    # how many cards 1:13
    num_cards = length(unique_cards)
    # card order ind-1:5
    hand_cards = 5
    # bid and hand type ind - 6,7
    columns = hand_cards + 2 
    card_matrix = zeros(Int32, rows, columns)
    for (r, line) in enumerate(lines)
        current_hand = zeros(Int32, 1, num_cards)
        split_line = split(line, " ")
        bid = split_line[2]

        #  parse hand category
        # save extra jack counts
        jacks = 0
        for (k, num) in enumerate(split_line[1])
            
            c = unique_cards[string(num)]
            current_hand[c] = current_hand[c]+ 1
            # start order matrix
            card_matrix[r,k+1] = c
            if string(num) == "J"
                jacks = jacks + 1
                # println(jacks)
            end
        end

        # get current hand category
        max_hand = maximum(current_hand)

        # lets loop through the cards depending on number of jacks
        if jacks == 1
            if max_hand == 3 || max_hand == 4
                # this is one jack and we need to increment the max hand

                ix = get_increment_index(current_hand, max_hand)
                current_hand[ix] = current_hand[ix].+jacks
                # println("number of jacks $jacks, value of max: $max_hand at index $ix")

                testval = current_hand[ix]
                # println("does $testval match")
                # println(current_hand)
                # println("")
                
                # need to get rid of jacks
                current_hand[end] = 0
            elseif max_hand == 2
                # there are potetially two pairs, 
                # but also only one is a jack
                ix = get_increment_index(current_hand, max_hand)

                if length(ix) == 2
                    # there are two pairs, so increment the first
                    # println("two pairs, so what are their indices: $ix")
                    ix_first = ix[1]
                else
                    # there should only be one pair, increment the single pair
                    ix_first = ix
                end
                current_hand[ix] = current_hand[ix].+jacks
                # need to get rid of jacks
                current_hand[end] = 0
            else
                println("start hand")
                println(current_hand)

                # now check if there are all randos
                # there are 2 jacks, 
                # but all of the others must be  randos
                ix_all = get_increment_index(current_hand, 1)
                ix = ix_all[1]
                # ix must be length 1
                current_hand[ix] = current_hand[ix].+jacks
                # need to get rid of jacks
                current_hand[end] = 0     
                println("jacks $jacks, index $ix")
                println("end hand")
                println(current_hand)

            end

        elseif jacks == 2
            # two jacks, meaning we can have
            # -- one three pair (make 5 of kind)
            # -- two pair, one random (make 4 of a kind) 
            # -- two jack is the max, 3 randos (find max and make 3 of kind)
            if max_hand == 3
                #
                ix = get_increment_index(current_hand, max_hand)
                current_hand[ix] = current_hand[ix].+jacks
                # need to get rid of jacks
                current_hand[end] = 0
            elseif max_hand == 2
                ix = get_increment_index(current_hand, max_hand)
                if length(ix) == 2
                    # there are two pairs, so increment the first
                    # println("two pairs, so what are their indices: $ix")
                    ix_first = ix[1]
                else
                    # there should only be one pair, increment the single pair
                    ix_first = ix
                end
                
                # check if the only pair is jacks if so the dont do anything
                if current_hand[ix] != 13
                    current_hand[ix] = current_hand[ix].+jacks
                    # need to get rid of jacks
                    current_hand[end] = 0
                end
            end

            # now check if there are all randos
            # there are 2 jacks, 
            # but all of the others must be  randos
            ix_all = get_increment_index(current_hand, 1)
            if length(ix_all) == 3
                ix = ix_all[1]
                # ix must be length 1
                current_hand[ix] = current_hand[ix].+jacks
                # need to get rid of jacks
                current_hand[end] = 0
                
            end
        elseif jacks == 3
            # next max hand must be 2, or 1
            ix = get_increment_index(current_hand, 2)
            # try 2
            if length(ix) == 1
                # there is only a two pair
                current_hand[ix] = current_hand[ix].+jacks
                # need to get rid of jacks
                current_hand[end] = 0
            else
                # there are no two pair, must be ones
                # reset index
                ix = get_increment_index(current_hand, 1)
                # ix must be length 2
                ix_first = ix[1]
                current_hand[ix] = current_hand[ix].+jacks
                # need to get rid of jacks
                current_hand[end] = 0
            end


        elseif jacks == 4
            # there are 4 jacks, so we have to increment to 5
            ix = get_increment_index(current_hand, 1)
            # ix must be length 1
            current_hand[ix] = current_hand[ix].+jacks
            # need to get rid of jacks
            current_hand[end] = 0
        end
            

        # reset max_hand
        max_hand = maximum(current_hand)

        if max_hand==5
            card_matrix[r,1] = 1
        elseif max_hand==4
            card_matrix[r,1] = 2
        elseif max_hand==3
            # full house -_-
            cnt = 0
            for c in current_hand
                if c == 1
                    cnt += 1
                end
            end

            
            if cnt == 0
                card_matrix[r,1] = 3
                # println("never $line, cnt $cnt")
            else
                card_matrix[r,1] = 4
            end
        elseif max_hand==2
            # either two pair or single pair
            cnt = 0
            for c in current_hand
                if c == 1
                    cnt += 1
                end
            end
            if cnt == 1
                card_matrix[r,1] = 5
                
            elseif cnt == 2
                card_matrix[r,1] = 6
                
            elseif cnt == 3
                card_matrix[r,1] = 7
                
            end
        elseif max_hand==1
            card_matrix[r,1] = 8
        end

        # save bid and sum
        card_matrix[r,end] = parse(Int32,bid)
    end
    return card_matrix
end
function calculate_bids(bids)
    total = 0
    for (rank, bid) in enumerate(reverse(bids))
        #,bid)
        total = total + rank*bid
        # println("rank $rank x bid $bid = $total")
    end
    return total
end

# cm = parse_lines("day_07/part1_sample.txt")
# cm = parse_lines("day_07/part1_sample_edit.txt")
cm = parse_lines("day_07/input.txt")
# calculate(times,distance)
   
# test = sortperm(cm[:, :],dims=1)
test = sortperm(eachslice(cm[:,:],dims=1))
# display(test)
# cm = cm[sortperm(cm[:, 6]), :]
# cm = cm[sortperm(cm[:, 1]), :]

sorted_maybe = cm[test,:]
display(sorted_maybe)
# println(sorted_maybe)
winner = calculate_bids(sorted_maybe[:,end])

println("SOLUTION: $winner")
println("Done")

m = (a->(@sprintf "%4d" a)).(sorted_maybe)
writedlm("./card_orders.txt", m, "" , quotes=false)
