# ansible-workspace
If you are running this on a disconnected installation of OpenShift, scroll down.

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
Also I use `ansible-jinja` for templates files
```json
"files.associations": {
       "*.j2": "ansible-jinja" 
},
```

## For disconnected installations
If you are running in an OpenShift cluster which is not connected to the internet, there are two things you need to do to get this to work.

1. Download the vscode extentions below
* https://marketplace.visualstudio.com/_apis/public/gallery/publishers/redhat/vsextensions/ansible/0.4.5/vspackage
* https://github.com/microsoft/vscode-python/releases/download/2020.7.94776/ms-python-release.vsix
2. Publish the two vsix files via som internal site or git repository
3. Edit https://github.com/pgustafs/codeready-workspaces/blob/main/plugins/redhat-ansible/meta.yaml to point to your internal place where the files are accessable.


