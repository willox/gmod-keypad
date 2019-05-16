gmod-keypad
===========

This is a great addon.

http://steamcommunity.com/sharedfiles/filedetails/?id=108424005

### Hooks

```lua
hook.Add("keypad_access_granted", "...", function(keypad, ply)
    -- Called after player enters correct passcode (serverside)
    -- keypad = entity of keypad access was granted to
    -- ply    = player who pressed "enter" on the keypad
end)

hook.Add("keypad_access_denied", "...", function(keypad, ply)
    -- Called after player enters incorrect passcode (serverside)
    -- keypad = entity of keypad access was denied from
    -- ply    = player who pressed "enter" on the keypad
end)

hook.Add("keypad_cracked", "...", function(keypad, ply)
    -- Called after player keypad cracks a keypad (serverside)
    -- keypad = entity of keypad that was just cracked
    -- ply    = player who cracked the keypad
end)
```
