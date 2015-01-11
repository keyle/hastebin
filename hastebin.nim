## 
## hastebin - Simple hastebin client
##
## (c) 2015 Nicolas Noben
##     MIT License
## 
import httpclient, strutils, json, parseopt2, os

const Version = 1.0

const Usage = "\nhastebin " & $Version & """ - Simple hastebin client

    Usage:
        echo some content | hastebin [options]

    Options:
        -o      Open the resulting URL
        -s      Do not print anything
        -u      alternative url to http://hastebin.com/"""

var
    open:bool
    silent:bool
    hasteurl:string = "http://hastebin/"

let x = stdin.readAll.strip
if x.len < 2:
    echo Usage
    quit()

for opt in getopt():
    if opt.kind == CmdLineKind.cmdShortOption:
        case opt.key:
        of "o":
            open = true
        of "s":
            silent = true
        of "u":
            hasteurl = opt.val
            if(hasteurl.len < 4):
                echo "\nInvalid url, expected: -u http://someurl.com/"
                echo Usage
                quit()
        else:
            echo "\nUnknown parameter: ", opt.key
            echo Usage
            quit()

let res = parseJson postContent(url = "http://hastebin.com/documents", body = x)
assert (res.kind == JObject)

let url = "http://hastebin.com/" & res["key"].str

if silent == false:
    echo url

if open == true:
    if defined(windows):
        let openstr = "start " & url
        discard execShellCmd(openstr)
    else:
        let openstr = "open " & url # TODO check that it works on both mac/linux
        discard execShellCmd(openstr)
    
