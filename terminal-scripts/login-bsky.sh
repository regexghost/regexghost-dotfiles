#!/bin/sh

# Quick script to login to bsky cli without saving password to shell history

read -p "Enter handle: " handle
read -p "Enter password: " password
bsky login "$handle" "$password"
