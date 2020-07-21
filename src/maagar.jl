module maagar

"""
    append_line(key::String, value::String)

documentation
"""
function append_line(key::String, value::String)
    len::UInt16 = ncodeunits(key) + ncodeunits(value)
    len_key::UInt8 = ncodeunits(key)
    open("./maagar", append=true) do io
        write(io, len, len_key, key, value, "\n")
    end
end # function

"""
    write_loop(c::Channel)

documentation
"""
function write_loop(c::Channel)
    for key_val in c
        append_line(key_val[1], key_val[2])
    end
end # function

"""
    find_by_key(args)

documentation
"""
function find_by_key(search_key::String)
    open("./maagar", read=true) do io
        while true
            len = read(io, 2)
            if length(len) == 0
                return nothing
            end
            len = reinterpret(UInt16, len)[1]
            len_key = reinterpret(UInt8, read(io, 1))[1]
            global key = String(read(io, len_key))
            global value = String(read(io, len - len_key))
            if key == search_key
                break
            end
        end
        return (key, value)
    end
end # function

"""
    initialize_loop()

documentation
"""
function initialize_loop()::Channel
    channel = Channel(write_loop)
    return channel
end # function

channel = initialize_loop()
put!(channel, ("1", "testing"))
put!(channel, ("2", "testing1"))
put!(channel, ("3", "testing2"))
put!(channel, ("4", "testing3"))

println(find_by_key("4"))
println(find_by_key("5"))

end # module
