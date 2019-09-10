# Credential Encryption

# This script takes care of the storage for credentials to the APIs used
# in this experiment. The .YAML is required, but Git Ignored

library(sodium)
library(cyphr)


## To Encrypt the Original (For syntax, not reproducibility. That should be obvious)
#  k <- sha256(charToRaw("<password>"))
#  key <- cyphr::key_openssl(k)

#  save(k, file = "key.rda")
#  cyphr::encrypt_file("credentials.yaml", key, "credentials.encrypted")

## And to Decypt the File
load('../creds/key.rda')
key <- cyphr::key_sodium(k)
cyphr::decrypt_file("../creds/credentials.encrypted", key, "../creds/credentials.yaml")
rm(k, key)