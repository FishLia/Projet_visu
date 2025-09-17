import requests
import os
from tqdm import tqdm

DATASET_SLUG = "donnees-climatologiques-de-base-mensuelles"

def get_dataset_resources(dataset_slug):
    url = f"https://www.data.gouv.fr/api/1/datasets/{dataset_slug}/"
    r = requests.get(url)
    r.raise_for_status()
    data = r.json()
    return data["resources"]

def download_all(dataset_slug):
    resources = get_dataset_resources(dataset_slug)
    print(f"Found {len(resources)} resources")

    os.makedirs("data", exist_ok=True)

    for res in tqdm(resources):
        title = res.get("title", res["id"]).replace(" ", "_")
        fmt = res.get("format", "").lower()
        url = res.get("url")
        if not url:
            print(f"Skipping {title} (no URL)")
            continue

        filename = f"data/{title}.{fmt or 'csv.gz'}"
        try:
            with requests.get(url, stream=True) as r:
                r.raise_for_status()
                with open(filename, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)
            
            print(f"Saved {filename}")
        except Exception as e:
            print(f"Error on {title}: {e}")

download_all(DATASET_SLUG)
