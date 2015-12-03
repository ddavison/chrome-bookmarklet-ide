![logo](https://raw.githubusercontent.com/ddavison/chrome-bookmarklet-ide/master/images/ide-logo-512.png)

Chrome Bookmarklet IDE
===

> A built-in IDE in Google Chrome for creating JavaScript Bookmarklets  


Develop
===

- Clone the repository
- Compile all sources from `./src` into `./dist`.
  > $ grunt
- In Chrome, enable Developer mode, and click "Load unpacked extension"
- Select the `./dist` folder and click OK.

After making changes...

- Compile all sources
    > $ grunt
- In Chrome, find the extension and click "Reload".
