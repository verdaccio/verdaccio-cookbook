#!/usr/bin/env bats

@test "node should be in the path" {
    [ "$(command -v node)" ]
}

@test "verdaccio should be in the path" {
    [ "$(command -v verdaccio)" ]
}

@test "verdaccio should be running" {
    [ "$(ps aux |grep -v grep |grep verdaccio)" ]
}

@test "verdaccio should be listening TCP 4873" {
    [ "$(netstat -plant | grep 4873 | grep LISTEN)" ]
}
