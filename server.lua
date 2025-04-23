RegisterNetEvent('tag:requestTags', function(tagType)
    local src = source
    local tags = {}
    for _, tag in ipairs(Config.Tags) do
        if IsPlayerAceAllowed(src, tag.ace) then
            table.insert(tags, tagType == 'head' and tag.headtag or tag.gangtag)
        end
    end
    TriggerClientEvent('tag:setAvailableTags', src, {type = tagType, tags = tags})
end)
