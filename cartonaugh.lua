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
    for c=0,column+1,1 do
        for r=0,row+1,1 do
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
            
            if r == (row+1) then
                return_str = return_str .. ("\\\\")
            else
                return_str = return_str .. ("\\&")
            end
        end
    end
    return return_str
 end
 
 function draw_pgf_kmap(column, row, grid_numb)
    grid_numb = grid_numb-1
    for d=0,grid_numb,1 do
        -- Find the top-left corner of each grid (seperated by 1 unit)
        local grid_x_loc = (d % 2)*(column+1)
        local grid_y_loc = (d // 2)*(row+1)
        -- Print out the grid
        localPrint(string.format("\\draw[color=black, ultra thin] (%d,%d) grid (%d, %d);", grid_x_loc, grid_y_loc, grid_x_loc+column, grid_y_loc+row))
        -- Print out the 
        -- Print out the matrix
        localPrint(string.format("\\matrix[matrix of nodes, ampersand replacement=\\&, column sep={1cm,between origins}, row sep={1cm,between origins},] at (%f, %f) {%s};", 
                                 grid_x_loc+(column//2), grid_y_loc+(row//2), generateKMap(row, column, d)
                                 ))
    end
 end
 
 
