# Credential Encryption

# This script takes care of the storage for credentials to the APIs used
# in this experiment. The .YAML is required, but Git Ignored

library(cyphr)

## To Encrypt the Original (For syntax, not reproducibility. That should be obvious)
#  k <- openssl::aes_keygen()
# key <- cyphr::key_openssl(k)
# save(key, file = "key.rda")
# cyphr::encrypt_file("credentials.yaml", key, "credentials.encrypted")

## And to Decypt the File
load('../creds/key.rda')
cyphr::decrypt_file("../creds/credentials.encrypted", key, "../creds/credentials.yaml")
rm(key)