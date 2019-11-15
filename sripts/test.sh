#!/usr/bin/env bash

f () {
    if [ $1 = "English (US)" ]; then
        echo "US"
    fi 
    if [ $1 = "Russian" ]; then
        echo "RU"
    fi 
}
f "Russian"
echo "1z"
