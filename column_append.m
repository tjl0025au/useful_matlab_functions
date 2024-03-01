function column_appended_matrix = column_append(previous_data,new_data,index,first_input)

if index == 1
    column_appended_matrix = first_input;
else
    column_appended_matrix = [previous_data, new_data];
end