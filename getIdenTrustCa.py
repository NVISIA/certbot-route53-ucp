from BeautifulSoup import BeautifulSoup     # BeautifulSoup is an HTML Parsing library
import requests                             # Requests is an HTTP request library
r = requests.get('https://www.identrust.com/certificates/trustid/root-download-x3.html')    # Fetch the HTML page that contains the IdenTrust root CA
soup = BeautifulSoup(r.text)                                # Parse the response
certElem = soup.findAll('textarea', {'name': 'cert'})       # Search for the textarea named cert that contains the key's text
with open('/var/ucp-certs/ca.pem', 'w') as f:               # Open /var/ucp-certs/ca.pem for writing using a with block for safety
    f.write('-----BEGIN CERTIFICATE-----\n')                # Write the first line of a PEM file
    f.write(certElem[0].text)                               # Write the innards of the textarea we found by parsing the HTML
    f.write('\n-----END CERTIFICATE-----\n')                # Write the last line of a PEM file
# Since we used a with block on line 6, the file is automatically closed here even if we hit an unexpected error.
