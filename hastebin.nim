## 
## hastebin - Simple hastebin client
##
## (c) 2015 Nicolas Noben
##     MIT License
## 
import httpclient, strutils, json, parseopt2, os, osproc

const Version = 1.0

const Usage = "\nhastebin " & $Version & """ - Simple hastebin client

    Usage:
        echo some content | hastebin [options]

    Options:
        -o      Open the resulting URL
        -s      Do not print anything
        -u      alternative url to http://hastebin.com"""

var
    open:bool
    silent:bool
    hasteurl:string = "http://hastebin.com"

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
                echo "\nInvalid url, expected: -u http://somehasteserver.com"
                echo Usage
                quit()
        else:
            echo "\nUnknown parameter: ", opt.key
            echo Usage
            quit()

let res = parseJson postContent(url = hasteurl & "/documents", body = x)
assert (res.kind == JObject)

let url = hasteurl & "/" & res["key"].str

if silent == false:
    echo url

if open == true:
    # TODO test on mac / linux
    if defined(windows):
        let openstr = "start " & url
        discard execShellCmd(openstr)
    if defined(linux):
        discard osproc.execProcess("xdg-open", [url])  
    else:
        let openstr = "open " & url
        discard execShellCmd(openstr)
