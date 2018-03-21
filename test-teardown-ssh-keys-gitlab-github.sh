#/bin/bash

creds_file_github=creds-for-curl-github-delete-public-key.netrc
creds_file_gitlab=creds-for-curl-gitlab.txt
if [ ! -f $creds_file_github ]
then
    echo "The required file $creds_file_github does not exist. Needs to be created from creds-for-curl-github.netrc.template using user with correct scopes"
    exit 1
fi
if [ ! -f $creds_file_gitlab ]
then
    echo "The required file $creds_file_gitlab does not exist. Needs to be created from $creds_file_gitlab.template using user with correct scopes"
    exit 1
fi
title_of_key="matthew@matthew-VirtualBox"
echo Removing key $title_of_key from GitLab
no_of_keys_before=$( curl -s -K creds-for-curl-gitlab.txt "https://gitlab.com/api/v4/user/keys" | jq '. | length' )
echo no of keys BEFORE $no_of_keys_before
echo get key id for key with title $title_of_key
key_id=$( curl -s -K creds-for-curl-gitlab.txt "https://gitlab.com/api/v4/user/keys" |  jq --arg title "$title_of_key" '.[] | select(.title == $title).id' )
echo $key_id
echo attempting to delete key...
curl -X DELETE -K creds-for-curl-gitlab.txt "https://gitlab.com/api/v4/user/keys/$key_id"
echo
no_of_keys_after=$( curl -s -K creds-for-curl-gitlab.txt "https://gitlab.com/api/v4/user/keys" | jq '. | length' )
echo no of keys AFTER $no_of_keys_after

echo Removing key $title_of_key from GitHub

no_of_keys_before=$( curl -s --netrc-file $creds_file_github https://api.github.com/user/keys | jq '. | length' )
echo no of keys BEFORE $no_of_keys_before
echo get key id for key with title $title_of_key
key_id=$( curl -s --netrc-file $creds_file_github https://api.github.com/user/keys |  jq --arg title "$title_of_key" '.[] | select(.title == $title).id' )
echo $key_id
echo attempting to delete key...
curl -X DELETE --netrc-file $creds_file_github https://api.github.com/user/keys/${key_id}
echo
no_of_keys_after=$( curl -s --netrc-file $creds_file_github https://api.github.com/user/keys | jq '. | length' )
echo no of keys AFTER $no_of_keys_after
