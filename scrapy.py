from scrapybara import Scrapybara
import os
from dotenv import load_dotenv

load_dotenv(dotenv_path="C:\\Users\\Ivenaccip\\Documents\\scrapybara\\.env", override=True)

client = Scrapybara(api_key="scrapy-a2e81cdd-8749-455d-88c7-1d2840e8098d")

# Start instance
instance = client.start(instance_type="medium")

# Scrape W25
response = instance.agent.scrape(
    cmd="Open https://ycombinator.com/companies, filter companies by 'W25', and extract company name, description, and tags.",
    schema={
        "companies": [
            {
                "name": "str",
                "description": "str",
                "tags": ["str"]
            }
        ]
    },
)

print(response)

print(response.data)

print(f"Scraped W25 companies: {response.data['companies']}")

# Find best way to conect each company 
for company in response.data['companies'][0:3]:
    print(f"\Contact info for {company['name']}...")
    contact_info = instance.agent.scrape(
        cmd=f"Open https://ycombinator.com/companies and find the best way to contact YC W25 company {company['name']}",
        schema={
            "contact_method": "str",
            "contact_details": "str"
        },
    )
    print(f"\n Found contact info for {company['name']}: {contact_info.data}")

# Stop
instance.stop()