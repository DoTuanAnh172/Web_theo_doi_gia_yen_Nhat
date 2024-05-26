from fastapi import FastAPI, HTTPException
import requests

app = FastAPI()

API_KEY = 'adbd85d151-8a4a47e300-se2ur9'  # Thay bằng key API của bạn
BASE_URL = 'https://api.fastforex.io/'  # URL cơ bản của API fastFOREX


@app.get("/forex/{to_currency}")
def get_forex_rate(to_currency: str):
    from_currency = 'JPY'  # Tiền tệ mặc định là JPY

    # Kiểm tra định dạng mã tiền tệ
    if len(to_currency) != 3 or not to_currency.isalpha():
        raise HTTPException(status_code=400, detail="Invalid currency code format. Use a 3-letter currency code.")

    url = f"{BASE_URL}fetch-one?from={from_currency}&to={to_currency}&api_key={API_KEY}"
    response = requests.get(url)

    if response.status_code == 200:
        return response.json()  # Trả về dữ liệu JSON trực tiếp
    elif response.status_code == 401:
        raise HTTPException(status_code=401, detail="Unauthorized. Check your API key.")
    elif response.status_code == 404:
        raise HTTPException(status_code=404, detail="Currency pair not found.")
    else:
        raise HTTPException(status_code=response.status_code, detail=response.text)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="127.0.0.1", port=8001)