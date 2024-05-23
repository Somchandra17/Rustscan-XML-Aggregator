import os
import subprocess
import xml.etree.ElementTree as ET

def run_rustscan(domain, results_dir):
    # Construct the Rustscan command
    command = f"rustscan -b 65000 --ulimit 70000 -a {domain} --range 0-65535 -- -Pn -oX {results_dir}/{domain}.xml"
    print(f"Running: {command}")
    subprocess.run(command, shell=True, check=True)

def add_domain_to_xml(file_path, domain):
    tree = ET.parse(file_path)
    root = tree.getroot()
    host_element = root.find('host')
    if host_element is not None:
        # Find or create the <hostnames> element
        hostnames_element = host_element.find('hostnames')
        if hostnames_element is None:
            hostnames_element = ET.SubElement(host_element, 'hostnames')
        
        # Remove existing PTR entries if you want to replace them
        for hostname in hostnames_element.findall('hostname'):
            if hostname.get('type') == 'PTR':
                hostnames_element.remove(hostname)
        
        # Add the user-defined domain name
        hostname_element = ET.SubElement(hostnames_element, 'hostname')
        hostname_element.set('name', domain)
        hostname_element.set('type', 'user-defined')
    tree.write(file_path, encoding='UTF-8', xml_declaration=True)

def create_combined_root():
    combined_root = ET.Element("nmaprun")
    combined_root.set("scanner", "nmap")
    combined_root.set("args", "Aggregated results")
    combined_root.set("start", "0")
    combined_root.set("startstr", "Aggregated results")
    combined_root.set("version", "1.05")
    combined_root.set("xmloutputversion", "1.05")
    return combined_root

def merge_xml(files, output_path):
    combined_root = create_combined_root()
    for file in files:
        tree = ET.parse(file)
        root = tree.getroot()
        for host in root.findall('host'):
            combined_root.append(host)
    
    tree = ET.ElementTree(combined_root)
    tree.write(output_path, encoding='UTF-8', xml_declaration=True)

def main():
    subdomains_file = input("Enter the path to the subdomains file: ")
    results_dir = "results"
    
    if not os.path.exists(results_dir):
        os.makedirs(results_dir)
    
    with open(subdomains_file, 'r') as f:
        domains = [line.strip() for line in f]
    
    for domain in domains:
        run_rustscan(domain, results_dir)
    
    xml_files = [os.path.join(results_dir, f) for f in os.listdir(results_dir) if f.endswith('.xml')]
    
    for xml_file in xml_files:
        domain = os.path.basename(xml_file).replace('.xml', '')
        add_domain_to_xml(xml_file, domain)
    
    merge_xml(xml_files, 'aggregated_results.xml')
    print("Merged XML saved as aggregated_results.xml")

    # Convert aggregated XML to HTML
    xslt_command = "xsltproc -o report.html nmap-bootstrap.xsl aggregated_results.xml"
    print(f"Running: {xslt_command}")
    subprocess.run(xslt_command, shell=True, check=True)
    print("HTML report saved as report.html")

if __name__ == "__main__":
    main()
