Config = {}

Config.debug = false
Config.allowlisted = false
Config.Groups = {
    ['police-chef'] = {
        label = 'Police Chef',
        perms = {
            'policeArmory',
            'policeDoors'
        },
    },
}
Config.Items = {
    ['fishing-rod'] = {
        label = 'Fishing Rod',
        desq = 'Go cacth a fish',
        weight = 0.5, -- 500g
        event = 'encf:fishing:Use' -- delete if not useable
    }
}