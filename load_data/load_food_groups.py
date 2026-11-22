# Load category and food group files
import json
import pandas as pd
import re
from pathlib import Path
from functools import lru_cache
from collections import deque

import json
from pathlib import Path

data_dir = Path("load_data")

with open(data_dir / "categories.full.json", encoding="utf-8") as f:
    categories = json.load(f)

with open(data_dir / "food_groups.txt", encoding="utf-8") as f:
    food_groups_text = f.read()

# Parse food_groups_text and record parent-child relationships
def normalize(name):
    name = name.removeprefix("en:")
    name = name.lower().strip()
    name = re.sub(r"[^a-z0-9]+", "-", name)
    return name.strip("-")

food_groups = {}
parents = []

for line in food_groups_text.splitlines():

    line = line.strip()

    if not line or line.startswith("#"):
        continue

    if line.startswith("< en:"):
        parents.append(normalize(line[5:]))

    elif line.startswith("en:"):
        name = line[3:].strip().replace("\\,", ",")
        key = normalize(name)

        food_groups[key] = {
            "name": name,
            "parents": parents.copy()
        }

        parents = []

# Extract the food group hierarchy
@lru_cache(maxsize=None)
def get_hierarchy(food_group):

    key = normalize(food_group)

    if key not in food_groups:
        return []

    group = food_groups[key]
    name = group["name"]
    parents = group["parents"]

    if not parents:
        return [name]

    return get_hierarchy(parents[0]) + [name]

# Get food groups from categories. If a food group is not found in a category, search it in the cloest parents.
@lru_cache(maxsize=None)
def get_food_group(category_tag):

    queue = deque([(category_tag, 0)])
    visited = set()
    matches = set()
    matched_depth = None

    while queue:

        tag, depth = queue.popleft()

        if matched_depth is not None and depth > matched_depth:
            break

        if tag in visited:
            continue

        visited.add(tag)

        category = categories.get(tag, {})

        group = category.get("food_groups", {}).get("en")

        if group == "undef":
            continue

        if group:
            matches.add(group)
            matched_depth = depth
            continue

        for parent in category.get("parents", []):
            queue.append((parent, depth + 1))

    if len(matches) > 1:
        return None, "ambiguous"

    if len(matches) == 1:
        method = "direct" if matched_depth == 0 else "inherited"
        return next(iter(matches)), method

    return None, "unmapped"

# Create the mapping table
records = []

for category_tag in categories:

    food_group, method = get_food_group(category_tag)

    hierarchy = (
        get_hierarchy(food_group)
        if food_group
        else []
    )

    # OFF handles alcoholic beverages as a special case
    if hierarchy == ["Alcoholic beverages"]:
        hierarchy.append("Alcoholic beverages")

    records.append({
        "category_tag": category_tag,
        "food_group_1": hierarchy[0] if len(hierarchy) >= 1 else None,
        "food_group_2": hierarchy[1] if len(hierarchy) >= 2 else None,
        "food_group_3": hierarchy[2] if len(hierarchy) >= 3 else None,
        "mapping_method": method
    })

df = pd.DataFrame(records)

# Testing
# Distribution of mapping methods
#print(df["mapping_method"].value_counts())

# Mapping coverage
#print(df["food_group_1"].notna().mean())
#print(df["food_group_2"].notna().mean())

# Number of distinct groups
#print(df["food_group_1"].nunique())
#print(df["food_group_2"].nunique())

# Check duplicate category tags
#print(df["category_tag"].duplicated().sum())

# Inspect unmapped categories
#print(df[df["food_group_1"].isna()].head(20))

# Export to dbt seeds
df.to_csv(
    "dbt_food_retail_dashboard_1/seeds/category_food_group_mapping.csv",
    index=False
)