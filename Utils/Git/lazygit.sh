#!/bin/bash
echo "Chose your commit message"
read commitMessage
git add .
git commit -m "$commitMessage"
git push
