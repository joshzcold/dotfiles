#!/usr/bin/env bash

touch "lists/list-$(date +%Y-%m-%d)"
nvim -o "lists/list-$(date +%Y-%m-%d)" "lists/"

