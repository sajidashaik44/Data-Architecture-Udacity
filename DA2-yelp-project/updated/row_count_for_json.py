import json

def count_rows(file_path):
    with open(file_path, 'r') as file:
        count = 0
        for line in file:
            try:
                json.loads(line)  # Try to load the JSON object
                count += 1
            except json.JSONDecodeError:
                pass
    return count

files = [
    'yelp_academic_dataset_business.json',
    'yelp_academic_dataset_checkin.json',
    'yelp_academic_dataset_covid_features.json',
    'yelp_academic_dataset_review.json',
    'yelp_academic_dataset_tip.json',
    'yelp_academic_dataset_user.json'
]

for file in files:
    print(f'{file}: {count_rows(file)} rows')

