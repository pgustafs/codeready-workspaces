# ansible-workspace
## Editor settings I like, that you might want to set
### Automatic code completion

Open `File -> Settings -> Open Preferences` and search for `quickSuggestions` click on `Edit in settings.json`.
```json
"editor.quickSuggestions": {
    "other": true,
    "comments": false,
    "strings": true           <-- default value is 'false'
},
```
Also you might like to set identation settings for “ansible” language:
```json
"[ansible]": {
    "editor.detectIndentation": false,
    "editor.tabSize": 2,
    "editor.insertSpaces": true
},
```




