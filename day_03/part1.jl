# part 1 day 3
using Printf
using DelimitedFiles
function parse_line(line, c)
    # need to actually loop through a vector
    # numbers = zeros(Int32, (1,c))
    numbers = fill("", 1,c)
    numbers_bool = zeros(Bool, (1,c))
    symbols = zeros(Bool, (1,c))

    for (i,val) in enumerate(line)
        try
            num = parse(Int, val)
            numbers[i] = string(val)
            numbers_bool[i] = true

        catch
            if val != '.'
                symbols[i] = true
            end
        end
        
    end

    return numbers, symbols, numbers_bool

end

function filterto_matrix_representation(input)
    lines = readlines(input)
    r = countlines(input)
    c = length(lines[1])
    println("rows:",r, "cols: ",c)
    # numbers_matrix = zeros(Int32, (r,c) )
    numbers_matrix = Matrix{String}(undef, r,c)
    symbols_matrix = zeros(Bool, (r,c) )
    numbers_bool_matrix = zeros(Bool, (r,c) )
    for (i, line) in enumerate(lines)
        n, s, nb  = parse_line(line,c)
        numbers_matrix[i,:] = n
        numbers_bool_matrix[i,:] = nb
        symbols_matrix[i,:] = s
        
    end

    return numbers_matrix, symbols_matrix, numbers_bool_matrix
end

function window(i,j,r,c)
    main_window_indices = [
        (i-1, j-1),
        (i-1, j  ),
        (i-1, j+1),
        (i+1, j-1),
        (i+1, j  ),
        (i+1, j+1),
        (i  , j+1),
        (i  , j-1),
        ]

    if i == 1
        subset = [4,5,6,7,8]
    elseif j == 1
        subset = [2,3,5,6,7]
    elseif i == r
        subset = [1,2,3,7,8]
    elseif j == c
        subset = [1,2,4,5,8]
    else
        subset = 1:8
    end

    window_indices = [main_window_indices[s] for s in subset]

    return window_indices
end
function create_neighbors_matrix(symbols_matrix)
    r,c = size(symbols_matrix)
    window_matrix = zeros(Bool, (r,c) )
    for j in 1:c
        for i in 1:r
            if symbols_matrix[i,j] == true
                window_indices = window(i,j, r, c)
                for ij in window_indices
                    # println(ij)
                    window_matrix[ij[1], ij[2]] = true
                end
            end
        end
    end


    # if you have multiple consequetive symbols set those to zero because
    # they overlap
    window_matrix = window_matrix .& .~symbols_matrix
    return window_matrix
end

function filter_tags(numbers, numbers_bool, neighboors)
    # now we only need to loop through each line and see if a
    # continuous number index has a True tag
    # continuous_num = "" 
    tag_num = collect(neighboors .& numbers_bool)
    # for row in eachrow(numbers_bool)
    #     number_indices = findall(row)
    #     println(number_indices)
    # end

    # for row in eachrow(tag_num)
    #     tagi = findall(row)
    #     print("WTF")
    #     println(row)
    #     println(tagi)
    # end
    # all_strs = []
    str_list = []

    for (row, tagrow) in zip(eachrow(numbers), eachrow(tag_num))
        row_list = []
        row_tags = []
        str_num = ""
        str_tag = 0
        iter_num = 0; last_iter = length(row) 
        for (val, tag) in zip(row, tagrow)
            iter_num += 1
            if val != ""
                str_num *= val
                str_tag += tag
                # println("value", str_num,"tag",str_tag)

            else
                if (str_tag > 0)
                    push!(row_list, str_num)
                    push!(row_tags, str_tag)
                    push!(str_list, str_num)
                end
                #     push!(str_list, str_num)
                #     push!(row_list, str_num)

                # end
                # new long number
                str_num = ""
                str_tag = 0
            end

            if (str_tag > 0 && iter_num == last_iter)
                push!(row_list, str_num)
                push!(row_tags, str_tag)
                push!(str_list, str_num)
            end
            
        end
        # for (rl, rt) in zip(row_list, row_tags)
        #     if rt > 0
        #         push!(str_list)
        #     end
        # end

        # push!(all_strs, str_list)
        # println(row_list, row_tags)
    end
    # print(all_strs)
    # println(str_list)
    numb = 0
    for c in str_list
        converted = parse(Int, c)
        numb += converted
    end
    # sum_str = sum([parse(Int, c) for c in str_list])
    # println("HHHHHHH")
    println(numb)


end
# n, s, nb = filterto_matrix_representation("day_03/part1_sample_edit.txt")
# n, s, nb = filterto_matrix_representation("day_03/part1_sample.txt")
n, s, nb = filterto_matrix_representation("day_03/input.txt")
cnm = create_neighbors_matrix(s)

tag_num = collect(cnm .& nb)
fm = filter_tags(n, nb, cnm)

print_matrices = true
print_matrices = false

# display(s)
if print_matrices
    println("\nsymbols")
    show(stdout, "text/plain", s)
    println("\nnumbers")
    show(stdout, "text/plain", n)
    println("\nnumber booleans")
    show(stdout, "text/plain", nb)

    println("\nneighbors")
    show(stdout, "text/plain", cnm)

    println("\ntag numbers")
    show(stdout, "text/plain", tag_num)

    println("\nmask")
    show(stdout, "text/plain", fm)

    # extract_numbers(tag_num, n)
end
# println(sum(adj_num))
# lines = readlines("day_03/input.txt")

m = (a->(@sprintf "%d" a)).(tag_num)
writedlm("./file.txt", m, "" , quotes=false)
println("done")