# vim:set ts=4 sw=4 et:

use Test::Nginx::Socket::Lua;
use Cwd qw(cwd);

repeat_each(1);

plan tests => repeat_each() * (3 * blocks());

my $pwd = cwd();

our $HttpConfig = qq{
    lua_package_path "$pwd/lib/?.lua;;";
};

$ENV{TEST_NGINX_PATH} = $pwd;

no_long_string();
#no_diff();

run_tests();

__DATA__

=== TEST 1: sanity
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua_block {

            local resty_ini = require "resty.ini"

            local conf, err = resty_ini.parse_file("$TEST_NGINX_PATH/t/sample.ini")
            if not conf then
                ngx.say("failed to parse_file: ", err)
                return
            end

            local function sorted_keys(t)
                local keys = {}
                for k, _ in pairs(t) do
                    keys[#keys + 1] = k
                end
                table.sort(keys)
                return keys
            end

            for _, section in ipairs(sorted_keys(conf)) do
                local values = conf[section]

                for __, k in ipairs(sorted_keys(values)) do
                    local v = values[k]
                    ngx.say(section, ": '", k, "', '", v, "'")
                end
            end
        }
    }
--- request
GET /t
--- response_body
default: 'passwd', 'xx; foo'
default: 'port', '3306'
default: 'server', '127.0.0.1'
default: 'username', 'ngx_test'
guest: 'limit_rate', '1r/s'
guest: 'passwd', 'false'
guest: 'username', 'guest'
--- no_error_log
[error]
