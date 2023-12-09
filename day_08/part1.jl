struct node_obj
    name::String
    data::Int
    children
end

function get_node_tuple(line)
    split_line = split(line," = ")
    nodes = split_line[end]
    nodes = replace(nodes, "(" => "")
    nodes = replace(nodes, ")" => "")
    nodes = split(nodes, ", ")

    lnode = nodes[1]; rnode = nodes[2]
    return lnode, rnode
end
function create_network(input)



    
    lines = readlines(input)
    nodes = Dict()

    step_order = lines[1]

    for line in lines[3:end]
        # println(line)
        node = line[1:3]
        left_node, right_node = get_node_tuple(line)
        nodes[string(node)] = node_obj(node, 1, [left_node, right_node])
    end

    tree = nodes

    # for 
    # F1 = element("F1", 1, nothing)
    # F2 = element("F2", 2, nothing)
    # F3 = element("F3", 3, nothing)
    # D4 = element("D4", 0, [F1, F2])
    # D5 = element("D5", 0, [F3])
    # D6 = element("D6", 0, [D4, D5])

    return tree, step_order
end

function traverse_network(tree, steps)
    # starting at node AAA
    found_end = false
    total_steps = 0
    current_step = 1
    max_step = length(steps)
    current_tree = "AAA"
    while found_end == false

        total_steps = total_steps + 1

        if steps[current_step] == 'R'
            indx = 2
        else
            indx = 1
        end

        # println("starting tree")
        # println(tree[current_tree])

        next_tree = tree[current_tree].children[indx]

        # print("took left or right child")
        # println(next_tree)
        
        if next_tree == "ZZZ"
            found_end = true
        elseif current_step < max_step
            # go to next step
            current_step = current_step + 1
            current_tree = next_tree
        else
            # reached the end, restart steps
            current_step = 1
            current_tree = next_tree
        end

        # println("next iter tree")
        # println(tree[current_tree])

        # # c = readline()
        # wait_for_key(prompt) = (print(stdout, prompt); read(stdin, 1); nothing)
        # wait_for_key("continue")

    end

    return total_steps
end

# tree, steps = create_network("day_08/part1_sample.txt")
# tree, steps = create_network("day_08/part1_sample_edit.txt")
tree, steps = create_network("day_08/input.txt")

steps_taken = traverse_network(tree, steps)

# println(tree)
# display(tree)
print("steps taken: $steps_taken")
