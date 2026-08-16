# adding necesssary libraries
import pandas as pd
from sqlalchemy import create_engine
import urllib

# reading CSV document
df = pd.read_csv(r"C:\Users\Mete\Onedrive\Belgeler\DataSet.csv") 

# transforming date column
df["transaction_date"] = pd.to_datetime(df["transaction_date"])

# SQL Server connect
params = urllib.parse.quote_plus(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost\\SQLEXPRESS;"
    "DATABASE=ShopSales;"
    "Trusted_Connection=yes;"
)

engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# adding data to SQL
df.to_sql(
    "Sales",
    engine,
    if_exists="append",
    index=False
)

print(f"✅ {len(df)} row added to SQL Server succesfully.")
