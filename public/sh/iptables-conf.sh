#!/bin/bash

echo "Iniciando configuração..."

### SSH Permitir conexões SSH

iptables -I INPUT -p tcp --dport 22 -j ACCEPT

iptables -I INPUT -i lo -j ACCEPT

### Permitir conexões do Full Node

iptables -A INPUT -p tcp --dport 6868 -j ACCEPT

iptables -A INPUT -p tcp --dport 6886 -j ACCEPT

iptables -A INPUT -p tcp --dport 6869 -j ACCEPT

### Permitir conexões já estabelecidas

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

### Proibir todas as conexões de entrada

iptables -P INPUT DROP

echo FEITO - Não se esqueça de persistir as regras quando elas funcionam.

echo "iptables-save > /etc/iptables/rules.v4"
