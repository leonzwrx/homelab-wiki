```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```

## Managing certificates for HAProxy & Atlassian servers
_Updated July 2024_

This guide outlines general steps for managing certificates for HAProxy and Atlassian servers (Jira, Bitbucket, Confluence). Replace placeholders with actual file paths and names as needed.

### Converting Certificates to PEM Format
1. Convert the issued certificate (`.cer`) to PEM format:

   ```bash
   openssl x509 -in <certificate_file>.cer -outform PEM -out <certificate_file>.pem
   ```
   * Replace `<certificate_file>` with the actual certificate filename.

### Verifying Key and Certificate Match
2. Verify that the key and certificate are a matching pair:

   ```bash
   openssl rsa -modulus -noout -in <private_key_file>.key | openssl md5
   openssl x509 -modulus -noout -in <certificate_file>.pem | openssl md5
   ```
   * If the output matches, the key and certificate are likely a pair.
   * Replace `<private_key_file>` and `<certificate_file>` with the actual file names.

### Creating a Combined PEM File
3. Combine the private key and certificate into a single PEM file:

   ```bash
   cat <private_key_file>.key <certificate_file>.pem > combined_cert.pem
   ```
   * Replace `<private_key_file>` and `<certificate_file>` with the actual file names.

### Updating HAProxy Certificates
4. Move the combined PEM file to the HAProxy certificate directory:

   ```bash
   mv combined_cert.pem /etc/haproxy/certs
   ```
   * Adjust the target directory if necessary.

5. Restart HAProxy:

   ```bash
   systemctl restart haproxy
   ```

### Loading Certificates into Atlassian Servers
**Note:** Certificate locations and keystore passwords vary across Atlassian products and installations. Consult the specific Atlassian documentation for accurate details.

#### Scenario 1: Loading a Third-Party Certificate
1. Locate the Java truststore (`cacerts`) file.
2. Import the certificate using the `keytool` command:

   ```bash
   keytool -import -keystore <truststore_path>/cacerts -alias <alias_name> -file <certificate_file>.pem
   ```
   * Replace placeholders with actual paths and values.
   * Provide the keystore password when prompted.

#### Scenario 2: Replacing Certificates
1. Backup the existing `cacerts` file.
2. Import the new certificates into the `cacerts` file:

   ```bash
   keytool -import -keystore <truststore_path>/cacerts -alias <alias_name> -file <certificate_file>.pem
   ```
   * Repeat for each certificate.
3. (Optional) List existing certificates:

   ```bash
   keytool -list -keystore <truststore_path>/cacerts -v
   ```
4. (Optional) Delete old certificates:

   ```bash
   keytool -delete -alias <old_alias> -keystore <truststore_path>/cacerts
   ```

### Additional Notes
* **Common certificate directories:** `/etc/ssl`, `/usr/local/etc/ssl`, or application-specific directories.
* **Keystore locations:** Check Atlassian documentation for specific locations.
* **Truststore passwords:** Use the correct password for your Atlassian installation.
* **Certificate details:** Use `openssl x509 -in <certificate_file>.pem -text` to view certificate information.
