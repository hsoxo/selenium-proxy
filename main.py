from fastapi import FastAPI, HTTPException, Response, Query
from pydantic import BaseModel, HttpUrl
import undetected_chromedriver as uc
import time

app = FastAPI()


class URLRequest(BaseModel):
    url: HttpUrl


@app.post("/fetch-html", response_class=Response)
def fetch_html(url: str = Query(..., description="URL to fetch")):
    print(url)
    try:
        options = uc.ChromeOptions()
        options.add_argument("--headless")
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-gpu")
        options.add_argument("--disable-dev-shm-usage")

        driver = uc.Chrome(options=options)
        driver.get(url)
        time.sleep(3)
        html = driver.page_source
        driver.quit()

        return Response(content=html, media_type="text/html")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
