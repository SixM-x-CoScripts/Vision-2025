function all_trim(s)
   if type(s) ~= "string" then return end
   return s:match( "^%s*(.-)%s*$" )
end