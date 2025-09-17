import gzip
import shutil
import os
from tqdm import tqdm

INPUT_DIR = "data"      
OUTPUT_DIR = "data_csv" 

def decompress_all(input_dir=INPUT_DIR, output_dir=OUTPUT_DIR):
    os.makedirs(output_dir, exist_ok=True)

    files = [f for f in os.listdir(input_dir) if f.endswith(".gz")]
    print(f"Found {len(files)} compressed files to decompress.")

    for fname in tqdm(files):
        input_path = os.path.join(input_dir, fname)
        output_name = fname[:-3] 
        output_path = os.path.join(output_dir, output_name)

        with gzip.open(input_path, "rb") as f_in:
            with open(output_path, "wb") as f_out:
                shutil.copyfileobj(f_in, f_out)

        print(f"Decompressed {fname} → {output_name}")

if __name__ == "__main__":
    decompress_all()