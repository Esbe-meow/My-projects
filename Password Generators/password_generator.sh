#!/bin/bash

lowcase="abcdefghijklmnopqrstuvwxyz"
upcase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
numbers="0123456789"
symbols="!@#$%^&*()_=+[]{};:,.<>?/-"

characters="${lowcas}${upcase}${numbers}${symbols}"

read -r -p "password length: " length

if ! [[ "$length" =~ ^[0-9]+$ ]] || (( length <= 0 )); then
    echo "password length must be a positive integer."
    exit 1
fi

read -r -p "number of passwords to generate: " passwordnum

if ! [[ "$passwordnum" =~ ^[0-9]+$ ]] || (( passwordnum <= 0 )); then
    echo "password to generate must be a positive integer."
    exit 1
fi

generate_password() {
    local length=$1
    local pass=""
    local set

    for set in "$lowcase" "$upcase" "$numbers" "$symbols"; do
        if [ -n "$set" ]; then
            pass+=$(LC_ALL=C tr -dc "$set" < /dev/urandom | head -c 1)
        fi
    done

    local left=$(( length - ${#pass} ))
    if (( left > 0 )); then
        pass+=$(LC_ALL=C tr -dc "$characters" < /dev/urandom | head -c "$left")
    fi

    pass=$(echo "$pass" | fold -w1 | shuf | tr -d '\n')

    echo "${pass:0:length}"
}

for ((i = 0; i < passwordnum; i++)); do
    generate_password "$length"
done
