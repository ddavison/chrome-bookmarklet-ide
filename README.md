![logo](https://raw.githubusercontent.com/ddavison/chrome-bookmarklet-ide/master/images/ide-logo-512.png)

Chrome Bookmarklet IDE
===

> A built-in IDE in Google Chrome for creating JavaScript Bookmarklets  

What it does
===

> Manage, run, edit your bookmarklets through this Chrome extension

The IDE provides a build-in code editor powered by [CodeMirror](https://codemirror.net)

Features
========

## See all bookmarklets in your project directory
![bookmarklets](http://i.imgur.com/wedzJE2.png)

## Edit existing bookmarklets
![editing](http://i.imgur.com/5wMkr2D.png)

## Add bookmarklets from the web
![add from link](http://i.imgur.com/S9kHuDi.png)

Develop
===

- Clone the repository
- Configure

  > $ npm install -g bower
  
  > $ npm install
  
  > $ bower install

- Compile all sources from `./src` into `./dist`.

  > $ grunt
  
- In Chrome, enable Developer mode, and click "Load unpacked extension"
- Select the `./dist` folder and click OK.

After making changes...

- Compile all sources

    > $ grunt
    
- In Chrome, find the extension and click "Reload".
