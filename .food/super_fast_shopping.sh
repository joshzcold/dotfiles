#!/usr/bin/env bash
#
# based on a list of grocery items, bring up a smiths search page in qutebrowser
#
grocery_store="${store:-smiths}"



while read p; do
  if [[ -n "$p" ]];then
    case $grocery_store in
      smiths)
        url="https://www.smithsfoodanddrug.com/search?query=$p&searchType=default_search"
        ;;
      maceys)
        url="https://shop.rosieapp.com/maceys_10998/search/$p"
        ;;
    esac
    qutebrowser ":open -t $url"
  fi
done <"$1"
