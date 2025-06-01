import pandas as pd
import ast

# Load the CSV
df = pd.read_csv(r"C:\Users\Khach\Desktop\IMDB Dataset\rewards\events.csv")

# Safely parse the stringified dictionaries in 'value' column
def parse_value(val):
    try:
        return ast.literal_eval(val)
    except Exception:
        return {}

# Apply parsing
df_parsed = df['value'].apply(parse_value)

# Convert list of dicts into DataFrame
df_expanded = pd.json_normalize(df_parsed)

# Fix inconsistent column name: 'offer id' → 'offer_id'
if 'offer id' in df_expanded.columns:
    df_expanded['offer_id'] = df_expanded.get('offer_id', pd.NA)
    df_expanded['offer_id'] = df_expanded['offer_id'].fillna(df_expanded['offer id'])
    df_expanded.drop(columns='offer id', inplace=True)

# Combine back with the original columns (excluding 'value')
df_final = pd.concat([df.drop(columns='value'), df_expanded], axis=1)

# Check result
print(df_final.head(10))

# Optional: Save to new CSV
df_final.to_csv("cleaned_rewards.csv", index=False)