# LuaHTML
pre-processor for mixed html code with lua.  
it works like `<?php ... ?>` but codeblocks looks like: `<lua>...</lua>`

Exapmple:

Luahtml:
```
<h1><lua> print('Test') </lua></h1>
```

PHP:
```
<h1><?php echo("Test") ?></h1>
```

Usage:
```
local result_html = EvalLuaHTML("<h1><lua> print('Test') </lua></h1>")
local result_html = EvalLuaHTMLFile("var/www/site.com/pages/index.lua.html")
```

  
Here is binding for Luvit http:  
https://github.com/Be1zebub/LuvitWeb
