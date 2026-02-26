import requests

url_token = "https://oauth.bb.com.br/oauth/token"

payload = {
    "grant_type": "client_credentials",
    "scope": "cobrancas.boletos-info cobrancas.boletos-requisicao"
}

headers = {
    "Content-Type": "application/x-www-form-urlencoded"
}

response = requests.post(
    url_token,
    data=payload,
    headers=headers,
    auth=("SEU_CLIENT_ID", "SEU_CLIENT_SECRET"),
    cert=("certificado.pem", "chave.key")  # mTLS
)

access_token = response.json()["access_token"]
print("TOKEN:", access_token)
