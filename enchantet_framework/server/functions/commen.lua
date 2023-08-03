encf = {}
users = {}

encf.player = function(source)
    local player = {}
    users[player:id()].source = source

    function player:identifier()
        local identifier = GetPlayerIdentifierByType(source, 'license'):gsub("license:", "")
        return identifier
    end

    function player:create()
        MySQL.Sync.insert('INSERT INTO `users` (identifier) VALUES (?)', {
            self:identifier()
        }, function(id)
            MySQL.Sync.insert('INSERT INTO `user_data` (id) VALUES (?)', {
                id
            }, function(id)
            end)
        end)
    end
    function player:delete()
        MySQL.Async.execute('DELETE FROM users WHERE id = ?;', {self:id()}, function(affectedRows) end)
    end

    function player:id()
        local id = MySQL.Sync.fetchScalar('SELECT `id` FROM `users` WHERE `identifier` = ? LIMIT 1', {
            self:identifier()
        })
        return id
    end
    function player:banned()
        local banned = MySQL.Sync.fetchScalar('SELECT `banned` FROM `users` WHERE `id` = ? LIMIT 1', {
            self:id()
        })
        return banned == 'yes'
    end
    function player:ban(m)
        MySQL.Async.execute('UPDATE users SET banned = ? WHERE id = ?', {
            m, self:id()
        }, function(affectedRows)
        end)
    end
    function player:allowlisted()
        local allowlisted = MySQL.Sync.fetchScalar('SELECT `allowlisted` FROM `users` WHERE `id` = ? LIMIT 1', {
            self:id()
        })
        return allowlisted == 'yes'
    end
    function player:allowlist(m)
        MySQL.Async.execute('UPDATE users SET allowlisted = ? WHERE id = ?', {
            m, self:id()
        }, function(affectedRows)
        end)
    end
    function player:money(type, type2, amount)
        if type2 ~= 'bank' or type2 ~= 'wallet' and amount ~= nil or type(amount) ~= 'number' then
            encf.error('player/money', 'Type not found!')
        else
            if type == 'get' then
                local money = MySQL.Sync.fetchScalar('SELECT '..type2..' FROM `users` WHERE `id` = ? LIMIT 1', {
                    self:id()
                })
                return money
            elseif type == 'add' then
                MySQL.Async.execute('UPDATE users SET '..type2..' = '..type2..' + ? WHERE id = ?', {
                    amount, self:id()
                }, function(affectedRows)
                end)
            elseif type == 'remove' then
                MySQL.Async.execute('UPDATE users SET '..type2..' = '..type2..' - ? WHERE id = ?', {
                    amount, self:id()
                }, function(affectedRows)
                end)
            else
                encf.error('player/money', 'Type not found!')
            end
        end
    end

    function player:group(type, group)
        if group ~= nil or not encf.Config.Groups[group] then
            encf.error('player/group', 'goup not specified!')
        elseif type == 'add' then
            local gr = json.decode(self:group('get'))
            gr[group] = true
            MySQL.Async.execute('UPDATE users SET group = ? WHERE id = ?', {
                json.encode(gr), self:id()
            }, function(affectedRows)
            end)
        elseif type == 'remove' then
            local gr = json.decode(self:group('get'))
            gr[group] = nil
            MySQL.Async.execute('UPDATE users SET group = ? WHERE id = ?', {
                json.encode(gr), self:id()
            }, function(affectedRows)
            end)
        elseif type == 'get' then
            local group = MySQL.Sync.fetchScalar('SELECT group FROM `users` WHERE `id` = ? LIMIT 1', {
                self:id()
            })
            return group
        else
            encf.error('player/group', 'not found!')
        end
    end

    function player:name(type, new)
        if type(new) ~= 'string' or new ~= nil then
            encf.error('player/name', 'Name not a string')
        elseif type == 'getFirst' then
            local name = MySQL.Sync.fetchScalar('SELECT firstname FROM `users` WHERE `id` = ? LIMIT 1', {
                self:id()
            })
            return name
        elseif type == 'getLast' then
            local name = MySQL.Sync.fetchScalar('SELECT lastname FROM `users` WHERE `id` = ? LIMIT 1', {
                self:id()
            })
            return name
        elseif type == 'setFirst' then
            MySQL.Async.execute('UPDATE users SET firstname = ? WHERE id = ?', {
                new, self:id()
            }, function(affectedRows)
            end)
        elseif type == 'setLast' then
            MySQL.Async.execute('UPDATE users SET lastname = ? WHERE id = ?', {
                new, self:id()
            }, function(affectedRows)
            end)
        end
    end

    function player:inventory(type, item, amount)
        if type == 'add' then
            if type(item) == 'string' and type(amount) == 'number' and Config.Items[item] then
                local inventory = json.decode(self:inventory('get'))
                if inventory[item] then
                    inventory[item] = {amount = inventory[item].amount + amount}
                else
                    inventory[item] = {amount = amount}
                end
                MySQL.Async.execute('UPDATE user_data SET inventory = ? WHERE id = ?', {
                    json.encode(inventory), self:id()
                }, function(affectedRows)
                end)
            end
        elseif type == 'remove' then
            if type(item) == 'string' and type(amount) == 'number' and Config.Items[item] then
                local inventory = json.decode(self:inventory('get'))
                if inventory[item] then
                    if inventory[item].amount > amount or inventory[item].amount == amount then
                        inventory[item] = {amount = inventory[item].amount - amount}
                        return true
                    else
                        return 
                    end
                end
                MySQL.Async.execute('UPDATE user_data SET inventory = ? WHERE id = ?', {
                    json.encode(inventory), self:id()
                }, function(affectedRows)
                end)
            end
        elseif type == 'get' then
            local inv = MySQL.Sync.fetchScalar('SELECT inventory FROM `user_data` WHERE `id` = ? LIMIT 1', {
                self:id()
            })
            return inv
        end
    end
    
    return player
end

encf.getIdSource = function(id)
    return users[id].source
end

encf.item = function(item)
    local items = {}

    function items:getProps()
        return Config.Items[item].label, Config.Items[item].desq, Config.Items[item].weight
    end
    function items:use()
    end
    function items:useAble()
    end
end