using Printf
using DelimitedFiles

function parse_lines(input)
    println("Parsing data")
    lines = readlines(input)
    last_line = countlines(input)
    init_matrix = Matrix{Int}(undef,0,3)
    data_dict = Dict{String, Matrix{Int}}()
    in_array = false
    map_name = ""
    seeds = []
    ordered_keys = []
    for (num, line) in enumerate(lines)
        # split line first to get game number
        if occursin("seeds", line)
            split_line = split(line, ":")
            seeds = split(split_line[2], " ")
            seeds = [parse(Int, s) for s in seeds if s!=""]
        elseif occursin("map", line)
            split_line = split(line, " ")
            map_name = split_line[1]
            push!(ordered_keys, map_name)
            in_array = true
            # println(map_name)
        elseif length(line) == 0
            in_array = false
            
            if  length(init_matrix) > 0 || num == last_line
                # println("LOLOLOL GHERE", line)
                # println(init_matrix)
                data_dict[map_name] = init_matrix
                
            end
            init_matrix = Matrix{Int}(undef,0,3)
        end

        if in_array == true && !occursin("map", line)
            data = split(line, " ")
            rows = Int[]
            for (i,d) in enumerate(data)
                if i != 3
                    push!(rows, parse(Int, d)+1)
                else
                    push!(rows, parse(Int, d))
                end
            end
            init_matrix = cat(init_matrix, rows', dims=1)
        end

        if  num == last_line
            # println(init_matrix)
            data_dict[map_name] = init_matrix
            
        end
    end
    # println(data_dict)
    # end

    return data_dict, seeds, ordered_keys
end

function process_maps_naive(map_matrix, seeds, maps)
    println("\nProcessing data naively\n")
    big_index = 100
    # big_index = 3000000000
    
    ordered_map = [i for i in range(1,big_index)]
    og_ordered_map = [i for i in range(1,100)]
    stack_maps = []
    push!(stack_maps, og_ordered_map)
    for key in maps
        
        ordered_map = [i for i in range(1,big_index)]
        mat = map_matrix[key]
        # println(key)
        r,c = size(mat)

        src_cat_range = []
        # println(src_cat_range)
        new_map = [i for i in range(1,big_index)]
        for j in 1:r
            new_map = [i for i in range(1,big_index)]
            src = mat[j,1]
            dest = mat[j,2] 
            len = mat[j,3]
            replace_order = [src+(i-1) for i in range(1,len)]

            # get index when matched
            # println("")
            # println(replace_order)
            # println("")
            ordered_map[dest:dest+(len-1)] = replace_order
            # logic to match the number
            # for (k, o) in enumerate(ordered_map)
            #     if o == dest
            #         println("matched ", o, " with dest", dest+len-1)
            #         ordered_map[dest:dest+(len-1)] = replace_order
            #     end
            # end


            # ordered_map[o_ind:o_ind+mat[j,3]-1] = replace_order[:]
            # println(ordered_map)
            # push!(stack_maps, copyto!(new_map,ordered_map))    
        end
        # println(ordered_map)
        push!(stack_maps, copyto!(new_map,ordered_map))    
        
        

    end


    # println(length(stack_maps))
    # makign debug matrix_map
    stack_matrix = zeros(Int, big_index, length(stack_maps))
    for (i,row) in enumerate(stack_maps)
        stack_matrix[:,i] = stack_maps[i]
    end

    r,c = size(stack_matrix)
    for seed in seeds
        # println("seed ", seed)
        src = seed +1
        for j in range(1,c)
            src = stack_matrix[src,j]
            # print("src ", src-1, ";")
        end
        # println(src-1)
        # println()
        println("location: ", src-1)
    end

   
    # show(stdout, "text/plain", stack_matrix)
    m = (a->(@sprintf "%3d" a)).(stack_matrix)
    writedlm("./sequentialMaps.txt", m, "" , quotes=false)
    return 0
end

function process_maps(map_matrix, seeds, maps)
    println("Smarter processing")
    locations = Int[]
    for seed in seeds
        println("seed ", seed)
        conversion = seed
        for key in maps
            
            
            mat = map_matrix[key]
            # println(key)
            r,c = size(mat)

            
            for j in 1:r
                
                src = mat[j,1] - 1
                dest = mat[j,2] - 1
                len = mat[j,3]

                dest_max = dest + len 

                shift = conversion-dest
                # println("\trow")
                if conversion < dest_max && conversion >= dest
                    # println(dest,"-", dest_max)
                    # println("\t\t",src+shift, "\t converted\t",dest,"-",dest_max)
                    conversion = src+shift
                    break
                else
                    # println("\t\t",conversion)

                end
                
            end


        end
        println(map,"\t",conversion)
        push!(locations, conversion)        
    end

    println("SOLUTION: ", minimum(locations))
end

# matrix_maps, seeds, map_names = parse_lines("day_05/part1_sample_edit.txt")
# matrix_maps, seeds, map_names = parse_lines("day_05/part1_sample.txt")
matrix_maps, seeds, map_names = parse_lines("day_05/input.txt")

# process_maps_naive(matrix_maps, seeds, map_names)
process_maps(matrix_maps, seeds, map_names)
# println(matrix_maps)
println("done")