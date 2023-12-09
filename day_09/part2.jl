
function loop_down(line)
    split_line = split(line, " ")
    int_array = Int[]
    for s in split_line
        val = parse(Int, s)
        push!(int_array, val)
    end

    current_line = int_array
    # println(current_line)
    start_array = []

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
            first_val = current_line[1]
            push!(start_array, first_val)
        else
            first_val = current_line[1]
            push!(start_array, first_val)
            current_line = difference
        end

        println(start_array)
        wait_for_key(prompt) = (print(stdout, prompt); read(stdin, 1); nothing)
        wait_for_key("continue")


    end
    # println("Current line sum: $return_sum")

    final_array = []
    prev_val = 0
    for c in reverse(start_array)
        final_diff = c - prev_val
        prev_val = final_diff
        push!(final_array, final_diff)
    end

    # println("FINAL: $final_array")
    final_val = final_array[end]
    return final_val
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

final = parse_input("day_09/part1_sample.txt")
# final = parse_input("day_09/part1_sample_edit.txt")
# final = parse_input("day_09/input.txt")

println("SOLUTION: $final")