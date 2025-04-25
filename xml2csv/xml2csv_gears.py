import os
import csv
import argparse
import xml.etree.ElementTree as ET


def extract_serial(filename):
    """Extracts the zXXXX pattern and returns the number part as serial."""
    match = re.search(r'z(\d+)', filename)
    return match.group(1) if match else ""

def xml_to_csv_recursive(root_dir, output_csv):
    header = [
        "filename", "path", "serial", "width", "height", "depth", "segmented",
        "object_name", "score", "xmin", "xmax", "ymin", "ymax"
    ]

    rows = []

    for subdir, _, files in os.walk(root_dir):
        for file in files:
            if file.endswith(".xml"):
                file_path = os.path.join(subdir, file)
                serial = extract_serial(file)
                try:
                    tree = ET.parse(file_path)
                    root = tree.getroot()

                    filename = root.findtext("filename", default="")
                    path = root.findtext("path", default="")
                    size = root.find("size")
                    width = size.findtext("width", default="") if size is not None else ""
                    height = size.findtext("height", default="") if size is not None else ""
                    depth = size.findtext("depth", default="") if size is not None else ""
                    segmented = root.findtext("segmented", default="")

                    for obj in root.findall("object"):
                        name = obj.findtext("name", default="")
                        score = obj.findtext("score", default="")
                        bndbox = obj.find("bndbox")
                        xmin = bndbox.findtext("xmin", default="") if bndbox is not None else ""
                        xmax = bndbox.findtext("xmax", default="") if bndbox is not None else ""
                        ymin = bndbox.findtext("ymin", default="") if bndbox is not None else ""
                        ymax = bndbox.findtext("ymax", default="") if bndbox is not None else ""

                        rows.append([
                            filename, path, serial, width, height, depth, segmented,
                            name, score, xmin, xmax, ymin, ymax
                        ])
                except ET.ParseError as e:
                    print(f"Error parsing {file_path}: {e}")

    with open(output_csv, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(header)
        writer.writerows(rows)

    print(f"CSV saved to {output_csv}")

def main():
    parser = argparse.ArgumentParser(description="Convert XML annotations to CSV.")
    parser.add_argument("input_dir", help="Root directory to search for XML files")
    parser.add_argument("output_csv", help="Path to output CSV file")
    args = parser.parse_args()

    xml_to_csv_recursive(args.input_dir, args.output_csv)

if __name__ == "__main__":
    main()

