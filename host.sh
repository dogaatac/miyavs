#!/bin/bash

# Yedekleme yap
cp /etc/hosts /etc/hosts.backup

# Önceki girişi kaldır
sed -i '/www.googleapis.com/d' /etc/hosts

# Yeni IP adreslerini ekle
for i in $(dig www.googleapis.com +short); do
    echo "$i www.googleapis.com" >> /etc/hosts
done
