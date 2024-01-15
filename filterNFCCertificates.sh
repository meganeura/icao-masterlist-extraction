#!/bin/bash

echo "#########################"
echo "Hello! I will extract all certificates for the countries you need and merge them to a new file. Please make sure the certificates are in a file called master_list_all.pem. You can select the countries by changing my code."
echo "Enough pleasantries exchanged. Let's get started!"
echo "#########################"

split -p "-----BEGIN CERTIFICATE-----" master_list_all.pem individual-

counter=0
output_file="filtered_masterlist.pem"

> "$output_file"

for file in individual-*; do
    certificate_output=$(openssl crl2pkcs7 -nocrl -certfile "$file" | openssl pkcs7 -print_certs -noout)

    if [[ "$certificate_output" =~ "C=AT" || "$certificate_output" =~ "C=DE" || "$certificate_output" =~ "C=CZ" || "$certificate_output" =~ "C=SK" ]]; then
        echo "I will keep that one: "
        echo $certificate_output
        echo "------------------------"
        cat "$file" >> "$output_file"
        rm "$file"
    else
        rm "$file"
        continue
    fi

    ((counter++))
done

echo "#########################"
echo "My work is done. $counter certificates found."
echo "I added everything you need to filtered_masterlist.pem."
echo "#########################"

