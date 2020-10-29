DEBUG_FLAG = 0

-- Function that is used to either print to LaTeX or to the console
-- Used for debugging mode
function  localPrint(str)
    if DEBUG_FLAG==1 then
        print(str)
    else
        tex.sprint(str)
    end
end

-- Function that converts a decimal number to binary
function decimalToBin(num, numb_bits, return_concat)
    if return_concat == nil then return_concat=true end
    num = tonumber(num)
    numb_bits = tonumber(numb_bits)
    local t={}
    for b=numb_bits,1,-1 do
        rest=math.floor(math.fmod(num,2))
        t[b]=rest
        num=(num-rest)/2
    end
    if return_concat == true then
        return table.concat(t)
    else
        return t
    end
 end

 -- Function that converts a decimal number to grey code
 function decimalToGreyBin(num, numb_bits)
    -- Get the binary array
    local t = decimalToBin(num, numb_bits, false)
    local tg={}
    -- Find grey code from binary by XORing the previous bit going from MSB to LSB
    for b=1,numb_bits,1 do
        if b == 1 then
            tg[b] = t[b]
        else
            tg[b] = t[b] ~ t[b-1]
        end
    end
    return table.concat(tg)
 end

 -- Function to pad a string by a amount with b string
 function padString(str, pad_to, pad_with)
    local ret = str
    for l=1, (pad_to-string.len(str)) do
        ret = pad_with .. ret
    end
    return ret
 end

 -- Function to generate a kmap template
 function generateKMap(column, row, grid_numb)
    local outside_column_bits = 1
    local outside_row_bits = 1
    local outside_grid_numb_bits = 2
    local return_str = ''
    if row >= 4 then
        outside_row_bits = 2
    end
    if column >= 4 then
        outside_column_bits = 2
    end
    for c=1,column,1 do
        for r=1,row,1 do
            if r == 0 then
                if c == 0 then

                elseif c == (column+1) then
                    return_str = return_str .. ("\\phantom{" .. decimalToBin(0, outside_column_bits) .. "}")
                else
                    return_str = return_str .. (decimalToGreyBin(c-1, outside_column_bits))
                end
            elseif r==(row+1) then
                if c==0 then
                    return_str = return_str .. ("\\phantom{" .. decimalToBin(0, outside_column_bits) .. "}")
                end
            else
                if c == 0 then
                    return_str = return_str .. (decimalToGreyBin(r-1, outside_row_bits))
                elseif c == (column+1) then

                else
--                     localPrint("|(" .. "00" ..
--                     decimalToGreyBin((c-1), 2) ..
--                     decimalToGreyBin((r-1), 2) ..  ")|" .. "\\phantom{0}")
                    return_str = return_str ..("|(" .. padString((decimalToGreyBin(grid_numb, outside_grid_numb_bits) .. decimalToGreyBin(c-1, outside_column_bits) .. decimalToGreyBin(r-1, outside_row_bits)), 6, 0) ..  ")|" .. "\\phantom{0}")
                    --TODO: Look into why reversing c and r from where they should be makes it work
                end
            end

            if r == (row) then
                return_str = return_str .. ("\\\\")
            else
                return_str = return_str .. ("\\&")
            end
        end
    end
    return return_str
 end

 function draw_pgf_kmap(column, row, grid_numb, implacant1, implacant2)
    grid_numb = grid_numb-1
    -- TODO: Transform the following settings variables into arguments
    local is_multitable_seperated = true    -- Setting to determine if the graphs are drawn with a sperator line or distanced out
    local graph_seperator = 1.5                -- Seperation lenght between kmaps if is_multitable_seperated=false
    local kmaplevel_seperator_lenght = 0.1   -- Setting to determine the seperator line's thickness if is_multitable_seperated=true
    local line_width = 0.015                 -- Set the line thickness of things here
    local zero_var_line_lenght = 0.75         -- The lenght of the line at the top-left corner of the kmap where the implacants reside
    for d=0,grid_numb,1 do
        if is_multitable_seperated then graph_seperator = 0 end
        -- Find the top-left corner of each grid (seperated by 1 unit)
        local grid_x_loc = (d % 2)*(column+graph_seperator)
        local grid_y_loc = -(d // 2)*(row+graph_seperator)
--         localPrint(string.format("\\node[above] at (%f,%f) {\\small{%s}};", 0, 0, abimplecant))
        if is_multitable_seperated then
            if (d % 2) == 1 then
                local add_heigh = 0
                if d >= 2 then add_heigh = kmaplevel_seperator_lenght end
                localPrint(string.format("\\fill[black] (%f,%f) rectangle (%f,%f);", grid_x_loc, grid_y_loc, grid_x_loc+kmaplevel_seperator_lenght, grid_y_loc-row-line_width-add_heigh))
                grid_x_loc = grid_x_loc + kmaplevel_seperator_lenght
            end
            if d >= 2 then
                localPrint(string.format("\\fill[black] (%f,%f) rectangle (%f,%f);", grid_x_loc, grid_y_loc, grid_x_loc+column+line_width, grid_y_loc-kmaplevel_seperator_lenght))
                grid_y_loc = grid_y_loc - kmaplevel_seperator_lenght
            end
        end
        if (is_multitable_seperated == false) or (d==0) then
            localPrint(string.format("\\draw[inner sep=0pt, outer sep=0pt] (%f, %f) -- (%f, %f);", grid_x_loc+line_width, grid_y_loc-line_width, grid_x_loc-zero_var_line_lenght, grid_y_loc+zero_var_line_lenght))
            localPrint(string.format("\\node[right] at (%f,%f) {\\small{%s}};", grid_x_loc-0.6, grid_y_loc+0.6, implacant1))
            localPrint(string.format("\\node[left] at (%f,%f) {\\small{%s}};", grid_x_loc-0.3, grid_y_loc+0.3, implacant2))
        end
        -- Print out the matrix
        localPrint(string.format("\\matrix[matrix of nodes, ampersand replacement=\\&, column sep={1cm,between origins}, row sep={1cm,between origins}, nodes={rectangle,draw,minimum height=1cm,align=center,text width=1cm,inner sep=0pt, text height=2ex, text depth=0.5ex, line width=0.015cm}, anchor=north west, inner sep=0pt, outer sep=0pt] at (%f, %f) {%s};",
                                 grid_x_loc, grid_y_loc, generateKMap(row, column, d)
                                 ))
    end
 end

