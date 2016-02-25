###
  Bookmarklet IDE
  (c) 2015 Daniel Davison & Contributors

  Bookmarklet IDE for Chrome
###

# this class is basically a middle man between the chrome storagesync specific to the IDE
class Settings
  # Save the settings
  save: (obj, callback) ->
    chrome.storage.sync.set(obj, ->
      callback()
    )

  # Get any setting from the storage
  get: (obj, callback) ->
    chrome.storage.sync.get(obj, (items) ->
      callback(items)
    )

window.Settings = new Settings()
