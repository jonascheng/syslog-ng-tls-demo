#!/bin/bash
# Ref: https://dev.to/techschoolguru/how-to-create-sign-ssl-tls-certificates-2aai
#

# 1. Generate Root CA privatge key
openssl genrsa -out root-ca.key 4096

# 2. Generate Root CA
openssl req -sha256 -x509 -days 90 \
    -new -key root-ca.key \
    -extensions v3_ca \
    -out root-ca.pem \
    -subj "/CN=$SITE_NAME Root CA/O=TXOne Networks/OU=R&D/C=TW/ST=Taipei/L=Taipei"

# echo "Root CA"
openssl x509 -in root-ca.pem -noout -text

# 3. Generate Endentity CA private key
openssl genrsa -out endentity-ca.key 4096

# 4. Generate Endentity CA CSR (Certificate Signing Request)
openssl req -sha256 \
    -new -key endentity-ca.key \
    -out endentity-ca.csr \
    -subj "/CN=$SITE_NAME/O=TXOne Networks/OU=R&D/C=TW/ST=Taipei/L=Taipei"

# 5. Generate Endentity CA
openssl x509 -req -days 30 \
    -in endentity-ca.csr \
    -CA root-ca.pem \
    -CAkey root-ca.key \
    -CAcreateserial \
    -out endentity-ca.pem \
    -extfile server-ext.cnf

# echo "Server CA"
openssl x509 -in endentity-ca.pem -noout -text
