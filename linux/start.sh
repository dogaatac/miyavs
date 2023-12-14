#!/usr/bin/env bash

echo -n "Memory gir dayi: "
read num

while true
do
  cd "$(dirname "$(realpath "${BASH_SOURCE[0]:-$0}")")"

  if [ -n "$num" ]; then
    mem_value="${num}G"
  else
    mem_value="24G"  # Memory gir dayi
  fi

  ./client -a xch16q8gxn8m8zs40fpfd6mja0hrdqwu9nna7newnww77sqjmudsa2tq89vzkk -d /mnt/pw/ --no-benchmark -c 14 --no-stop -vv -s /root/cache/ --no-mining --rescan-interval 60 -m "$mem_value"

  sleep 60
done
