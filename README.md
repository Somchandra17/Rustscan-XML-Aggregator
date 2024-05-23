# Rustscan XML Aggregator

This repository contains a Python script that automates the process of running Rustscan on a list of subdomains, storing the results in XML format, and merging the individual XML files into a single aggregated XML file. The script also converts the aggregated XML to an HTML report for easier analysis.

## Prerequisites

Before running the script, ensure you have the following installed on your system:

- Python 3.x
- Rustscan
- `xsltproc` (for converting XML to HTML)

## Installation

1. Clone this repository to your local machine:

```sh
git clone https://github.com/yourusername/rustscan-xml-aggregator.git
cd rustscan-xml-aggregator
```
2. Ensure Rustscan is installed and accessible from the command line. You can install Rustscan using:

```sh
cargo install rustscan
```
3. Ensure xsltproc is installed on your system. You can install it using:

```
sudo apt-get install xsltproc  # On Debian/Ubuntu
brew install xsltproc          # On macOS
```
## Usage

1. Prepare a file containing the list of subdomains, each on a new line. For example, subdomains.txt:

```
example.com
test.example.com
anotherdomain.com
```

2. Run the python script: 

```sh
python run_rustscan_and_merge.py
```

3. When prompted, enter the path to your subdomains file:

```
Enter the path to the subdomains file: subdomains.txt
```
### Breakdown

The script will:

    > Run Rustscan for each domain in the subdomains file.
    > Store the output XML files in the results directory.
    > Add the domain name to each resulting XML file.
    > Merge all the XML files into a single file named aggregated_results.xml.
    > Convert the aggregated XML to an HTML report named report.html.
