# STL_CRIME_Murders

This repository is also now hosting the resources for the evaluation of commercial geocoding options.

## File Structure

`creds/` contains an encrypted YAML file with the API credentials.

`data/` contains tabular and spatial data.

`docs/` contains R-Markdown notebooks with narrated analysis.

`source/` contains scripts for creating the dataset, defining geocoding functions, decryption, and making maps.

## Credential Storage
This work uses commercial APIs with private credentials. To protect the security of these credentials, they are encrypted using the R package `cyphr` prior to being added to git. The unencrypted YAML and key are gitignored and should never be pushed.
There are other options for credential storage, such as storing in the .Renviron or using a keychain manager, however, the current implementation allows for collaborators to access the same set of credentials.

You will need to obtain your own credentials to replicate most of this experiment. It is important to note that keys for all of the options tested here do not require even a credit card.
You may store your credentials in the same fashion, using YAML.

The YAML syntax is such:
```yaml
GoogleMaps:
  Key:
    xxxxxxxxxxxxx
```

... and you may use the `yaml::read_yaml()` function to interpret this as an R object.

To encrypt the file:
```r
# First, Generate a Key
k <- openssl::aes_keygen()
key <- cyphr::key_openssl(k)
# IMPORTANT, Save this key somewhere safe
save(key, file = 'key.rda')

# To Encrpyt a File
cyphr::encrypt_file("credentials.yaml", key, "credentials.encrypted")
```

Then to decrypt this file later:
```r
load('key.rda')
cyphr::decrypt_file("credentials.encrypted", key, "credentials.yaml")
rm(key)
```
To share access to your credentials, all you need to share is the `key.rda` file.
