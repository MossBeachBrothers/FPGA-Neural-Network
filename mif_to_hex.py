# Convert MIF to HEX
def mif_to_hex(mif_filename, hex_filename):
# mif_to_hex.py

    # Open the MIF file and hex file
    with open('sigmoid_14_bit.mif', 'r') as mif_file, open('sigmoid_14_bit.hex', 'w') as hex_file:
        in_content_section = False
        for line in mif_file:
            line = line.strip()
            if line.startswith("CONTENT"):
                in_content_section = True
                continue
            if in_content_section:
                if line == "END;":
                    break
                if ':' in line:
                    _, value = line.split(':')
                    value = value.strip().strip(';')
                    # Write the value to the hex file
                    hex_file.write(f"{int(value):02X}\n")


# Convert HEX to MIF
def hex_to_mif(hex_filename, mif_filename):
    with open(hex_filename, 'r') as hex_file, open(mif_filename, 'w') as mif_file:
        mif_file.write("WIDTH=8;\nDEPTH=256;\n\nADDRESS_RADIX=UNS;\nDATA_RADIX=HEX;\n\nCONTENT BEGIN\n")
        
        address = 0
        for line in hex_file:
            line = line.strip()
            if line:
                # Write the address and value to the MIF file
                mif_file.write(f"    {address} : {line};\n")
                address += 1
                
        mif_file.write("END;\n")

# File names
mif_filename = 'sigmoid_14_bit.mif'
hex_filename = 'sigmoid_14_bit.hex'
converted_mif_filename = 'converted_sigmoid_14_bit.mif'

# Convert MIF to HEX
mif_to_hex(mif_filename, hex_filename)

# Convert HEX back to MIF
hex_to_mif(hex_filename, converted_mif_filename)
