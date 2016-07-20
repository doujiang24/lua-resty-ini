Name
=====

lua-resty-ini - Lua ini parser

Table of Contents
=================

* [Name](#name)
* [Status](#status)
* [Synopsis](#synopsis)
* [Author](#author)
* [Copyright and License](#copyright-and-license)
* [See Also](#see-also)

Status
======

This library is still under early development and is still experimental.



Synopsis
========

```lua
    lua_package_path "/path/to/lua-resty-ini/lib/?.lua;;";

    server {
        location /test {
            content_by_lua_block {
                local resty_ini = require "resty.ini"

                local conf, err = resty_ini.parse_file("/path/to/file.ini")
                if not conf then
                    ngx.say("failed to parse_file: ", err)
                    return
                end

                for section, values in pairs(conf) do
                    for k, v in pairs(values) do
                        ngx.say(section, ": '", k, "', '", v, "', ", type(v))
                    end
                end
            }
        }
    }
```

file.ini
```ini
[default]
username = ngx_test
password = ngx_test
notes = "just for test"
number = 10

[guest]
username= guest
; guest do not need password
password = false
```

```shell
$ curl "http://127.0.0.1:80/t"
guest: 'password', 'false', boolean
guest: 'username', 'guest', string
default: 'password', 'ngx_test', string
default: 'username', 'ngx_test', string
default: 'notes', 'just for test', string
default: 'number', '10', number
```


Author
======

Dejiang Zhu (doujiang24) <doujiang24@gmail.com>.


[Back to TOC](#table-of-contents)

Copyright and License
=====================

This module is licensed under the BSD license.

Copyright (C) 2016-2016, by Dejiang Zhu (doujiang24) <doujiang24@gmail.com>.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


[Back to TOC](#table-of-contents)

See Also
========
* the ngx_lua module: http://wiki.nginx.org/HttpLuaModule

[Back to TOC](#table-of-contents)

