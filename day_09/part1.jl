
function loop_down(line)
    split_line = split(line, " ")
    int_array = Int[]
    for s in split_line
        val = parse(Int, s)
        push!(int_array, val)
    end

    current_line = int_array
    # println(current_line)
    return_sum = 0
    last_line = false
    # next_array
    while last_line == false
        difference = diff(current_line)
        val_diff = sum(difference)

        # println(current_line, sum(difference))
        # println("type", typeof(difference))
        # println("type", typeof(val_diff))
        # print(start_array)
        # println(current_line)

        if val_diff == 0
            println("SUM IS ZERO")
            last_line = true
        else
            return_sum = return_sum + current_line[end]
            current_line = difference
        end

        
        # println(difference)
        # println(return_sum)
        # wait_for_key(prompt) = (print(stdout, prompt); read(stdin, 1); nothing)
        # wait_for_key("continue")
    end
    return_sum = return_sum + current_line[end]
    # println("Current line sum: $return_sum")
    return return_sum
end

function parse_input(input)
    lines = readlines(input)
    interp = Int[]

    for line in lines
        line_interpolation =loop_down(line)
        push!(interp, line_interpolation)
    end

    final_interp = sum(interp)
    return final_interp
end

# final = parse_input("day_09/part1_sample.txt")
# tree, steps = parse_input("day_08/part1_sample_edit.txt")
final = parse_input("day_09/input.txt")

println("SOLUTION: $final")