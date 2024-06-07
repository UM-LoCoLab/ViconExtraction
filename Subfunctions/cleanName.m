function outString = cleanName(inString)
    outString = strrep(strrep(strrep(strrep(inString,' ',''),'.','_'),'/','_'),'-','_');
end